//
//  TokenNetApi.m
//  NationalRedPacket
//
//  Created by sunmingyue on 17/7/18.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "TokenNetApi.h"
#import "HttpCommonParam.h"
#import "NSDictionary+JSON.h"
#import "NSDate+Timestamp.h"

@implementation TokenNetApi

/**
 * 获取token
 *
 * @param success 成功回调
 * @param failure 失败回调
 */
+ (void)fetchRequestToken:(SuccessBlock)success
                  failure:(FailureBlock)failure {
    
    NSDictionary *query = @{@"key":[HttpCommonParam tokenKey],
                            @"timestamp":[NSDate timestamp],
                            @"signature":[HttpCommonParam tokenSignature]
                            };
    NSDictionary *param = @{@"a":[HttpCommonParam userAccount],
                            @"e":@"0",
                            @"q":[query json],
                            @"s": @(2)
                            };
    
    XLLog(@"[Server Request]: %@ %@", URL_INITLOGIN, param);
    
    [NetworkManager.shared sendPostRequest:URL_INITLOGIN
                             withParamDict:param
                                   success:^(id response) {
                                        
                                       [self handleTokenResultDict:response success:success failure:failure];
                                    
                                   }
                                   failure:^(NSInteger errorCode) {
                                       
                                       if (failure) {
                                           failure(errorCode);
                                       }
                                         
                                   }];
}

/**
 * 处理token请求的返回结果
 *
 * @param responseDict  需要处理的数据字典
 * @param success       成功回调
 * @param failure       失败回调
 */
+ (void)handleTokenResultDict:(NSDictionary *)responseDict
                      success:(SuccessBlock)success
                      failure:(FailureBlock)failure {
    
    if([responseDict[@"error"] integerValue] != 0 || responseDict.count == 0) {
        if (failure) {
            failure([responseDict[@"error"] integerValue]);
        }
        return ;
    }
    
    NSString *dataString = responseDict[@"data"];
    NSDictionary *dateDict = [NSDictionary dictionaryWithJSON:dataString];
    
    XLLog(@"[Server Response %li]: %@ %@", [responseDict[@"error"] integerValue], URL_INITLOGIN, responseDict);
    
    if(![dateDict[@"result"] boolValue] && dateDict.count > 0) {
        success(dateDict[@"token"]);
        return;
    }
    
    if (failure) {
        failure([dateDict[@"result"] integerValue]);
    }
   
    return ;
}

@end
