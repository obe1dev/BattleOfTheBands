//
//  S3Manager.h
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 11/14/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface S3Manager : NSObject

+ (void) uploadImage:(UIImage *)image withName:(NSString *)name;

@end
