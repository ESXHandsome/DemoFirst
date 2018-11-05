//
// Created by Zhangziqi on 4/12/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import "Fingerprint.h"
#import "SHA256.h"
#import "Xor.h"
#import "Base64.h"

@implementation Fingerprint

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
                                  key2:(NSString *_Nonnull)key2 {
    NSInteger key1Num = [key1 integerValue];
    NSInteger key2Num = [key2 integerValue];
    NSInteger difference;

    if (key1Num > key2Num) {
        difference = key1Num - key2Num;
    } else {
        difference = key2Num - key1Num;
    }

    NSMutableString *plain = [idfa mutableCopy];
    [plain appendFormat:@"%ld", (long) difference];

    NSString *subKey = [NSString stringWithFormat:@"%@%@", key2, key1];
    NSMutableString *key = [[NSMutableString alloc] init];

    while (key.length < plain.length) {
        [key appendString:subKey];
    }

    key = [[key substringWithRange:NSMakeRange(0, plain.length)] mutableCopy];

    NSString *cipher = [Base64 encodeString:[Xor xor:plain with:key]
                               withEncoding:NSUTF8StringEncoding];

    return [SHA256 hash:cipher];
}

@end
