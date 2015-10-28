//
//  Songs.m
//  Battle Of The Bands
//
//  Created by Brock Oberhansley on 10/21/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "Songs.h"

static NSString * const songNameKey = @"songNameKey";
static NSString * const songDataKey = @"songDataKey";


@implementation Songs

- (id) initWithDictionary:(NSDictionary *) dictionary{
    self = [super init];
    
    self.songName = [dictionary objectForKey:songNameKey];
    self.songData = [dictionary objectForKey:songDataKey];
    
    
    return self;
};

- (NSDictionary *) dictionaryRepresentation{
    
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    if (self.songName) {
        [dictionary setObject:self.songName forKey:songNameKey];
    }
    if (self.songData) {
        [dictionary setObject:self.songData forKey:songDataKey];
    }
    
    return dictionary;
    
};

@end
