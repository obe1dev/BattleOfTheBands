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

- (IBAction)SignUpBand:(id)sender {
//the completion block will run true if the creatAccount method is properly ran if there was an error it'll be false
    [FireBaseController creatAccount:self.email.text password:self.password.text completion:^(bool success) {
        if (success) {
            
            [ProfileController sharedInstance].isBand = YES;
            [self performSegueWithIdentifier:@"signUpComplete" sender:nil];

        } else {
            
            [self signUpError];
        }
    }];
    
    //TODO: set isband
}

- (IBAction)SignUpListener:(id)sender {
    [FireBaseController creatAccount:self.email.text password:self.password.text completion:^(bool success) {
        if (success) {
            
            [ProfileController sharedInstance].isBand = NO;
            [self performSegueWithIdentifier:@"signUpComplete" sender:nil];
            //[self dismissViewControllerAnimated:true completion:nil];
            
        } else {
            
            [self signUpError];
        }
    }];
    //----------set profile isBand to No--------------
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.email.delegate = self;
    self.password.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated{
    self.email.text = nil;
    self.password.text = nil;
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
- (IBAction)backToLogIn:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)signUpError{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Sorry there was an error logging in. This accout may exist already" preferredStyle:UIAlertControllerStyleAlert];
    
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
