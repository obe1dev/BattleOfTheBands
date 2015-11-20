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

@property (strong, nonatomic) Profile *leftProfile;
@property (strong, nonatomic) Profile *rightPrfile;

@property (strong, nonatomic) UIImage *completeImage;
@property (strong, nonatomic) UIImage *incompleteImage;
//@property (strong, nonatomic) Profile *selectedProfile;


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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUpdatedProfiles) name:randomBandProfileLoadedNotification object:nil];
}

- (void)showUpdatedProfiles {
//TODO: debug this is being call alot 
    Profile *profile1 = [ProfileController sharedInstance].randomBand[0];
    self.leftProfile = profile1;
    Profile *profile2 = [ProfileController sharedInstance].randomBand[1];
    self.rightPrfile = profile2;
    
    NSLog(@"Updating random bands, first: %@, second %@", profile1.name, profile2.name);
    
   
    //self.leftBandName.titleLabel.text = [NSString stringWithString:profile1.name];
    [self.leftBandName setTitle:profile1.name forState:UIControlStateNormal];
    //self.leftBandPlay.imageView.image =
    
    
    [self.rightBandName setTitle:profile2.name forState:UIControlStateNormal];
    //self.rightBandPlay.imageView.image =
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.completeImage = [UIImage imageNamed:@"complete"];
    self.incompleteImage = [UIImage imageNamed:@"incomplete"];

    [[ProfileController sharedInstance] loadRandomBands];
    
    [self.leftbandCheckBox setImage:self.incompleteImage forState:UIControlStateNormal];
    [self.rightBandCheckBox setImage:self.incompleteImage forState:UIControlStateNormal];

    [self registerForNotifications];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([ProfileController sharedInstance].isListener) {
#warning this is where the error is 
        if ([self.tabBarController viewControllers].count == 3) {
            
        
        //Remove the third tab from a tab bar controlled by a tab bar controller
        NSMutableArray * vcs = [NSMutableArray
                                arrayWithArray:[self.tabBarController viewControllers]];
        [vcs removeObjectAtIndex:2];
        [self.tabBarController setViewControllers:vcs];
        }
    }
    
#warning  signUp stuff work on this this loads and sets to index2 every time
    if ([ProfileController sharedInstance].needsToFillOutProfile) {
        [self.tabBarController setSelectedIndex:2];
    };
    
    
    //this is part of the loging out process
    if (![[ProfileController sharedInstance]currentProfile]) {
        if ([ProfileController sharedInstance].isListener == NO) {
            [self.tabBarController performSegueWithIdentifier:@"notLoggedIn" sender:nil];
            NSLog(@"user is not logged in");

        }
    }
    

}

//change to the next battle
- (IBAction)next:(id)sender {
#warning this is update multiple time why?
    [self viewDidLoad];
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

    self.leftbandCheckBox.selected = YES;
    self.rightBandCheckBox.selected = NO;
    if (self.leftbandCheckBox.selected) {
        //checking left box and unchecking right box
        [self.leftbandCheckBox setImage:self.completeImage forState:UIControlStateNormal];
        [self.rightBandCheckBox setImage:self.incompleteImage forState:UIControlStateNormal];
        
        self.selectedProfile = self.leftProfile;

    }

    
}

- (IBAction)rightBandCheckBox:(id)sender {
    
    self.rightBandCheckBox.selected = YES;
    self.leftbandCheckBox.selected = NO;
    if (self.rightBandCheckBox.selected) {
        
        [self.rightBandCheckBox setImage:self.completeImage forState:UIControlStateNormal];
        [self.leftbandCheckBox setImage:self.incompleteImage forState:UIControlStateNormal];
        
        self.selectedProfile = self.rightPrfile;
    }
    
}


- (IBAction)vote:(id)sender {
    
    [[ProfileController sharedInstance] updateVoteForProfile:self.selectedProfile];
    
    [self.leftbandCheckBox setImage:self.incompleteImage forState:UIControlStateNormal];
    [self.rightBandCheckBox setImage:self.incompleteImage forState:UIControlStateNormal];

    
    [[ProfileController sharedInstance] loadRandomBands];
}

//segues to detail view
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"rightButtonSegue"]) {
        
    DetailTableViewController * detailViewController = segue.destinationViewController;
        
    Profile *profile = self.rightPrfile;
        
    detailViewController.profile = profile;
        
    }
    
    else if ([segue.identifier isEqualToString:@"leftButtonSegue"]) {
        
        DetailTableViewController * detailViewController = segue.destinationViewController;
        
        Profile *profile = self.leftProfile;
        
        detailViewController.profile = profile;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//setting tabBar to index when loging in or signing up.

-(void)setTabBarIndexTo0{
    [self.tabBarController setSelectedIndex:0];
}
-(void)setTabbarIndexTo2{
    [self.tabBarController setSelectedIndex:2];
}

@end
