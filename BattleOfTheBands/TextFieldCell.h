//
//  TextFieldCell.h
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 10/29/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Profile.h"

@protocol TextFieldCellDelegate;

@interface TextFieldCell : UITableViewCell <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UITextField *infoEntryTextField;

@property (weak, nonatomic) id<TextFieldCellDelegate> delegate;

@end

@protocol TextFieldCellDelegate

-(void) textChangedInCell:(TextFieldCell *) cell;

@end