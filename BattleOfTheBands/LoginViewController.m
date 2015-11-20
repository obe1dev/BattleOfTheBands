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
#import "SignUpViewController.h"
#import "BattleViewController.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailLogin;
@property (weak, nonatomic) IBOutlet UITextField *passwordLogin;

@end

@implementation LoginViewController

#warning add dismiss keyboard with tap outside
//TODO: add dismiss keyboard with tap outside

+ (LoginViewController *)sharedInstance {
    static LoginViewController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [LoginViewController new];
    });
    return sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
        self.emailLogin.delegate = self;
   
        self.passwordLogin.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated{
    self.emailLogin.text = nil;
    self.passwordLogin.text = nil;
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
- (IBAction)justListen:(id)sender {
    [ProfileController sharedInstance].isListener = YES;
    self.didSelectListen();
}

- (IBAction)loginButton:(id)sender {
    
    [FireBaseController login:self.emailLogin.text password:self.passwordLogin.text completion:^(bool success) {
        
        if (success) {
            
            self.isProfile(success);
            
        } else {
            
            [self loginErrorWithAlert:[ProfileController sharedInstance].loginAlert message:[ProfileController sharedInstance].loginMessage];
            
        }
    }];
}
- (IBAction)signUpband:(id)sender {
    //the completion block will run true if the creatAccount method is properly ran if there was an error it'll be false
    [FireBaseController creatAccount:self.emailLogin.text password:self.passwordLogin.text completion:^(bool success) {
        if (success) {
            
            [ProfileController sharedInstance].isBand = YES;
            self.isProfile(success);
            
        } else {

            [self signUpErrorMessage:[ProfileController sharedInstance].signUpMessage];
        }
    }];
    
}


-(void)loginErrorWithAlert:(NSString *)alert message:(NSString *)message{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alert message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:dismissAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

-(void)signUpErrorMessage:(NSString *)message{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:dismissAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
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
