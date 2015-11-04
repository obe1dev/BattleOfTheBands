//
//  FireBaseController.m
//  Battle Of The Bands
//
//  Created by Brock Oberhansley on 10/22/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "FireBaseController.h"
#import "Profile.h"

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

+ (void) creatAccount:(NSString *)userEmail password:(NSString *)password{
    
    [self.base createUser:userEmail password:password withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
            if (error) {
            // There was an error creating the account
            NSLog(@"%@",error);
            } else {
            NSString *uid = [result objectForKey:@"uid"];
            NSLog(@"Successfully created user account with uid: %@", uid);
                
            }
    }];
    
};

+ (Firebase *) listenerProfiles {
    return [[[FireBaseController base] childByAppendingPath:@"ListnerProfiles/"] childByAppendingPath:[FireBaseController currentUserUID]];
}

+ (Firebase *) BandProfiles {
    return [[[FireBaseController base] childByAppendingPath:@"BandProfiles/"] childByAppendingPath:[FireBaseController currentUserUID]];
}

+ (Firebase *) userSongBase {
    return [[[FireBaseController base] childByAppendingPath:@"songs/"] childByAppendingPath:[FireBaseController currentUserUID]];
}

+ (NSString *) currentUserUID {
    return [FireBaseController base].authData.uid;
}

+(void) login:(NSString *)userEmail password:(NSString *)password {
    
    [self.base authUser:userEmail password:password withCompletionBlock:^(NSError *error, FAuthData *authData) {
        NSLog(@"%@",authData);
    }];
}

#pragma mark Read




#pragma mark Update





#pragma mark delete


@end
