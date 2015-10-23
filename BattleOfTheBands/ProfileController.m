//
//  ProfileController.m
//  Battle Of The Bands
//
//  Created by Brock Oberhansley on 10/21/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "ProfileController.h"
#import "Profile.h"
#import "FirebaseController.h"

@interface ProfileController ()

@property (strong, nonatomic) NSMutableArray *profiles;
//@property (strong, nonatomic) Firebase *firebaseRef = [Firebase alloc] initWithUrl:[@"https://battleofbands.firebaseIO.com/entries/"];

@end

@implementation ProfileController

+ (ProfileController *)sharedInstance {
    static ProfileController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [ProfileController new];
        
        sharedInstance.profiles = [NSMutableArray new];
        
        //[sharedInstance setUpMockData];
        
        //[sharedInstance loadFromPersistentStorage];
    });
    return sharedInstance;
}


#pragma mark Creat profile


-(Profile *)createProfileWithName:(NSString *)name bioOfBand:(NSString *)bioOfBand vote:(NSNumber *)vote bandWebsite:(NSURL *)bandWebsite songs:(NSArray *)songs{
    
    //creating a new profile
    Profile *profile = [Profile new];
    //adding data to the profile
    profile.name = name;
    profile.bioOfBand = bioOfBand;
    profile.vote = vote;
    profile.bandWebsite = bandWebsite;
    profile.songs = songs;
    
    //adding this profile to the array
    [self addProfile:profile];
    
    return profile;
};

-(void) addProfile:(Profile *)profile{
    
    if (!profile) {
        return;
    }
    
    //-------do i need mutableCopy-----------
    NSMutableArray *profileList = self.profiles.mutableCopy;
    [profileList addObject:profile];
    self.profiles = profileList;
    [self saveToPersistentStorage];
    
}

#pragma mark Read

#pragma mark Update

- (void)saveToPersistentStorage {
    NSMutableArray *profileDictionaries = [NSMutableArray new];
    for (Profile *profile in self.profiles) {
        
        [profileDictionaries addObject:[profile dictionaryRepresentation]];
    }
    
    
    //Firebase *base =[[Firebase alloc]initWithUrl:@"https://devmtnbrock.firebaseio.com/entries/"];
    
    //[base setValue:entryDictionaries];
}

#pragma mark delete

-(void) removeProfile:(Profile *)profile{
    
}


//-(void) setUpMockData {
//    
//    Profile *sampleProfile1 = [Profile new];
//    sampleProfile1.name = @"good band";
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
//    [self.profile addObjectsFromArray:@[sampleProfile1, sampleProfile2, sampleProfile3]];
//    
//    
//};

@end
