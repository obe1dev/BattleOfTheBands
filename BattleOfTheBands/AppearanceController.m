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
    

    UIColor *tableViewColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    UIColor *barColor = [UIColor colorWithRed:12/255.0 green:12/255.0 blue:12/255.0 alpha:.5];
    UIColor *textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    NSString *font = @"Helvetica Neue";
    
    
    //TabBar
    //this is setting the tabBar color with the RGB format and the transparent (alpha)
    [[UITabBar appearance] setBarTintColor:barColor];
    //sets the TitleTextAttributes include font color and font name and size. this has to be done in a dictionary
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:textColor,
                                                        
                                                        NSFontAttributeName:[UIFont fontWithName:font
                                                                                             size:20]}
                                                                                        forState:UIControlStateNormal];
    //selected tabBar
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0
                                                                                                       green:0/255.0
                                                                                                        blue:0/255.0
                                                                                                       alpha:1],
                                                        
                                                        NSFontAttributeName: [UIFont fontWithName:font
                                                                                             size:20]}
                                                                                        forState:UIControlStateSelected];
    
    //navagation bar
    [[UINavigationBar appearance] setBarTintColor:barColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:textColor,
                                                           NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:20]}];
    [[UINavigationBar appearance] setTintColor:textColor];
    
    
    //viewcontroller
    //[[UIView appearance] setTintColor:viewColor];
    
//    //tabeView
    [[UITableViewCell appearance] setBackgroundColor:tableViewColor];
    [[UITableView appearance] setBackgroundColor:tableViewColor];
    [[UITextView appearance] setBackgroundColor:tableViewColor];
    
     
                                                          
    
    
}

@end
