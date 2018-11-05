//
//  UITabBar+Badge.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2017/8/9.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)

- (void)showBadgeOnItemIndex:(NSInteger)index; // 显示小红点

- (void)hideBadgeOnItemIndex:(NSInteger)index; // 隐藏小红点

@end
