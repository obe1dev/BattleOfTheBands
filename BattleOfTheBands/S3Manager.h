//
//  S3Manager.h
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 11/14/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
@import UIKit;

typedef void (^DownloadDataBlock)(NSData *data);
typedef void (^UploadDataBlock)(BOOL success);

@interface S3Manager : NSObject

+ (void) uploadImage:(UIImage *)image withName:(NSString *)name completion:(UploadDataBlock)block;

+ (void) uploadSong:(NSData *)song withName:(NSString *)name completion:(UploadDataBlock)block;

+ (void)downloadImageWithName:(NSString *)name dataPath:(NSString *)savingDataPath completion:(DownloadDataBlock)block;

+ (void)downloadSongWithName:(NSString *)name dataPath:(NSString *)savingDataPath completion:(DownloadDataBlock)block;

@end
