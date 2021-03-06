//
//  SignUpViewController.m
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 10/31/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "SignUpViewController.h"
#import "FireBaseController.h"
#import "ProfileTableViewController.h"
#import "ProfileController.h"
#import "LoginViewController.h"
#import "BattleViewController.h"

@interface SignUpViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;


@end

@implementation SignUpViewController

- (IBAction)forgotPassword:(id)sender {
    
    [self forgotPasswordAlert];
    
}


- (IBAction)SignUpBand:(id)sender {
    
    //the completion block will run true if the creatAccount method is properly ran if there was an error it'll be false
    [FireBaseController creatAccount:self.email.text password:self.password.text completion:^(bool success) {
        if (success) {
            
            [ProfileController sharedInstance].isBand = YES;
            //self.isProfile(success);
            [self performSegueWithIdentifier:@"signUpComplete" sender:nil];
            
        } else {
            
            //[self signUpErrorMessage:[ProfileController sharedInstance].signUpMessage];
            [self loginErrorWithAlert:[ProfileController sharedInstance].loginAlert message:[ProfileController sharedInstance].loginMessage];
        }
    }];

}

// TODO: set listener in future
//    [FireBaseController creatAccount:self.email.text password:self.password.text completion:^(bool success) {
//        if (success) {
//
//            [ProfileController sharedInstance].isBand = NO;
//            [self performSegueWithIdentifier:@"signUpComplete" sender:nil];
//            //[self dismissViewControllerAnimated:true completion:nil];
//
//        } else {
//
//            [self signUpErrorMessage:[ProfileController sharedInstance].signUpMessage];
//        }
//    }];

- (IBAction)logInBand:(id)sender {
    
    [FireBaseController login:self.email.text password:self.password.text completion:^(bool success) {
        
        if (success) {
            
            //self.isProfile(success);
            [self performSegueWithIdentifier:@"signUpComplete" sender:nil];
            
        } else {
            
            [self loginErrorWithAlert:[ProfileController sharedInstance].loginAlert message:[ProfileController sharedInstance].loginMessage];
            
        }
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.email.delegate = self;
    self.password.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated{
    self.email.text = nil;
    self.password.text = nil;
    if ([ProfileController sharedInstance].loggedOut) {
        
        [self ErrorWithAlert:[ProfileController sharedInstance].loginAlert message:[ProfileController sharedInstance].loginMessage];
        [ProfileController sharedInstance].loggedOut = NO;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
    return YES;
}

-(void)dismissKeyboard {
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
}

- (IBAction)backToLogIn:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


#pragma alerts

-(void)forgotPasswordAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Forgot Password?" message:@"Plese enter your email address and you'll get a password reset email" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Email";
    }];
    
    UIAlertAction *dissmissAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *resetPassword = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *email = alertController.textFields.firstObject.text;
        
        [FireBaseController resetPassword:email completion:^(bool success) {
            
            if (success) {
                
                [self ErrorWithAlert:[ProfileController sharedInstance].loginAlert message:[ProfileController sharedInstance].loginMessage];
                
                
                
            } else {
                
                [self ErrorWithAlert:[ProfileController sharedInstance].loginAlert message:[ProfileController sharedInstance].loginMessage];
                
            }
            
        }];
        
        
    }];
    
    [alertController addAction:dissmissAction];
    
    [alertController addAction:resetPassword];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
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

-(void)ErrorWithAlert:(NSString *)alert message:(NSString *)message{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alert message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:dismissAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


@end
