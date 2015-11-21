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
#import "DeleteProfileCell.h"
#import "S3Manager.h"

typedef NS_ENUM(NSUInteger, ProfileRow) {
    ProfileRowPhoto,
    ProfileRowName,
    ProfileRowRankVotes,
    ProfileRowBio,
    ProfileRowWebsite,
    ProfileRowDelete,
};

@interface ProfileTableViewController () <TextFieldCellDelegate,BandBioCellDelegate,PhotoCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MPMediaPickerControllerDelegate,DeleteProfileDelegate>;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Logout;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Edit;

@property (assign, nonatomic) BOOL isBand;

@property (assign, nonatomic) BOOL isEditting;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) NSNumber *votes;
@property (strong, nonatomic) NSData *bandImage;
@property (strong, nonatomic) NSNumber *rank;
@property (strong, nonatomic) MPMediaItem *song;

@end

@implementation ProfileTableViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isBand = YES;
    
   
    
    [self updateBandProfile];
    
    
//this if for adding listeners
    
//    Profile *currentProfile = [ProfileController sharedInstance].currentProfile;
    
    
//    if (currentProfile.isBand == YES) {
//        [self updateBandProfile];
//        self.isBand = YES;
//    }
//    else if (currentProfile.isBand == NO) {
//        [self updateListenerProfile];
//        self.isBand = NO;
//    }
    
    
    
    //creating song data for user name and user
    [[SongsController sharedInstance] createSongWithsongName:@"song that is good" songData:@""];
    
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    //Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self registerForNotifications];
}

-(void)viewDidAppear:(BOOL)animated{
    
    if ([ProfileController sharedInstance].isListener) {
        [self.tabBarController setSelectedIndex:0];
    }
    
    if ([ProfileController sharedInstance].needsToFillOutProfile) {
        [self editButtonError];
        [self.tabBarController setSelectedIndex:2];
    };
    
}

//TODO: setup a picker View for genres

- (void)updateBandProfile {
    
    Profile *currentProfile = [ProfileController sharedInstance].currentProfile;
    Songs *currentSong = [SongsController sharedInstance].currentSong;
    
    if (currentProfile) {
        self.name = currentProfile.name;
        self.bio = currentProfile.bioOfBand;
        self.website = currentProfile.bandWebsite;
        self.votes = currentProfile.vote;

        self.bandImage = currentProfile.bandImage;
        self.song = currentSong.songData;
        
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

//- (void)updateListenerProfile {
//    
//    Profile *currentProfile = [ProfileController sharedInstance].currentProfile;
//    
//    if (currentProfile) {
//        self.name = currentProfile.name;
//        
//        [self.tableView reloadData];
//        NSLog(@"Updated with profile");
//    } else {
//        NSLog(@"No profile to update");
//    }
//}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBandProfile) name:currentBandProfileLoadedNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateListenerProfile) name:currentListenerProfileLoadedNotification object:nil];
}

- (IBAction)logoutButton:(id)sender {
    
    
    Profile *currentProfile = [ProfileController sharedInstance].currentProfile;
    if (currentProfile.isBand == YES) {
        [[FireBaseController bandProfile:currentProfile] unauth];
    }
    //else if (currentProfile.isBand == NO)
        [[FireBaseController listenerProfile:currentProfile] unauth];
    
    // navigate to the login view
    [self.tabBarController performSegueWithIdentifier:@"notLoggedIn" sender:nil];
    
    
}


//update text for name and website (textFields)
-(void) textChangedInCell:(TextFieldCell *)cell{
    
    NSString *updatedText = cell.infoEntryTextField.text;
    
       
    if (self.isBand) {
        
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
            case ProfileRowDelete:
                break;
                
        }
    }else if (!self.isBand){
        self.name = updatedText;
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
        case ProfileRowDelete:
            break;
    }
    
}


//this will run after the done button is tapped
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    if (editing) {
      self.isEditting = YES;
    }else{
        self.isEditting = NO;
    }
    
    
    [self.tableView reloadData];
    
    
    
    if (self.isBand) {
        if (!editing) {
            if (self.name == nil) {
                [self errorAlert];
            }else{
                [ProfileController sharedInstance].needsToFillOutProfile = NO;
            }
            if (self.website == nil) {
                self.website = @"";
            }
            
            [[ProfileController sharedInstance] updateProfileWithName:self.name bioOfBand:self.bio bandWebsite:self.website];
        }
    }
//    else if (!self.isBand){
//        if (!editing) {
//            if (self.name == nil) {
//                [self errorAlert];
//            }else{
//                [ProfileController sharedInstance].needsToFillOutProfile = NO;
//            }
//            [[ProfileController sharedInstance]  updateListenerWithName:self.name];
//        }
//    }
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
    if (self.isEditting == YES) {
        return 6;
    } else {
        return 5;
    }
    
    
    
    
    
