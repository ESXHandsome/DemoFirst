//
//  HttpRequestParam.h
//  NationalRedPacket
//
//  Created by sunmingyue on 17/7/18.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpCommonParam : NSObject

+ (NSString *)userAccount;      // 用户账号

+ (NSString *)tokenSignature;   // 请求token的签名

+ (NSString *)tokenKey;         // 请求token的秘钥

@end
