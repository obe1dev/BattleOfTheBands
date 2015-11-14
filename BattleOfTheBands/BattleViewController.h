//
//  ViewController.h
//  Battle Of The Bands
//
//  Created by Brock Oberhansley on 10/18/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Profile.h"

@interface BattleViewController : UIViewController

+ (BattleViewController *)sharedInstance;

@property (strong, nonatomic) Profile *selectedProfile;

-(void)setTabBarIndexTo0;
-(void)setTabbarIndexTo2;

@end

