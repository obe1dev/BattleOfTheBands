//
//  FireBaseController.m
//  Battle Of The Bands
//
//  Created by Brock Oberhansley on 10/22/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "FirebaseController.h"

@implementation FirebaseController


// Create a reference to a Firebase database URL
+ (Firebase *) base{

    return [[Firebase alloc] initWithUrl:@"https://battleofbands.firebaseIO.com/"];
};

#pragma mark Creat

+(void) creatAccount:(NSString *)userName password:(NSString *)password{
    
    [[self base] createUser:userName password:password withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
            if (error) {
            // There was an error creating the account
            NSLog(@"%@",error);
            } else {
            NSString *uid = [result objectForKey:@"uid"];
            NSLog(@"Successfully created user account with uid: %@", uid);
            }
    }];
    
};

+(Firebase *) profiles {
    return [[[FirebaseController base] childByAppendingPath:@"/profiles/"] childByAppendingPath:[FirebaseController currentUserUID]];
}


+ (Firebase *) userSongBase {
    return [[[FirebaseController base] childByAppendingPath:@"/songs/"] childByAppendingPath:[FirebaseController currentUserUID]];
}

+ (NSString *) currentUserUID {
    return [FirebaseController base].authData.uid;
}

+(void) login{
    
}

@end
