//
//  S3Manager.m
//  BattleOfTheBands
//
//  Created by Brock Oberhansley on 11/14/15.
//  Copyright © 2015 Brock Oberhansley. All rights reserved.
//

#import "S3Manager.h"
#import <AWSCore/AWSCore.h>
#import <AWSS3/AWSS3.h>
#import <AWSCognito/AWSCognito.h>
#import "ProfileController.h"
#import "FireBaseController.h"


@implementation S3Manager


+ (void) uploadImage:(UIImage *)image withName:(NSString *)name completion:(UploadDataBlock)block{

    NSData *dataToUpload = UIImageJPEGRepresentation(image, 0.8);
        
    AWSS3TransferUtilityUploadExpression *expression = [AWSS3TransferUtilityUploadExpression new];
    expression.uploadProgress = ^(AWSS3TransferUtilityTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"%lld of %lld uploaded", totalBytesSent, totalBytesExpectedToSend);
        });
    };
    
    AWSS3TransferUtilityUploadCompletionHandlerBlock completionHandler = ^(AWSS3TransferUtilityUploadTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Do something e.g. Alert a user for transfer completion.
            // On failed uploads, `error` contains the error object.
            if (error) {
                block(NO);
            } else {
                block(YES);
            }
            NSLog(@"Task: %@", task);
            NSLog(@"Error: %@", error.description);
            
        });
    };
    
    AWSS3TransferUtility *transferUtility = [AWSS3TransferUtility defaultS3TransferUtility];
    
    [[transferUtility uploadData:dataToUpload
                          bucket:@"battleofthebands-images"
                             key:name
                     contentType:@"image/jpeg"
                      expression:expression
                completionHander:completionHandler] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
//            block(NO);
            NSLog(@"Error: %@", task.error);
        }
        if (task.exception) {
//            block(NO);
            NSLog(@"Exception: %@", task.exception);
        }
        if (task.result) {
            AWSS3TransferUtilityUploadTask *uploadTask = task.result;
            
//            [uploadTask resume];
//            block(YES);
            
            NSLog(@"%@", uploadTask.aws_properties);
        }
        
        return nil;
    }];
    
}

+ (void) deleteImage:(NSString *)name completion:(DownloadDataBlock)block {
    [self deleteData:@"battleofthebands-images" WithName:name completion:block];
}

+ (void) deleteSong:(NSString *)name completion:(DownloadDataBlock)block {
    [self deleteData:@"battleofthebands-songs" WithName:name completion:block];

}


+ (void)downloadImageWithName:(NSString *)name dataPath:(NSString *)savingDataPath completion:(DownloadDataBlock)block {
    [self downLoadData:@"battleofthebands-images" WithName:name dataPath:savingDataPath completion:block];
}

+ (void)downloadSongWithName:(NSString *)name dataPath:(NSString *)savingDataPath completion:(DownloadDataBlock)block {
    [self downLoadData:@"battleofthebands-songs" WithName:name dataPath:savingDataPath completion:block];
}


+ (void) downLoadData:(NSString *)bucketPath WithName:(NSString *)dataName dataPath:(NSString *)savingDataPath completion:(DownloadDataBlock)block {
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
    // Construct the NSURL for the download location.
    NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:savingDataPath];
    NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
    
    // Construct the download request.
    AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
    
    downloadRequest.bucket = bucketPath;
    downloadRequest.key = dataName;
    downloadRequest.downloadingFileURL = downloadingFileURL;
    
    // Download the file.
    [[transferManager download:downloadRequest] continueWithExecutor:[AWSExecutor mainThreadExecutor]
                                                           withBlock:^id(AWSTask *task) {
                                                               if (task.error){
                                                                   if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                                                                       switch (task.error.code) {
                                                                           case AWSS3TransferManagerErrorCancelled:
                                                                           case AWSS3TransferManagerErrorPaused:
                                                                               break;
                                                                               
                                                                           default:
                                                                               NSLog(@"Error: %@", task.error);
                                                                               break;
                                                                       }
                                                                   } else {
                                                                       // Unknown error.
                                                                       NSLog(@"Error: %@", task.error);
                                                                   }
                                                                   block(nil);
                                                               }
                                                               
                                                               if (task.result) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^{

                                                                   AWSS3TransferManagerDownloadOutput *downloadOutput = task.result;
                                                                   NSData *data = [NSData dataWithContentsOfFile:downloadOutput.body];
                                                                   block(data);
                                                                   //downloadOutput.body
                                                                   //File downloaded successfully.
                                                                   NSLog(@"%@",downloadOutput);
                                                                   });
                                                               }
                                                               return nil;
                                                           }];
 
    
}

