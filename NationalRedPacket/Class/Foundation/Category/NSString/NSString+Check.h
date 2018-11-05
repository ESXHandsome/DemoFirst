//
//  NSString+Check.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/10.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Check)

/**
 检查字符串是否是空或者空字符串
 
 @param string 字符串
 @return 是否是空
 */
+ (BOOL)isBlankString:(NSString *)string;

@end
