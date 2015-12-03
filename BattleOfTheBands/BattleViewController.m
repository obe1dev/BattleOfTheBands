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
#import "soundController.h"
#import "FireBaseController.h"
#import "S3Manager.h"

@interface BattleViewController ()
@property (weak, nonatomic) IBOutlet UIButton *leftBandPlay;
@property (weak, nonatomic) IBOutlet UIButton *rightBandPlay;

@property (weak, nonatomic) IBOutlet UIButton *leftPlayPause;
@property (weak, nonatomic) IBOutlet UIButton *rightPlayPause;

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

@property (nonatomic, strong) soundController *leftSoundController;
@property (nonatomic, strong) soundController *rightSoundController;

@property (strong, nonatomic) AVAudioPlayer *player;

@property (assign, nonatomic) BOOL okToSkip;
@property (assign, nonatomic) BOOL leftBandLoad;
@property (assign, nonatomic) BOOL rightbandLoad;


@end

@implementation BattleViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUpdatedProfiles) name:randomBandProfileLoadedNotification object:nil];
}

- (void)showUpdatedProfiles {

    Profile *profile1 = [ProfileController sharedInstance].randomBand[0];
    self.leftProfile = profile1;
    
    
    Profile *profile2 = [ProfileController sharedInstance].randomBand[1];
    self.rightPrfile = profile2;
    
    NSLog(@"Updating random bands, first: %@, second %@", profile1.name, profile2.name);
    
   
    //self.leftBandName.titleLabel.text = [NSString stringWithString:profile1.name];
    [self.leftBandName setTitle:profile1.name forState:UIControlStateNormal];
    self.leftBandName.titleLabel.textAlignment = NSTextAlignmentCenter;
    [S3Manager downloadImageWithName:profile1.uID dataPath:profile1.uID completion:^(NSData *data) {
        if ([profile1.uID isEqualToString: self.leftProfile.uID]) {
            if (data) {
                
                UIImage *profileImage = [UIImage imageWithData:data];
                
                [self.leftBandPlay setImage:profileImage forState:UIControlStateNormal];
                
                
            } else {
                
                UIImage *profileImage = [UIImage imageNamed:@"anchorIcon"];
                [self.leftBandPlay setImage:profileImage forState:UIControlStateNormal];
                //self.leftBandPlay.imageView.image = [UIImage imageNamed:@"anchorIcon"];
            }
        }
    }];
    
    [S3Manager downloadSongWithName:[NSString stringWithFormat:@"%@.m4a", profile1.uID] dataPath:profile1.uID completion:^(NSData *data) {
        if (data) {
            
            NSURL *profile1SongURL = [[ProfileController sharedInstance] songURLForProfile:profile1];
            [data writeToURL:profile1SongURL atomically:YES];
            
        }
    }];

    
    
    
    [self.rightBandName setTitle:profile2.name forState:UIControlStateNormal];
    self.rightBandName.titleLabel.textAlignment = NSTextAlignmentCenter;
    [S3Manager downloadImageWithName:profile2.uID dataPath:profile2.uID completion:^(NSData *data) {
        if ([profile2.uID isEqualToString: self.rightPrfile.uID]) {
            if (data) {
                
                UIImage *profileImage = [UIImage imageWithData:data];
                
                [self.rightBandPlay setImage:profileImage forState:UIControlStateNormal];
                
                //self.rightBandPlay.imageView.image = [UIImage imageWithData:data];
                
            } else {
                
                UIImage *profileImage = [UIImage imageNamed:@"anchorIcon"];
                [self.rightBandPlay setImage:profileImage forState:UIControlStateNormal];
                //self.rightBandPlay.imageView.image = [UIImage imageNamed:@"anchorIcon"];
            }
        }
    }];
    [S3Manager downloadSongWithName:[NSString stringWithFormat:@"%@.m4a", profile2.uID] dataPath:profile2.uID completion:^(NSData *data) {
        if (data) {
            NSURL *profile2SongURL = [[ProfileController sharedInstance] songURLForProfile:profile2];
            [data writeToURL:profile2SongURL atomically:YES];
        }
    }];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.completeImage = [UIImage imageNamed:@"complete"];
    self.incompleteImage = [UIImage imageNamed:@"incomplete"];
    
    
    self.leftSoundController = nil;
    self.rightSoundController = nil;
    

    [[ProfileController sharedInstance] loadRandomBands];
    
    [self.leftbandCheckBox setImage:self.incompleteImage forState:UIControlStateNormal];
    [self.rightBandCheckBox setImage:self.incompleteImage forState:UIControlStateNormal];

    [self registerForNotifications];
//    self.soundController = [[soundController alloc] init];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([ProfileController sharedInstance].isListener) {
        
        UIBarButtonItem *logout = [[UIBarButtonItem alloc]initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(segue)];
        
        self.navigationItem.leftBarButtonItem = logout;
        
        
        if ([self.tabBarController viewControllers].count == 3) {
            
            
            //Remove the third tab from a tab bar controlled by a tab bar controller
            NSMutableArray * vcs = [NSMutableArray
                                    arrayWithArray:[self.tabBarController viewControllers]];
            [vcs removeObjectAtIndex:2];
            [self.tabBarController setViewControllers:vcs];
        }
    }
    
