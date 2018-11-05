//
//  NSNumber+RandomNumber.m
//  NationalRedPacket
//
//  Created by sunmingyue on 17/8/18.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "NSNumber+RandomNumber.h"

@implementation NSNumber (RandomNumber)

+ (NSInteger)randomNumberFrom:(int)from to:(int)to {
    return (NSInteger)(from + (arc4random()%(to - from + 1)));
}

@end
