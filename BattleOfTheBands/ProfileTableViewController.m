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
#import "ResetPasswordCell.h"
#import "S3Manager.h"
#import "SongCell.h"
#import "soundController.h"
#import "SignUpViewController.h"


typedef NS_ENUM(NSUInteger, ProfileRow) {
    ProfileRowPhoto = 0,
    ProfileRowName,
    profileRowSong,
    ProfileRowRankVotes,
    ProfileRowBio,
    ProfileRowWebsite,
    ProfileRowReset,
    ProfileRowDelete,
};

@interface ProfileTableViewController () <TextFieldCellDelegate,BandBioCellDelegate,PhotoCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MPMediaPickerControllerDelegate,DeleteProfileDelegate,ResetPasswordDelegate,SongCellDelegate>;
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
@property (strong, nonatomic) NSData *song;

@property (assign, nonatomic) BOOL failure;
@property (assign, nonatomic) BOOL success;
//@property (assign, nonatomic) BOOL loggedOut;

@property (nonatomic, strong) soundController *soundController;


@end

@implementation ProfileTableViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isBand = YES;
    
    [ProfileController sharedInstance].loggedOut = NO;
    //self.loggedOut = NO;
    
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

-(void)viewWillDisappear:(BOOL)animated{
    
    [self.soundController pauseAudioFile];
    
}


