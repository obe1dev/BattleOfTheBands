//
//  BandBioCell.m
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 10/29/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "BandBioCell.h"

@implementation BandBioCell

- (void)awakeFromNib {
    // Initialization code
    self.bandBioTextView.editable = self.editing;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    self.bandBioTextView.editable = self.editing;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)textViewDidChange:(UITextView *)textView {
    if (self.delegate) {
        [self.delegate bioChangedInCell:self];
    }
}

@end
