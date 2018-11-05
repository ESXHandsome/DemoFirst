//
//  NSString+NumberAdapt.h
//  NationalRedPacket
//
//  Created by 王海玉 on 2017/12/21.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NumberAdapt)

+ (NSString *)numberAdaptWithStringNumber:(NSString *)numString;

+ (NSString *)numberAdaptWithFloatNumber:(float)num;

+ (NSString *)numberAdaptWithInteger:(NSInteger)num;

+ (NSString *)transformNumber:(NSString *)number;

@end
