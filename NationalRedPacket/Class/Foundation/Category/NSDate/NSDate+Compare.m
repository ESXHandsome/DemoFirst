//
//  NSDate+Compare.m
//  NationalRedPacket
//
//  Created by fensi on 2018/4/4.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "NSDate+Compare.h"

@implementation NSDate (Compare)

/**
 是否是今年
 
 @return YES/NO
 */
+ (BOOL)isThisYear:(NSDate *)createDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:createDate];
    
    return nowCmps.year == selfCmps.year;
}

/**
 判断两个日期是否是同一天
 */
+ (BOOL)isTheSameDay:(long long)time1 time2:(long long)time2
{
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:time1];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:time2];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:date1];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:date2];
    
    return nowCmps.day == selfCmps.day && nowCmps.month == selfCmps.month && nowCmps.year == selfCmps.year;
}

@end
