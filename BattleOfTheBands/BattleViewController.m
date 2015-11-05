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

@interface BattleViewController ()
@property (weak, nonatomic) IBOutlet UIButton *leftButtonDisplay;

@property (weak, nonatomic) IBOutlet UIButton *rightButtonDisplay;

@property (weak, nonatomic) IBOutlet UIButton *displayBandName;

@end

@implementation BattleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //TODO: update the buttons with label and image form randomly selected bands
    [self.leftButtonDisplay.titleLabel setText:@"left button"];
   // self.leftButtonDisplay.imageView.image =
    
    
    [self.rightButtonDisplay.titleLabel setText:@"right Button"];
    //self.rightButtonDisplay.imageView.image =
    
}

// TODO: update so the segue will update the detailViewController 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BattleToDetail"]) {
        
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        
        DetailTableViewController * detailViewController = segue.destinationViewController;
        
//        Profile *profile = [ProfileController sharedInstance].profiles[indexPath.row];
//        
//        detailViewController.profile = profile;
    }
}

- (IBAction)leftButton:(UIButton *)sender {
    self.displayBandName.titleLabel.text = self.leftButtonDisplay.titleLabel.text;
}

- (IBAction)rightButton:(UIButton *)sender {
    self.displayBandName.titleLabel.text = self.rightButtonDisplay.titleLabel.text;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
