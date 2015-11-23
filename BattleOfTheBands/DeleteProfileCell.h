//
//  DeleteProfileCell.h
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 11/20/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@protocol DeleteProfileDelegate;

@interface DeleteProfileCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *deleteProfile;

@property (weak, nonatomic) id<DeleteProfileDelegate> delegate;

@end

@protocol DeleteProfileDelegate <NSObject>

-(void) deleteProfileButtonTapped;

@end