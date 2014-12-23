//
//  Settings.m
//  Muq
//
//  Created by Sergey Petrov on 3/5/14.
//  Copyright (c) 2014 supudo.net. All rights reserved.
//

#import "Settings.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import "LeveyPopListView.h"
#import "TextFieldPad.h"

@interface Settings () <MFMailComposeViewControllerDelegate, LeveyPopListViewDelegate, UITextFieldDelegate>
@property BOOL shareOpened;
@end

@implementation Settings

@synthesize shareOpened;

#pragma mark - System

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Life cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [MQSettings sharedInstance].colorBackground;
    self.navigationItem.title = NSLocalizedString(@"Settings", @"Settings");
    self.shareOpened = NO;
    
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) &&
        [[UIScreen mainScreen] scale] > 1.0 &&
        [UIScreen mainScreen].bounds.size.height != 568.f)
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundSettings"]]];
    else
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundSettings5"]]];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

#pragma mark - Text field delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    int t = [textField.text intValue];
    if (t == 0)
        return NO;
    else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (textField.tag == 101) {
            [MQSettings sharedInstance].tries = t;
            [defaults setObject:[NSNumber numberWithInt:[MQSettings sharedInstance].tries] forKey:@"tries"];
        }
        else if (textField.tag == 102) {
            [MQSettings sharedInstance].totalQuestions = t;
            [defaults setObject:[NSNumber numberWithInt:[MQSettings sharedInstance].totalQuestions] forKey:@"totalQuestions"];
        }
        [defaults synchronize];

        [textField resignFirstResponder];
        return YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}

