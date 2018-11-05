//
//  NSDate+Timestamp.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/4.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Timestamp)

/**
 时间戳转日期
 
 @param timestamp 时间戳
 @param formatStr 日期格式
 @return 日期字符串
 */
+ (NSString *)switchTimestamp:(NSInteger )timestamp toFormatStr:(NSString *)formatStr;

/**
 获取时间间隔
 
 @param compareTime 时间戳
 @reture 时间间隔 例如“一小时之前”
 */
+ (NSString *)timeIntervalCompareWithTimestamp:(long)compareTime isContainHour:(BOOL)isContainHour;

/**
 获取时间戳
 */
+ (NSString *)timestamp;

/**
 获取时间戳
 */
+ (NSString *)timeStringWithSecond:(NSInteger)second;

@end
