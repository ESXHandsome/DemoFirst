
//
//  NetworkEncrypt.m
//  NationalRedPacket
//
//  Created by 孙明悦 on 2017/6/15.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "NetworkEncrypt.h"
#import "NSDictionary+JSON.h"
#import "AES256.h"

@implementation NetworkEncrypt

/**
 *  加密  给定的字典数据，先把字典数据转换成了JSON之后加密
 *
 *  @param data 要加密的数据
 *  @param key  加密的密钥
 *
 *  @return 加密后的字符串
 */
+ (NSString *_Nonnull)encryptData:(NSDictionary *_Nonnull)data
                          withKey:(NSString *_Nonnull)key {
    
    return [AES256 encryptString:[data json] withKey:key];
}

/**
 *  解密给定的字符串，解密后的数据是JSON，转换成字典输出
 *
 *  @param data 要解密的串
 *  @param key  解密的密钥
 *
 *  @return 解密后的字典数据
 */
+ (NSDictionary *_Nonnull)decryptData:(NSString *)data
                              withKey:(NSString *_Nonnull)key {
    
    return [NSDictionary dictionaryWithJSON:[AES256 decryptString:data withKey:key]];
}

@end
