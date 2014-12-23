//
//  Quiz.m
//  Muq
//
//  Created by Sergey Petrov on 2/26/14.
//  Copyright (c) 2014 supudo.net. All rights reserved.
//

#import "Quiz.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"
#import "TrackAnswerCell.h"
#import "NSArray+Helpers.h"

@interface Quiz () <AVAudioPlayerDelegate>
@property (nonatomic, strong) NSMutableArray *trackData, *trackAnswers;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) MPMediaItem *currentSong;
@property (nonatomic, strong) AVAudioPlayer *player;
@property int currentTrackIndex, currentTries, currentQuiz, currentQuizCorrect, currentQuizWrong;
@end

@implementation Quiz

@synthesize trackData, hud, currentSong, btnClose, btnPause, btnPlay, btnRandomize, lblStatus, currentQuizCorrect, currentQuizWrong;
@synthesize sliderVolume, player, currentTrackIndex, tblTracks, trackAnswers, currentTries, currentQuiz;

#pragma mark - System

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.player stop];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [MQSettings sharedInstance].colorBackground;
    
    [self.tblTracks setBackgroundColor:[UIColor clearColor]];
    [self.tblTracks setBackgroundView:nil];
    
    [self.lblStatus setFont:[UIFont fontWithName:[MQSettings sharedInstance].fontName size:18.0]];
    [self.lblStatus setTextColor:[MQSettings sharedInstance].colorText];
    [self.lblStatus.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    [self.lblStatus.layer setShadowOffset:CGSizeZero];
    [self.lblStatus.layer setShadowRadius:3.0];
    [self.lblStatus.layer setShadowOpacity:0.9];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showHud:NSLocalizedString(@"FetchingTracks", @"FetchingTracks")];
    [self startQuiz];
}

#pragma mark - UI

- (void)startQuiz {
    self.currentTrackIndex = -1;
    self.currentTries = 1;
    self.currentQuiz = 0;
    self.currentQuizCorrect = 0;
    self.currentQuizWrong = 0;
    if (self.trackAnswers == nil)
        self.trackAnswers = [NSMutableArray array];
    else
        [self.trackAnswers removeAllObjects];
    [self performSelector:@selector(loadMusic) withObject:nil afterDelay:1.0];
}

- (void)showMessage:(NSString *)title withMessage:(NSString *)message tag:(int)tg {
    UIAlertView *alertView = nil;
    if (tg == 99)
        alertView = [[UIAlertView alloc] initWithTitle:title
                                               message:message
                                              delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"UI.StartAgain", @"UI.StartAgain")
                                     otherButtonTitles:NSLocalizedString(@"UI.Cancel", @"UI.Cancel"), nil];
    else
        alertView = [[UIAlertView alloc] initWithTitle:title
                                               message:message
                                              delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK")
                                     otherButtonTitles:nil];
    [alertView setTag:tg];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 999)
        [self dismissViewControllerAnimated:YES completion:nil];
    else if (alertView.tag == 2)
        [self playRandomTrack];
    else if (alertView.tag == 99) {
        if (buttonIndex == 0)
            [self startQuiz];
        else
            [self goBack];
    }
}

- (IBAction)iboClose:(id)sender {
    [self.player stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)iboPause:(id)sender {
    if ([self.player isPlaying])
        [self.player pause];
    else
        [self.player play];
}

- (IBAction)iboPlay:(id)sender {
    [self.player play];
}

- (IBAction)iboRandomize:(id)sender {
    if (self.currentQuiz == [MQSettings sharedInstance].totalQuestions)
        [self gameFinish];
    else {
        [self showHud:NSLocalizedString(@"Randomizing", @"Randomizing")];
        self.currentQuizWrong++;
        [self playRandomTrack];
    }
}

- (IBAction)iboVolumeChange:(id)sender {
    [self.player setVolume:self.sliderVolume.value];
}

- (void)goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)gameFinish {
    [self hideHud];
    NSString *ttl = @"";
    NSString *msg = @"";
    if (self.currentQuizCorrect > self.currentQuizWrong) {
        [MQSettings sharedInstance].totalWins++;
        ttl = NSLocalizedString(@"FinishTitleSuccess", @"FinishTitleSuccess");
        msg = NSLocalizedString(@"FinishMessageSuccess", @"FinishMessageSuccess");
    }
    else {
        [MQSettings sharedInstance].totalLoses++;
        ttl = NSLocalizedString(@"FinishTitleFail", @"FinishTitleFail");
        msg = NSLocalizedString(@"FinishMessageFail", @"FinishMessageFail");
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:[MQSettings sharedInstance].totalWins] forKey:@"totalWins"];
    [defaults setObject:[NSNumber numberWithInt:[MQSettings sharedInstance].totalLoses] forKey:@"totalLoses"];
    [defaults synchronize];
    [self showMessage:ttl withMessage:msg tag:99];
}

