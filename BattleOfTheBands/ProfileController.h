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

+ (ProfileController *)sharedInstance;

- (void)loadFromPersistentStorage;

-(Profile *)createProfileWithName:(NSString *)name bioOfBand:(NSString *)bioOfBand bandWebsite:(NSString *)bandWebsite;

-(void) addProfile:(Profile *)Profile;

-(void) removeProfile:(Profile *)Profile;

-(void) save:(NSArray *) profiles;

@end
