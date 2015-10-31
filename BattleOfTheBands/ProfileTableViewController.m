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


@interface ProfileTableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Logout;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Edit;
@property (assign, nonatomic) BOOL isBand;

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isBand = YES;
    
    //creating moc data
    
    //creating song data for user name and user
//    [[SongsController sharedInstance] createSongWithsongName:@"song that is good" songData:@""];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
     //Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (IBAction)logoutButton:(id)sender {

}
- (IBAction)editButton:(id)sender {
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
//#warning Incomplete implementation, return the number of rows
    if (self.isBand) {
        return 5;
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
            return cell;
            
        }
        
        if (indexPath.row == 4) {
            
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell" forIndexPath:indexPath];
            cell.infoLabel.text = @"Bands Website";
            cell.infoEntryTextField.placeholder = @"Enter your band Website";
            return cell;
            
        }
        
                
    }
        
    
    // Configure the cell...
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
