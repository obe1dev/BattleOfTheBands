//
//  FireBaseController.h
//  Battle Of The Bands
//
//  Created by Brock Oberhansley on 10/22/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>

@interface FirebaseController : NSObject

+ (Firebase *) base;

+(void) creatAccount:(NSString *)userName password:(NSString *)password;

@end
