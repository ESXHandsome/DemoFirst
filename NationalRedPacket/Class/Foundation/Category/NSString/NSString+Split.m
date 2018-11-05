//
// Created by Zhangziqi on 4/12/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import "NSString+Split.h"

@implementation NSString (Split)

- (NSMutableArray *)splitToChars {
    NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[self length]];
    for (NSUInteger i = 0; i < [self length]; i++) {
        NSString *ichar = [NSString stringWithFormat:@"%c", [self characterAtIndex:i]];
        [characters addObject:ichar];
    }
    return characters;
}

//每隔4个字符添加一个空格的字符串算法
+ (NSString *)dealWithString:(NSString *)number
{
    NSString *doneTitle = @"";
    int count = 0;
    for (int i = 0; i < number.length; i++) {
        
        count++;
        doneTitle = [doneTitle stringByAppendingString:[number substringWithRange:NSMakeRange(i, 1)]];
        if (number.length == 11 && i < 3 && count == 3) {
            //手机号的特殊处理
            doneTitle = [NSString stringWithFormat:@"%@ ", doneTitle];
            count = 0;
        } else if (count == 4) {

            doneTitle = [NSString stringWithFormat:@"%@ ", doneTitle];
            count = 0;
        }
    }
    return doneTitle;
}

@end
