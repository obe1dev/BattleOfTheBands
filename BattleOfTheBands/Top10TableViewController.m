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



@interface Top10TableViewController () <UISearchResultsUpdating,UISearchBarDelegate,UISearchControllerDelegate>

@property (nonatomic, strong) NSMutableArray * filteredItems;
@property (nonatomic, weak) NSArray * displayedItems;


@end

@implementation Top10TableViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[ProfileController sharedInstance] loadTopTenBandProfiles];
    
    
    
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchResultsUpdater = self;
    searchController.searchBar.delegate = self;
    searchController.dimsBackgroundDuringPresentation = NO;
    
    [searchController.searchBar sizeToFit];
    
    searchController.definesPresentationContext =YES;
    
    // Add the UISearchBar to the top header of the table view
    self.tableView.tableHeaderView = searchController.searchBar;
    
    // Hides search bar initially.  When the user pulls down on the list, the search bar is revealed.
    [self.tableView setContentOffset:CGPointMake(0, searchController.searchBar.frame.size.height)];
    
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

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSLog(@"Displaying profiles: %@", @([ProfileController sharedInstance].topTenBandProfiles.count));
//   return [ProfileController sharedInstance].topTenBandProfiles.count;
    return self.displayedItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UILabel *loading = [[UILabel alloc] initWithFrame:CGRectMake(60, 110 , 100, 25)];
//    loading.text = @"Uploading..";
//    loading.textColor= [UIColor whiteColor];
    
//    CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height/2 - 75 - 130, 200, 150)
    
//    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)];
//    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
//    spinner.backgroundColor = [UIColor colorWithWhite:.333 alpha:.98];
//    [spinner centerXAnchor];
//    spinner.center = self.view.center;
    
    //[spinner addSubview:loading];
    //spinner.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
//    [spinner layer].cornerRadius = 8.0;
//    [spinner layer].masksToBounds = YES;
//    spinner.color = [UIColor redColor];
//    spinner.hidesWhenStopped = YES;
//    [tableView. addSubview:spinner];
//    [spinner startAnimating];
//
    
    NSLog(@"Loading cell for row: %ld in section: %ld", (long)indexPath.row, (long)indexPath.section);
    
    Top10TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
//    Profile *profile = [ProfileController sharedInstance].topTenBandProfiles[indexPath.row];
    Profile *profile = self.displayedItems[indexPath.row];
    
    cell.bandName.text = profile.name;
    
    
    if (profile.bandImagePath) {
        
        // TODO: come back to this
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

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    NSString *searchString = searchController.searchBar.text;
    NSLog(@"searchString=%@", searchString);
    
    // Check if the user cancelled or deleted the search term so we can display the full list instead.
    if (![searchString isEqualToString:@""]) {
        [self.filteredItems removeAllObjects];
        for (NSString *str in [ProfileController sharedInstance].searchProfiles) {
            if ([searchString isEqualToString:@""] || [str localizedCaseInsensitiveContainsString:searchString] == YES) {
                NSLog(@"str=%@", str);
                [self.filteredItems addObject:str];
            }
        }
        self.displayedItems = self.filteredItems;
    }
    else {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
