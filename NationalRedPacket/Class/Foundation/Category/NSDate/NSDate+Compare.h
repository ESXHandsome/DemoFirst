//
//  NSDate+Compare.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/4.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Compare)

/**
 判断是否是今年
 */
+ (BOOL)isThisYear:(NSDate *)createDate;

/**
 判断两个日期是否是同一天
 */
+ (BOOL)isTheSameDay:(long long)time1 time2:(long long)time2;

@end
