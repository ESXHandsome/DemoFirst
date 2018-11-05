//
//  LoginManager.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/9.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"
#import "UserInfoModel.h"

typedef NS_ENUM(NSUInteger, LoginState) {
    LoginStateInitial,          // 初始状态，服务端未登录
    LoginStateVisitor,          // 服务端登录成功，无账号
    LoginStateAccount,          // 服务端登录成功，有账号
    LoginStateAccountNoServer,  // 服务端登录失败，有账号
};

@interface XLLoginManager : NSObject

/** 单例 */
+ (instancetype _Nonnull)shared;

/// 当前登录状态
@property (assign, nonatomic, readonly) LoginState state;

/// 当前是否已游客登录（包含账号登录），只是单纯判断当前登录状态的计算属性
@property (assign, nonatomic, readonly) BOOL isVisitorLogined;

/// 当前是否已账号登录，只是单纯判断当前登录状态的计算属性
@property (assign, nonatomic, readonly) BOOL isAccountLogined;

/// 通用唯一标识（登录状态变化时更新）
@property (strong, nonatomic, readonly) NSString *_Nonnull UUID;

/// 服务端 Token
@property (strong, nonatomic, readonly) NSString *_Nullable serverToken;

/// 登录后的用户id
@property (strong, nonatomic, readonly) NSString *_Nullable userId;

/// 新手红包id
@property (strong, nonatomic, readonly) NSString *_Nullable luckyId;

/// 新手红包状态
@property (assign, nonatomic) NSInteger newUserRedPacketStatus;

/// 登录后的用户基本信息
@property (strong, nonatomic) UserInfoModel *_Nullable userInfo;

/// 登录成功进入主页的闭包
@property (copy, nonatomic) void (^ _Nullable EnterRootViewController)(void);

/**
 服务端登录，此方法支持游客登录和微信回调后的登录

 @param openId 微信登录时传递，游客时为空
 @param accessToken 微信登录时传递，游客时为空
 @param success 成功回调
 @param failure 失败回调，返回错误码
 */
- (void)loginWithThirdpartyPlatform:(NSString *_Nullable)platform
                             openId:(NSString *_Nullable)openId
                        accessToken:(NSString *_Nullable)accessToken
                            success:(SuccessBlock _Nullable)success
                            failure:(FailureBlock _Nullable)failure;

/**
 使用本地存储的信息重新登录，在每次启动时需调用

 @param success 成功回调
 @param failure 失败回调，返回错误码
 */
- (void)relogin:(SuccessBlock _Nullable)success
        failure:(FailureBlock _Nullable)failure;

/**
 退出登录

 @param isEnforce 是否强制退出，当为 NO 时会先请求服务端的登出接口
 @param success 成功回调
 @param failure 失败回调，返回错误码
 */
- (void)logoutWithIsEnforce:(BOOL)isEnforce
                    success:(SuccessBlock _Nullable)success
                    failure:(FailureBlock _Nullable)failure;

/**
 处理登录相关的网络错误

 @param errorCode 返回的错误码
 @param result 返回的数据内容
 */
- (void)networkErrorHandlerWithErrorCode:(NSInteger)errorCode
                                  result:(NSDictionary *_Nullable)result;

/**
 手动重置登录状态
 */
- (void)resetLoginStatus;

- (void)reloadUserInfo:(void (^)(UserInfoModel *))success failure:(FailureBlock)failure;

@end
