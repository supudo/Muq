//
//  TrackAnswerCell.h
//  Muq
//
//  Created by Sergey Petrov on 3/5/14.
//  Copyright (c) 2014 supudo.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class TrackAnswerCell;

@interface TrackAnswerCell : UITableViewCell

@property (nonatomic, strong) MPMediaItem *trackItem;
@property (nonatomic, assign) IBOutlet UIImageView *imgAlbum;
@property (nonatomic, assign) IBOutlet UILabel *lblAlbum, *lblArtist, *lblTrack;

@end