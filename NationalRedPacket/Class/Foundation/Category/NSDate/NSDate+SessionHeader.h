//
//  NSDate+SessionHeader.h
//  NationalRedPacket
//
//  Created by Ying on 2018/5/30.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SessionHeader)

/**
 把时间戳转换成字符串

 @param timestamp 时间戳
 @return 需要转换成的格式
 */
+ (NSString *)changeTimestampToString:(NSString *)timestamp;

@end

