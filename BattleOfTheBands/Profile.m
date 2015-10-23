//
//  Profile.m
//  Battle Of The Bands
//
//  Created by Brock Oberhansley on 10/21/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "Profile.h"

static NSString * const nameKey = @"nameKey";
static NSString * const bioOfBandKey = @"bioOfBand";
static NSString * const bandImageKey = @"bandImageKey";
static NSString * const voteKey = @"voteKey";
static NSString * const bandWebsiteKey =@"bandWebsiteKey";


@implementation Profile

- (id) initWithDictionary:(NSDictionary *) dictionary{
    self = [super init];
    
    self.name = [dictionary objectForKey:nameKey];
    self.bioOfBand = [dictionary objectForKey:bioOfBandKey];
    self.bandImage = [dictionary objectForKey:bandImageKey];
    self.vote = [dictionary objectForKey:voteKey];
    self.bandWebsite = [dictionary objectForKey:bandImageKey];
    
    return self;
};

- (NSDictionary *) dictionaryRepresentation{
    
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    [dictionary setObject:self.name forKey:nameKey];
    [dictionary setObject:self.bioOfBand forKey:bioOfBandKey];
    [dictionary setObject:self.bandImage forKey:bandImageKey];
    [dictionary setObject:self.vote forKey:voteKey];
    [dictionary setObject:self.bandWebsite forKey:bandWebsiteKey];
    
    return dictionary;
    
};


@end
