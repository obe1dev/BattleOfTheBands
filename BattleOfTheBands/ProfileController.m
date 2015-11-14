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


#pragma mark Create profile

-(Profile *)createProfile:(NSString *)email uid:(NSString*)uID{
    
    //creating new profile
    Profile *profile = [Profile new];
    profile.email = email;
    profile.uID = uID;
    
    self.currentProfile = profile;
#warning signUp stuff
    self.needsToFillOutProfile = YES;
    
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
    
    [self saveProfile:self.currentProfile];
    
}

-(void) updateVoteForProfile:(Profile *)profile {
    
    //adding a vote to selectedProfile
#warning this method is not working for updating profile votes
//    [[FireBaseController bandProfile:profile] runTransactionBlock:^FTransactionResult *(FMutableData *currentData) {
//        profile.vote = @(1 + [profile.vote intValue]);
//    }];
    
    profile.vote = @(1 + [profile.vote intValue]);
    
    //start here
    [self saveProfile:profile];
    
}

- (void)setCurrentUser:(NSDictionary *)dictionary {
    
    Profile *currentUser = [[Profile alloc] initWithDictionary:dictionary];
    self.currentProfile = currentUser;
}


#pragma mark Update

- (void) saveProfile:(Profile *)profile {
    
    [[FireBaseController bandProfile:profile] setValue:profile.dictionaryRepresentation];

}

- (void) saveVoteToProfile{
    [[FireBaseController voteForband] setValue:self.currentProfile.vote];
}

-(void)rankForProfile:(Profile *)profile completion:(void (^)(NSNumber *rank))completion {
    [[FireBaseController allBandProfiles] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSDictionary *bandDictionaries = snapshot.value;
        NSMutableArray *topBandsMutable = [NSMutableArray array];
        for (NSString *bandDictionaryKey in bandDictionaries) {
            NSDictionary *bandDictionary = bandDictionaries[bandDictionaryKey];
            Profile *bandProfile = [[Profile alloc] initWithDictionary:bandDictionary];
            [topBandsMutable addObject:bandProfile];
        }
        NSArray *sortedBands = [topBandsMutable sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"vote" ascending:NO]]];
       
        
        NSInteger index = [sortedBands indexOfObject:profile];
        index++;
        NSNumber *number = [NSNumber numberWithInteger:index];
        
        
        
        completion(number);
    }];
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
        NSInteger random1 = arc4random() % [topBandsMutable count];
        
        NSInteger random2 = 0;
        
        do {
            random2 = arc4random() % [topBandsMutable count];
        } while (random2 == random1 && [topBandsMutable count] > 1);
        
        NSMutableArray *randomArray = topBandsMutable.mutableCopy;
       
        //NSMutableDictionary *randomDictionary =
        
        self.randomBand = @[ randomArray[random1], randomArray[random2] ];
        
        
        
//        NSMutableArray *entryList = self.entries.mutableCopy;
//        [entryList addObject:entry];
//        self.entries = entryList;
//        [self saveToPersistentStorage];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:randomBandProfileLoadedNotification object:nil];
    }];

}
#warning if the band has no data in the profile it will still add them to the battle rounds
#warning i need to add a ranking in here or in top 10 view?
//TODO:i need to add a ranking in here or in top 10 view?
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
