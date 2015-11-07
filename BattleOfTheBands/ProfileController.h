//
//  ProfileController.h
//  Battle Of The Bands
//
//  Created by Brock Oberhansley on 10/21/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Profile.h"

static NSString *profilesLoadedNotification = @"profilesLoaded";

@interface ProfileController : NSObject

@property (strong, nonatomic, readonly) NSArray *profiles;
@property (strong, nonatomic, readonly) Profile *currentProfile;

+ (ProfileController *)sharedInstance;

- (void)loadFromPersistentStorage;

- (void)setCurrentUser:(NSDictionary *)dictionary;

-(Profile *)createProfile:(NSString *)email uid:(NSString*)uID;

-(void) currentUser:(NSString *)email;

-(void)updateProfileWithName:(NSString *)name bioOfBand:(NSString *)bioOfBand bandWebsite:(NSString *)bandWebsite;

-(void) addProfile:(Profile *)Profile;

-(void) removeProfile:(Profile *)Profile;

-(void) save:(NSArray *) profiles;

@end
