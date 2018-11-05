//
//  Network.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

typedef void(^SuccessBlock)(id responseDict);
typedef void(^FailureBlock)(NSInteger errorCode);
typedef void(^ProgressBlock)(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend);

typedef NS_ENUM(NSInteger, NetworkCode) {
    NetworkSuccessCode = 0,                 // 请求成功
    NetworkMissingParametersCode = 2,       // 参数缺失
    NetworkTokenNotFoundCode = 6,           // 用户token不存在
    NetworkTokenDeniedCode = 7,             // 访问拦截，当token为空的时候
    NetworkNotLoginCode = 11,               // 执行操作前，没有登录
    NetworkFrequentRequestsCode = 13,       // 请求频繁
    NetworkNeedReloginThirdpartyCode = 18,  // 需要重新第三方登录
    NetworkAccountRemoteLoginCode = 19,     // 账号在其他设备登录
    NetworkIllegalAccountCode = 20,         // 非法登录
    NetworkAccountPermanentBan = 21,        // 此用户被永久封禁
};

#import "NetworkManager.h"
