//
//  WechatLoginManager.m
//  NationalRedPacket
//
//  Created by sunmingyue on 17/7/27.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "WechatLogin.h"
#import "ThirdpartyLoginApi.h"
#import "WechatShare.h"

#define SendAuthReqScope @"snsapi_userinfo"

NSInteger const WECHAT_LOGIN_NO_ERROR_CODE = 0;
NSInteger const WECHAT_LOGIN_REQUEST_TIMEOUT_CODE = 1;

@interface WechatLogin ()

@property (copy, nonatomic) WechatLoginCompletion wechatLoginCompletion;

@end

@implementation WechatLogin

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static WechatLogin *sharedInstance;
    dispatch_once(&onceToken, ^{ sharedInstance = [self new]; });
    return sharedInstance;
}


#pragma mark - login

- (void)wechatLogin:(WechatLoginCompletion)completion {
    self.wechatLoginCompletion = completion;
    
    SendAuthReq *req = [SendAuthReq alloc];
    req.scope = SendAuthReqScope;
    req.state = XLWechatId;
    [WXApi sendReq:req];
    
    self.isLoggingIn = YES;
}

#pragma mark - foreground check

- (void)applicationWillEnterForegroundLoginCheck {
    // 两秒后检查登录状态
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        if (self.isLoggingIn) {
            self.isLoggingIn = NO;
            [self wechatLoginCallback:WECHAT_LOGIN_REQUEST_TIMEOUT_CODE openId:nil accessToken:nil];
        }
    });
}

#pragma mark - handler

/**
 处理回调请求，当通过微信客户端登录或者取消时回调
 */
- (void)handleLoginCallback:(NSDictionary *)userInfo {
    self.isLoggingIn = NO;
    
    NSString *code = [userInfo objectForKey:@"code"];
    NSInteger errorCode = [[userInfo objectForKey:@"errorCode"] integerValue];
    
    if (errorCode != 0) {
        [self wechatLoginCallback:errorCode openId:nil accessToken:nil];
        return;
    }
    
    [TalkingData trackEvent:XLTalkingDataClickWechat];
    
    [ThirdpartyLoginApi fetchWeiXinTokenWithCode:code success:^(NSDictionary *responseDict) {
        [self requestWechatLoginToServerWithWechatInfo:responseDict];
    } failure:^(NSInteger errorCode) {
        [self wechatLoginCallback:errorCode openId:nil accessToken:nil];
    }];
}

/**
 验证微信登录是否成功
 */
- (void)requestWechatLoginToServerWithWechatInfo:(NSDictionary *)info {
    
    NSString *openId = info[@"openid"];
    NSString *accessToken = info[@"access_token"];
    
    [ThirdpartyLoginApi requestThirdpartyLoginPlatform:@"WECHAT" openId:openId accessToken:accessToken success:^(id res) {
        
        [self wechatLoginCallback:WECHAT_LOGIN_NO_ERROR_CODE
                           openId:openId
                      accessToken:accessToken];
        
    } failure:^(NSInteger errorCode) {
        [self wechatLoginCallback:errorCode openId:nil accessToken:nil];
    }];
}

/**
 微信登录回调处理
 */
- (void)wechatLoginCallback:(NSInteger)code openId:(NSString *)openId accessToken:(NSString *)accessToken {
    if (self.wechatLoginCompletion) {
        ThirdpartyLoginModel *model = [ThirdpartyLoginModel new];
        model.code = code;
        model.openId = openId;
        model.accessToken = accessToken;
        model.platform = @"WECHAT";
        self.wechatLoginCompletion(model);
        self.wechatLoginCompletion = nil;
    }
}

#pragma mark - Weixin Delegate

- (void)onResp:(BaseResp *)resp {
    
    // 判断是否为授权请求，否则与微信支付等功能发生冲突
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        
        SendAuthResp *aresp = (SendAuthResp *)resp;
        
        [self handleLoginCallback:@{@"code": aresp.code ?: @"",
                                    @"errCode": @(aresp.errCode)}];
        
    } else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        
        SendMessageToWXResp *result = (SendMessageToWXResp *)resp;
        
        if ([WechatShare sharedInstance].sendReqCallback) {
            [WechatShare sharedInstance].sendReqCallback(result.errCode);
        }
    }
}

@end
