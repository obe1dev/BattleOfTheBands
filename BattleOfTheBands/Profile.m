
//  Profile.m
//  Battle Of The Bands
//
//  Created by Brock Oberhansley on 10/21/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "Profile.h"

static NSString * const uIDKey = @"uIDKey";
static NSString * const emailKey = @"emailkey";
static NSString * const passwordKey = @"passwordKey";
static NSString * const nameKey = @"nameKey";
static NSString * const bioOfBandKey = @"bioOfBand";
static NSString * const bandImageKey = @"bandImageKey";
static NSString * const voteKey = @"voteKey";
static NSString * const bandWebsiteKey =@"bandWebsiteKey";
static NSString * const songsKey = @"songsKey";
static NSString * const likesKey = @"likesKey";
static NSString * const genreKey = @"genreKey";
static NSString * const isBandKey = @"isBandKey";


@implementation Profile


//giving the class properties an object key  for a dictionary.
- (id) initWithDictionary:(NSDictionary *) dictionary{
    self = [super init];
    
    self.uID = [dictionary objectForKey:uIDKey];
    self.email = [dictionary objectForKey:emailKey];
    self.password = [dictionary objectForKey:passwordKey];
    self.name = [dictionary objectForKey:nameKey];
    self.bioOfBand = [dictionary objectForKey:bioOfBandKey];
    self.bandImage = [dictionary objectForKey:bandImageKey];
    self.vote = [dictionary objectForKey:voteKey];
    self.bandWebsite = [dictionary objectForKey:bandWebsiteKey];
    self.songs = [dictionary objectForKey:songsKey];
    self.likes = [dictionary objectForKey:likesKey];
    self.genre = [dictionary objectForKey:genreKey];
    self.isBand = [dictionary objectForKey:isBandKey];
    
    return self;
};


//adding properties to the dictionary 

- (NSDictionary *) dictionaryRepresentation{
    
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    if (self.uID) {
        [dictionary setObject:self.uID forKey:uIDKey];
    }
    if (self.email) {
        [dictionary setObject:self.email forKey:emailKey];
    }
    if (self.password) {
        [dictionary setObject:self.password forKey:passwordKey];
    }
    if (self.name) {
        [dictionary setObject:self.name forKey:nameKey];
    }
    if (self.bioOfBand) {
        [dictionary setObject:self.bioOfBand forKey:bioOfBandKey];
    }
    if (self.bandImage) {
        [dictionary setObject:self.bandImage forKey:bandImageKey];
    }
    if (self.vote) {
        [dictionary setObject:self.vote forKey:voteKey];
    }
    if (self.bandWebsite) {
        [dictionary setObject:self.bandWebsite forKey:bandWebsiteKey];
    }
    if (self.songs) {
        [dictionary setObject:self.songs forKey:songsKey];
    }
    if (self.likes) {
        [dictionary setObject:self.likes forKey:likesKey];
    }
    if (self.genre) {
        [dictionary setObject:self.genre forKey:genreKey];
    }
    
    return dictionary;
    
};


@end
