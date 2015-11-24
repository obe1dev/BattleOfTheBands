//
//  AppearanceController.m
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 11/23/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "AppearanceController.h"

@implementation AppearanceController

+(void)initializeAppearanceDefaults{
    
    //this method will be called in the AppDelegate
    
    //this is setting the tabBar color with the RGB format and the transparent (alpha)
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:214/255 green:215/255 blue:216/255 alpha:1]];
    //sets the TitleTextAttributes include font color and font name and size. this has to be done in a dictionary
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:79/255 green:255/255 blue:96/255 alpha:1],
                                                        NSFontAttributeName: [UIFont fontWithName:@"Avenir-Light" size:20]}
                                             forState:UIControlStateNormal];
    
}

@end
