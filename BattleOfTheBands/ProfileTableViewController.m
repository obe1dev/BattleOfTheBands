//
//  ProfileTableViewController.m
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 10/28/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "FireBaseController.h"
#import "SongsController.h"
#import "ProfileController.h"
#import "PhotoCell.h"
#import "RankingVotesCell.h"
#import "TextFieldCell.h"
#import "BandBioCell.h"
#import "FollowingTitleCell.h"
#import "FollowingBandCell.h"
#import "S3Manager.h"

typedef NS_ENUM(NSUInteger, ProfileRow) {
    ProfileRowPhoto,
    ProfileRowName,
    ProfileRowRankVotes,
    ProfileRowBio,
    ProfileRowWebsite,
};

@interface ProfileTableViewController () <TextFieldCellDelegate,BandBioCellDelegate,PhotoCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Logout;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Edit;

//this is fake data this will be set in the profile property
@property (assign, nonatomic) BOOL isBand;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) NSNumber *votes;
@property (strong, nonatomic) NSData *bandImage;
@property (strong, nonatomic) NSNumber *rank;

@end

@implementation ProfileTableViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isBand = YES;
    
    [self updateWithProfile];
    
    //creating song data for user name and user
    [[SongsController sharedInstance] createSongWithsongName:@"song that is good" songData:@""];
    
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
     //Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self registerForNotifications];
}

-(void)viewDidAppear:(BOOL)animated{
    
#warning signUp stuff
    if ([ProfileController sharedInstance].needsToFillOutProfile) {
        [self.tabBarController setSelectedIndex:2];
    };
    
}

//TODO: setup a picker View for genres

- (void)updateWithProfile {
    
    Profile *currentProfile = [ProfileController sharedInstance].currentProfile;

    if (currentProfile) {
        self.name = currentProfile.name;
        self.bio = currentProfile.bioOfBand;
        self.website = currentProfile.bandWebsite;
        self.votes = currentProfile.vote;
        
        [[ProfileController sharedInstance] rankForProfile:currentProfile completion:^(NSNumber *rank) {
            self.rank = rank;
            [self.tableView reloadData];
        }];

        
        [self.tableView reloadData];
        NSLog(@"Updated with profile");
    } else {
        NSLog(@"No profile to update");
    }
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWithProfile) name:currentProfileLoadedNotification object:nil];
}

- (IBAction)logoutButton:(id)sender {

//    TODO: check to see if this is working and segue back to login view.
    Profile *currentProfile = [ProfileController sharedInstance].currentProfile;
    [[FireBaseController bandProfile:currentProfile] unauth];
    
    // navigate to the tab bar controller's first view
    [self.tabBarController performSegueWithIdentifier:@"notLoggedIn" sender:nil];
    
    
}


//update text for name and website (textFields)
-(void) textChangedInCell:(TextFieldCell *)cell{
    
    NSString *updatedText = cell.infoEntryTextField.text;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    ProfileRow row = indexPath.row;
    
    switch (row) {
        case ProfileRowName:
            self.name = updatedText;
            break;
        case ProfileRowWebsite:
            self.website = updatedText;
            break;
        case ProfileRowBio:
        case ProfileRowRankVotes:
        case ProfileRowPhoto:
            break;
            
    }

}


//update text for bio (textView)
- (void)bioChangedInCell:(BandBioCell *)cell{
    
    NSString *updatedText = cell.bandBioTextView.text;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    ProfileRow row = indexPath.row;
    
    switch (row) {
        case ProfileRowName:
        case ProfileRowWebsite:
        case ProfileRowBio:
            self.bio = updatedText;
            break;
        case ProfileRowRankVotes:
        case ProfileRowPhoto:
            break;
    }
    
}


//this will run after the done button is tapped
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    if (!editing) {
#warning signUp stuff
        if (self.name == nil) {
            [self errorAlert];
        }else{
            [ProfileController sharedInstance].needsToFillOutProfile = NO;
        }
        
        [[ProfileController sharedInstance] updateProfileWithName:self.name bioOfBand:self.bio bandWebsite:self.website];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.isBand) {
        return  5;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isBand) {
        
        ProfileRow row = indexPath.row;
        
        switch (row) {
            case ProfileRowPhoto: {
                PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell" forIndexPath:indexPath];
                cell.photoButton.titleLabel.text = @"Add Photo";
                cell.uploadSongButton.titleLabel.text = @"Add Song";
                cell.delegate = self;
                
                return cell;
            }
            case ProfileRowName: {
                TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell" forIndexPath:indexPath];
                cell.infoLabel.text = @"Band Name";
                cell.infoEntryTextField.placeholder = @"Enter your band Name";
                cell.infoEntryTextField.text = self.name;
                cell.delegate = self;
                
                return cell;
            }
            case ProfileRowRankVotes: {
                RankingVotesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankingVotesCell" forIndexPath:indexPath];
               
                if ([self.rank intValue] <= 0) {
                    self.rank = nil;
                }
                
                cell.ranking.text = [self.rank stringValue];
                cell.votes.text = [self.votes stringValue];
                return cell;
            }
            case ProfileRowBio: {
                BandBioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BandBioCell" forIndexPath:indexPath];
                cell.bandBioLabel.text = @"Band Bio";
                cell.bandBioTextView.text = @"";
                cell.bandBioTextView.text = self.bio;
                cell.delegate = self;
                return cell;
            }
            case ProfileRowWebsite: {
                TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell" forIndexPath:indexPath];
                cell.infoLabel.text = @"Bands Website";
                cell.infoEntryTextField.placeholder = @"Enter your band Website";
                cell.infoEntryTextField.text = self.website;
                cell.delegate = self;
                return cell;
            }
        }
        
        
        //TODO:add a genre picker
        
        
        //this is for the liked bands and listener
    }
        
//        if (indexPath.row == 0) {
    
    TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell" forIndexPath:indexPath];
    cell.infoLabel.text = @"Name";
    cell.infoEntryTextField.placeholder = @"Enter your Name";
    return cell;
    
//        }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isBand) {
        
        if (indexPath.row == 0) {
            return 250;
        }
        if (indexPath.row == 1) {
            return 85;
        }
        if (indexPath.row == 2) {
            return 46;
        }
        if (indexPath.row == 3) {
            return 150;
        }
        if (indexPath.row == 4) {
            return 85;
        }
        
    }else if(!self.isBand){
        
    }
    return 0;
}


//this takes away the red delete button next to each row
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

//this take away the indenting while in editing mode
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

#pragma band photo


- (void)photoCellButtonTapped {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    UIAlertController *photoActionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraRollAction = [UIAlertAction actionWithTitle:@"From Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    [photoActionSheet addAction:cameraRollAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [photoActionSheet addAction:cancelAction];
    
    
    [self presentViewController:photoActionSheet animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.bandImage = UIImageJPEGRepresentation(image, 0.8);
    
    [self.tableView reloadData];
    
    [S3Manager uploadImage:image withName:@"image.jpg"];
    
    //save to server or firebase
    //[self.bandImage ];
}

#warning signUp stuff
-(void)errorAlert{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Sorry you have to enter a name" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:dismissAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


//- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
//    [super setEditing:editing animated:NO];
//    
//    
//}

@end
