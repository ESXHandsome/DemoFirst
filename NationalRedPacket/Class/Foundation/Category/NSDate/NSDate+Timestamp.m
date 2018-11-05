//
//  NSDate+Timestamp.m
//  NationalRedPacket
//
//  Created by fensi on 2018/4/4.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "NSDate+Timestamp.h"
#import "NSDate+Compare.h"

static NSDateFormatter *dateformatter = nil;

@implementation NSDate (Timestamp)

+ (NSString *)switchTimestamp:(NSInteger )timestamp toFormatStr:(NSString *)formatStr
{
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timestamp];
    if (!dateformatter) {
        dateformatter=[[NSDateFormatter alloc] init];
    }
    [dateformatter setDateFormat:formatStr];
    
    NSString *resultStr =[dateformatter stringFromDate:date];
    return resultStr;
}

// 计算时间差
+ (NSString *)timeIntervalCompareWithTimestamp:(long)compareTime isContainHour:(BOOL)isContainHour{
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    
    // 时间差
    NSTimeInterval time = currentTime - compareTime;
    if (time < 60) {
        return @"刚刚";
    }
    // 秒转分钟
    NSInteger minute = time/60;
    if (minute<60) {
        return [NSString stringWithFormat:@"%ld分钟前",(long)minute];
    }
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%ld小时前",(long)hours];
    }
    // 转日期格式
    return [self switchTimestamp:compareTime isContainHour:isContainHour];
    
}

/**
 转换时间戳为日期
 
 @param timestamp 时间戳
 @return 日期
 */
+ (NSString *)switchTimestamp:(NSInteger )timestamp isContainHour:(BOOL)isContainHour{
    
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timestamp]; 
    
    if (!dateformatter) {
        dateformatter=[[NSDateFormatter alloc] init];
    }
    NSString *formatStr;
    
    if (isContainHour) {
        formatStr = [self isThisYear:date] ? @"M-d HH:mm" : @"yy-M-d HH:mm";
    } else {
        formatStr = [self isThisYear:date] ? @"M-d" : @"yy-M-d";
    }
    [dateformatter setDateFormat:formatStr];
    
    NSString *resultStr =[dateformatter stringFromDate:date];
    
    return resultStr;
    
}

+ (NSString *)timestamp {
    NSTimeInterval interval =[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", interval];//转为字符型
    return timeString;
}

+ (NSString *)timeStringWithSecond:(NSInteger)second {
    NSInteger seconds = second % 60;
    NSInteger minutes = (second / 60) % 60;
    NSInteger hours = second / 3600;
    
    if (hours > 0) {
        return [NSString stringWithFormat:@"%ld小时%ld分%ld秒",(long)hours, (long)minutes, (long)seconds];
    }
    if (minutes > 0) {
        return [NSString stringWithFormat:@"%ld分%ld秒",(long)minutes, (long)seconds];
    }
    return [NSString stringWithFormat:@"%ld秒",(long)seconds];
}

@end
