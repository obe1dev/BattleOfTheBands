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

@implementation S3Manager

+ (void) uploadImage:(UIImage *)image withName:(NSString *)name {

    NSData *dataToUpload = UIImageJPEGRepresentation(image, 0.8);
        
    AWSS3TransferUtilityUploadExpression *expression = [AWSS3TransferUtilityUploadExpression new];
    expression.uploadProgress = ^(AWSS3TransferUtilityTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Do something e.g. Update a progress bar.
            
            NSLog(@"%lld of %lld uploaded", totalBytesSent, totalBytesExpectedToSend);
        });
    };
    
    AWSS3TransferUtilityUploadCompletionHandlerBlock completionHandler = ^(AWSS3TransferUtilityUploadTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Do something e.g. Alert a user for transfer completion.
            // On failed uploads, `error` contains the error object.
            
            NSLog(@"%@", error.description);
            
        });
    };
    
    AWSS3TransferUtility *transferUtility = [AWSS3TransferUtility defaultS3TransferUtility];
    [[transferUtility uploadData:dataToUpload
                          bucket:@"battleofthebandsimages"
                             key:@"image.jpg"
                     contentType:@"image/jpeg"
                      expression:expression
                completionHander:completionHandler] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"Error: %@", task.error);
        }
        if (task.exception) {
            NSLog(@"Exception: %@", task.exception);
        }
        if (task.result) {
            AWSS3TransferUtilityUploadTask *uploadTask = task.result;
            
            [uploadTask resume];
            
            NSLog(@"%@", uploadTask.aws_properties);
        }
        
        return nil;
    }];
    
}

@end
