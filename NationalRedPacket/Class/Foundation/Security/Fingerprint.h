//
// Created by Zhangziqi on 4/12/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Fingerprint : NSObject

/**
 *  根据idfa、key1、key2生成签名
 *
 *  @param key1  格式为数字的字符串，外部输入为时间戳的偶数位
 *  @param key2  格式为数字的字符串，外部输入为时间戳的奇数位
 *  @param idfa  设备的idfa
 *
 *  @return 生成的签名
 */
+ (NSString *_Nonnull)generateWithIdfa:(NSString *_Nonnull)idfa
                                  key1:(NSString *_Nonnull)key1
                                  key2:(NSString *_Nonnull)key2;
@end