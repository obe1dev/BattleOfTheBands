//
//  Profile.m
//  Battle Of The Bands
//
//  Created by Brock Oberhansley on 10/21/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "Profile.h"

static NSString * const uIDKey = @"uIDKey";
static NSString * const passwordKey = @"passwordKey";
static NSString * const nameKey = @"nameKey";
static NSString * const bioOfBandKey = @"bioOfBand";
static NSString * const bandImageKey = @"bandImageKey";
static NSString * const voteKey = @"voteKey";
static NSString * const bandWebsiteKey =@"bandWebsiteKey";
static NSString * const songsKey = @"songsKey";


@implementation Profile


//giving the class properties an object key  for a dictionary.
- (id) initWithDictionary:(NSDictionary *) dictionary{
    self = [super init];
    
    self.uID = [dictionary objectForKey:uIDKey];
    self.password = [dictionary objectForKey:passwordKey];
    self.name = [dictionary objectForKey:nameKey];
    self.bioOfBand = [dictionary objectForKey:bioOfBandKey];
    self.bandImage = [dictionary objectForKey:bandImageKey];
    self.vote = [dictionary objectForKey:voteKey];
    self.bandWebsite = [dictionary objectForKey:bandImageKey];
    self.songs = [dictionary objectForKey:songsKey];
    
    return self;
};


//adding properties to the dictionary 
- (NSDictionary *) dictionaryRepresentation{
    
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    [dictionary setObject:self.uID forKey:uIDKey];
    [dictionary setObject:self.password forKey:passwordKey];
    [dictionary setObject:self.name forKey:nameKey];
    [dictionary setObject:self.bioOfBand forKey:bioOfBandKey];
    [dictionary setObject:self.bandImage forKey:bandImageKey];
    [dictionary setObject:self.vote forKey:voteKey];
    [dictionary setObject:self.bandWebsite forKey:bandWebsiteKey];
    [dictionary setObject:self.songs forKey:songsKey];
    
    return dictionary;
    
};


@end
