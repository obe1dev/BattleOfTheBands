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
                [ProfileController sharedInstance].signUpMessage = [NSString stringWithFormat:@"%@",error];
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
//currentProfile
+ (Firebase *) allProfiles:(Profile *)profile{
    return [self ProfileWithUID:profile.uID];
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
        
        if (error != nil) {
            // an error occurred while attempting login
            switch(error.code) {
                case FAuthenticationErrorUserDoesNotExist:
                    // Handle invalid user
                    [ProfileController sharedInstance].loginAlert = @"Invalid User";
                    [ProfileController sharedInstance].loginMessage = @"The specified user does not exist.";
                    break;
                    
                case FAuthenticationErrorInvalidEmail:
                    // Handle invalid email
                    [ProfileController sharedInstance].loginAlert = @"Invalid User";
                    [ProfileController sharedInstance].loginMessage = @"The specified user does not exist.";
                    break;
                    
                case FAuthenticationErrorInvalidPassword:
                    // Handle invalid password
                    [ProfileController sharedInstance].loginAlert = @"Invalid Password";
                    [ProfileController sharedInstance].loginMessage = @"The password does not match the user.";
                    break;
                default:
                    //you may not be connected to the internet.
                    [ProfileController sharedInstance].loginAlert = @"Error";
                    [ProfileController sharedInstance].loginMessage = @"An error occurred while attempting to connect.";
                    break;
            }
        }
        if (error) {
            // There was an error creating the account
            
            [ProfileController sharedInstance].currentProfile.isLoggedIn = NO;
            
            if (completion) {
                completion(false);
            }
            
            NSLog(@"%@",error);
        } else {
            
            [self fetchUser:userEmail];
            
            if (completion) {
                completion(true);
            }
        }
    }];
}


+ (void)fetchUser:(NSString *)email {

    [[FireBaseController currentProfile] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSDictionary *profileDictionary;
        
        if ([snapshot.value isKindOfClass:[NSNull class]]) {
            
            Profile *newProfiles = [[ProfileController sharedInstance] createProfile:email uid:[self currentUserUID] isband:[ProfileController sharedInstance].isBand];
            
            profileDictionary = newProfiles.dictionaryRepresentation;
            
        } else if ([snapshot.value isKindOfClass:[NSDictionary class]]) {
            
            profileDictionary = snapshot.value;
        }
        
        [[ProfileController sharedInstance] setCurrentUser:profileDictionary];
        
        [[ProfileController sharedInstance] saveAllProfile:[ProfileController sharedInstance].currentProfile];
        
        if ([ProfileController sharedInstance].currentProfile.isBand == YES) {
            
            [self fetchBand:email];
            
        } else if ([ProfileController sharedInstance].currentProfile.isBand == NO){
            
            [self fetchListener:email];
            
        }
        
    } withCancelBlock:^(NSError *error) {
        // Do nothing for now
    }];

}

+ (void)fetchBand:(NSString *)email{
    
    [[FireBaseController currentBandProfile] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSDictionary *profileDictionary;
        
        if ([snapshot.value isKindOfClass:[NSNull class]]) {
            
            Profile *newProfiles = [[ProfileController sharedInstance] createProfile:email uid:[self currentUserUID] isband:[ProfileController sharedInstance].isBand];
            
            profileDictionary = newProfiles.dictionaryRepresentation;
            
        }else if ([snapshot.value isKindOfClass:[NSDictionary class]]) {
            
            profileDictionary = snapshot.value;
        
        }
        
        [[ProfileController sharedInstance] setCurrentUser:profileDictionary];
        
        [[ProfileController sharedInstance] saveProfile:[ProfileController sharedInstance].currentProfile];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:currentBandProfileLoadedNotification object:nil];
    
    }];
    
}

+ (void)fetchListener:(NSString *)email{
    
    [[FireBaseController currentListenerProfile] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {

        NSDictionary *profileDictionary;
        
        if ([snapshot.value isKindOfClass:[NSNull class]]) {
            
            Profile *newProfiles = [[ProfileController sharedInstance] createProfile:email uid:[self currentUserUID] isband:[ProfileController sharedInstance].isBand];
            
            profileDictionary = newProfiles.dictionaryRepresentation;
            
        }else if ([snapshot.value isKindOfClass:[NSDictionary class]]) {
            
            profileDictionary = snapshot.value;
        }
        
        [[ProfileController sharedInstance] setCurrentUser:profileDictionary];
        
        [[ProfileController sharedInstance] saveListenerProfile:[ProfileController sharedInstance].currentProfile];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:currentListenerProfileLoadedNotification object:nil];
    
    }];
    
}

#pragma mark Read




#pragma mark Update





#pragma mark delete


@end
