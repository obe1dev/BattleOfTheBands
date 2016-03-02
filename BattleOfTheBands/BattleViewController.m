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
@property (assign, nonatomic) BOOL leftBandPhotoLoad;
@property (assign, nonatomic) BOOL leftBandSongLoad;
@property (assign, nonatomic) BOOL rightbandPhotoLoad;
@property (assign, nonatomic) BOOL rightbandSongLoad;


@end

@implementation BattleViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUpdatedProfiles) name:randomBandProfileLoadedNotification object:nil];
}

- (void)showUpdatedProfiles {
    
    Profile *profile1;
    Profile *profile2;
    
    if (![ProfileController sharedInstance].randomBand) {
        
        self.rightPrfile = [[Profile alloc] init];
        self.leftProfile = [[Profile alloc] init];
        
    }else{
        
        profile1 = [ProfileController sharedInstance].randomBand[0];
        self.leftProfile = profile1;
        
        
        profile2 = [ProfileController sharedInstance].randomBand[1];
        self.rightPrfile = profile2;
    }
    
    NSLog(@"Updating random bands, first: %@, second %@", profile1.name, profile2.name);
    
    
    // LEFT BAND PROFILE
    
    [self.leftBandName setTitle:profile1.name forState:UIControlStateNormal];
    self.leftBandName.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [S3Manager downloadImageWithName:profile1.uID dataPath:profile1.uID completion:^(NSData *data) {
        if ([profile1.uID isEqualToString: self.leftProfile.uID]) {
            if (data) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSLog(@"%@", [NSDate date]);
                    
                    UIImage *profileImage = [UIImage imageWithData:data];
                    [self.leftBandPlay setImage:profileImage forState:UIControlStateNormal];
                    
                    self.leftBandPhotoLoad = YES;
                    
                });
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *profileImage = [UIImage imageNamed:@"anchorIcon"];
                    [self.leftBandPlay setImage:profileImage forState:UIControlStateNormal];
                    //self.leftBandPlay.imageView.image = [UIImage imageNamed:@"anchorIcon"];
                    
                    self.leftBandPhotoLoad = YES;
                    
                });
            }
        }
    }];
    
    [S3Manager downloadSongWithName:[NSString stringWithFormat:@"%@.m4a", self.leftProfile.uID] dataPath:self.leftProfile.uID completion:^(NSData *data) {
        if (data) {
            NSURL *songURL = [[ProfileController sharedInstance] songURLForProfile:self.leftProfile];
            [data writeToURL:songURL atomically:YES];
            
            self.leftBandSongLoad = YES;
            
        } else {
            // TODO: Alert the user?
            self.leftBandSongLoad = YES;

        }
    }];

    
    // RIGHT BAND PROFILE
    
    [self.rightBandName setTitle:profile2.name forState:UIControlStateNormal];
    self.rightBandName.titleLabel.textAlignment = NSTextAlignmentCenter;
    [S3Manager downloadImageWithName:profile2.uID dataPath:profile2.uID completion:^(NSData *data) {
        if ([profile2.uID isEqualToString: self.rightPrfile.uID]) {
            if (data) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *profileImage = [UIImage imageWithData:data];
                    [self.rightBandPlay setImage:profileImage forState:UIControlStateNormal];
                    
                    self.rightbandPhotoLoad = YES;
                    
                });
                
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *profileImage = [UIImage imageNamed:@"anchorIcon"];
                    [self.rightBandPlay setImage:profileImage forState:UIControlStateNormal];
                    //self.rightBandPlay.imageView.image = [UIImage imageNamed:@"anchorIcon"];
                    
                    self.rightbandPhotoLoad = YES;
                });
            }
        }
    }];

    [S3Manager downloadSongWithName:[NSString stringWithFormat:@"%@.m4a", self.rightPrfile.uID] dataPath:self.rightPrfile.uID completion:^(NSData *data) {
        if (data) {
            NSURL *songURL = [[ProfileController sharedInstance] songURLForProfile:self.rightPrfile];
            [data writeToURL:songURL atomically:YES];
            
            self.rightbandSongLoad = YES;
            
        } else {
            // TODO: Alert the user?
            self.rightbandSongLoad = YES;
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

-(void)viewDidDisappear:(BOOL)animated{
    
    [self.leftSoundController pauseAudioFile];
    [self.rightSoundController pauseAudioFile];
    
    self.leftPlayPause.selected= NO;
    self.rightPlayPause.selected = NO;
    
}

- (void) segue{
    [self.tabBarController performSegueWithIdentifier:@"notLoggedIn" sender:nil];
    [ProfileController sharedInstance].isListener = NO;
}

//change to the next battle
- (IBAction)next:(id)sender {

#warning if  next button pressed repeatedly before band info loads, it will play the the previously loaded image and song.
    
    [S3Manager cancelDownload];
    
    self.completeImage = [UIImage imageNamed:@"complete"];
    self.incompleteImage = [UIImage imageNamed:@"incomplete"];
    
    [[ProfileController sharedInstance] loadRandomBands];
    
    [self.leftbandCheckBox setImage:self.incompleteImage forState:UIControlStateNormal];
    [self.rightBandCheckBox setImage:self.incompleteImage forState:UIControlStateNormal];
    
    self.leftPlayPause.selected = NO;
    self.rightPlayPause.selected = NO;
    
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

- (IBAction)leftPerviousSong:(id)sender {
    
    self.leftPlayPause.selected=NO;
    
    [self.leftSoundController perviousAudioFile];
    
}

- (IBAction)rightBandPlay:(id)sender {
    
    NSURL *songURL = [[ProfileController sharedInstance] songURLForProfile:self.rightPrfile];
    
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
    
    
    self.leftPlayPause.selected = NO;
    
    
    
}
- (IBAction)rightPlayPuase:(id)sender {
    
    [self rightBandPlay:(id)sender];
    
}

- (IBAction)rightPerviousSong:(id)sender {
    
    self.rightPlayPause.selected=NO;
    
    [self.rightSoundController perviousAudioFile];
    
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
    
    if (self.selectedProfile) {
        
        [[ProfileController sharedInstance] updateVoteForProfile:self.selectedProfile];
        
    }
    
    
    [self.leftbandCheckBox setImage:self.incompleteImage forState:UIControlStateNormal];
    [self.rightBandCheckBox setImage:self.incompleteImage forState:UIControlStateNormal];
    
    self.leftPlayPause.selected = NO;
    self.rightPlayPause.selected = NO;
    
    //this will reset its value so the next bands called will be able to send its url to the player.
    self.rightSoundController = nil;
    self.leftSoundController = nil;
    
    self.selectedProfile = nil;
    
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
