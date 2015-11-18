//
//  FireBaseController.m
//  Battle Of The Bands
//
//  Created by Brock Oberhansley on 10/22/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "FireBaseController.h"
#import "Profile.h"
#import "ProfileController.h"
#import "LoginViewController.h"
#import "BattleViewController.h"

//@interface FireBaseController()
//
//@property (strong,nonatomic) NSString *userEmail;
//@property (strong,nonatomic) NSString *password;
//
//@end

@implementation FireBaseController


// Create a reference to a Firebase database URL
+ (Firebase *) base{

    return [[Firebase alloc] initWithUrl:@"https://battleofbands.firebaseio.com/"];
};

#pragma mark Creat

+ (void) creatAccount:(NSString *)userEmail password:(NSString *)password completion:(void (^)(bool success))completion{
    
    [self.base createUser:userEmail password:password withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
            if (error) {
            // There was an error creating the account
                if (completion) {
                    completion(false);
                }
                
            NSLog(@"%@",error);
            } else {
                [self login:userEmail password:password completion:nil];
                sleep(1);
                if (completion) {
                    completion(true);
                }
            }
        
    }];
    
};
//currentProfile
+ (Firebase *) currentProfile {
    return [self ProfileWithUID:self.currentUserUID];
}
//currentProfile
+ (Firebase *) ProfileWithUID:(NSString *)uid {
    return [[[FireBaseController base] childByAppendingPath:@"AllProfiles/"] childByAppendingPath:uid];
}
//listener
+ (Firebase *) listenerProfilesWithUID:(NSString *)uid {
    return [[[FireBaseController base] childByAppendingPath:@"ListnerProfiles/"] childByAppendingPath:uid];
}
//listener
+ (Firebase *) currentListenerProfile {
    return [self listenerProfilesWithUID:self.currentUserUID];
}
//listener
+ (Firebase *) listenerProfile:(Profile *)profile {
    return [self listenerProfilesWithUID:profile.uID];
}

+ (Firebase *) allBandProfiles {
    return [[FireBaseController base] childByAppendingPath:@"BandProfiles/"];
}

+ (Firebase *) bandProfile:(Profile *)profile {
    return [self bandProfileWithUID:profile.uID];
}

+ (Firebase *) bandProfileWithUID:(NSString *)uid {
    return [[[FireBaseController base] childByAppendingPath:@"BandProfiles/"] childByAppendingPath:uid];
}

+ (Firebase *) currentBandProfile {
    return [self bandProfileWithUID:self.currentUserUID];
}

+ (Firebase *) voteForband{
    return [[[FireBaseController base] childByAppendingPath:@"BandProfiles/Votes/"] childByAppendingPath:[FireBaseController currentUserUID]];
}

+ (Firebase *) userSongBase {
    return [[[FireBaseController base] childByAppendingPath:@"songs/"] childByAppendingPath:[FireBaseController currentUserUID]];
}

+ (NSString *) currentUserUID {
    return [FireBaseController base].authData.uid;
}


+(void) login:(NSString *)userEmail password:(NSString *)password completion:(void (^)(bool success))completion{
    
    [self.base authUser:userEmail password:password withCompletionBlock:^(NSError *error, FAuthData *authData) {
        NSLog(@"%@",authData);
        if (error) {
            // There was an error creating the account
            
            [ProfileController sharedInstance].currentProfile.isLoggedIn = NO;
            
            if (completion) {
                completion(false);
            }
            
            NSLog(@"%@",error);
        } else {
            
            [self fetchUser:userEmail];
           // [self fetchCurrentUser:userEmail];
            
//            if ([ProfileController sharedInstance].currentProfile.isBand == YES) {
//                [self fetchCurrentUser: userEmail];
//                [ProfileController sharedInstance].currentProfile.isLoggedIn = YES;
//            }
//            else if ([ProfileController sharedInstance].currentProfile.isBand == NO){
//                [self fetchCurrentListener: userEmail];
//                [ProfileController sharedInstance].currentProfile.isLoggedIn = YES;
//            }
        
            if (completion) {
                completion(true);
            }
        }
    }];
}

//+ (void)fetchCurrentUser:(NSString *)email {
//    [[FireBaseController currentBandProfile] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
//        NSDictionary *profileDictionary;
//        if ([snapshot.value isKindOfClass:[NSNull class]]) {
//            Profile *newBandProfile = [[ProfileController sharedInstance] createBandProfile:email uid:[self currentUserUID]];
//            profileDictionary = newBandProfile.dictionaryRepresentation;
//        } else if ([snapshot.value isKindOfClass:[NSDictionary class]]) {
//            profileDictionary = snapshot.value;
//        }
//        [[ProfileController sharedInstance] setCurrentUser:profileDictionary];
//        [[ProfileController sharedInstance] saveProfile:[ProfileController sharedInstance].currentProfile];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:currentBandProfileLoadedNotification object:nil];
//    } withCancelBlock:^(NSError *error) {
//        // Do nothing for now
//    }];
//}

+ (void)fetchUser:(NSString *)email {
    [[FireBaseController currentProfile] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSDictionary *profileDictionary;
        
        if ([snapshot.value isKindOfClass:[NSNull class]]) {
            
            Profile *newProfile = [[ProfileController sharedInstance] createProfile:email uid:[self currentUserUID] isband:[ProfileController sharedInstance].isBand];
            
            profileDictionary = newProfile.dictionaryRepresentation;
            
        } else if ([snapshot.value isKindOfClass:[NSDictionary class]]) {
            
            profileDictionary = snapshot.value;
        }
        
        [[ProfileController sharedInstance] setCurrentUser:profileDictionary];
        
        if ([ProfileController sharedInstance].currentProfile.isBand == YES) {
            
            [[ProfileController sharedInstance] saveProfile:[ProfileController sharedInstance].currentProfile];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:currentBandProfileLoadedNotification object:nil];
        
        } else if ([ProfileController sharedInstance].currentProfile.isBand == NO){
            
            [[ProfileController sharedInstance] saveListenerProfile:[ProfileController sharedInstance].currentProfile];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:currentListenerProfileLoadedNotification object:nil];
        }
        
    } withCancelBlock:^(NSError *error) {
        // Do nothing for now
    }];
}


//+ (void)fetchCurrentListener:(NSString *)email {
//    [[FireBaseController currentListenerProfile] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
//        NSDictionary *profileDictionary;
//        if ([snapshot.value isKindOfClass:[NSNull class]]) {
//            Profile *newListenerProfile = [[ProfileController sharedInstance] createListenerProfile:email uid:[self currentUserUID]];
//            profileDictionary = newListenerProfile.dictionaryRepresentation;
//        } else if ([snapshot.value isKindOfClass:[NSDictionary class]]) {
//            profileDictionary = snapshot.value;
//        }
//        [[ProfileController sharedInstance] setCurrentUser:profileDictionary];
//        [[ProfileController sharedInstance] saveListenerProfile:[ProfileController sharedInstance].currentProfile];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:currentListenerProfileLoadedNotification object:nil];
//    } withCancelBlock:^(NSError *error) {
//        // Do nothing for now
//    }];
//}

#pragma mark Read




#pragma mark Update





#pragma mark delete


@end
