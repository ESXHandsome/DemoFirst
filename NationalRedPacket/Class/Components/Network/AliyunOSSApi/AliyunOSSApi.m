//
//  AliyunOSSApi.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2017/8/8.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "AliyunOSSApi.h"
#import "AliyunOSSiOS.h"
#import "MD5Encrypt.h"

NSString * const endPoint = @"http://oss-cn-qingdao.aliyuncs.com";
NSString * const ossTokenUrl = @"/Tool/getOssItemToken";
NSString * const bucketName = @"lyq-crawler";

@implementation AliyunOSSApi

OSSClient *client;

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{ sharedInstance = [self new]; });
    return sharedInstance;
}

#pragma mark - Public Methods

- (void)uploadObjectAsyncWithImage:(UIImage *)image
                      imageFileURL:(NSURL *)imageFileURL
                           success:(SuccessBlock)success
                           failure:(FailureBlock)failure {
    
    //建立OSS连接
    [self initOSSClientSuccess:^(id responseDict) {
            
        [self uploadImageObject:image imageFileURL:imageFileURL success:success failure:failure];
        
    } failure:failure];
    
}

- (void)uploadObjectAsyncWithVideoFileURL:(NSURL *)videoFileURL
                               firstImage:(UIImage *)firstImage
                                  success:(SuccessBlock)success
                                 progress:(ProgressBlock)progress
                                  failure:(FailureBlock)failure {
    
    //建立OSS连接
    [self initOSSClientSuccess:^(id responseDict) {
        
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
            
        //封面图上传
        [self uploadImageObject:firstImage imageFileURL:nil success:^(NSDictionary *imageDict) {
            
            [resultDic setObject:imageDict[@"image"] forKey:@"cover"];
            [resultDic setObject:imageDict[@"width"] forKey:@"width"];
            [resultDic setObject:imageDict[@"height"] forKey:@"height"];
            
            //视频文件上传
            [self uploadVideoObjectWithFileURL:videoFileURL success:^(id videoDict) {
                
                [resultDic setObject:videoDict[@"video"] forKey:@"item"];
                success(resultDic);
                
            }  progress:^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                 progress(bytesSent ,totalByteSent ,totalBytesExpectedToSend);
            
            }  failure:failure];
            
        } failure:failure];
        
    } failure:failure];
    
}

#pragma mark - Private Methods
//上传图片对象
- (void)uploadImageObject:(UIImage *)image
             imageFileURL:(NSURL *)imageFileURL
                  success:(SuccessBlock)success
                  failure:(FailureBlock)failure {
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    put.bucketName = bucketName;
    
    if (imageFileURL && [imageFileURL.pathExtension.lowercaseString isEqualToString:@"gif"]) {
        put.uploadingFileURL = imageFileURL;
        put.objectKey = [self objectKeyForExt:@"gif"];
    } else {
        put.uploadingData = UIImagePNGRepresentation(image);
        put.objectKey = [self objectKeyForExt:@"png"];
    }
    
    OSSTask * putTask = [client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!task.error) {
                if (success) {
                    NSDictionary *result = @{@"image": put.objectKey,
                                             @"width": @(image.size.width),
                                             @"height": @(image.size.height)};
                    success(result);
                }
            } else {
                failure(task.error.code);
            }
        });
        return nil;
    }];
    
}

//上传视频对象
- (void)uploadVideoObjectWithFileURL:(NSURL *)videoFileURL
                             success:(SuccessBlock)success
                            progress:(ProgressBlock)progress
                             failure:(FailureBlock)failure
{
        
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    put.bucketName = bucketName;
    put.uploadingFileURL = videoFileURL;
    put.objectKey = [self objectKeyForExt:videoFileURL.pathExtension];
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        progress(bytesSent ,totalBytesSent ,totalBytesExpectedToSend);
    };
    
    OSSTask * putTask = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!task.error) {
                if (success) {
                    NSDictionary *result = @{@"video": put.objectKey};
                    success(result);
                }
            } else {
                failure(task.error.code);
            }
        });
        return nil;
    }];
}

/**
 建立OSSClient连接
 */
- (void)initOSSClientSuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    
    [BaseNetApi httpRequestWithURL:[URL_BASE stringByAppendingString:ossTokenUrl] withParam:@{}success:^(id responseDict) {
        
        if ([responseDict[@"result"] integerValue] == 0) {
            
            NSDictionary *resultDic = responseDict[@"Credentials"];
            
            id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:resultDic[@"AccessKeyId"] secretKeyId:resultDic[@"AccessKeySecret"] securityToken:resultDic[@"SecurityToken"]];
            
            client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential];
            success(resultDic);
            
        } else {
            
            failure([responseDict[@"result"] integerValue]);
        }
        
    } failure:failure];
}

/**
 生成 objectKey 字符串

 @param ext 扩展名
 @return 名字
 */
- (NSString *)objectKeyForExt:(NSString *)ext
{
    // 时间戳(ms级)+随机数（0~100）
    NSString *randomString = [NSString stringWithFormat:@"%.0f%u", [[NSDate date] timeIntervalSince1970]*1000, arc4random()%(101)];
    
    // 图片名字 MD5
    NSString *imageNameMD5 = [MD5Encrypt MD5ForLower32Bate:randomString];
    
    return [NSString stringWithFormat:@"%@.%@", imageNameMD5, ext];
}

@end
