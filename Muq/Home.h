//
//  Home.h
//  Muq
//
//  Created by Sergey Petrov on 2/26/14.
//  Copyright (c) 2014 supudo.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface Home : UIViewController <ADBannerViewDelegate>

@property (nonatomic, assign) IBOutlet UIButton *btnStart;
@property (nonatomic, assign) IBOutlet UIView *contentView;
@property (nonatomic, assign) IBOutlet ADBannerView *bannerView;

@end
