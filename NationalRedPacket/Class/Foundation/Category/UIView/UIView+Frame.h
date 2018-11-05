//
//  UIView+Frame.h
//  Categories
//
//  Created by 刘永杰 on 15/12/14.
//  Copyright © 2015年 刘永杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGFloat centerX;
@property (assign, nonatomic) CGFloat centerY;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;

- (UIViewController *)viewController;

@end
