//
//  PhotoCell.m
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 10/28/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (void)awakeFromNib {
    // Initialization code
}

-(void) setEditing:(BOOL)editing animated:(BOOL)animated{
    
    [super setEditing:editing animated:animated];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonTapped:(id)sender {
    [self.delegate photoCellButtonTapped: self.photoButton];
}
- (IBAction)uploadSong:(id)sender {
    [self.delegate uploadSongButtonTapped];
}
@end