#pragma mark - Player

- (void)loadMusic {
    if (self.trackData == nil)
        self.trackData = [NSMutableArray array];
    else
        [self.trackData removeAllObjects];

    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    
    [[MQSettings sharedInstance] LogThis:@"Fetching all music tracks..."];
    NSArray *tracks = [everything items];
    for (MPMediaItem *song in tracks)
        [self.trackData addObject:song];

    [self hideHud];
    if (self.trackData == nil || [self.trackData count] == 0)
        [self showMessage:NSLocalizedString(@"Oops", @"Oops") withMessage:NSLocalizedString(@"NoMusic", @"NoMusic") tag:999];
    else
        [self playRandomTrack];
}

- (void)playRandomTrack {
    self.currentTrackIndex = arc4random() % [self.trackData count];
    float volume = 0.8;
    [self.player setVolume:volume];
    [self.sliderVolume setValue:volume];
    [self playTrack:self.currentTrackIndex];
}

- (void)playTrack:(int)idx {
    [self hideHud];

    self.currentSong = [self.trackData objectAtIndex:idx];
    
    NSString *artist = [self.currentSong valueForKey:MPMediaItemPropertyArtist];
    NSString *genre = [self.currentSong valueForKey:MPMediaItemPropertyGenre];
    NSString *title = [self.currentSong valueForKey:MPMediaItemPropertyTitle];
    NSString *album = [self.currentSong valueForKey:MPMediaItemPropertyAlbumTitle];
    NSString *trackNum = [self.currentSong valueForKey:MPMediaItemPropertyAlbumTrackNumber];
    [[MQSettings sharedInstance] LogThis:@"Now playing : %@ - %@ : \"%@\" from \"%@\" (%@)", artist, trackNum, title, album, genre];
    
    if (self.trackAnswers == nil)
        self.trackAnswers = [NSMutableArray array];
    else
        [self.trackAnswers removeAllObjects];

    NSMutableArray *arrt = [self getRandomTracks];
    MPMediaItem *track2 = [arrt objectAtIndex:0];
    MPMediaItem *track3 = [arrt objectAtIndex:1];
    MPMediaItem *track4 = [arrt objectAtIndex:2];
    MPMediaItem *track5 = [arrt objectAtIndex:3];
    
    self.trackAnswers = [NSMutableArray arrayWithArray:[[NSArray arrayWithObjects:self.currentSong, track2, track3, track4, track5, nil] shuffled]];

    [self.tblTracks reloadData];

    self.currentTries = 1;
    NSError *error = nil;
    NSURL *url = [self.currentSong valueForProperty:MPMediaItemPropertyAssetURL];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [self.player setDelegate:self];
    [self.player play];
    if (error != nil)
        [[MQSettings sharedInstance] LogThis:@"Player error - %@", [error localizedDescription]];
    self.currentQuiz++;

    NSString *status = NSLocalizedString(@"QuizStatus", @"QuizStatus");
    status = [status stringByReplacingOccurrencesOfString:@"{T1}" withString:[NSString stringWithFormat:@"%i", self.currentQuiz]];
    status = [status stringByReplacingOccurrencesOfString:@"{T2}" withString:[NSString stringWithFormat:@"%i", self.currentQuizCorrect]];
    status = [status stringByReplacingOccurrencesOfString:@"{T3}" withString:[NSString stringWithFormat:@"%i", self.currentQuizWrong]];
    [self.lblStatus setText:status];
}

- (NSMutableArray *)getRandomTracks {
    NSMutableArray *pickedTracks = [[NSMutableArray alloc] init];
    int remaining = 4;
    if ([self.trackData count] >= remaining) {
        while (remaining > 0) {
            MPMediaItem *t = [self.trackData objectAtIndex:[[MQSettings sharedInstance] randomInt2:[self.trackData count]]];
            if (![pickedTracks containsObject:t]) {
                [pickedTracks addObject:t];
                remaining--;
            }
        }
    }
    return pickedTracks;
}

#pragma mark - Player delegates

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.currentQuizWrong++;
    [self showHud:NSLocalizedString(@"TimesUp", @"TimesUp")];
    [self performSelector:@selector(iboRandomize:) withObject:nil afterDelay:3.0];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    [[MQSettings sharedInstance] LogThis:@"%s", __PRETTY_FUNCTION__];
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    [[MQSettings sharedInstance] LogThis:@"%s", __PRETTY_FUNCTION__];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
    [[MQSettings sharedInstance] LogThis:@"%s", __PRETTY_FUNCTION__];
}

#pragma mark - HUD

- (void)showHud:(NSString *)title {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = (title != nil ? title : @"");
    self.hud.labelFont = [UIFont fontWithName:[MQSettings sharedInstance].fontName size:16.0];
    self.hud.dimBackground = YES;
}

