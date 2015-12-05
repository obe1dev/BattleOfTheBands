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

-(Profile *)createProfile:(NSString *)email uid:(NSString*)uID isband:(BOOL)isBand {
    
    //creating new profile
    Profile *profile = [Profile new];
    profile.email = email;
    profile.uID = uID;
    profile.isBand = isBand;
    
    self.currentProfile = profile;
    
    
    self.needsToFillOutProfile = YES;
    
    return profile;
}


-(Profile *)createBandProfile:(NSString *)email uid:(NSString*)uID{
    
    //creating new profile
    Profile *profile = [Profile new];
    profile.email = email;
    profile.uID = uID;
    profile.isBand = YES;
    
    self.currentProfile = profile;
    

    self.needsToFillOutProfile = YES;
    
    return profile;
}

-(Profile *)createListenerProfile:(NSString *)email uid:(NSString*)uID{
    
    //creating new profile
    Profile *profile = [Profile new];
    profile.email = email;
    profile.uID = uID;
    profile.isBand = NO;
    
    self.currentProfile = profile;
    
    
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

-(void)updateListenerWithName:(NSString *)name{
    if (name) {
        self.currentProfile.name = name;
    }
    
//    [self saveListenerProfile:self.currentProfile];
}

-(void) updateVoteForProfile:(Profile *)profile {
    
    //adding a vote to selectedProfile
#warning this method is not working for updating profile votes
//    [[FireBaseController bandProfile:profile] runTransactionBlock:^FTransactionResult *(FMutableData *currentData) {
//        profile.vote = @(1 + [profile.vote intValue]);
//    }];
//    if (profile.vote==nil) {
//        return;
//    }
    profile.vote = @(1 + [profile.vote intValue]);
    
    //start here
    [self saveProfile:profile];
    
}

- (void)setCurrentUser:(NSDictionary *)dictionary {
    
    Profile *currentUser = [[Profile alloc] initWithDictionary:dictionary];
    self.currentProfile = currentUser;
}


#pragma mark Update

-(void) saveAllProfile:(Profile *)profile{
    [[FireBaseController allProfiles:profile] setValue:profile.dictionaryRepresentation];
}

//-(void) saveListenerProfile:(Profile *)profile{
//    [[FireBaseController listenerProfile:profile] setValue:profile.dictionaryRepresentation];
//}

- (void) saveProfile:(Profile *)profile {
    NSLog(@"Saving profile");
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
        
        if (snapshot.value != [NSNull null]) {
            NSDictionary *bandDictionaries = snapshot.value;
            NSMutableArray *topBandsMutable = [NSMutableArray array];
            for (NSString *bandDictionaryKey in bandDictionaries) {
                NSDictionary *bandDictionary = bandDictionaries[bandDictionaryKey];
                Profile *bandProfile = [[Profile alloc] initWithDictionary:bandDictionary];
                //this will check to see if the band has a name and song
                if (bandProfile.name && bandProfile.songPath) {
                    
                    if (![bandProfile.name isEqualToString:@""] && ![bandProfile.songPath isEqualToString:@""]) {
                        
                        [topBandsMutable addObject:bandProfile];
                        
                    }
                    
                }
            }
            
            if (topBandsMutable.count > 0) {
                NSInteger random1 = arc4random() % [topBandsMutable count];
                
                NSInteger random2 = 0;
                
                do {
                    random2 = arc4random() % [topBandsMutable count];
                } while (random2 == random1 && [topBandsMutable count] > 1);
                
                NSMutableArray *randomArray = topBandsMutable.mutableCopy;
                
                
                self.randomBand = @[ randomArray[random1], randomArray[random2] ];
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:randomBandProfileLoadedNotification object:nil];

            }
        }
    }];
}

- (void)loadTopTenBandProfiles {
    [[FireBaseController allBandProfiles] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSDictionary *bandDictionaries = snapshot.value;
        NSMutableArray *topBandsMutable = [NSMutableArray array];
        for (NSString *bandDictionaryKey in bandDictionaries) {
            NSDictionary *bandDictionary = bandDictionaries[bandDictionaryKey];
            Profile *bandProfile = [[Profile alloc] initWithDictionary:bandDictionary];
            
            //this will check to see if the band has a name and song
            if (bandProfile.name) {
                
                if (![bandProfile.name isEqualToString:@""]) {
                    
                    [topBandsMutable addObject:bandProfile];
                    
                }
                
            }
            
        }
        NSArray *sortedBands = [topBandsMutable sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"vote" ascending:NO]]];
        if (sortedBands.count > 10) {
            sortedBands = [sortedBands subarrayWithRange:NSMakeRange(0, 10)];
        }
        self.topTenBandProfiles = sortedBands;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:topBandProfilesLoadedNotification object:nil];
    }];
}

- (NSURL *)songURLForProfile:(Profile *)profile {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * myDocumentsDirectory = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSString * fileName = [NSString stringWithFormat:@"%@.m4a", profile.uID];
    
    NSString *exportFile = [myDocumentsDirectory stringByAppendingPathComponent:fileName];
    
    NSURL *exportURL = [NSURL fileURLWithPath:exportFile];
    
    return exportURL;
}

@end
