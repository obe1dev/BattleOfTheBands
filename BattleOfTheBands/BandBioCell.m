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
    self.bandBioTextView.delegate = self;
    self.bandBioTextView.enabled = self.editing;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    //self.bandBioTextView.
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    [self.bandBioTextView ];
}

@end
