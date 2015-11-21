//
//  DeleteProfileCell.m
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 11/20/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "DeleteProfileCell.h"


@implementation DeleteProfileCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    
    self.deleteProfile.enabled = self.editing;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)deleteProfileButton:(id)sender {
    
    [self.delegate deleteProfileButtonTapped];
    
}

@end