+ (void) deleteData:(NSString *)bucketPath WithName:(NSString *)dataName completion:(DownloadDataBlock)block{
    
    AWSS3 *s3 = [AWSS3 defaultS3];
    AWSS3DeleteObjectRequest *deleteRequest = [AWSS3DeleteObjectRequest new];
    
    // Construct the NSURL for the delete location.
//    NSString *deleteFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:deletingDataPath];
//    NSURL *deleteFileURL = [NSURL fileURLWithPath:deleteFilePath];
    deleteRequest.bucket = bucketPath;
    deleteRequest.key = dataName;
//    deleteRequest.deleteFileURL = deleteFileURL;
    
    [[[s3 deleteObject:deleteRequest] continueWithBlock:^id(AWSTask *task) {
        if(task.error != nil){
            if(task.error.code != AWSS3TransferManagerErrorCancelled && task.error.code != AWSS3TransferManagerErrorPaused){
                NSLog(@"%s Error: [%@]",__PRETTY_FUNCTION__, task.error);
            }
        }else{
            // Completed logic here
            if (task.result) {
                
                NSLog(@"deleting %@ is complete!", dataName);
                
            }
        }
        return nil;
    }] waitUntilFinished];
    
    
}

+ (void) uploadSong:(NSData *)song withName:(NSString *)name completion:(UploadDataBlock)block{
    
   // NSData *dataToUpload = [NSData dataWithContentsOfURL:[song valueForProperty:MPMediaItemPropertyAssetURL]];
   // NSData *dataToUpload = [NSData dataWithContentsOfURL:[song valueForProperty:MPMediaItemPropertyAssetURL]];
    
    AWSS3TransferUtilityUploadExpression *expression = [AWSS3TransferUtilityUploadExpression new];
    expression.uploadProgress = ^(AWSS3TransferUtilityTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"%lld of %lld uploaded", totalBytesSent, totalBytesExpectedToSend);
            
        });
    };
    
    AWSS3TransferUtilityUploadCompletionHandlerBlock completionHandler = ^(AWSS3TransferUtilityUploadTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Do something e.g. Alert a user for transfer completion.
            // On failed uploads, `error` contains the error object.
            if (error) {
                block(NO);
            } else {
                block(YES);
            }
            NSLog(@"Task: %@", task.aws_properties);
            NSLog(@"Error: %@", error.description);
        });
    };
    
    AWSS3TransferUtility *transferUtility = [AWSS3TransferUtility defaultS3TransferUtility];
    
    [[transferUtility uploadData:song
                          bucket:@"battleofthebands-songs"
                             key:name
                     contentType:@"song/m4a"
                      expression:expression
                completionHander:completionHandler] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"Error: %@", task.error);
//            block(NO);
        }
        if (task.exception) {
            NSLog(@"Exception: %@", task.exception);
//            block(NO);
        }
        if (task.result) {
            AWSS3TransferUtilityUploadTask *uploadTask = task.result;
                        [uploadTask resume];
            
//            NSLog(@"%@", uploadTask.aws_properties);
//            block(YES);
        }
        
        return nil;
    }];
}

@end
