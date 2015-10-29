//
//  Profile.h
//  Battle Of The Bands
//
//  Created by Brock Oberhansley on 10/21/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 


@interface Profile : NSObject

//do i need to add uid and passwords

@property (strong,nonatomic) NSString *uID;
@property (strong,nonatomic) NSString *email;
@property (strong,nonatomic) NSString *password;
@property (strong,nonatomic) UIImage *bandImage;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSNumber *vote;
@property (strong,nonatomic) NSString *bioOfBand;
@property (strong,nonatomic) NSURL *bandWebsite;
@property (strong,nonatomic) NSArray *songs;

@property (assign,nonatomic) BOOL isBand;

- (id) initWithDictionary:(NSDictionary *) dictionary;

- (NSDictionary *) dictionaryRepresentation;

@end
