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

@interface LoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailLogin;
@property (weak, nonatomic) IBOutlet UITextField *passwordLogin;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
        self.emailLogin.delegate = self;
   
        self.passwordLogin.delegate = self;
    
    
    //creating moc data
    
    //creating user
    //[FireBaseController creatAccount:@"brocktest@gmail.com" password:@"happybirthday"];
    
    //login user
    //[FireBaseController login:@"brockBandUid@gmail.com" password:@"happybirthday"];
    //[FireBaseController login:@"signUpSecond@gmail.com" password:@"signup"];
    
    //creating profile
    //[[ProfileController sharedInstance] createProfileWithName:@"Another bands" bioOfBand:@"bio" bandWebsite:@"twitter.com"];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.emailLogin resignFirstResponder];
    [self.passwordLogin resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButton:(id)sender {
    
    [FireBaseController login:self.emailLogin.text password:self.passwordLogin.text];
    
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
