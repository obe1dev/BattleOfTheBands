//
//  ViewController.h
//  Battle Of The Bands
//
//  Created by Brock Oberhansley on 10/18/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Profile.h"

@interface BattleViewController : UIViewController

@property (strong, nonatomic) Profile *selectedProfile;

-(void)setTabBarIndexTo0;
-(void)setTabbarIndexTo2;

@end

