//
//  SignUpViewController.h
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 10/31/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController

@property (nonatomic, copy) void (^didSelectListen)();
@property (nonatomic, copy) void (^isProfile)(BOOL success);

@end
