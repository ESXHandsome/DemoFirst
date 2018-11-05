//
//  UIButton+StateBackgroundColor.m
//  NationalRedPacket
//
//  Created by fensi on 2018/4/25.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "UIButton+StateBackgroundColor.h"

@implementation UIButton (StateBackgroundColor)

- (UIColor *)normalBackgroundColor {
    return nil;
}

- (void)setNormalBackgroundColor:(UIColor *)normalBackgroundColor {
    [self setBackgroundImage:[UIImage imageWithColor:normalBackgroundColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
}

- (UIColor *)highlightedBackgroundColor {
    return nil;
}

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor {
    [self setBackgroundImage:[UIImage imageWithColor:highlightedBackgroundColor size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
}

- (UIColor *)selectedBackgroundColor {
    return nil;
}

- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor {
    [self setBackgroundImage:[UIImage imageWithColor:selectedBackgroundColor size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
}

- (UIColor *)disableBackgroundColor {
    return nil;
}

- (void)setDisableBackgroundColor:(UIColor *)disableBackgroundColor {
    [self setBackgroundImage:[UIImage imageWithColor:disableBackgroundColor size:CGSizeMake(1, 1)] forState:UIControlStateDisabled];
}

@end
