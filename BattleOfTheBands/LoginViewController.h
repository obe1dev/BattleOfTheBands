//
//  LoginViewController.h
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 10/29/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Firebase/Firebase.h>

@interface LoginViewController : UIViewController

+ (LoginViewController *)sharedInstance;

-(void)loginErrorWithAlert:(NSString *)alert message:(NSString *)message;

@property (nonatomic, copy) void (^didSelectListen)();
@property (nonatomic, copy) void (^isProfile)(BOOL success);

@end
