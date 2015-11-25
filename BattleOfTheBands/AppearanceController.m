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
    
    
    //TabBar
    //this is setting the tabBar color with the RGB format and the transparent (alpha)
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:72/255 green:72/255 blue:72/255 alpha:.8]];
    //sets the TitleTextAttributes include font color and font name and size. this has to be done in a dictionary
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:153/255
                                                                                                       green:153/255
                                                                                                        blue:153/255
                                                                                                       alpha:.8],
                                                        
                                                        NSFontAttributeName: [UIFont fontWithName:@"Avenir-Light"
                                                                                             size:20]}
                                                                                        forState:UIControlStateNormal];
    //selected tabBar
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:255/255
                                                                                                       green:0/255
                                                                                                        blue:0/255
                                                                                                       alpha:.8],
                                                        
                                                        NSFontAttributeName: [UIFont fontWithName:@"Avenir-Light"
                                                                                             size:20]}
                                                                                        forState:UIControlStateSelected];
  
    
    //navagation bar
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:72/255 green:72/255 blue:72/255 alpha:.8]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:237/255 green:237/255 blue:237/255 alpha:.8]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:170/255
                                                                                                         green:170/255
                                                                                                          blue:170/255
                                                                                                         alpha:.8],
                                                          NSFontAttributeName: [UIFont fontWithName:@"Avenir-Light"
                                                                                               size:20]}];
    
    //tabeView
    [[UITableView appearance] setBackgroundColor:[UIColor colorWithRed:120/255 green:120/255 blue:120/255 alpha:1]];
    //[[UITableView appearance]  = [UIColor colorWithRed:155/255 green:155/255 blue:155/255 alpha:1] ];
    
     
                                                          
    
    
}

@end
