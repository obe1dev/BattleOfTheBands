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

@end


@implementation soundController

- (void)playAudioFileAtURL:(NSURL *)url{
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    self.player.numberOfLoops = 1;
    [self.player play];
}

@end
