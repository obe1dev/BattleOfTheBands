//
//  BandBioCell.h
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 10/29/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BandBioCellDelegate;

@interface BandBioCell : UITableViewCell <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *bandBioTextView;
@property (weak, nonatomic) IBOutlet UILabel *bandBioLabel;

@property (weak, nonatomic) id<BandBioCellDelegate> delegate;

@end

@protocol BandBioCellDelegate

-(void) bioChangedInCell:(BandBioCell *) cell;

@end