//     else if (!self.isBand){
//        return 1;
//        //for now only have name add favorite bands later
//    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isBand) {
        
        ProfileRow row = indexPath.row;
        
        switch (row) {
            case ProfileRowPhoto: {
                PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell" forIndexPath:indexPath];
                
                UIImage *profileImage;
                
                profileImage = [UIImage imageWithData:self.bandImage];
                [cell.photoButton setImage:profileImage forState:UIControlStateNormal];
                
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
                cell.infoEntryTextField.placeholder = @"yourbandswebsite.com";
                cell.infoEntryTextField.text = self.website;
                cell.delegate = self;
                return cell;
            }
            case ProfileRowDelete: {
                DeleteProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeleteProfileCell" forIndexPath:indexPath];
                cell.delegate = self;
                return cell;
            }
               
        }
        
        
        //TODO:add a genre picker
        
#warning this if for setting up listeners in future
        //this is for the liked bands and listener
        
    }
//    else{
//        
//        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell" forIndexPath:indexPath];
//        
//        cell.infoLabel.text = @"Name";
//        cell.infoEntryTextField.placeholder = @"Enter your Name";
//        cell.infoEntryTextField.text = self.name;
//        cell.delegate = self;
//        return cell;
//        
//        
//        ProfileRow row = indexPath.row;
//        
//        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell" forIndexPath:indexPath];
//        
//        
//        switch (row) {
//                
//                
//            case ProfileRowName:{
//                
//                TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell" forIndexPath:indexPath];
//                
//                cell.infoLabel.text = @"Name";
//                cell.infoEntryTextField.placeholder = @"Enter your Name";
//                cell.infoEntryTextField.text = self.name;
//                cell.delegate = self;
//                return cell;
//                
//            }
//            case ProfileRowBio:{
//                return cell;
//                break;
//            }
//            case ProfileRowPhoto:{
//                return cell;
//                break;
//            }
//            case ProfileRowWebsite:{
//                return cell;
//                break;
//            }
//            case ProfileRowRankVotes:{
//                return cell;
//                break;
//            }
//        }
//        
//        
//    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isBand) {
        
        if (indexPath.row == 0) {
            return 250.0;
        }
        if (indexPath.row == 1) {
            return 85.0;
        }
        if (indexPath.row == 2) {
            return 46.0;
        }
        if (indexPath.row == 3) {
            return 150.0;
        }
        if (indexPath.row == 4) {
            return 85.0;
        }
        if (indexPath.row == 5) {
            return 50.0;
        }
    }
    
    //    else if(!self.isBand){
    //        if (indexPath.row == 0) {
    //            return 85.0;
    //        }
    //
    //    }
    return 0.0;
}


//this takes away the red delete button next to each row
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

//this take away the indenting while in editing mode
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

#pragma songs

-(void)uploadSongButtonTapped{
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = NO;
    mediaPicker.prompt = @"Select your song.";
    
    //MPMediaItemCollection *mediaItem = [[MPMediaItemCollection alloc] init];
    
    //[self mediaPicker:mediaPicker didPickMediaItems:<#(nonnull MPMediaItemCollection *)#>];
    [self presentViewController:mediaPicker animated:YES completion:nil];
    
}

-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    
    if (mediaItemCollection) {
        
        [self.tableView reloadData];
        
        MPMediaItem *item = [[mediaItemCollection items] objectAtIndex:0];
        NSString *string = [item valueForProperty:MPMediaItemPropertyTitle];
        NSLog(@"%@", string);

        //self.song = mediaItemCollection;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
   
    [self dismissViewControllerAnimated:YES completion:nil];
    
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

    }];
    [photoActionSheet addAction:cancelAction];
    
    
    [self presentViewController:photoActionSheet animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.bandImage = UIImageJPEGRepresentation(image, 0.8);
    
    //    [ProfileController sharedInstance].currentProfile.bandImage = self.bandImage;
    
    [self.tableView reloadData];
    
    [S3Manager uploadImage:image withName:@"image.jpg"];
    
    //TODO:save to server or firebase
  
}

#pragma delete Profile

-(void)deleteProfileButtonTapped{
#warning it does not delete the users data from firebase.
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Delete Account" message:@"Enter Your email and password to delete your account" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Email";
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
    }];
    
    UIAlertAction *deleteProfile = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *email = alertController.textFields[0].text;
        NSString *password = alertController.textFields[1].text;
        
        [FireBaseController deleteProfile:email password:password completion:^(bool success) {
            if (success) {
                
                [self ErrorWithAlert:[ProfileController sharedInstance].loginAlert message:[ProfileController sharedInstance].loginMessage];
                [self viewDidLoad];
                
                [self.tabBarController performSegueWithIdentifier:@"notLoggedIn" sender:nil];
                
            } else {
                
                [self ErrorWithAlert:[ProfileController sharedInstance].loginAlert message:[ProfileController sharedInstance].loginMessage];
                
            }
        }];
        
    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];

    [alertController addAction:deleteProfile];
    [self presentViewController:alertController animated:YES completion:nil];
    
   
}

#pragma errors

-(void)ErrorWithAlert:(NSString *)alert message:(NSString *)message{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alert message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:dismissAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)editButtonError{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Tap Edit Button" message:@"Tap the edit button to begin editing your profile, and tab done when complete" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:dismissAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

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
