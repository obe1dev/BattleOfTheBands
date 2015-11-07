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

typedef NS_ENUM(NSUInteger, ProfileRow) {
    ProfileRowPhoto,
    ProfileRowName,
    ProfileRowRankVotes,
    ProfileRowBio,
    ProfileRowWebsite,
};

@interface ProfileTableViewController () <TextFieldCellDelegate,BandBioCellDelegate>;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Logout;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Edit;

//this is fake data this will be set in the profile property
@property (assign, nonatomic) BOOL isBand;


@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *website;

@end

@implementation ProfileTableViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isBand = YES;
    
    //[self updateWithProfile:[ProfileController sharedInstance].profiles.firstObject];
    [self updateWithProfile];
    
    //creating moc data
    
    //creating song data for user name and user
    [[SongsController sharedInstance] createSongWithsongName:@"song that is good" songData:@""];
    
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
     //Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //self.Edit = self.editButtonItem;
    
    [self registerForNotifications];
}

//TODO: setup a picker View for genres

- (void)updateWithProfile {
    self.profile = [ProfileController sharedInstance].profiles.firstObject;

    if (self.profile ) {
        self.name = self.profile.name;
        self.bio = self.profile.bioOfBand;
        self.website = self.profile.bandWebsite;
        
        [self.tableView reloadData];
        NSLog(@"Updated with profile");
    } else {
        NSLog(@"No profile to update");
    }
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWithProfile) name:profilesLoadedNotification object:nil];
}

- (IBAction)logoutButton:(id)sender {

}


//update text for name and website (textField)
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
        
        if (self.profile) {
            
            self.profile.name = self.name;
            self.profile.bioOfBand = self.bio;
            self.profile.bandWebsite = self.website;
            
            
        } else {
            
            self.profile = [[ProfileController sharedInstance] createProfileWithName:self.name bioOfBand:self.bio bandWebsite:self.website];
            
        }
        
        [[ProfileController sharedInstance] save:[ProfileController sharedInstance].profiles];
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
                cell.ranking.text = @"";
                cell.votes.text = @"";
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
        
        
        //add a genre picker
        
        
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


//- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
//    [super setEditing:editing animated:NO];
//    
//    
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
