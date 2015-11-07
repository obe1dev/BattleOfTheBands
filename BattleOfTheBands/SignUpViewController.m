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

@interface SignUpViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation SignUpViewController
- (IBAction)SignUpBand:(id)sender {
    
    [FireBaseController creatAccount:self.email.text password:self.password.text];
    
    //TODO: set isband
}

- (IBAction)SignUpListener:(id)sender {
    [FireBaseController creatAccount:self.email.text password:self.password.text];
    //----------set profile isBand to No--------------
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.email.delegate = self;
    self.password.delegate = self;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
