//
//  AliyunOSSApi.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2017/8/8.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "BaseNetApi.h"

@interface AliyunOSSApi : BaseNetApi

+ (instancetype)shared;

/**
 异步上传图片

 @param image UIImage 实例
 @param imageFileURL 图片本地地址
 @param success 成功回调
 @param failure 失败回调
 */
- (void)uploadObjectAsyncWithImage:(UIImage *)image
                      imageFileURL:(NSURL *)imageFileURL
                           success:(SuccessBlock)success
                           failure:(FailureBlock)failure;

/**
 异步上传视频

 @param videoFileURL 视频路径
 @param firstImage 视频首帧图片
 @param success 成功
 @param failure 失败
 */
- (void)uploadObjectAsyncWithVideoFileURL:(NSURL *)videoFileURL
                               firstImage:(UIImage *)firstImage
                                  success:(SuccessBlock)success
                                 progress:(ProgressBlock)progress
                                  failure:(FailureBlock)failure ;

@end
