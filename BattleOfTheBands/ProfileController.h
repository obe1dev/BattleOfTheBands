//
//  ProfileController.h
//  Battle Of The Bands
//
//  Created by Brock Oberhansley on 10/21/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Profile.h"

static NSString *currentListenerProfileLoadedNotification = @"currentListenerProfileLoaded";
static NSString *currentBandProfileLoadedNotification = @"currentBandProfileLoaded";
static NSString *topBandProfilesLoadedNotification = @"topBandProfilesLoaded";
static NSString *randomBandProfileLoadedNotification = @"randomBandLoaded";

@interface ProfileController : NSObject

@property (weak,nonatomic) NSString *signUpMessage;

@property (weak,nonatomic) NSString *loginAlert;

@property (weak,nonatomic) NSString *loginMessage;

@property (strong, nonatomic, readonly) Profile *currentProfile;
@property (strong, nonatomic, readonly) NSArray *topTenBandProfiles;
@property (strong, nonatomic, readonly) NSArray *searchProfiles;
@property (strong, nonatomic, readonly) NSArray *randomBand;
@property (assign, nonatomic) BOOL needsToFillOutProfile;

@property (assign, nonatomic) BOOL isListener;

//change if needed
@property (assign, nonatomic) BOOL isBand;

+ (ProfileController *)sharedInstance;

//- (void)loadFromPersistentStorage;

- (void)setCurrentUser:(NSDictionary *)dictionary;

-(Profile *)createProfile:(NSString *)email uid:(NSString*)uID isband:(BOOL)isBand;

-(Profile *)createBandProfile:(NSString *)email uid:(NSString*)uID;

-(Profile *)createListenerProfile:(NSString *)email uid:(NSString*)uID;

-(void) saveAllProfile:(Profile *)profile;

//-(void) saveListenerProfile:(Profile *)profile;

- (void) saveProfile:(Profile *)profile;

-(void) currentUser:(NSString *)email;

-(void)updateProfileWithName:(NSString *)name bioOfBand:(NSString *)bioOfBand bandWebsite:(NSString *)bandWebsite;

-(void)updateListenerWithName:(NSString *)name;

-(void) updateVoteForProfile:(Profile *)profile;

- (void)loadRandomBands;

-(void)rankForProfile:(Profile *)profile completion:(void (^)(NSNumber *rank))completion;

- (void)loadTopTenBandProfiles;

- (NSURL *)songURLForProfile:(Profile *)profile;

@end
