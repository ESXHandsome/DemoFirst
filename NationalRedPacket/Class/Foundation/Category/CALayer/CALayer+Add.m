//
//  CALayer+Add.m
//  NationalRedPacket
//
//  Created by Ying on 2018/3/5.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "CALayer+Add.h"

@implementation CALayer (Add)
- (CGFloat)transformScale {
    NSNumber *v = [self valueForKeyPath:@"transform.scale"];
    return v.doubleValue;
}

- (void)setTransformScale:(CGFloat)v {
    [self setValue:@(v) forKeyPath:@"transform.scale"];
}

@end
