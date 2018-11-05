//
//  NSString+MD5String.m
//  NationalRedPacket
//
//  Created by Ying on 2018/1/15.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "NSString+MD5String.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString(MD5String)
- (NSString *)nim_MD5String {
    const char *cstr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end
