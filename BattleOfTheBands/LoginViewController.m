//
//  LoginViewController.m
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 10/29/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "LoginViewController.h"
#import "FireBaseController.h"
#import "ProfileController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailLogin;
@property (weak, nonatomic) IBOutlet UITextField *passwordLogin;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //creating moc data
    
    //creating user
    //[FireBaseController creatAccount:@"brockBandUid@gmail.com" password:@"happybirthday"];
    
    //login user
    [FireBaseController login:@"brockBandUid@gmail.com" password:@"happybirthday"];
    
    //creating profile
    [[ProfileController sharedInstance] createProfileWithName:@"Another bands" bioOfBand:@"bio" bandWebsite:@"twitter.com"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButton:(id)sender {
    
    //[FireBaseController login:self.emailLogin.text password:self.passwordLogin.text];
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
