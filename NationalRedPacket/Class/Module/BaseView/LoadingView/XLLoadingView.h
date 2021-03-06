//
//  WNLoadingView.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/22.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseView.h"

@interface XLLoadingView : BaseView

@property (strong, nonatomic) UIImageView *imageView;

+ (void)showLoadingInView:(UIView *)view;

+ (void)showLoadingInView:(UIView *)view offSet:(NSInteger)offSet;

+ (void)hideLoadingForView:(UIView *)view;

+ (void)hideAllLoadingForView:(UIView *)view;

+ (XLLoadingView *)loadingForView:(UIView *)view;

- (void)showInView:(UIView *)view;

- (void)hide;

@end
