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

- (void)playAudioFileAtURL:(NSURL *)url;

@end
