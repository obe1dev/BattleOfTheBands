//
//  PhotoCell.h
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 10/28/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoCellDelegate;

@interface PhotoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadSongButton;

@property (weak, nonatomic) id<PhotoCellDelegate> delegate;

@end

@protocol PhotoCellDelegate <NSObject>

- (void)photoCellButtonTapped;

@end