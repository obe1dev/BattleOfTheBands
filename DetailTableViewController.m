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
#import "SongCell.h"
#import "soundController.h"


@interface DetailTableViewController () <SongCellDelegate>

@property (weak, nonatomic) NSString *name;
@property (weak, nonatomic) NSString *bio;
@property (weak, nonatomic) NSString *website;
@property (strong, nonatomic) NSNumber *vote;
@property (strong, nonatomic) NSNumber *rank;
@property (strong, nonatomic) NSData *bandImage;
@property (strong, nonatomic) NSData *bandSong;

@property (nonatomic, strong) soundController *soundController;


@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateWithEntry:self.profile];

}

-(void)viewWillDisappear:(BOOL)animated{

    [self.soundController pauseAudioFile];
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
    
    [S3Manager downloadSongWithName:[NSString stringWithFormat:@"%@.m4a", profile.uID] dataPath:profile.uID completion:^(NSData *data) {
        
        if (data) {
            
            self.bandSong = data;
            [self.tableView reloadData];
        
        }else{
            
        }
     }];
    
    [[ProfileController sharedInstance] rankForProfile:profile completion:^(NSNumber *rank) {
        self.rank = rank;
        [self.tableView reloadData];
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
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
        SongCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songCell" forIndexPath:indexPath];
        
        cell.delegate = self;
        
        return cell;
        
    }
    
    if (indexPath.row == 2) {
        
        InfoRankingVotesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoRankingVotesCell" forIndexPath:indexPath];
        
        if ([self.rank intValue] <= 0) {
            self.rank = nil;
        }
        
        cell.ranking.text = [self.rank stringValue];
        cell.votes.text = [self.vote stringValue];
        
        return cell;
        
    }
    
    if (indexPath.row == 3) {
    
        InfoBandBioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoBandBioCell" forIndexPath:indexPath];
        
        
        cell.bioBandEntryLabel.text = self.bio;
        
        return cell;
        
    }
    
    if (indexPath.row == 4) {
        
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
        return 65;
    }
    if (indexPath.row == 2) {
        return 46;
    }
    if (indexPath.row == 3) {
        return 150;
    }
    if (indexPath.row == 4) {
        return 75;
    }
    
    return 0;
}

#pragma song play

-(void)playButtonTapped:(SongCell *)cell{
    
    NSURL *songURL = [[ProfileController sharedInstance] songURLForProfile:self.profile];
    
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

@end
