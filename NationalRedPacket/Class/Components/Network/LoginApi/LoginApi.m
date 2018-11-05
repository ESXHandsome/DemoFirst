//
//  LoginApi.m
//  NationalRedPacket
//
//  Created by 孙明悦 on 2017/6/2.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "LoginApi.h"
#import "LoginRequestURL.h"
#import "UIDevice+Info.h"
#import "NSDictionary+JSON.h"

@interface LoginApi ()

@end

@implementation LoginApi

+ (void)requestUserLoginWithThirdpartyOpenId:(NSString *)openId
                                 accessToken:(NSString *)accessToken
                                     success:(SuccessBlock)success
                                     failure:(FailureBlock)failure {
    
    // 从UIDevice获取设备信息
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *idfa = UIDevice.idfa;
    
    // 从MainBundle获取app相关信息
    NSString *appVersion = NSBundle.appVersion;
    NSString *clientVersion = NSBundle.appVersionNumber;
    NSString *bundleName = NSBundle.appBundleName;
    
    // 当前WiFi信息 eg:bssid ssid ssiddata
    NSDictionary *wifiInfo = [UIDevice deviceWifiInfo];
    NSString *ssid = [wifiInfo objectForKey:@"SSID"] ?: @"";
    
    // 屏幕信息
    NSString *displayWidth = [NSString stringWithFormat:@"%f",SCREEN_WIDTH];
    NSString *displayHeight = [NSString stringWithFormat:@"%f",SCREEN_HEIGHT];
    
    NSDictionary *deviceInfo = @{@"wechatOpenId": openId ?: @"",
                                 @"accessToken": accessToken ?: @"",
                                 @"idfa": idfa ?: @"",
                                 @"model": [UIDevice deviceType],
                                 @"displayHeight": displayHeight,
                                 @"displayWidth": displayWidth,
                                 @"systemVersion": systemVersion,
                                 @"network": @"wifi",
                                 @"ssid": ssid,
                                 @"clientVersion": clientVersion,
                                 @"clientChannel": XLAppChannel,
                                 @"packageName": bundleName,
                                 @"clientVersionNumber": appVersion,
                                 @"carrier": [UIDevice deviceNetCarrier]};
    
    [self httpRequestWithURL:URL_USERLOGIN
                   withParam:deviceInfo
                     success:success
                     failure:failure];
}

+ (void)requestUserLogout:(SuccessBlock)success failure:(FailureBlock)failure {
    
    [self httpRequestWithURL:URL_USERLOGOUT
                   withParam:nil
                     success:success
                     failure:failure];
}

+ (void)fetchUserInfoSuccess:(SuccessBlock)success
                     failure:(FailureBlock)failure {
    
    [self httpRequestWithURL:URL_USERINFO
                   withParam:nil
                     success:^(id response) {
                         success([UserInfoModel yy_modelWithJSON:response]);
                     }
                     failure:failure];
}

+ (void)checkUpdate:(SuccessBlock)success
            failure:(FailureBlock)failure {

    NSDictionary *queryDict = @{@"clientVersionNumber" : NSBundle.appVersionNumber};
    
    [self httpRequestWithURL:URL_CHECKUPDATE
                   withParam:queryDict
                     success:success
                     failure:failure];
}

@end
