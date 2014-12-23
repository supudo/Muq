//
//  MQSettings.h
//  Muq
//
//  Created by Sergey Petrov on 2/26/14.
//  Copyright (c) 2014 supudo.net. All rights reserved.
//

@interface MQSettings : NSObject

@property BOOL inDebug, difficultyShowArtwork, difficultyShowArtist;
@property int tries, totalWins, totalLoses, totalQuestions;
@property (nonatomic, strong) NSString *fontName;
@property (nonatomic, strong) NSString *appStoreID, *appStoreURL;
@property (nonatomic, strong) UIColor *colorBackground, *colorText;

- (void)LogThis:(NSString *)log, ...;
- (double)randomDoubleBetween:(double)low andValue:(double)high;
- (int)randomMTInt:(int)limit;
- (int)randomInt:(int)limit;
- (NSInteger)randomInt2:(NSInteger)limit;

+ (MQSettings *)sharedInstance;

@end
