//
//  NSString+NumberAdapt.m
//  NationalRedPacket
//
//  Created by 王海玉 on 2017/12/21.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "NSString+NumberAdapt.h"

@implementation NSString(NumberAdapt)

+ (NSString *)numberAdaptWithStringNumber:(NSString *)numString {
    return [self transformNumber:numString];
}

+ (NSString *)numberAdaptWithFloatNumber:(float)num {
    NSString *numJudge = [NSString stringWithFormat:@"%.0f", num];
    return [self transformNumber:numJudge];
}

+ (NSString *)numberAdaptWithInteger:(NSInteger)num {
    NSString *numJudge = [NSString stringWithFormat:@"%ld", num];
    return [self transformNumber:numJudge];
}

+ (NSString *)transformNumber:(NSString *)number
{
    NSInteger resultNumber = number.integerValue;
    NSString *numberStr;
    if (resultNumber < 10000) {
        numberStr = [NSString stringWithFormat:@"%ld", (long)[number integerValue]];
    } else if (number.integerValue >= 10000 && number.integerValue < 100000) {
        numberStr = [NSString stringWithFormat:@"%.1f万", [number integerValue] / 10000.0];
    } else if (number.integerValue >= 100000) {
        numberStr = [NSString stringWithFormat:@"%.0f万", [number integerValue] / 10000.0];
    }
    if (resultNumber < 0) {
        return @"0";
    }
    return numberStr;
}

@end
