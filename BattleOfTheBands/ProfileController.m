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

@property (strong, nonatomic) NSArray *profiles;
@property (strong, nonatomic) Profile *currentProfile;

@end

@implementation ProfileController

+ (ProfileController *)sharedInstance {
    static ProfileController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [ProfileController new];
        
        sharedInstance.profiles = [NSArray new];
        
//      [sharedInstance setUpMockData];
        
        [sharedInstance loadFromPersistentStorage];
    });
    return sharedInstance;
}


#pragma mark Creat profile

-(Profile *)createProfile:(NSString *)email uid:(NSString*)uID{
    
    //creating new profile
    Profile *profile = [Profile new];
    profile.email = email;
    profile.uID = uID;
    [self addProfile:profile];
    
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
    
}

- (void)setCurrentUser:(NSDictionary *)dictionary {
    
    Profile *currentUser = [[Profile alloc] initWithDictionary:dictionary];
    self.currentProfile = currentUser;
}


-(void) addProfile:(Profile *)profile{
    
    if (!profile) {
        return;
    }
    
    NSMutableArray *profileList = self.profiles.mutableCopy;
    [profileList addObject:profile];
    self.profiles = profileList;
    [self saveToPersistentStorage];
    
}

#pragma mark Read

- (void)loadFromPersistentStorage {
    
    
    [[FireBaseController BandProfiles] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSMutableArray *profiles = [NSMutableArray new];
        
        for (NSDictionary *profile in snapshot.value) {
            
            
            [profiles addObject:[[Profile alloc] initWithDictionary:profile]];
        }
        self.profiles = profiles;
//        [ProfileController sharedInstance].profiles = profiles;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:profilesLoadedNotification object:nil];
        
    }];
}

#pragma mark Update

- (void) saveToPersistentStorage {
    
    NSMutableArray *profileDictionaries = [NSMutableArray new];
    for (Profile *profile in self.profiles) {
        
        [profileDictionaries addObject:[profile dictionaryRepresentation]];
        
    }
    //i Need to cange to userProfile instead of base but it errors.
    [[FireBaseController BandProfiles] setValue:profileDictionaries];
}

- (void) save:(NSArray *) profiles{
    [self saveToPersistentStorage];
}

#pragma mark delete

-(void) removeProfile:(Profile *)profile{
    
    if (!profile) {
        return;
    }
    
    NSMutableArray *profileList = self.profiles.mutableCopy;
    [profileList removeObject:profile];
    self.profiles = profileList;
    [self saveToPersistentStorage];

    
}


//-(void) setUpMockData {
//    
//    Profile *sampleProfile1 = [Profile new];
//    sampleProfile1.name = @"changed good band";
//    sampleProfile1.uID = @"e9e223cc-1b4d-4842-9350-13624ab3a580";
//    sampleProfile1.songs = [SongsController sharedInstance].songs;
//    //[FireBaseController creatAccount:@"brock@gmail.com" password:@"thisisthepassword"];
//    
//    
//    
//    Profile *sampleProfile2 = [Profile new];
//    sampleProfile2.name = @"another good band";
//    
//    
//    Profile *sampleProfile3 = [Profile new];
//    sampleProfile3.name = @"the best band";
//    
//    
//    NSMutableArray *profileList = self.profiles.mutableCopy;
//  
//
//    [profileList addObjectsFromArray:@[sampleProfile1, sampleProfile2, sampleProfile3]];
//    
//    self.profiles = profileList;
//    [self saveToPersistentStorage];
//
//};

@end
