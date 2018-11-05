//
//  NSString+XLBadgeCount.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/5.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "NSString+XLBadgeCount.h"

@implementation NSString (XLBadgeCount)

+ (NSString *)badgeCount:(NSInteger)count {
    if (count == 0) {
        return nil;
    } else if (count > 99) {
        return @"···";
    } else {
        return  [NSString stringWithFormat:@"%ld",(long)count];
    }
}

@end
