//
//  UITabBar+Badge.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2017/8/9.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "UITabBar+Badge.h"

#define TabbarItemNums 5.0    //tabbar的数量 如果是5个设置为5.0

@implementation UITabBar (Badge)

/// 显示小红点
- (void)showBadgeOnItemIndex:(NSInteger)index {
    
    if (index >= 2) {
        index++;
    }
    // 移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    // 新建小红点
    UIView *badgeView = [UIView new];
    badgeView.backgroundColor = [UIColor colorWithString:COLORFF3E3D];
    badgeView.tag = 888 + index;
    CGRect tabFrame = self.frame;
    
    // 确定小红点的位置
    float percentX = (index + 0.51) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 8, 8);//圆形大小为8
    badgeView.layer.cornerRadius = 4;
    badgeView.layer.masksToBounds = YES;
    [self addSubview:badgeView];
}

/// 隐藏小红点
- (void)hideBadgeOnItemIndex:(NSInteger)index {
    if (index >= 2) {
        index++;
    }
    // 移除小红点
    [self removeBadgeOnItemIndex:index];
}

/// 移除小红点
- (void)removeBadgeOnItemIndex:(NSInteger)index {
    // 按照tag值进行移除
    for (UIImageView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end
