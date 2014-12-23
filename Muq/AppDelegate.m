//
//  AppDelegate.m
//  Muq
//
//  Created by Sergey Petrov on 2/26/14.
//  Copyright (c) 2014 supudo.net. All rights reserved.
//

#import "AppDelegate.h"
#import "Appirater.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Appirater setAppId:[MQSettings sharedInstance].appStoreID];
    [Appirater setDaysUntilPrompt:2];
    [Appirater setUsesUntilPrompt:10];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:5];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
    
    UIColor *navTextColor = [MQSettings sharedInstance].colorText;
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName : navTextColor,
                                                            NSFontAttributeName : [UIFont fontWithName:[MQSettings sharedInstance].fontName size:20.0f]
                                                            }];
    
    if ([[UINavigationBar appearance] respondsToSelector:@selector(setBarTintColor:)])
        [[UINavigationBar appearance] setBarTintColor:[MQSettings sharedInstance].colorBackground];
    if ([[UINavigationBar appearance] respondsToSelector:@selector(setTintColor:)])
        [[UINavigationBar appearance] setTintColor:navTextColor];

    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication*)application {
    [Appirater appEnteredForeground:YES];
}

@end
