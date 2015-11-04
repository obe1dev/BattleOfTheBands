//
//  Top10TableViewCell.h
//  Battle Of The Bands
//
//  Created by Brock Oberhansley on 10/21/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Top10TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bandName;
@property (weak, nonatomic) IBOutlet UIImageView *bandImage;

@end
