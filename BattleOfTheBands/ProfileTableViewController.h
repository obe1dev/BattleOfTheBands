//
//  ProfileTableViewController.h
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 10/28/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileController.h"

@interface ProfileTableViewController : UITableViewController <UITableViewDelegate>

@property (strong, nonatomic) Profile *profile;


@end
