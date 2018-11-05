//
//  NSDate+SessionHeader.m
//  NationalRedPacket
//
//  Created by Ying on 2018/5/30.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "NSDate+SessionHeader.h"



@implementation NSDate (SessionHeader)

/**用于消息界面中头饰图tab界面内的时间定义*/
+ (NSString *)changeTimestampToString:(NSString *)timestamp {
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    double distanceTime = now - [timestamp integerValue];
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:[timestamp integerValue]];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    NSString * lastDay = [df stringFromDate:beDate];
    
    if(distanceTime <24*60*60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天
        distanceStr = timeStr;
    }
    else if(distanceTime<24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){
        
        if ([nowDay integerValue] - [lastDay integerValue] ==1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            distanceStr = [NSString stringWithFormat:@"昨天"];
        }
        else{
            [df setDateFormat:@"MM-dd"];
            distanceStr = [df stringFromDate:beDate];
        }
        
    }
    else if(distanceTime <24*60*60*365){
        [df setDateFormat:@"M-d"];
        distanceStr = [df stringFromDate:beDate];
    }
    else{
        [df setDateFormat:@"yyyy/MM/dd"];
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}

@end
