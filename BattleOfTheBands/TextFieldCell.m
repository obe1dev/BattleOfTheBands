//
//  TextFieldCell.m
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 10/29/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "TextFieldCell.h"
#import "Profile.h"

@implementation TextFieldCell 

- (void)awakeFromNib {
    self.infoEntryTextField.delegate = self;
    // Initialization code
    self.infoEntryTextField.enabled = self.editing;
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    self.infoEntryTextField.enabled = self.editing;
    
//    if (self.editing == NO) {
//        NSLog(@"I'm turned off");
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.infoEntryTextField resignFirstResponder];
    return YES;
}

- (IBAction)textChanged:(id)sender {
    if (self.delegate) {
        [self.delegate textChangedInCell:self];
    }
}

@end
