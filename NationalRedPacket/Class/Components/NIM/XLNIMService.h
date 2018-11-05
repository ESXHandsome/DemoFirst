//
//  XLNIMService.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/25.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>

@interface XLNIMService : NSObject

///云信是否登录
@property (assign, nonatomic) BOOL isLogined;
///是否是游客云信登录
@property (assign, nonatomic) BOOL isVisitorLogin;
///游客账户
@property (copy, nonatomic) NSString *visitorAccount;

+ (instancetype)shared;

/**
 初始化云信配置
 */
- (void)initNIMSDKConfig;

/**
 手动登录，手动微信登录成功后使用此登录方法
 */
- (void)loginNIMAccount:(NSString *)account token:(NSString *)token success:(void(^)(void))success failure:(void(^)(void))failure;

/**
 配置云信account和token，此方法主要用于升级版本仍在账户登录状态的情况
 */
- (void)configNIMAccount:(NSString *)account token:(NSString *)token;

/**
 自动登录，如果用户已经微信登录且登录状态保持，本地存有Accout和token，使用此登录方式
 目的：保证已经登录的用户在无网络进入时仍然能从本地拉取到历史聊天信息
 */
- (void)autoLogin;

/**
 退出登录，退出是否成功不需要关心
 */
- (void)logout;

@end
