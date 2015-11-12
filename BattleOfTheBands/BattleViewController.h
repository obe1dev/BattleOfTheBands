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

#warning login is not working
+ (BattleViewController *)sharedInstance;

@property (assign, nonatomic) BOOL islogin;
@property (strong, nonatomic) Profile *selectedProfile;

@end

