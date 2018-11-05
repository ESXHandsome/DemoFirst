//
//  PublisherApi.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/27.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "BaseNetApi.h"

@interface PublisherApi : BaseNetApi

/**
 获取发布者个人信息

 @param publisherId 发布者id
 @param success 成功
 @param failure 失败
 */
+ (void)fetchPublisherInfoWithPublisherId:(NSString *)publisherId
                                  Success:(SuccessBlock)success
                                  failure:(FailureBlock)failure;

@end
