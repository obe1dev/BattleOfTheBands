//
//  TabBarViewController.m
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 11/18/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "TabBarViewController.h"
#import "LoginViewController.h"
#import "SignUpViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"notLoggedIn"]) {
        SignUpViewController *dismiss = (SignUpViewController *)segue.destinationViewController;
        LoginViewController *controller = (LoginViewController *)segue.destinationViewController;
        controller.didSelectListen = ^{

            [self dismissViewControllerAnimated:YES completion:nil];
            

        };
        
        dismiss.isProfile = ^(BOOL success){
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