- (void)hideHud {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - Table delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.trackAnswers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrackAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrackAnswerCellIdentifier" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor blackColor]];
    [cell setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    [cell setClipsToBounds:YES];
    
    MPMediaItem *singleTrack = [self.trackAnswers objectAtIndex:indexPath.row];
    
    cell.trackItem = singleTrack;
    
    NSString *trackAnswer = [NSString stringWithFormat:@"%@\n%@", [singleTrack valueForKey:MPMediaItemPropertyArtist], [singleTrack valueForKey:MPMediaItemPropertyTitle]];

    [cell.lblTrack setText:trackAnswer];
    [cell.lblTrack setTextColor:[MQSettings sharedInstance].colorText];
    [cell.lblTrack setFont:[UIFont fontWithName:[MQSettings sharedInstance].fontName size:16.0]];
    [cell.lblTrack setLineBreakMode:NSLineBreakByWordWrapping];
    [cell.lblTrack.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    [cell.lblTrack.layer setShadowOffset:CGSizeZero];
    [cell.lblTrack.layer setShadowRadius:3.0];
    [cell.lblTrack.layer setShadowOpacity:0.9];
    
    if (![MQSettings sharedInstance].difficultyShowArtwork) {
        CGRect f = cell.lblTrack.frame;
        f.origin.x = 10;
        f.size.width = cell.contentView.frame.size.width - 20;
        cell.lblTrack.frame = f;
    }
    
    CGSize maximumLabelSize = CGSizeMake(cell.lblTrack.frame.size.width, FLT_MAX);
    NSDictionary *attr = @{ NSFontAttributeName : cell.lblTrack.font };
    CGRect expectedLabelRect = [trackAnswer boundingRectWithSize:maximumLabelSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attr context:nil];
    CGRect newFrame = cell.lblTrack.frame;
    newFrame.size.height = expectedLabelRect.size.height;
    cell.lblTrack.frame = newFrame;
    
    if ([MQSettings sharedInstance].difficultyShowArtwork) {
        MPMediaItemArtwork *artWork = [singleTrack valueForKey:MPMediaItemPropertyArtwork];
        if (artWork != nil)
            cell.imgAlbum.image = [artWork imageWithSize:CGSizeMake(56, 56)];
        else
            cell.imgAlbum.image = [UIImage imageNamed:@"AppIcon"];
    }
    else
        [cell.imgAlbum setHidden:YES];
    
    if (indexPath.row > 0) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 0.0, cell.contentView.frame.size.width - 20, 1)];
        lineView.backgroundColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:lineView];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TrackAnswerCell *cell = (TrackAnswerCell *)[self.tblTracks cellForRowAtIndexPath:indexPath];
    if (self.currentSong == cell.trackItem) {
        self.currentQuizCorrect++;
        [self showHud:NSLocalizedString(@"CorrectAnswer", @"CorrectAnswer")];
        if (self.currentQuiz == [MQSettings sharedInstance].totalQuestions)
            [self gameFinish];
        else
            [self performSelector:@selector(playRandomTrack) withObject:nil afterDelay:2.0];
    }
    else {
        [self showHud:NSLocalizedString(@"IncorrectAnswer", @"IncorrectAnswer")];
        [self performSelector:@selector(hideHud) withObject:nil afterDelay:1.0];
        if (self.currentTries == [MQSettings sharedInstance].tries) {
            self.currentQuizWrong++;
            if (self.currentQuiz == [MQSettings sharedInstance].totalQuestions)
                [self gameFinish];
            else {
                NSString *msg = [NSLocalizedString(@"MaxTries", @"MaxTries") stringByReplacingOccurrencesOfString:@"{T}" withString:[NSString stringWithFormat:@"%i", [MQSettings sharedInstance].tries]];
                [self showMessage:NSLocalizedString(@"UI.Error", @"UI.Error") withMessage:msg tag:2];
            }
        }
        else
            self.currentTries++;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MPMediaItem *singleTrack = [self.trackAnswers objectAtIndex:indexPath.row];

    NSString *trackAnswer = [NSString stringWithFormat:@"%@\n%@", [singleTrack valueForKey:MPMediaItemPropertyArtist], [singleTrack valueForKey:MPMediaItemPropertyTitle]];
    CGSize maximumLabelSize = CGSizeMake(232, FLT_MAX);
    if (![MQSettings sharedInstance].difficultyShowArtwork)
        maximumLabelSize = CGSizeMake(300, FLT_MAX);
    NSDictionary *attr = @{ NSFontAttributeName : [UIFont fontWithName:[MQSettings sharedInstance].fontName size:16.0] };
    CGRect expectedLabelRect = [trackAnswer boundingRectWithSize:maximumLabelSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attr context:nil];

    if (expectedLabelRect.size.height > 64)
        return expectedLabelRect.size.height;
    else
        return 64;
}

@end
