//
//  ResetPasswordCell.h
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 11/23/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResetPasswordDelegate;


@interface ResetPasswordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *resetPassword;

@property (weak, nonatomic) id<ResetPasswordDelegate> delegate;

@end

@protocol ResetPasswordDelegate <NSObject>

-(void) resetPasswordButtonTapped;

@end