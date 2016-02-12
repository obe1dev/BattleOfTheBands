//
//  Top10TableViewController.m
//  Battle Of The Bands
//
//  Created by Brock Oberhansley on 10/21/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "Top10TableViewController.h"
#import "Top10TableViewCell.h"
#import "ProfileController.h"
#import "DetailTableViewController.h"
#import "Profile.h"
#import "S3Manager.h"



@interface Top10TableViewController () <UISearchResultsUpdating, UISearchControllerDelegate>

@property (nonatomic, strong) NSMutableArray * filteredItems;
@property (nonatomic, weak) NSArray * displayedItems;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end

@implementation Top10TableViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    if (self.searchResults == nil) {
        
    [[ProfileController sharedInstance] loadTopTenBandProfiles];
    
    }
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.definesPresentationContext = YES;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    
    [self.searchController.searchBar sizeToFit];
    
    // Add the UISearchBar to the top header of the table view
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    // Hides search bar initially.  When the user pulls down on the list, the search bar is revealed.
    [self.tableView setContentOffset:CGPointMake(0, self.searchController.searchBar.frame.size.height)];
    
    [self registerForNotifications];
    
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUpdatedProfiles) name:topBandProfilesLoadedNotification object:nil];
}

- (void)showUpdatedProfiles {
    
    
    self.displayedItems = [ProfileController sharedInstance].topTenBandProfiles;

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"top10ToDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
         DetailTableViewController * detailViewController = segue.destinationViewController;
        
//        Profile *profile = [ProfileController sharedInstance].topTenBandProfiles[indexPath.row];
        Profile *profile = self.displayedItems[indexPath.row];
        
        detailViewController.profile = profile;
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSLog(@"Displaying profiles: %@", @([ProfileController sharedInstance].topTenBandProfiles.count));
//   return [ProfileController sharedInstance].topTenBandProfiles.count;
    return self.displayedItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSLog(@"Loading cell for row: %ld in section: %ld", (long)indexPath.row, (long)indexPath.section);
    
    Top10TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
//    Profile *profile = [ProfileController sharedInstance].topTenBandProfiles[indexPath.row];
    Profile *profile = self.displayedItems[indexPath.row];
    
    cell.bandName.text = profile.name;
    cell.bandName.backgroundColor = [UIColor colorWithRed:12/255.0 green:12/255.0 blue:12/255.0 alpha:.7];
    cell.bandName.textColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:.9];
    
    
    if (profile.bandImagePath) {
        
        [S3Manager downloadImageWithName:profile.uID dataPath:profile.bandImagePath completion:^(NSData *data) {
            if (data) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.bandImage.image = [UIImage imageWithData:data];
                
                });
                
            } else {
                
                
            }
        }];
        
    }else{
        
        cell.bandImage.image = [UIImage imageNamed:@"anchorIcon"];
        
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // update the filtered array based on the search text
    NSString *searchText = searchController.searchBar.text;
    
    // Everything that can be searched
    self.searchResults = [[ProfileController sharedInstance].searchProfiles mutableCopy];
    
    NSLog(@"search text = %@", searchText);
    
    // strip out all the leading and trailing spaces
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSLog(@"strippedString = %@", strippedString);
    
    // break up the search terms (separated by spaces)
    NSArray *searchItems = [NSArray new];
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }
    
    if (![searchText isEqualToString:@""]) {
        
        NSMutableArray *searchItemsPredicate = [NSMutableArray array];

        for (NSString *searchString in searchItems) {
            
            // Below we use NSExpression represent expressions in our predicates.
            // NSPredicate is made up of smaller, atomic parts: two NSExpressions (a left-hand value and a right-hand value)
            
            // name field matching
            NSExpression *lhs = [NSExpression expressionForKeyPath:@"name"];
            NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
            NSPredicate *finalPredicate = [NSComparisonPredicate
                                           predicateWithLeftExpression:lhs
                                           rightExpression:rhs
                                           modifier:NSDirectPredicateModifier
                                           type:NSContainsPredicateOperatorType
                                           options:NSCaseInsensitivePredicateOption];
            [searchItemsPredicate addObject:finalPredicate];
        }
        
        NSCompoundPredicate *finalCompoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:searchItemsPredicate];
        self.searchResults = [[self.searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
        
        // hand over the filtered results to our search results table
        //APLResultsTableController *tableController = (APLResultsTableController *)self.searchController.searchResultsController;
        self.displayedItems = self.searchResults;
    } else {
        self.displayedItems = [ProfileController sharedInstance].topTenBandProfiles;
    }
    [self.tableView reloadData];
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


@end