#pragma mark - Table delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 4;
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingsCellIdentifier"];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    float margin = 10;
    float lblWidth = cell.contentView.frame.size.width - (margin * 2);
    float lblWidth3 = (cell.contentView.frame.size.width / 2);
    CGRect f = CGRectMake(margin, margin, lblWidth, cell.contentView.frame.size.height - (margin * 2));
    
    if (indexPath.section == 0) {
        UILabel *lbl = [[UILabel alloc] init];
        f.size.width = lblWidth3;
        [lbl setFrame:f];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setFont:[UIFont fontWithName:[MQSettings sharedInstance].fontName size:20]];
        [lbl setTextColor:[UIColor whiteColor]];
        if (indexPath.row == 0)
            [lbl setText:NSLocalizedString(@"SettingsMaxTries", @"SettingsMaxTries")];
        else if (indexPath.row == 1)
            [lbl setText:NSLocalizedString(@"SettingsTotalQ", @"SettingsTotalQ")];
        else if (indexPath.row == 2)
            [lbl setText:NSLocalizedString(@"SettingsDifficultyShortArtwork", @"SettingsDifficultyShortArtwork")];
        else if (indexPath.row == 3)
            [lbl setText:NSLocalizedString(@"SettingsDifficultyShortArtist", @"SettingsDifficultyShortArtist")];
        [lbl.layer setShadowColor:[UIColor blackColor].CGColor];
        [lbl.layer setShadowOffset:CGSizeZero];
        [lbl.layer setShadowRadius:2.0];
        [lbl.layer setShadowOpacity:0.9];
        [cell.contentView addSubview:lbl];

        if (indexPath.row < 2) {
            TextFieldPad *tf = [[TextFieldPad alloc] init];
            f.origin.x = cell.contentView.frame.size.width - margin - 100;
            f.origin.y = 4;
            f.size.width = 100;
            f.size.height = 36;
            [tf setFrame:f];
            [tf setBackgroundColor:[UIColor whiteColor]];
            [tf setTextColor:[UIColor blackColor]];
            [tf setFont:[UIFont fontWithName:[MQSettings sharedInstance].fontName size:20]];
            [tf setAdjustsFontSizeToFitWidth:YES];
            [tf setTextAlignment:NSTextAlignmentCenter];
            [tf setEnabled:YES];
            [tf setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            [tf setClearButtonMode:UITextFieldViewModeWhileEditing];
            [tf setDelegate:self];
            [tf setReturnKeyType:UIReturnKeyDone];
            [tf.layer setBorderWidth:2.0];
            [tf.layer setBorderColor:[UIColor clearColor].CGColor];
            [tf.layer setCornerRadius:10.0];
            if (indexPath.row == 0) {
                [tf setTag:101];
                [tf setText:[NSString stringWithFormat:@"%i", [MQSettings sharedInstance].tries]];
            }
            else {
                [tf setTag:102];
                [tf setText:[NSString stringWithFormat:@"%i", [MQSettings sharedInstance].totalQuestions]];
            }
            [cell.contentView addSubview:tf];
        }
        else {
            UISwitch *sw = [[UISwitch alloc] init];
            f.origin.x = cell.contentView.frame.size.width - margin - 100;
            f.size.width = 100;
            [sw setFrame:f];
            if (indexPath.row == 2) {
                [sw addTarget:self action:@selector(changeDifficultyArtwork:) forControlEvents:UIControlEventValueChanged];
                [sw setOn:[MQSettings sharedInstance].difficultyShowArtwork];
            }
            else {
                [sw addTarget:self action:@selector(changeDifficultyArtist:) forControlEvents:UIControlEventValueChanged];
                [sw setOn:[MQSettings sharedInstance].difficultyShowArtist];
            }
            [sw setTintColor:[MQSettings sharedInstance].colorText];
            [sw setOnTintColor:[MQSettings sharedInstance].colorText];
            [cell.contentView addSubview:sw];
        }
        
        [cell.contentView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.2]];
        
        if (indexPath.row > 0) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 0.0, cell.contentView.frame.size.width - 20, 1)];
            lineView.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:lineView];
        }
    }
    else if (indexPath.section == 1) {
        UILabel *lbl = [[UILabel alloc] init];
        [lbl setFrame:f];
        [lbl setBackgroundColor:[UIColor clearColor]];
        NSString *s = NSLocalizedString(@"WinsLoses", @"WinsLoses");
        s = [s stringByReplacingOccurrencesOfString:@"{T1}" withString:[NSString stringWithFormat:@"%i", [MQSettings sharedInstance].totalWins]];
        s = [s stringByReplacingOccurrencesOfString:@"{T2}" withString:[NSString stringWithFormat:@"%i", [MQSettings sharedInstance].totalLoses]];
        [lbl setText:s];
        [lbl setFont:[UIFont fontWithName:[MQSettings sharedInstance].fontName size:20]];
        [lbl setTextColor:[UIColor whiteColor]];
        [lbl setTextAlignment:NSTextAlignmentLeft];
        [lbl.layer setShadowColor:[UIColor blackColor].CGColor];
        [lbl.layer setShadowOffset:CGSizeZero];
        [lbl.layer setShadowRadius:2.0];
        [lbl.layer setShadowOpacity:0.9];
        [cell.contentView addSubview:lbl];
        [cell.contentView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.2]];
    }
    else {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:f];
        [btn setTag:103];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitleColor:[MQSettings sharedInstance].colorText forState:UIControlStateNormal];
        [btn setTitle:NSLocalizedString(@"Share", @"Share") forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont fontWithName:[MQSettings sharedInstance].fontName size:20]];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn addTarget:self action:@selector(shareApp) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel.layer setShadowColor:[UIColor blackColor].CGColor];
        [btn.titleLabel.layer setShadowOffset:CGSizeZero];
        [btn.titleLabel.layer setShadowRadius:2.0];
        [btn.titleLabel.layer setShadowOpacity:0.9];
        [cell.contentView addSubview:btn];
        [cell.contentView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.2]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
        return 44;
    else
        return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] init];
    [v setFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, 44)];
    [v setBackgroundColor:[UIColor clearColor]];
    
    UILabel *lbl = [[UILabel alloc] init];
    [lbl setFrame:v.frame];
    if (section == 0)
        [lbl setText:NSLocalizedString(@"Settings", @"Settings")];
    else if (section == 1)
        [lbl setText:NSLocalizedString(@"Statistics", @"Statistics")];
    else if (section == 2)
        [lbl setText:NSLocalizedString(@"ShareTitleShort", @"ShareTitleShort")];
    [lbl setFont:[UIFont fontWithName:[MQSettings sharedInstance].fontName size:20]];
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setAlpha:0.8];
    [lbl.layer setShadowColor:[UIColor blackColor].CGColor];
    [lbl.layer setShadowOffset:CGSizeZero];
    [lbl.layer setShadowRadius:2.0];
    [lbl.layer setShadowOpacity:0.9];
    [v addSubview:lbl];
    
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

#pragma mark - UI

- (void)closeSettings {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeDifficultyArtwork:(UISwitch *)sw {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [MQSettings sharedInstance].difficultyShowArtwork = sw.isOn;
    [defaults setObject:[NSNumber numberWithInt:[MQSettings sharedInstance].difficultyShowArtwork] forKey:@"difficultyShowArtwork"];
    [defaults synchronize];
}

- (void)changeDifficultyArtist:(UISwitch *)sw {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [MQSettings sharedInstance].difficultyShowArtist = sw.isOn;
    [defaults setObject:[NSNumber numberWithInt:[MQSettings sharedInstance].difficultyShowArtist] forKey:@"difficultyShowArtist"];
    [defaults synchronize];
}

#pragma mark - Sharing

- (void)shareApp {
    if (!self.shareOpened) {
        NSArray *shareOptions = [NSArray arrayWithObjects:
                                 [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"ShareFacebook"], @"img", NSLocalizedString(@"TitleFacebook", @"TitleFacebook"), @"text", nil],
                                 [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"ShareTwitter"], @"img", NSLocalizedString(@"TitleTwitter", @"TitleTwitter"), @"text", nil],
                                 [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"ShareEmail"], @"img", NSLocalizedString(@"TitleEmail", @"TitleEmail"), @"text", nil],
                                 nil];
        
        LeveyPopListView *lplv = [[LeveyPopListView alloc] initWithTitle:NSLocalizedString(@"ShareTitle", @"ShareTitle") options:shareOptions];
        lplv.delegate = self;
        [lplv showInView:self.view animated:YES];
        self.shareOpened = YES;
    }
}

