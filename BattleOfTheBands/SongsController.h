//
//  SongsController.h
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 10/22/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Songs.h"

@interface SongsController : NSObject

@property (strong,nonatomic,readonly) NSMutableArray *songs;

+(SongsController *)sharedInstance;

-(Songs *)createSongWithsongName:(NSString *)songName songData:(NSString *)songData;

-(void) addSong:(Songs *)song;

-(void) removeSong:(Songs *)song;

-(void) save:(NSArray *) songs;

@end
