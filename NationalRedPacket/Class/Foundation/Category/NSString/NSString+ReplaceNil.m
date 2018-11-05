//
//  NSString+Check.m
//  NationalRedPacket
//
//  Created by sunmingyue on 17/7/13.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

@implementation NSString (ReplaceNil)

+ (NSString *)replaceNil:(NSString *)content {
    return content == nil ? @"" : content;
}

+ (BOOL)verificatePhoneNumber:(NSString *)phoneNumber
{
    NSString *pattern = @"^1+[34578]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    return isMatch;
}

@end
