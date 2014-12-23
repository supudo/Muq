//
//  Quiz.h
//  Muq
//
//  Created by Sergey Petrov on 2/26/14.
//  Copyright (c) 2014 supudo.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Quiz : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) IBOutlet UIButton *btnClose, *btnPause, *btnPlay, *btnRandomize;
@property (nonatomic, assign) IBOutlet UILabel *lblStatus;
@property (nonatomic, assign) IBOutlet UISlider *sliderVolume;
@property (nonatomic, assign) IBOutlet UITableView *tblTracks;

- (IBAction)iboClose:(id)sender;
- (IBAction)iboPause:(id)sender;
- (IBAction)iboPlay:(id)sender;
- (IBAction)iboRandomize:(id)sender;
- (IBAction)iboVolumeChange:(id)sender;

@end
