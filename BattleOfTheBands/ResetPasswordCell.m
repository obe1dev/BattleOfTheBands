//
//  ResetPasswordCell.m
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 11/23/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "ResetPasswordCell.h"

@implementation ResetPasswordCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    
    //this need to be the button form the header.
    self.resetPassword.enabled = self.editing;
    
};

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)resetPasswordButton:(id)sender {
    
    [self.delegate resetPasswordButtonTapped];
    
}

@end
