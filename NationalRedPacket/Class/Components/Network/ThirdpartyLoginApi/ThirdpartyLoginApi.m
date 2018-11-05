//
//  WechatApi.m
//  NationalRedPacket
//
//  Created by sunmingyue on 17/7/27.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "ThirdpartyLoginApi.h"
#import "ThirdpartyLoginRequestURL.h"

@implementation ThirdpartyLoginApi

+ (void)fetchWeiXinTokenWithCode:(NSString *)code
                         success:(SuccessBlock)success
                         failure:(FailureBlock)failure {
    
    NSString *urlString =[NSString stringWithFormat:URL_WEIXINCODE,XLWechatId,XLWechatKey,code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSString *urlUTF8 = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        
        NSData *urlData = [urlUTF8 dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (urlData){
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:urlData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:nil];
                if ([dict[@"errcode"] integerValue] == 0) {
                    success(dict);
                    return ;
                }
                failure([dict[@"errcode"] integerValue]);
            }
        });
    });
}

+ (void)requestThirdpartyLoginPlatform:(NSString *)platform
                                openId:(NSString *)openId
                           accessToken:(NSString *)accessToken
                               success:(SuccessBlock)success
                               failure:(FailureBlock)failure {
    
    NSDictionary *queryDict = @{@"openId": openId ?: @"",
                                @"accessToken": accessToken ?: @"",
                                @"accessMode" : platform ?: @""
                                };
    
    [self httpRequestWithURL:URL_THIRDPARTY_LOGIN
                   withParam:queryDict
                     success:^(id response) {
                         NSInteger result = [response[@"result"] integerValue];
                         if (result == 0) {
                             success(response);
                         } else {
                             failure(result);
                         }
                     } failure:^(NSInteger errorCode) {
                         failure(errorCode);
                     }];
}
@end
