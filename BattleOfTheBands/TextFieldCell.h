//
//  TextFieldCell.h
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 10/29/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UITextField *infoEntryTextField;

@end
