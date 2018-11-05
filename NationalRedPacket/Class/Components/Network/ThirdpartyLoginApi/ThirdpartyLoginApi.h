//
//  WechatApi.h
//  NationalRedPacket
//
//  Created by sunmingyue on 17/7/27.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNetApi.h"

@interface ThirdpartyLoginApi : BaseNetApi

/**
 * 向微信请求 openid 和 access_token
 *
 * @param success 成功回调
 * @param failure 失败回调
 */
+ (void)fetchWeiXinTokenWithCode:(NSString *)code
                         success:(SuccessBlock)success
                         failure:(FailureBlock)failure;
/**
 微信登录
 
 @param platform 第三方 platform
 @param openId 第三方 OpenId
 @param accessToken 第三方 AccessToken
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestThirdpartyLoginPlatform:(NSString *)platform
                                openId:(NSString *)openId
                           accessToken:(NSString *)accessToken
                               success:(SuccessBlock)success
                               failure:(FailureBlock)failure;

@end
