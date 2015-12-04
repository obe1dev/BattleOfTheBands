//
//  SongCell.h
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 12/3/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SongCellDelegate;

@interface SongCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) id<SongCellDelegate> delegate;

@end

@protocol SongCellDelegate <NSObject>

-(void)playButtonTapped:(SongCell*)cell;

@end
