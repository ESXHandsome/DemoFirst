//
//  WechatLogin.h
//  NationalRedPacket
//
//  Created by sunmingyue on 17/7/27.
//  Copyright © 2017年 孙明悦. All rights reserved.
//
//  微信登录

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "ThirdpartyLoginModel.h"

typedef void(^WechatLoginCompletion)(ThirdpartyLoginModel *loginModel);

extern NSInteger const WECHAT_LOGIN_NO_ERROR_CODE;
extern NSInteger const WECHAT_LOGIN_REQUEST_TIMEOUT_CODE;

@interface WechatLogin : NSObject <WXApiDelegate>

/// 是否正在进行微信登录
@property (assign, nonatomic) BOOL isLoggingIn;

/** 单例 */
+ (instancetype)shared;

/** 微信登录 */
- (void)wechatLogin:(WechatLoginCompletion)completion;

/** 程序进入前台，检测微信登录状态 */
- (void)applicationWillEnterForegroundLoginCheck;

@end
