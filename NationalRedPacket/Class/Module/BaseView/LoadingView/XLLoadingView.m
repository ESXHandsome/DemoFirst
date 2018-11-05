//
//  WNLoadingView.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/22.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "XLLoadingView.h"

static CABasicAnimation *s_animation = nil;

@implementation XLLoadingView

- (CABasicAnimation *)basicAnimation {
    if (!s_animation) {
        s_animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        s_animation.fromValue = @(0);
        s_animation.toValue = @(M_PI*4);
        s_animation.duration = 1;
        s_animation.repeatCount = HUGE_VALF;
        s_animation.fillMode = kCAFillModeForwards;
        s_animation.removedOnCompletion = NO;
    }
    return s_animation;
}

- (void)addAnimalImages:(NSInteger)offset
{
    self.imageView = [UIImageView new];
    self.imageView.image = [UIImage imageNamed:@"page_loading_icon"];
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-offset);
        make.width.height.mas_equalTo(adaptWidth750(92));

    }];
}

+ (void)showLoadingInView:(UIView *)view
{
    [XLLoadingView showLoadingInView:view offSet:0];
}

+ (void)showLoadingInView:(UIView *)view offSet:(NSInteger)offSet
{
    XLLoadingView *loadingView = [XLLoadingView new];
    
    loadingView.frame = view.bounds;
    if (view.y == 0) {
        loadingView.y = 64;
    }
    
    loadingView.backgroundColor = view.backgroundColor;
    [loadingView addAnimalImages:loadingView.y - offSet];
    
    [loadingView showInView:view];
    
}

+ (void)hideLoadingForView:(UIView *)view
{
    XLLoadingView *loadingView = [self loadingForView:view];
    if (loadingView) {
        [loadingView hide];
    }
}

+ (XLLoadingView *)loadingForView:(UIView *)view
{
    NSEnumerator *reverseSubviews = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in reverseSubviews) {
        if ([subview isKindOfClass:self]) {
            return (XLLoadingView *)subview;
        }
    }
    return nil;
}

+ (void)hideAllLoadingForView:(UIView *)view
{
    NSEnumerator *reverseSubviews = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in reverseSubviews) {
        if ([subview isKindOfClass:self]) {
            [(XLLoadingView *)subview hideNoAnimation];
        }
    }
}

- (void)showInView:(UIView *)view
{
    if (!view) {
        return ;
    }
    if (self.superview != view) {
        
        [self removeFromSuperview];
        
        [view addSubview:self];
        
        [view bringSubviewToFront:self];
        
    }
    [self.imageView.layer addAnimation:[self basicAnimation] forKey:@"animation"];
}

- (void)hide
{
    self.alpha = 1.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self hideNoAnimation];
    }];
}

- (void)hideNoAnimation
{
    [self.imageView.layer removeAllAnimations];
    [self removeFromSuperview];
}

- (void)dealloc
{
    [self.imageView.layer removeAllAnimations];
    self.imageView.animationImages = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
