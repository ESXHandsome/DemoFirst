//
//  XLLoadIndicator.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/7/3.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLLoadIndicator : UIButton

///描边颜色
@property (strong, nonatomic) UIColor *borderColor;
///描边宽度
@property (assign, nonatomic) CGFloat borderWidth;
///背景填充颜色
@property (strong, nonatomic) UIColor *fillColor;
///绘制颜色
@property (strong, nonatomic) UIColor *strokeColor;
///绘制宽度
@property (assign, nonatomic) CGFloat lineWidth;
///进度
@property (assign, nonatomic) CGFloat progress;

- (void)reset;

@end
