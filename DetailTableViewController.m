//
//  DetailTableViewController.m
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 10/28/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "DetailTableViewController.h"
#import "Profile.h"
#import "InfoPhotoCell.h"
#import "InfoRankingVotesCell.h"
#import "InfoTextCell.h"
#import "InfoBandBioCell.h"
#import "ProfileController.h"
#import "S3Manager.h"


@interface DetailTableViewController ()

@property (weak, nonatomic) NSString *name;
@property (weak, nonatomic) NSString *bio;
@property (weak, nonatomic) NSString *website;
@property (strong, nonatomic) NSNumber *vote;
@property (strong, nonatomic) NSNumber *rank;
@property (strong, nonatomic) NSData *bandImage;


@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateWithEntry:self.profile];

        
     //Uncomment the following line to preserve selection between presentations.
     //self.clearsSelectionOnViewWillAppear = NO;
    
     //Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     //self.navigationItem.rightBarButtonItem = self.editButtonItem;
        

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateWithEntry:(Profile *)profile {
    self.name = profile.name;
    self.bio = profile.bioOfBand;
    self.website = profile.bandWebsite;
    self.vote = profile.vote;
    
    [S3Manager downloadImageWithName:profile.uID dataPath:profile.uID completion:^(NSData *data) {
        if (data) {
            self.bandImage = data;
            [self.tableView reloadData];
        } else {
            // TODO: Alert the user?
        }
    }];


    // TODO: Come back to this
//    if (profile.bandImage) {
//        self.bandImage = profile.bandImage;
//    }
    
    [[ProfileController sharedInstance] rankForProfile:profile completion:^(NSNumber *rank) {
        self.rank = rank;
        [self.tableView reloadData];
    }];
    
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        InfoPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoPhotoCell" forIndexPath:indexPath];
        
        if (self.bandImage) {
            
            cell.bandPhoto.image = [UIImage imageWithData:self.bandImage];
       
        }else{
        
        cell.bandPhoto.image = [UIImage imageNamed:@"anchorIcon"];
            
        }
        
        cell.bandNameLabel.text = self.name;
        
        return cell;
    }
    
    if (indexPath.row == 1) {
        
        InfoRankingVotesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoRankingVotesCell" forIndexPath:indexPath];
        
        if ([self.rank intValue] <= 0) {
            self.rank = nil;
        }
        
        cell.ranking.text = [self.rank stringValue];
        cell.votes.text = [self.vote stringValue];
        
        return cell;
        
    }
    
    if (indexPath.row == 2) {
    
        InfoBandBioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoBandBioCell" forIndexPath:indexPath];
        
        
        cell.bioBandEntryLabel.text = self.bio;
        
        return cell;
        
    }
    
    if (indexPath.row == 3) {
        
        InfoTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoTextCell" forIndexPath:indexPath];
        
        NSMutableAttributedString *website = [[NSMutableAttributedString alloc] initWithString:self.website];
        [website addAttribute:NSLinkAttributeName value:self.website range:NSMakeRange(0,website.length)];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoTapped)];
        cell.infoOptionInput.gestureRecognizers = @[];
        cell.infoOptionInput.userInteractionEnabled = YES;
        [cell.infoOptionInput addGestureRecognizer:recognizer];
        cell.infoOptionLabel.text = @"Band Website";
        cell.infoOptionInput.textColor = [UIColor lightGrayColor];
        cell.infoOptionInput.attributedText = website;
        
        return cell;
        
    }
    
    return nil;
}

- (void)infoTapped {
    
    NSString *website =[NSString stringWithFormat:@"http:%@",self.website];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:website]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 275;
    }
    if (indexPath.row == 1) {
        return 46;
    }
    if (indexPath.row == 2) {
        return 150;
    }
    if (indexPath.row == 3) {
        return 75;
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
