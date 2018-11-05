//
//  NSString+Tools.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/3/19.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "NSString+Tools.h"

@implementation NSString (Tools)

+ (NSString *)removeSpaceAndEnter:(NSString *)string {
    NSString *tempString = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    tempString = [tempString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    tempString = [tempString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return tempString;
}

@end
