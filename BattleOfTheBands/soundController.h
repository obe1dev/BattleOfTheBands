//
//  soundController.h
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 11/20/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Songs.h"

@interface soundController : NSObject

@property (assign, nonatomic) BOOL prepareSong;



- (instancetype)initWithURL:(NSURL *)url;

- (void)playAudioFile;
-(void)pauseAudioFile;

@end
