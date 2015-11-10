//
//  ProfileController.m
//  Battle Of The Bands
//
//  Created by Brock Oberhansley on 10/21/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "ProfileController.h"
#import "Profile.h"
#import "FireBaseController.h"
#import "SongsController.h"

@interface ProfileController ()

@property (strong, nonatomic) Profile *currentProfile;
@property (strong, nonatomic) NSArray *topTenBandProfiles;

@end

@implementation ProfileController

+ (ProfileController *)sharedInstance {
    static ProfileController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [ProfileController new];
    });
    return sharedInstance;
}


#pragma mark Creat profile

-(Profile *)createProfile:(NSString *)email uid:(NSString*)uID{
    
    //creating new profile
    Profile *profile = [Profile new];
    profile.email = email;
    profile.uID = uID;
    
    self.currentProfile = profile;
    
    return profile;
}

-(void) currentUser:(NSString *)email{
    self.currentProfile.email = email;
}

-(void)updateProfileWithName:(NSString *)name bioOfBand:(NSString *)bioOfBand bandWebsite:(NSString *)bandWebsite {
    
        if (name) {
        self.currentProfile.name = name;
    }
        if (bioOfBand) {
        self.currentProfile.bioOfBand = bioOfBand;
    }
        if (bandWebsite) {
        self.currentProfile.bandWebsite = bandWebsite;
    }
    
    [self saveCurrentProfile];
    
}

- (void)setCurrentUser:(NSDictionary *)dictionary {
    
    Profile *currentUser = [[Profile alloc] initWithDictionary:dictionary];
    self.currentProfile = currentUser;
}


#pragma mark Update

- (void) saveCurrentProfile {
    
    [[FireBaseController currentBandProfile] setValue:self.currentProfile.dictionaryRepresentation];

}

#warning Implement this for real to get the top ten bands as sorted by votes
- (void)loadTopTenBandProfiles {
    [[FireBaseController allBandProfiles] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSArray *bandDictionaries = (NSArray *)snapshot.value;
        NSMutableArray *topBandsMutable = [NSMutableArray array];
        for (NSDictionary *bandDictionary in bandDictionaries) {
            Profile *bandProfile = [[Profile alloc] initWithDictionary:bandDictionary];
            [topBandsMutable addObject:bandProfile];
        }
        self.topTenBandProfiles = topBandsMutable;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:topBandProfilesLoadedNotification object:nil];
    }];
}

@end
