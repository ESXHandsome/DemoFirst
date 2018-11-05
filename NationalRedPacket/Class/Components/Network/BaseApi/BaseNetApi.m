//
//  BaseNetApi.m
//  NationalRedPacket
//
//  Created by 孙明悦 on 2017/6/2.
//  Copyright © 2017年 孙明悦. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BaseNetApi.h"
#import "HttpCommonParam.h"
#import "LoginApi.h"
#import "NetworkEncrypt.h"

@implementation BaseNetApi

/**
 *  生成请求参数：query为q参数，方法生成a(account)与e(encrypt)参数，返回完整的数据请求参数
 *
 *  @param query 要加密的q参数
 *
 *  @return 请求参数
 */
+ (NSDictionary *)encryptionParamsWithQuery:(NSDictionary *)query {
    
    NSString *account = [HttpCommonParam userAccount];
    NSString *token  = XLLoginManager.shared.serverToken ?: @"123"; //防止无网络进入崩溃问题，值无意义
    NSDictionary *q = query == nil ? @{} : query;
    
    return @{
             @"q" : [NetworkEncrypt encryptData:q withKey:token],
             @"e" : @1,
             @"a" : account,
             @"s" : @(2)
             };
}

/**
 *  发送数据请求
 *
 *  @param url 数据请求URL
 *  @param param 数据请求参数
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)httpRequestWithURL:(NSString *)url
                 withParam:(NSDictionary *)param
                   success:(SuccessBlock)success
                   failure:(FailureBlock)failure {
    
    XLLog(@"[Server Request]: %@ %@", url, param);
        
    [NetworkManager.shared sendPostRequest:url withParamDict:[self encryptionParamsWithQuery:param] success:^(NSDictionary *responseDict) {
        
        NSInteger errorCode = [responseDict[@"error"] integerValue];

        NSDictionary *result;
        
        if (errorCode == NetworkSuccessCode ||
            errorCode == NetworkAccountRemoteLoginCode) {
            
            NSString *jsonData = responseDict[@"data"];
            NSString *token = XLLoginManager.shared.serverToken;
            
            if (jsonData && token) {
                // 数据解密
                result = [NetworkEncrypt decryptData:jsonData withKey:token];
            }
        }
        
        if (errorCode == NetworkSuccessCode) {
            
            if (success) {
                success(result);
            }
            
        } else if (errorCode == NetworkTokenNotFoundCode ||
                   errorCode == NetworkTokenDeniedCode ||
                   errorCode == NetworkNotLoginCode) {
            
            [XLLoginManager.shared relogin:^(id responseDict) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self httpRequestWithURL:url withParam:param success:success failure:failure];
                });
                
            } failure:^(NSInteger errorCode) {
                
//                NSAssert(NO, @"需要排查错误");
                
            }];
            
        } else {
            
            if (failure) {
                failure(errorCode);
            }
            
            [XLLoginManager.shared networkErrorHandlerWithErrorCode:errorCode result:result];

        }
        
        XLLog(@"[Server Response %li]: %@ %@", errorCode, url, result ?: responseDict);
                                                
    } failure:^(NSInteger errorCode) {
        
        if (failure) {
            failure(errorCode);
        }
    }];
}

@end
