//
//  TokenNetApi.h
//  NationalRedPacket
//
//  Created by sunmingyue on 17/7/18.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNetApi.h"

// 获取用户请求Token URL
#define URL_INITLOGIN URL_BASE@"/User/initLogin"

@interface TokenNetApi : NSObject

/**
 *  请求加密token
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)fetchRequestToken:(SuccessBlock)success
                  failure:(FailureBlock)failure;

@end
