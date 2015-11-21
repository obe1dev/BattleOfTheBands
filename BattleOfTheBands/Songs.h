//
//  Songs.h
//  Battle Of The Bands
//
//  Created by Brock Oberhansley on 10/21/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface Songs : NSObject

@property (strong,nonatomic) NSString *songName;
@property (strong,nonatomic) NSData *songData;

- (id) initWithDictionary:(NSDictionary *) dictionary;

- (NSDictionary *) dictionaryRepresentation;


@end
