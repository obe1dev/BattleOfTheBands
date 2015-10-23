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

    return [[Firebase alloc] initWithUrl:@"https://battleofbands.firebaseIO.com/profiles/"];
};


@end
