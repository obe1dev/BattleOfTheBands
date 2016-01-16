//
//  SongsController.m
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 10/22/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "SongsController.h"
#import "FireBaseController.h"

@interface SongsController ()

@property (strong,nonatomic) NSMutableArray *songs;

@end

@implementation SongsController


+ (SongsController *)sharedInstance {
    static SongsController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [SongsController new];
        
        sharedInstance.songs = [NSMutableArray new];
        
        [sharedInstance loadFromPersistentStorage];

    });
    return sharedInstance;
}

#pragma mark creat

-(Songs *)createSongWithsongName:(NSString *)songName songData:(NSString *)songData{
    
    Songs *song = [Songs new];
    song.songName = songName;
    song.songData = [NSData dataWithContentsOfFile:songData];
    
    [self addSong:song];
    
    return song;
}

-(void) addSong:(Songs *)song{
    
    if (!song) {
        return;
    }
    
    NSMutableArray *songList = self.songs.mutableCopy;
    [songList addObject:song];
    self.songs = songList;
    [self saveToPersistentStorage];
    
}

#pragma mark read

- (void)loadFromPersistentStorage {
    
    [[FireBaseController userSongBase] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSMutableArray *songs = [NSMutableArray new];
        
        if (snapshot.value != [NSNull null]) {
            for (NSDictionary *song in snapshot.value) {
                [songs addObject:[[Songs alloc] initWithDictionary:song]];
            }
        }

        self.songs = songs;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadSongs" object:nil];
        
    }];
}

#pragma mark update

- (void) saveToPersistentStorage {
    
    NSMutableArray *songDictionaries = [NSMutableArray new];
    for (Songs *song in self.songs) {
        
        [songDictionaries addObject:[song dictionaryRepresentation]];
    }
    
    [[FireBaseController userSongBase] setValue:songDictionaries];
}

- (void) save:(NSArray *) songs{
    [self saveToPersistentStorage];
}

#pragma mark delete

-(void) removeSong:(Songs *)song{
    
    if (!song) {
        return;
    }
    
    NSMutableArray *songList = self.songs.mutableCopy;
    [songList removeObject:song];
    self.songs = songList;
    [self saveToPersistentStorage];
    
}

@end
