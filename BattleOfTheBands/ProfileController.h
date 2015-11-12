//
//  ProfileController.h
//  Battle Of The Bands
//
//  Created by Brock Oberhansley on 10/21/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Profile.h"

static NSString *currentProfileLoadedNotification = @"currentProfileLoaded";
static NSString *topBandProfilesLoadedNotification = @"topBandProfilesLoaded";
static NSString *randomBandProfileLoadedNotification = @"randomBandLoaded";

@interface ProfileController : NSObject

@property (strong, nonatomic, readonly) Profile *currentProfile;
@property (strong, nonatomic, readonly) NSArray *topTenBandProfiles;
@property (strong, nonatomic, readonly) NSArray *randomBand;

+ (ProfileController *)sharedInstance;

//- (void)loadFromPersistentStorage;

- (void)setCurrentUser:(NSDictionary *)dictionary;

-(Profile *)createProfile:(NSString *)email uid:(NSString*)uID;

- (void) saveProfile:(Profile *)profile;

-(void) currentUser:(NSString *)email;

-(void)updateProfileWithName:(NSString *)name bioOfBand:(NSString *)bioOfBand bandWebsite:(NSString *)bandWebsite;

-(void) updateVoteForProfile:(Profile *)profile;

- (void)loadRandomBands;

- (void)loadTopTenBandProfiles;

@end
