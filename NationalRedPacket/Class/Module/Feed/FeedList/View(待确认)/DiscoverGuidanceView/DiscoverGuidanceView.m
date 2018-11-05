//
//  DiscoverGuidanceView.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/4/18.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "DiscoverGuidanceView.h"

@implementation DiscoverGuidanceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *discoverGuidanceImageView = [UIImageView new];
    discoverGuidanceImageView.userInteractionEnabled = YES;
    discoverGuidanceImageView.image = [UIImage imageNamed:@"discover_guidance_icon"];
    [self addSubview:discoverGuidanceImageView];
    [discoverGuidanceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    UILabel *tipLabel = [UILabel new];
    tipLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
    tipLabel.textColor = [UIColor colorWithString:COLOR333333];
    tipLabel.text = @"戳这里，关注账号";
    [self addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(discoverGuidanceImageView.mas_bottom).mas_offset(-adaptHeight1334(50));
        make.centerX.equalTo(discoverGuidanceImageView);
    }];
    
    [self layoutIfNeeded];
    [self startGuidanceImageViewAnimation];
}

- (void)startGuidanceImageViewAnimation {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"position.y";
        animation.values = @[@(self.center.y),@(self.center.y + 10),@(self.center.y)];
        animation.duration = 1.2;
        animation.repeatCount = MAXFLOAT;
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = NO;

        [self.layer addAnimation:animation forKey:nil];
    });
}

@end
