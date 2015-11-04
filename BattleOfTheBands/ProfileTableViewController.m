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


@interface ProfileTableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Logout;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Edit;

//this is fake data this will be set in the profile property
@property (assign, nonatomic) BOOL isBand;

@property (weak, nonatomic) NSString *name;
@property (weak, nonatomic) NSString *bio;
@property (weak, nonatomic) NSString *website;

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isBand = YES;
    
    [self updateWithEntry:self.profile];
    
    //creating moc data
    
    //creating song data for user name and user
//    [[SongsController sharedInstance] createSongWithsongName:@"song that is good" songData:@""];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
     //Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)updateWithEntry:(Profile *)profile {
    self.name = profile.name;
    self.bio = profile.bioOfBand;
    self.website = profile.bandWebsite;
}

- (IBAction)logoutButton:(id)sender {

}
- (IBAction)editButton:(id)sender {
    //disable keyboard after the shaved button is pressed
    if ([self.Edit.title isEqualToString:@"Edit"]) {
        [self.Edit setTitle:@"Save"];
        if (self.profile) {
            self.profile.name = self.name;
            self.profile.bioOfBand = self.bio;
            self.profile.bandWebsite = self.website;
            

        }else{
        
        //setting the name bio and website for this profile
        [[ProfileController sharedInstance] createProfileWithName:self.name bioOfBand:self.bio bandWebsite:self.website];
        
        }
        //adding this profile to the profiles array
        [[ProfileController sharedInstance] save:[ProfileController sharedInstance].profiles];
        
    }else{
        [self.Edit setTitle:@"Edit"];
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
        
        if (indexPath.row == 0) {
            
            PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell" forIndexPath:indexPath];
            cell.photoButton.titleLabel.text = @"Add Photo";
            cell.uploadSongButton.titleLabel.text = @"Add Song";
            return cell;
            
        }
        
        if (indexPath.row == 1) {
            
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell" forIndexPath:indexPath];
            cell.infoLabel.text = @"Band Name";
            cell.infoEntryTextField.placeholder = @"Enter your band Name";
            self.name = cell.infoEntryTextField.text;
            return cell;
            
        }
        
        if (indexPath.row == 2){
            
            RankingVotesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankingVotesCell" forIndexPath:indexPath];
            cell.ranking.text = @"";
            cell.votes.text = @"";
            return cell;
            
        }
        
        if (indexPath.row == 3) {
            
            BandBioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BandBioCell" forIndexPath:indexPath];
            cell.bandBioLabel.text = @"Band Bio";
            cell.bandBioTextView.text = @"";
            self.bio = cell.bandBioTextView.text;
            return cell;
            
        }
        
        if (indexPath.row == 4) {
            
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell" forIndexPath:indexPath];
            cell.infoLabel.text = @"Bands Website";
            cell.infoEntryTextField.placeholder = @"Enter your band Website";
            self.website = cell.infoEntryTextField.text;
            return cell;
            
        }
        
        //add a genre picker
        
        
        //this is for the liked bands and listener
        else if (!self.isBand){
        
        if (indexPath.row == 0) {
            
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell" forIndexPath:indexPath];
            cell.infoLabel.text = @"Name";
            cell.infoEntryTextField.placeholder = @"Enter your Name";
            return cell;
            
         }
       }
                
    }
        
    
    // Configure the cell...
    return nil;
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
