//
//  NSString+Tools.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/3/19.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tools)

/**
 移除字符串中的空格与回车
 */
+ (NSString *)removeSpaceAndEnter:(NSString *)string;

@end
