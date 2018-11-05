//
//  UIView+Display.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/3.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "UIView+Display.h"

@implementation UIView (Display)

// 判断View是否显示在屏幕上
+ (BOOL)isDisplayedInScreenForView:(UIView *)view
{
    if (view == nil) {
        return FALSE;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 转换view对应window的Rect
    CGRect rect = [view convertRect:view.bounds fromView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return FALSE;
    }
    
    // 若view 隐藏
    if (view.hidden) {
        return FALSE;
    }
    
    // 若没有superview
    if (view.superview == nil) {
        return FALSE;
    }
    
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  FALSE;
    }
    
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return FALSE;
    }
    
    return TRUE;
}

@end
