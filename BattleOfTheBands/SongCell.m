//
//  SongCell.m
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 12/3/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "SongCell.h"

@implementation SongCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)playSong:(id)sender {
    [self.delegate playButtonTapped:self];
}

- (IBAction)perviousSong:(id)sender {
    [self.delegate perviousButton:self];
}


@end


