//
//  InfoPhotoCell.h
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 10/29/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoPhotoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bandPhoto;
@property (weak, nonatomic) IBOutlet UILabel *bandNameLabel;

@end
