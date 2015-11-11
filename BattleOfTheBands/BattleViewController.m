//
//  ViewController.m
//  Battle Of The Bands
//
//  Created by Brock Oberhansley on 10/18/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "BattleViewController.h"
#import "DetailTableViewController.h"
#import "ProfileController.h"
#import "Profile.h"
#import "LoginViewController.h"

@interface BattleViewController ()
@property (weak, nonatomic) IBOutlet UIButton *leftBandPlay;
@property (weak, nonatomic) IBOutlet UIButton *rightBandPlay;


@property (weak, nonatomic) IBOutlet UIButton *leftBandName;
@property (weak, nonatomic) IBOutlet UIButton *rightBandName;


@property (weak, nonatomic) IBOutlet UIButton *leftbandCheckBox;
@property (weak, nonatomic) IBOutlet UIButton *rightBandCheckBox;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *voteButton;


@end

@implementation BattleViewController

+ (BattleViewController *)sharedInstance {
    static BattleViewController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [BattleViewController new];
    });
    return sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.leftbandCheckBox.imageView.image = [UIImage imageNamed:@"incomplete"];
    //TODO: update the buttons with label and image form randomly selected bands
    [self.leftBandName setTitle:@"left Button" forState:UIControlStateNormal];
    //self.leftBandPlay.imageView.image =
    
    
    [self.rightBandName setTitle:@"right Button" forState:UIControlStateNormal];
    //self.rightBandPlay.imageView.image =
    
#warning login cehck is not working
    //login check
//    if (!self.islogin) {
//        
//        LoginViewController * loginView = [LoginViewController new];
//        
//        [self presentViewController:loginView animated:NO completion:nil];
//    }
    
}

//change to the next battle
- (IBAction)next:(id)sender {
}

//band art play and pause buttons
- (IBAction)leftBandPlay:(id)sender {
    
}

- (IBAction)rightBandPlay:(id)sender {
    
}

//name of band and segue to detail of band
- (IBAction)leftBandName:(id)sender {
    
}

- (IBAction)rightBandName:(id)sender {
    
}

//check box to vote
- (IBAction)leftbandCheckBox:(id)sender {
#warning this won't change images after it's clicked whats wrong
    self.leftbandCheckBox.selected = YES;
    self.rightBandCheckBox.selected = NO;
    if (self.leftbandCheckBox.selected) {
        self.leftbandCheckBox.imageView.image = [UIImage imageNamed:@"complete"];
        self.rightBandCheckBox.imageView.image = [UIImage imageNamed:@"incomplete"];
    }
    
    
}

- (IBAction)rightBandCheckBox:(id)sender {
    
}

//voting
- (IBAction)vote:(id)sender {
    
}

// TODO: update so the segue will update the detailViewController 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"rightButtonSegue"]) {
        
    //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        
    DetailTableViewController * detailViewController = segue.destinationViewController;
        
    //Profile *profile = [ProfileController sharedInstance].topTenBandProfiles;
        
    //detailViewController.profile = profile;
    }
    
    if ([segue.identifier isEqualToString:@"leftButtonSegue"]) {
        
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        
        DetailTableViewController * detailViewController = segue.destinationViewController;
        
        //    Profile *profile = [ProfileController sharedInstance].profiles[indexPath.row];
        //
        //detailViewController.profile = profile;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
