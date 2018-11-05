//
// Created by Zhangziqi on 4/12/16.
// Copyright (c) 2016 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Split)

- (NSMutableArray *)splitToChars;

//每隔4个字符添加一个空格的字符串算法
+ (NSString *)dealWithString:(NSString *)number;

@end
