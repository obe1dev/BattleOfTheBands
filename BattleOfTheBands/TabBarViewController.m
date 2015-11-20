//
//  TabBarViewController.m
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 11/18/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "TabBarViewController.h"
#import "LoginViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"notLoggedIn"]) {
        LoginViewController *controller = (LoginViewController *)segue.destinationViewController;
        controller.didSelectListen = ^{
#warning i need to find a way to remove profile form tabBar
            [self dismissViewControllerAnimated:YES completion:nil];
             //TODO: Disable tab bar
            
//            [[[[self tabBar] items] objectAtIndex:2] setEnabled:NO];
        };
        
        controller.isProfile = ^(BOOL success){
            if (success) {
                // YAY!
            } else {
                // handle it
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    }
}


@end
