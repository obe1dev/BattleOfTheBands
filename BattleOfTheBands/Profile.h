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

@property (strong,nonatomic) UIImage *bandImage;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSNumber *vote;
@property (strong,nonatomic) NSString *bioOfBand;
@property (strong,nonatomic) NSURL *bandWebsite;
@property (strong,nonatomic) NSArray *songs;

- (id) initWithDictionary:(NSDictionary *) dictionary;

- (NSDictionary *) dictionaryRepresentation;

@end
