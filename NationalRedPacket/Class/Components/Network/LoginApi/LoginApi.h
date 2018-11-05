//
//  LoginApi.h
//  NationalRedPacket
//
//  Created by 孙明悦 on 2017/6/2.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNetApi.h"
#import "UserInfoModel.h"

typedef NS_ENUM(NSInteger,RetryMethod) {
    Retry_RequestToken = 2,
    Retry_UserLogin = 3,
    Retry_UserInfo = 4,
};

@interface LoginApi : BaseNetApi

/**
 登录
 
 @param openId 微信 OpenId，游客时为空
 @param accessToken 微信 AccessToKen，游客时为空
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestUserLoginWithThirdpartyOpenId:(NSString *_Nullable)openId
                                 accessToken:(NSString *_Nullable)accessToken
                                     success:(SuccessBlock)success
                                     failure:(FailureBlock)failure;

/**
 登出（目前是微信登出，因为目前只有一种登出，所以暂不对外暴露细节）

 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestUserLogout:(SuccessBlock)success
                  failure:(FailureBlock)failure;

/**
 * 获取用户信息
 *
 * @param success 成功回调
 * @param failure 失败回调
 */
+ (void)fetchUserInfoSuccess:(SuccessBlock)success
                     failure:(FailureBlock)failure;

/**
 * 强制更新
 *
 * @param success 成功回调
 * @param failure 失败回调
 */
+ (void)checkUpdate:(SuccessBlock)success
            failure:(FailureBlock)failure;

@end
