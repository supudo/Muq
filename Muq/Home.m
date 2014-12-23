//
//  Home.m
//  Muq
//
//  Created by Sergey Petrov on 2/26/14.
//  Copyright (c) 2014 supudo.net. All rights reserved.
//

#import "Home.h"

@implementation Home

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [MQSettings sharedInstance].colorBackground;
    [self.btnStart setTitleColor:[MQSettings sharedInstance].colorText forState:UIControlStateNormal];
    self.navigationItem.title = NSLocalizedString(@"AppTitle", @"AppTitle");
    
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) &&
        [[UIScreen mainScreen] scale] > 1.0 &&
        [UIScreen mainScreen].bounds.size.height != 568.f)
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]]];
    else
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background5"]]];
    
    UIBarButtonItem *bi = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ButtonMenu"] style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu)];
    [bi setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = bi;
    
    [self.bannerView setHidden:YES];
}

- (void)showMenu {
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [btn setTitleTextAttributes:@{ NSFontAttributeName : [UIFont fontWithName:[MQSettings sharedInstance].fontName size:16.0] } forState:UIControlStateNormal];
    [btn setTintColor:[UIColor whiteColor]];
    self.navigationItem.backBarButtonItem = btn;
    [self performSegueWithIdentifier:@"openSettings" sender:self];
}

#pragma mark - Banner

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    [self.bannerView setHidden:NO];
    [[MQSettings sharedInstance] LogThis:@"bannerViewDidLoadAd %@", [banner description]];
    [self layoutForCurrentOrientation];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [self.bannerView setHidden:YES];
    [[MQSettings sharedInstance] LogThis:@"didFailToReceiveAdWithError %@", error];
    [self layoutForCurrentOrientation];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
}

- (void)layoutForCurrentOrientation {
    /*
    CGFloat animationDuration = 0.2f;
    CGRect contentFrame = self.contentView.bounds;
	CGPoint bannerOrigin = CGPointMake(CGRectGetMinX(contentFrame), CGRectGetMaxY(contentFrame));
    CGFloat bannerHeight = 0.0f;
    
    bannerHeight = self.bannerView.bounds.size.height;
    
    if (self.bannerView.bannerLoaded) {
        contentFrame.size.height -= bannerHeight;
		bannerOrigin.y -= bannerHeight;
    }
    else
		bannerOrigin.y += bannerHeight;
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.contentView.frame = contentFrame;
                         [self.contentView layoutIfNeeded];
                         self.bannerView.frame = CGRectMake(bannerOrigin.x, bannerOrigin.y + 50, self.bannerView.frame.size.width, self.bannerView.frame.size.height);
                     }];
     */
}

@end
