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
#import "BattleViewController.h"

@interface ProfileController ()

@property (strong, nonatomic) Profile *currentProfile;
@property (strong, nonatomic) NSArray *topTenBandProfiles;
@property (strong, nonatomic) NSArray *randomBand;

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

-(void) voteUpdate{
    
    NSNumber *newVote =[NSNumber numberWithInt:1];
    
    //adding a vote to currentProfile
    self.currentProfile.vote = [NSNumber numberWithInt:([newVote intValue] + [self.currentProfile.vote intValue])];
    
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

- (void) saveVoteToProfile{
    [[FireBaseController voteForband] setValue:self.currentProfile.vote];
}

- (void)loadRandomBands{
    [[FireBaseController allBandProfiles] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSDictionary *bandDictionaries = snapshot.value;
        NSMutableArray *topBandsMutable = [NSMutableArray array];
        for (NSString *bandDictionaryKey in bandDictionaries) {
            NSDictionary *bandDictionary = bandDictionaries[bandDictionaryKey];
            Profile *bandProfile = [[Profile alloc] initWithDictionary:bandDictionary];
            [topBandsMutable addObject:bandProfile];
        }
        NSInteger random = arc4random() % [topBandsMutable count];
        
        //start here
        self.randomBand = topBandsMutable[random];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:randomBandProfileLoadedNotification object:nil];
    }];

}

- (void)loadTopTenBandProfiles {
    [[FireBaseController allBandProfiles] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSDictionary *bandDictionaries = snapshot.value;
        NSMutableArray *topBandsMutable = [NSMutableArray array];
        for (NSString *bandDictionaryKey in bandDictionaries) {
            NSDictionary *bandDictionary = bandDictionaries[bandDictionaryKey];
            Profile *bandProfile = [[Profile alloc] initWithDictionary:bandDictionary];
            [topBandsMutable addObject:bandProfile];
        }
        NSArray *sortedBands = [topBandsMutable sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"vote" ascending:NO]]];
        if (sortedBands.count > 10) {
            sortedBands = [sortedBands subarrayWithRange:NSMakeRange(0, 10)];
        }
        self.topTenBandProfiles = sortedBands;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:topBandProfilesLoadedNotification object:nil];
    }];
}

@end
