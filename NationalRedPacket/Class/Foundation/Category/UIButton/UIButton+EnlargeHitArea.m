//
//  UIButton+EnlargeHitArea.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/2/9.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "UIButton+EnlargeHitArea.h"

@implementation UIButton (EnlargeHitArea)

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (!self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect bounds = self.bounds;
    
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    //扩大bounds
    
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    
    //如果点击的点 在 新的bounds里，就返回YES
    
    return CGRectContainsPoint(bounds, point);
}

@end
