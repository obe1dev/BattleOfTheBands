//
//  FireBaseController.h
//  Battle Of The Bands
//
//  Created by Brock Oberhansley on 10/22/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>

@class Profile;

@interface FireBaseController : NSObject

+ (Firebase *) base;

+ (Firebase *) allProfiles:(Profile *)profile;

+ (Firebase *) listenerProfile:(Profile *)profile;

+ (Firebase *) allBandProfiles;

+ (Firebase *) bandProfile:(Profile *)profile;

+ (Firebase *) voteForband;

+ (Firebase *) userSongBase;

+ (NSString *) currentUserUID;

+(void) deleteProfile:(NSString *)email password:(NSString*)password completion:(void (^)(bool success))completion;

+(void) login:(NSString *)userEmail password:(NSString *)password completion:(void (^)(bool success))completion;

+ (void) creatAccount:(NSString *)userEmail password:(NSString *)password completion:(void (^)(bool success))completion;

@end
