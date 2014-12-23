//
//  MQSettings.m
//  Muq
//
//  Created by Sergey Petrov on 2/26/14.
//  Copyright (c) 2014 supudo.net. All rights reserved.
//

#import "MQSettings.h"
#import "MTRandom.h"

@implementation MQSettings

@synthesize inDebug, fontName, appStoreID, appStoreURL, colorBackground, colorText, tries;
@synthesize totalWins, totalLoses, totalQuestions, difficultyShowArtwork, difficultyShowArtist;

+ (MQSettings *)sharedInstance {
    static dispatch_once_t once;
    static MQSettings * sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)LogThis:(NSString *)log, ... {
    if (self.inDebug) {
        NSString *output;
        va_list ap;
        va_start(ap, log);
        output = [[NSString alloc] initWithFormat:log arguments:ap];
        va_end(ap);
        NSLog(@"[Muq] %@", output);
    }
}

- (id) init {
	if (self = [super init]) {
#if (TARGET_IPHONE_SIMULATOR)
        self.inDebug = YES;
#else
        self.inDebug = NO;
#endif
        
        self.difficultyShowArtwork = YES;
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"difficultyShowArtwork"])
            self.difficultyShowArtwork = [[[NSUserDefaults standardUserDefaults] objectForKey:@"difficultyShowArtwork"] boolValue];
        
        self.difficultyShowArtist = YES;
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"difficultyShowArtist"])
            self.difficultyShowArtist = [[[NSUserDefaults standardUserDefaults] objectForKey:@"difficultyShowArtist"] boolValue];
        
        self.tries = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tries"] intValue];
        if (self.tries == 0)
            self.tries = 3;
        
        self.totalQuestions = [[[NSUserDefaults standardUserDefaults] objectForKey:@"totalQuestions"] intValue];
        if (self.totalQuestions == 0)
            self.totalQuestions = 5;
        
        self.totalWins = [[[NSUserDefaults standardUserDefaults] objectForKey:@"totalWins"] intValue];
        self.totalLoses = [[[NSUserDefaults standardUserDefaults] objectForKey:@"totalLoses"] intValue];

        self.appStoreID = @"835040516";
        self.appStoreURL = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/muq/id%@?ls=1&mt=8", self.appStoreID];

        self.fontName = @"Harabara";//@"Karma Future";

        self.colorBackground = [UIColor blackColor];
        self.colorText = [UIColor whiteColor];
    }
    return self;
}

- (double)randomDoubleBetween:(double)low andValue:(double)high {
    MTRandom *rnd = [[MTRandom alloc] init];
    return [rnd randomDoubleFrom:low to:high];
}

- (int)randomMTInt:(int)limit {
    MTRandom *rnd = [[MTRandom alloc] init];
    if (limit > 0)
        return [rnd randomUInt32From:0 to:limit];
    else
        return [rnd randomUInt32];
}

- (int)randomInt:(int)limit {
    return arc4random() % limit;
}

- (NSInteger)randomInt2:(NSInteger)limit {
    return arc4random() % limit;
}

@end
