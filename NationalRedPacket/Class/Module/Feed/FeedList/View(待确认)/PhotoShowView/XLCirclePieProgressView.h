//
//  PPSCirclePieProgressView.m
//  NationalRedPacket
//
//  Created by Ying on 2018/2/26.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLCirclePieProgressView : UIView
@property (assign, nonatomic) CGFloat progress; 
@property (assign, nonatomic) CGFloat beginAngle;
@property (assign, nonatomic) CGFloat lineWidth;
@property (strong, nonatomic) UIColor *progressColor;
@property (strong, nonatomic) UIColor *lineColor;
@end
