//
//  PersonalBackgroundView.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/1/25.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "PersonalBackgroundView.h"
#import "PublisherViewController.h"
#import "PersonalTopView.h"
#import "UIView+Extension.h"

@interface PersonalBackgroundView ()

@end

@implementation PersonalBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark -
#pragma mark  重载系统的hitTest方法

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    PublisherViewController *currentVC = (PublisherViewController *)self.nextResponder;

    currentVC.printPoint = point;

    // 动态按钮
    if (CGRectContainsPoint(CGRectMake(0, adaptHeight1334(2 * 290) + self.topView.y, adaptWidth750(2 * 60), adaptHeight1334(2 * 40)),point)) {
        self.scrollView.scrollEnabled = YES;
        return [super hitTest:point withEvent:event];
    }
    // 视频按钮
    if (CGRectContainsPoint(CGRectMake(adaptWidth750(2 * 60), adaptHeight1334(2 * 290) + self.topView.y, adaptWidth750(2 * 60), adaptHeight1334(2 * 40)),point)) {
        self.scrollView.scrollEnabled = YES;
        return [super hitTest:point withEvent:event];
    }
    // 关注按钮
    if (CGRectContainsPoint(CGRectMake(adaptWidth750(2 * 281), adaptWidth750(2 * 135) + self.topView.y, adaptWidth750(2 * 80), adaptWidth750(2 * 32)),point)) {
        self.scrollView.scrollEnabled = YES;
        return [super hitTest:point withEvent:event];
    }
    if ([self.topView pointInside:point withEvent:event] && point.y - self.topView.y <= self.topView.height) {
        self.scrollView.scrollEnabled = NO;
        if (self.scrollView.contentOffset.x < SCREEN_WIDTH * 0.5) {
            return self.dynamicView;
        } else {
            return self.videoView;
        }
    } else {
        self.scrollView.scrollEnabled = YES;
        return [super hitTest:point withEvent:event];
    }
}

@end
