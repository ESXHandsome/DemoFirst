//
//  UIView+XLBadge.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/4.
//  Copyright © 2018年 XLook. All rights reserved.
//
#import "UIView+XLBadge.h"
#import <objc/runtime.h>
#import "XLBadgeRedView.h"

#pragma mark- XLBadgeRedView interface extension

@interface XLBadgeRedView ()

@property (nonatomic, weak) NSLayoutConstraint *layoutCenterX;
@property (nonatomic, weak) NSLayoutConstraint *layoutCenterY;

@end

@interface XLBadgeView ()

@property (nonatomic, weak) NSLayoutConstraint *layoutCenterX;
@property (nonatomic, weak) NSLayoutConstraint *layoutCenterY;

@end

@interface UIView ()

@property (nonatomic, strong) XLBadgeRedView *redDotView;
@property (nonatomic, strong) XLBadgeView *badgeView;

@end

@implementation UIView (XLBadge)

- (BOOL)showRedDot {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setShowRedDot:(BOOL)showRedDot {
    if (self.showRedDot != showRedDot) {
        objc_setAssociatedObject(self, @selector(showRedDot), @(showRedDot), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self _refreshHiddenState];
    }
}

- (XLBadgeRedView *)redDotView {
    XLBadgeRedView *dotView = objc_getAssociatedObject(self, _cmd);
    if (!dotView) {
        dotView = [[XLBadgeRedView alloc] init];
        dotView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        dotView.refreshBlock = ^(XLBadgeRedView *view) {
            [weakSelf refreshRedDotView:view];
        };
        objc_setAssociatedObject(self, _cmd, dotView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addSubview:dotView];
        [self _layoutDotView:dotView];
    }
    return dotView;
}

- (XLBadgeView *)badgeView {
    XLBadgeView *badgeView = objc_getAssociatedObject(self, _cmd);
    if (!badgeView) {
        badgeView = [[XLBadgeView alloc] init];
        badgeView.hidden = YES;
  
        objc_setAssociatedObject(self, _cmd, badgeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addSubview:badgeView];
        [self _layoutBadgeView:badgeView];
    }
    return badgeView;
}

//offset
- (CGPoint)redDotOffset {
    return self.redDotView.offset;
}

- (void)setRedDotOffset:(CGPoint)redDotOffset {
    self.redDotView.offset = redDotOffset;
}

// badge
- (NSString *)badgeValue {
    return self.badgeView.badgeValue;
}

- (void)setBadgeValue:(NSString *)badgeValue {
    if ([self.badgeView.badgeValue isEqualToString:badgeValue]) return;
    self.badgeView.badgeValue = badgeValue;
    self.badgeView.hidden = !badgeValue;
    [self _refreshHiddenState];
}

- (CGPoint)badgeOffset {
    return self.badgeView.offset;
}

- (void)setBadgeOffset:(CGPoint)badgeOffset {
    self.badgeView.offset = badgeOffset;
    [self _refreshBadgeLayout];
}

#pragma mark - Private

- (void)_refreshHiddenState {
    self.redDotView.hidden = (!self.showRedDot || self.badgeValue);
}

- (void)_layoutDotView:(XLBadgeRedView *)dotView {
    
    [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_right);
        make.centerY.equalTo(self.mas_top);
    }];
}

- (void)_refreshRedDotLayout {
    CGFloat x = - self.redDotView.radius + self.redDotOffset.x;
    CGFloat y = self.redDotView.radius + self.redDotOffset.y;
    self.redDotView.layoutCenterX.constant = x;
    self.redDotView.layoutCenterY.constant = y;
}

- (void)refreshRedDotView:(XLBadgeRedView *)view {
    [self _refreshRedDotLayout];
}

- (void)_layoutBadgeView:(XLBadgeView *)bageview {
    [bageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_right);
        make.centerY.equalTo(self.mas_top);
    }];
}

- (void)_refreshBadgeLayout {
    CGFloat x = - 9 + self.badgeOffset.x;
    CGFloat y = 9 + self.badgeOffset.y;
    self.badgeView.layoutCenterX.constant = x;
    self.badgeView.layoutCenterY.constant = y;
}

@end
