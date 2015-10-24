//
//  ProfileController.h
//  Battle Of The Bands
//
//  Created by Brock Oberhansley on 10/21/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Profile.h"

@interface ProfileController : NSObject

@property (strong, nonatomic, readonly) NSMutableArray *profile;

+ (ProfileController *)sharedInstance;

-(Profile *)createProfileWithName:(NSString *)name uID:(NSString *)uID password:(NSString *)password bioOfBand:(NSString *)bioOfBand vote:(NSNumber *)vote bandWebsite:(NSURL *)bandWebsite songs:(NSArray *)songs;

-(void) addProfile:(Profile *)Profile;

-(void) removeProfile:(Profile *)Profile;

-(void) save:(NSArray *) profiles;

@end
