//
//  UIButton+XLEdgeInsetsButton.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/4/27.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

// 定义一个枚举（包含了四种类型的button）
typedef NS_ENUM(NSUInteger, XLButtonEdgeInsetsStyle) {
    XLButtonEdgeInsetsStyleTop, // image在上，label在下
    XLButtonEdgeInsetsStyleLeft, // image在左，label在右
    XLButtonEdgeInsetsStyleBottom, // image在下，label在上
    XLButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface UIButton (XLEdgeInsetsButton)

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(XLButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

@end