- (void)updateBandProfile {
    
    Profile *currentProfile = [ProfileController sharedInstance].currentProfile;
    
    if (currentProfile) {
        self.name = currentProfile.name;
        self.bio = currentProfile.bioOfBand;
        self.website = currentProfile.bandWebsite;
        self.votes = currentProfile.vote;

        [S3Manager downloadImageWithName:currentProfile.uID dataPath:currentProfile.uID completion:^(NSData *data) {
            if (data) {
                self.bandImage = data;
                [self.tableView reloadData];
            } else {
                // TODO: Alert the user?
            }
        }];


        [S3Manager downloadSongWithName:[NSString stringWithFormat:@"%@.m4a", currentProfile.uID] dataPath:currentProfile.uID completion:^(NSData *data) {
            if (data) {
                self.song = data;
                [self.tableView reloadData];
            } else {
                // TODO: Alert the user?
            }
        }];

        
        
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
    else if (currentProfile.isBand == NO){
//        [[FireBaseController listenerProfile:currentProfile] unauth];
    }
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
            case profileRowSong:
            case ProfileRowReset:
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
        case profileRowSong:
        case ProfileRowReset:
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isEditting == YES) {
        
        return 8;
        
    } else {
        return 6;
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
                
                if (self.success) {

                    [self ErrorWithAlert:@"Success" message:@"You have successfully loaded your song! It might take a moment to play your song."];
                    self.success = NO;

                }
                
                if (self.failure) {
                    
                    [self ErrorWithAlert:@"Failure" message:@"There was an error loading your song."];
                    self.failure = NO;
                }
                
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
            case profileRowSong: {
                SongCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songCell" forIndexPath:indexPath];
                
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
            
        
            case ProfileRowReset: {
                ResetPasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResetPasswordCell" forIndexPath:indexPath];
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
            return 65.0;
        }
        if (indexPath.row == 3) {
            return 46.0;
        }
        if (indexPath.row == 4) {
            return 150.0;
        }
        if (indexPath.row == 5) {
            return 85.0;
        }
        if (indexPath.row == 6) {
            return 50.0;
        }
        if (indexPath.row == 7) {
            return 50.0;
        }
    }
    
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
    mediaPicker.showsCloudItems = NO;
    mediaPicker.prompt = @"Select your song";
    
    [self presentViewController:mediaPicker animated:YES completion:nil];
    
}

-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    
    if (mediaItemCollection) {
        
        [self.tableView reloadData];
        
        MPMediaItem *item = [[mediaItemCollection items] objectAtIndex:0];
        
        [self mediaItemToData:item];

    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
   
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)mediaItemToData : (MPMediaItem * ) curItem
{
    UILabel *loading = [[UILabel alloc] initWithFrame:CGRectMake(60, 110 , 100, 25)];
    loading.text = @"Uploading..";
    loading.textColor= [UIColor whiteColor];
    
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height/2 - 75 - 130, 200, 150)];
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    spinner.backgroundColor = [UIColor colorWithWhite:.333 alpha:.98];
    
    [spinner addSubview:loading];
    
    [spinner layer].cornerRadius = 8.0;
    [spinner layer].masksToBounds = YES;
    spinner.color = [UIColor redColor];
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    
    [spinner startAnimating];
    
    NSURL *url = [curItem valueForProperty: MPMediaItemPropertyAssetURL];
    
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL: url options:nil];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset: songAsset
                                                                      presetName:AVAssetExportPresetAppleM4A];
 
    exporter.outputFileType = @"com.apple.m4a-audio";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * myDocumentsDirectory = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSTimeInterval seconds = [[NSDate date] timeIntervalSince1970];
    NSString *intervalSeconds = [NSString stringWithFormat:@"%0.0f",seconds];
    
    NSString * fileName = [NSString stringWithFormat:@"%@.m4a",intervalSeconds];
    
    NSString *exportFile = [myDocumentsDirectory stringByAppendingPathComponent:fileName];
    
    NSURL *exportURL = [NSURL fileURLWithPath:exportFile];
    exporter.outputURL = exportURL;
    
    if (!exporter) {
        
        self.failure = YES;
        
    }
    
    // do the export
    [exporter exportAsynchronouslyWithCompletionHandler:
     ^{
         
         
         int exportStatus = exporter.status;
         
         switch (exportStatus)
         {
             case AVAssetExportSessionStatusFailed:
             {
                 NSError *exportError = exporter.error;
                 NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                 
                 [spinner stopAnimating];
                 
                 self.failure = YES;
                 
                 break;
             }
             case AVAssetExportSessionStatusCompleted:
             {
                 
                 NSLog (@"AVAssetExportSessionStatusCompleted");
                 
                 NSData *data = [NSData dataWithContentsOfFile: exportFile];
                 
                 NSString *songKey = [NSString stringWithFormat:@"%@.m4a", [ProfileController sharedInstance].currentProfile.uID];
                 
                 [S3Manager uploadSong:data withName:songKey completion:^(BOOL success) {
                     if (success) {
                         // Save to firebase.
                         [ProfileController sharedInstance].currentProfile.songPath = songKey;
                         [[ProfileController sharedInstance] saveProfile:[ProfileController sharedInstance].currentProfile];
                         NSLog(@"Got to success block");
                         
                         [spinner stopAnimating];
                         
                         self.success = YES;
                         [self.tableView reloadData];
                     } else {
                         
                     }
                 }];
                 
                 break;
             }
             case AVAssetExportSessionStatusUnknown:
             {
                 NSLog (@"AVAssetExportSessionStatusUnknown"); break;
             }
             case AVAssetExportSessionStatusExporting:
             {
                 NSLog (@"AVAssetExportSessionStatusExporting"); break;
             }
             case AVAssetExportSessionStatusCancelled:
             {
                 NSLog (@"AVAssetExportSessionStatusCancelled"); break;
             }
             case AVAssetExportSessionStatusWaiting:
             {
                 NSLog (@"AVAssetExportSessionStatusWaiting"); break;
             }
             default:
             {
                 NSLog (@"didn't get export status");
                 
                 self.failure = YES;
                 
                 break;
             }
         }
     }];
}

#pragma song play

-(void)playButtonTapped:(SongCell *)cell{
    
    NSURL *songURL = [[ProfileController sharedInstance] songURLForProfile:[ProfileController sharedInstance].currentProfile];
    
    if (!songURL) {
        
        NSLog(@"ERROR songURL is nil");
        
    }
    
    if (!self.soundController) {
        self.soundController = [[soundController alloc] initWithURL:songURL];
    }
    
    if (cell.playPauseButton.selected == YES) {
        
        cell.playPauseButton.selected=NO;
        [self.soundController pauseAudioFile];
    }
    else{
        cell.playPauseButton.selected = YES;
        [self.soundController playAudioFile];
    }
    
}

-(void)perviousButton:(SongCell *)cell{
    
    cell.playPauseButton.selected=NO;
    [self.soundController perviousAudioFile];
}

#pragma band photo


