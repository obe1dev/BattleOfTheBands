//
//  soundController.m
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 11/20/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "soundController.h"

@interface soundController()

@property (strong, nonatomic) AVAudioPlayer *player;
@property (assign, nonatomic) BOOL playing;


@end


@implementation soundController

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        self.player.numberOfLoops = 1;
    }
    return self;
}

- (void)playAudioFile {
    [self.player play];
    
}

-(void)pauseAudioFile{
    
    [self.player pause];
    
}

@end
