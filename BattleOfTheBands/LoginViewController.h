//
//  LoginViewController.h
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 10/29/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

+ (LoginViewController *)sharedInstance;

-(void)loginError;

@end
