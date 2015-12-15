//
//  soundController.m
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 11/20/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "soundController.h"

@interface soundController()


@property (assign, nonatomic) BOOL playing;

//@property(strong, nonatomic) NSError* error;


@end


@implementation soundController

- (instancetype)initWithURL:(NSURL *)url{
    
    self = [super init];
    
    if (self) {
        
        NSError *error=nil;
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        //self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        self.player.numberOfLoops = 1;
        
        if (error) {
            NSLog(@"this is the error %@",[error localizedDescription]);
        }else{
            NSLog(@"complete!!!!!!");
        }
        
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
