//
//  HttpRequestParam.m
//  NationalRedPacket
//
//  Created by sunmingyue on 17/7/18.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "HttpCommonParam.h"
#import "MD5Encrypt.h"
#import "Base64.h"
#import "SHA256.h"
#import "UIDevice+Info.h"
#import "NSDate+Timestamp.h"
#import "XLLoginManager.h"

@implementation HttpCommonParam

/**
 * 用户账号:sha256(uuid拼接model拼接client_key)
 */
+ (NSString *)userAccount {
    NSString *uuid = XLLoginManager.shared.UUID;
    NSString *userAccountDecrypt = [NSString stringWithFormat:@"%@%@",uuid,KEY_CLIENT];
    NSString *userAccount = [SHA256 hash:userAccountDecrypt];
    return userAccount;
}

/**
 * a参数和key拼接的字符串 为 subSignature1
 * 算出str的长度为len
 * 把timestamp参数向右填充，填充到len长度，填充内容为timestamp 结果为subSignature2
 * 把str与strr做二进制异或  结果为sign
 * sign做base64 再做两遍md5
 */
+ (NSString *)tokenSignature {
   
    NSString *subSignature = [NSString stringWithFormat:@"%@%@",[self userAccount],[self tokenKey]];

    NSString *sign = [self xor:subSignature withInterval:[self fillLenth:subSignature.length]];;

    return [MD5Encrypt MD5ForLower32Bate:[MD5Encrypt MD5ForLower32Bate:[Base64 encodeString:sign withEncoding:NSUTF8StringEncoding]]];
}

/**
 * 把timestamp参数向右填充，填充到len长度，填充内容为timestamp
 */
+ (NSString *)fillLenth:(NSInteger)fillLenth{
    NSString *fillContent = @"";
    NSString *timestamp = [NSDate timestamp];
    NSInteger completeCount = fillLenth/timestamp.length;
    
    for (int i = 0; i < completeCount; i ++) {
        fillContent = [NSString stringWithFormat:@"%@%@",fillContent,timestamp];
    }
    NSString *fillSubContent = [timestamp substringToIndex:fillLenth - timestamp.length * completeCount];

    fillContent = [NSString stringWithFormat:@"%@%@",fillContent,fillSubContent];
    
    return fillContent;
}
/*
 * 请求token秘要:hash('sha256', hash('sha256', (account.deviceType)))
 */
+ (NSString *)tokenKey {
    NSString *account = self.userAccount;
    NSString *deviceModel = [UIDevice deviceType];
    NSString *keyString = [NSString stringWithFormat:@"%@%@",account,deviceModel];
    return [SHA256 hash:[SHA256 hash:keyString]];
}

/*
 * 字符串二进制异或
 */
+ (NSString *)xor:(NSString *)str withInterval:(NSString *)interval {
   
    NSData *strData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSData *intervalData = [interval dataUsingEncoding:NSUTF8StringEncoding];

    Byte *strByte = (Byte *)[strData bytes];   //取关键字的Byte数组, keyBytes一直指向头部
    Byte *intervalByte = (Byte *)[intervalData bytes];  //取需要加密的数据的Byte数组
    
    for (long i = 0; i < [intervalData length]; i++) {
        strByte[i] = strByte[i] ^ intervalByte[i]; //然后按位进行异或运算
    }
    return [[NSString alloc] initWithData:[NSData dataWithBytes:strByte length:[intervalData length]]
                                 encoding:NSUTF8StringEncoding];
}

@end