- (void)shareFacebook {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        NSString *txt = NSLocalizedString(@"FacebookMessage", @"FacebookMessage");
        txt = [txt stringByReplacingOccurrencesOfString:@"{URL}" withString:[MQSettings sharedInstance].appStoreURL];
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [controller setInitialText:txt];
        [self presentViewController:controller animated:YES completion:nil];
    }
    else {
        UIAlertView *dialog = [[UIAlertView alloc] init];
        [dialog setDelegate:self];
        [dialog setTitle:NSLocalizedString(@"UI.Error", @"UI.Error")];
        [dialog setMessage:NSLocalizedString(@"FacebookNoAccount", @"FacebookNoAccount")];
        [dialog addButtonWithTitle:NSLocalizedString(@"UI.OK", @"UI.OK")];
        [dialog setTag:2];
        [dialog show];
    }
}

- (void)shareTwitter {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        NSString *txt = NSLocalizedString(@"TwitterMessage", @"TwitterMessage");
        txt = [txt stringByReplacingOccurrencesOfString:@"{URL}" withString:[MQSettings sharedInstance].appStoreURL];
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [controller setInitialText:txt];
        [self presentViewController:controller animated:YES completion:nil];
    }
    else {
        UIAlertView *dialog = [[UIAlertView alloc] init];
        [dialog setDelegate:self];
        [dialog setTitle:NSLocalizedString(@"UI.Error", @"UI.Error")];
        [dialog setMessage:NSLocalizedString(@"TwitterNoAccount", @"TwitterNoAccount")];
        [dialog addButtonWithTitle:NSLocalizedString(@"UI.OK", @"UI.OK")];
        [dialog setTag:3];
        [dialog show];
    }
}

- (void)shareEmail {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        [mailController setMailComposeDelegate:self];
        [mailController setSubject:NSLocalizedString(@"Email.Subject", @"Email.Subject")];
        [mailController setToRecipients:nil];
        [mailController setCcRecipients:nil];
        [mailController setBccRecipients:nil];
        
        NSString *body = NSLocalizedString(@"Email.Body", @"Email.Body");
        NSString *s = NSLocalizedString(@"WinsLoses", @"WinsLoses");
        s = [s stringByReplacingOccurrencesOfString:@"{T1}" withString:[NSString stringWithFormat:@"%i", [MQSettings sharedInstance].totalWins]];
        s = [s stringByReplacingOccurrencesOfString:@"{T2}" withString:[NSString stringWithFormat:@"%i", [MQSettings sharedInstance].totalLoses]];
        body = [body stringByReplacingOccurrencesOfString:@"{T}" withString:s];
        NSString *appStoreURL = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>", [MQSettings sharedInstance].appStoreURL, [MQSettings sharedInstance].appStoreURL];
        body = [body stringByReplacingOccurrencesOfString:@"{URL}" withString:appStoreURL];
        [mailController setMessageBody:body isHTML:YES];
        [mailController.navigationBar setBarStyle:UIBarStyleBlack];
        [self presentViewController:mailController animated:YES completion:nil];
    }
    else {
        UIAlertView *dialog = [[UIAlertView alloc] init];
        [dialog setDelegate:self];
        [dialog setTitle:NSLocalizedString(@"UI.Error", @"UI.Error")];
        [dialog setMessage:NSLocalizedString(@"Email.InAppEmailCantSend", @"Email.InAppEmailCantSend")];
        [dialog addButtonWithTitle:NSLocalizedString(@"UI.OK", @"UI.OK")];
        [dialog setTag:4];
        [dialog show];
    }
}

- (void)sendEmailMessageFinished:(id)sender {
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	switch (result) {
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			break;
		default:
            break;
	}
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Share delegates

- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex {
    self.shareOpened = NO;
    switch (anIndex) {
        case 0:
            [self shareFacebook];
            break;
        case 1:
            [self shareTwitter];
            break;
        case 2:
            [self shareEmail];
            break;
            break;
        default:
            break;
    }
}

- (void)leveyPopListViewDidCancel {
    self.shareOpened = NO;
}

@end