- (void)photoCellButtonTapped: (UIButton *)button {
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
    
    photoActionSheet.popoverPresentationController.sourceView = self.view;
    photoActionSheet.popoverPresentationController.sourceRect = button.frame;
    
    
    [self presentViewController:photoActionSheet animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    // shrink image to 40% of the size
    
    CGSize size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(0.2, 0.2));
    BOOL hasAlpha = false;
    CGFloat scale = 0.0;
    
    CGRect rect = CGRectMake(0, 0, 0, 0);
    
    rect.size = size;
    rect.origin = CGPointZero;
    
    UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale);
    [image drawInRect:rect];

    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // compress image
    
    self.bandImage = UIImageJPEGRepresentation(scaledImage, 0.5);

    UIImage *compressedImage = [UIImage imageWithData:self.bandImage];
    
    [self.tableView reloadData];
    
    NSString *imageName = [ProfileController sharedInstance].currentProfile.uID;
    
    [S3Manager uploadImage:compressedImage withName:imageName completion:^(BOOL success){
        if (success) {
            [ProfileController sharedInstance].currentProfile.bandImagePath = imageName;
            [[ProfileController sharedInstance] saveProfile:[ProfileController sharedInstance].currentProfile];
        }
    }];
    
  
}

#pragma delete Profile

-(void)resetPasswordButtonTapped{
  
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reset Password" message:@"Enter in your current or temporary password. And then enter in your new password" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Current Password";
        textField.secureTextEntry = YES;
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"New Password";
        textField.secureTextEntry = YES;
    }];
    
    UIAlertAction *resetPassword = [UIAlertAction actionWithTitle:@"Change" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *oldPassword = alertController.textFields[0].text;
        NSString *newPassword = alertController.textFields[1].text;
        
        [FireBaseController changePassword:oldPassword newPassword:newPassword completion:^(bool success) {
           
            if (success) {
                
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
//            [self ErrorWithAlert:[ProfileController sharedInstance].loginAlert message:[ProfileController sharedInstance].loginMessage];
                
                [ProfileController sharedInstance].loggedOut = YES;
                //self.loggedOut = YES;
                
            
        } else {
            
            [ProfileController sharedInstance].loggedOut = NO;
            //self.loggedOut = NO;
            
            [self ErrorWithAlert:[ProfileController sharedInstance].loginAlert message:[ProfileController sharedInstance].loginMessage];
        }

        }];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];
    
    [alertController addAction:resetPassword];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)deleteProfileButtonTapped{
#warning  app crashes after deleting profile
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
                
//                [self ErrorWithAlert:[ProfileController sharedInstance].loginAlert message:[ProfileController sharedInstance].loginMessage];
                //[self viewDidLoad];
                
                
                Profile *currentProfile = [ProfileController sharedInstance].currentProfile;
                
                
                //this will delete the data from the profile
                [[FireBaseController bandProfile:currentProfile] removeValue];
                
                [S3Manager deleteImage:[ProfileController sharedInstance].currentProfile.uID completion:nil];
                [S3Manager deleteSong:[ProfileController sharedInstance].currentProfile.uID completion:nil];
                
                [ProfileController sharedInstance].loggedOut = YES;
                
//                [self dismissViewControllerAnimated:YES completion:nil];
                
            } else {
                
                [self ErrorWithAlert:[ProfileController sharedInstance].loginAlert message:[ProfileController sharedInstance].loginMessage];
                
                [ProfileController sharedInstance].loggedOut = NO;
//                self.loggedOut = NO;
            }
        }];
        
        if ([ProfileController sharedInstance].loggedOut == YES) {
            
            [self.tabBarController performSegueWithIdentifier:@"notLoggedIn" sender:nil];
            
        }
        
    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];

    [alertController addAction:deleteProfile];
    [self presentViewController:alertController animated:YES completion:nil];
    
   
}

#pragma errors

-(void)ErrorWithAlert:(NSString *)alert message:(NSString *)message{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alert message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if ([ProfileController sharedInstance].loggedOut) {
        [self.tabBarController performSegueWithIdentifier:@"notLoggedIn" sender:nil];
    }
    
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:dismissAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)editButtonError{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Tap Edit Button" message:@"Tap the edit button to edit your profile, and tap done when complete" preferredStyle:UIAlertControllerStyleAlert];
    
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


@end