#warning  signUp stuff 
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

- (void) segue{
    [self.tabBarController performSegueWithIdentifier:@"notLoggedIn" sender:nil];
    [ProfileController sharedInstance].isListener = NO;
}

//change to the next battle
- (IBAction)next:(id)sender {
    
    self.completeImage = [UIImage imageNamed:@"complete"];
    self.incompleteImage = [UIImage imageNamed:@"incomplete"];
    
    [[ProfileController sharedInstance] loadRandomBands];
    
    [self.leftbandCheckBox setImage:self.incompleteImage forState:UIControlStateNormal];
    [self.rightBandCheckBox setImage:self.incompleteImage forState:UIControlStateNormal];
    
    self.leftPlayPause.selected=NO;
    self.rightPlayPause.selected=NO;
    
    self.rightSoundController = nil;
    self.leftSoundController = nil;
    
}

//band art play and pause buttons
- (IBAction)leftBandPlay:(id)sender {

    NSURL *songURL = [[ProfileController sharedInstance] songURLForProfile:self.leftProfile];
    if (!self.leftSoundController) {
        self.leftSoundController = [[soundController alloc] initWithURL:songURL];
    }
    
    if (self.leftPlayPause.selected == YES) {
        
        self.leftPlayPause.selected=NO;
        [self.leftSoundController pauseAudioFile];
    }
    else{
        self.leftPlayPause.selected = YES;
        [self.rightSoundController pauseAudioFile];
        [self.leftSoundController playAudioFile];
    }
    
    
    self.rightPlayPause.selected = NO;

}
- (IBAction)leftPalyPause:(id)sender {
    
    [self leftBandPlay:(id)sender];
    
}


- (IBAction)rightBandPlay:(id)sender {
    
    NSURL *songURL = [[ProfileController sharedInstance] songURLForProfile:self.rightPrfile];
//    [self.soundController playAudioFileAtURL:songURL];
    
    if (!self.rightSoundController) {
        self.rightSoundController = [[soundController alloc] initWithURL:songURL];
    }
    if (self.rightPlayPause.selected == YES) {
        
        self.rightPlayPause.selected=NO;
        [self.rightSoundController pauseAudioFile];
    }
    else{
        self.rightPlayPause.selected = YES;
        [self.leftSoundController pauseAudioFile];
        [self.rightSoundController playAudioFile];
    }

    //ended
//    if (self.rightPlayPause.selected == YES) {
//        self.rightPlayPause.selected=NO;
////        [self.soundController pauseAudioFile];
//        
//    }else{
//        self.rightPlayPause.selected=YES;
////        [self.soundController playAudioFileAtURL:songURL];
//        
//    }
    
    self.leftPlayPause.selected = NO;
    

    
}
- (IBAction)rightPlayPuase:(id)sender {
    
    [self rightBandPlay:(id)sender];
    
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
    
    self.leftPlayPause.selected = NO;
    self.rightPlayPause.selected = NO;
    
    //setting this to nil will reset
    self.rightSoundController = nil;
    self.leftSoundController = nil;
    
    
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
