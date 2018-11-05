//
//  ShareView.m
//  NationalRedPacket
//
//  Created by sunmingyue on 17/11/15.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "ShareView.h"
#import "UIView+LSCore.h"

@interface ShareView ()

@property (strong, nonatomic) UIView *toolView;

@end

@implementation ShareView

- (void)setupViews {
    UIButton *tapClearBgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tapClearBgButton addTarget:self action:@selector(didClickConcelButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tapClearBgButton];
    
    UIView *containerBgView = [UIView new];
    containerBgView.backgroundColor = [UIColor clearColor];
    self.toolView = containerBgView;
    [self addSubview:containerBgView];

    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.layer.cornerRadius = 8.0f;
    effectView.clipsToBounds = YES;
    effectView.frame = CGRectMake(0,0, self.bounds.size.width, adaptHeight1334(165 * 2) + 8);
    [containerBgView addSubview:effectView];
    
    UIView *blackBgView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - adaptHeight1334(392), SCREEN_WIDTH, adaptWidth750(392))];
    [blackBgView addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadii:CGSizeMake(8.f, 8.f)];
    blackBgView.backgroundColor = [UIColor colorWithString:COLOR1F1F1F];
    blackBgView.alpha = 0.55;
    [containerBgView addSubview:blackBgView];
    
//    UILabel *tipLabel = [UILabel new];
//    tipLabel.text = @"转发到";
//    tipLabel.font = [UIFont systemFontOfSize:adaptFontSize(30)];
//    tipLabel.textColor = [UIColor colorWithString:COLOR939393];
//    [containerBgView addSubview:tipLabel];
    
    UIButton *wechatShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [wechatShareButton setImage:[UIImage imageNamed:@"share_wechat_icon"] forState:UIControlStateNormal];
    [wechatShareButton addTarget:self action:@selector(didClickWechatShareButton) forControlEvents:UIControlEventTouchUpInside];
    [wechatShareButton addTarget:self action:@selector(didClickButtonWithAnimation:) forControlEvents:UIControlEventTouchDown];
    [wechatShareButton addTarget:self action:@selector(didClickButtonWithCancelAnimation:) forControlEvents:UIControlEventTouchCancel];
    [wechatShareButton addTarget:self action:@selector(didClickButtonWithCancelAnimation:) forControlEvents:UIControlEventTouchUpInside];
    [containerBgView addSubview:wechatShareButton];
    
    UIButton *wechatShareTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [wechatShareTitleButton setTitle:@"微信" forState:UIControlStateNormal];
    wechatShareTitleButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(26)];
    [wechatShareTitleButton addTarget:self action:@selector(didClickWechatShareButton) forControlEvents:UIControlEventTouchUpInside];
    [containerBgView addSubview:wechatShareTitleButton];
    
    UIButton *timelineShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [timelineShareButton setImage:[UIImage imageNamed:@"share_timeline_icon"] forState:UIControlStateNormal];
    [timelineShareButton addTarget:self action:@selector(didClickTimeLineShareButton) forControlEvents:UIControlEventTouchUpInside];
    [timelineShareButton addTarget:self action:@selector(didClickButtonWithAnimation:) forControlEvents:UIControlEventTouchDown];
    [timelineShareButton addTarget:self action:@selector(didClickButtonWithCancelAnimation:) forControlEvents:UIControlEventTouchCancel];
    [timelineShareButton addTarget:self action:@selector(didClickButtonWithCancelAnimation:) forControlEvents:UIControlEventTouchUpInside];
    [containerBgView addSubview:timelineShareButton];
    
    UIButton *timelineShareTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [timelineShareTitleButton setTitle:@"朋友圈" forState:UIControlStateNormal];
    timelineShareTitleButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(26)];
    [timelineShareTitleButton addTarget:self action:@selector(didClickTimeLineShareButton) forControlEvents:UIControlEventTouchUpInside];
    [containerBgView addSubview:timelineShareTitleButton];

    UIButton *qqZoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [qqZoneButton setImage:[UIImage imageNamed:@"share_qq_zone"] forState:UIControlStateNormal];
    [qqZoneButton addTarget:self action:@selector(didClickQQZoneShareButton) forControlEvents:UIControlEventTouchUpInside];
    [qqZoneButton addTarget:self action:@selector(didClickButtonWithAnimation:) forControlEvents:UIControlEventTouchDown];
    [qqZoneButton addTarget:self action:@selector(didClickButtonWithCancelAnimation:) forControlEvents:UIControlEventTouchCancel];
    [qqZoneButton addTarget:self action:@selector(didClickButtonWithCancelAnimation:) forControlEvents:UIControlEventTouchUpInside];
    [containerBgView addSubview:qqZoneButton];
    
    UIButton *qqZoneTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [qqZoneTitleButton setTitle:@"QQ空间" forState:UIControlStateNormal];
    qqZoneTitleButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(26)];
    [qqZoneTitleButton addTarget:self action:@selector(didClickQQZoneShareButton) forControlEvents:UIControlEventTouchUpInside];
    [containerBgView addSubview:qqZoneTitleButton];
    
    UIButton *qqShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [qqShareButton setImage:[UIImage imageNamed:@"share_qq_chat"] forState:UIControlStateNormal];
    [qqShareButton addTarget:self action:@selector(didClickQQChatShareButton) forControlEvents:UIControlEventTouchUpInside];
    [qqShareButton addTarget:self action:@selector(didClickButtonWithAnimation:) forControlEvents:UIControlEventTouchDown];
    [qqShareButton addTarget:self action:@selector(didClickButtonWithCancelAnimation:) forControlEvents:UIControlEventTouchCancel];
    [qqShareButton addTarget:self action:@selector(didClickButtonWithCancelAnimation:) forControlEvents:UIControlEventTouchUpInside];
    [containerBgView addSubview:qqShareButton];
    
    UIButton *qqShareTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [qqShareTitleButton setTitle:@"QQ" forState:UIControlStateNormal];
    qqShareTitleButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(26)];
    [qqShareTitleButton addTarget:self action:@selector(didClickQQChatShareButton) forControlEvents:UIControlEventTouchUpInside];
    [containerBgView addSubview:qqShareTitleButton];
    
    UIButton *concelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 343, SCREEN_WIDTH, 49)];
    [concelButton setTitle:@"取消" forState:UIControlStateNormal];
//    [concelButton addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadii:CGSizeMake(8.f, 8.f)];
    concelButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(30)];
    [concelButton setTitleColor:[UIColor colorWithString:COLORffffff] forState:UIControlStateNormal];
    [concelButton setBackgroundColor:[UIColor colorWithString:COLOR313132]];
    concelButton.alpha = 0.4;
    [concelButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithString:@"#212020"] size:CGSizeMake(SCREEN_WIDTH, concelButton.height)]   forState:UIControlStateHighlighted];
    [concelButton addTarget:self action:@selector(didClickConcelButton) forControlEvents:UIControlEventTouchUpInside];
    [containerBgView addSubview:concelButton];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handlePan:)];
    [containerBgView addGestureRecognizer:panGestureRecognizer];
    
    [containerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(adaptHeight1334(165 * 2));
    }];
    [blackBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(adaptHeight1334(165 * 2));
    }];
    [tapClearBgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(blackBgView.mas_top);
    }];
//    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(blackBgView.mas_top).mas_offset(adaptHeight1334(16));
//        make.centerX.equalTo(blackBgView.mas_centerX);
//    }];
    [wechatShareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(blackBgView.mas_top).mas_offset(adaptHeight1334(40));
        make.left.equalTo(blackBgView.mas_left).mas_offset(adaptWidth750(44));
        make.width.height.mas_equalTo(adaptWidth750(120));
    }];
    [wechatShareTitleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wechatShareButton.mas_bottom);
        make.centerX.equalTo(wechatShareButton.mas_centerX);
        make.width.equalTo(wechatShareButton.mas_width);
    }];
    [timelineShareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wechatShareButton.mas_top);
        make.left.equalTo(wechatShareButton.mas_right).mas_offset(adaptWidth750(66));
        make.width.height.equalTo(wechatShareButton.mas_width);
    }];
    [timelineShareTitleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timelineShareButton.mas_bottom);
        make.centerX.equalTo(timelineShareButton.mas_centerX);
        make.width.equalTo(timelineShareButton.mas_width);
    }];
    [qqZoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timelineShareButton.mas_top);
        make.left.equalTo(timelineShareButton.mas_right).mas_offset(adaptWidth750(66));
        make.width.height.equalTo(timelineShareButton.mas_width);
    }];
    [qqZoneTitleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qqZoneButton.mas_bottom);
        make.centerX.equalTo(qqZoneButton.mas_centerX);
        make.width.equalTo(qqZoneButton.mas_width);
    }];
    [qqShareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qqZoneButton.mas_top);
        make.left.equalTo(qqZoneButton.mas_right).mas_offset(adaptWidth750(66));
        make.width.height.equalTo(qqZoneButton.mas_width);
    }];
    [qqShareTitleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qqShareButton.mas_bottom);
        make.centerX.equalTo(qqShareButton.mas_centerX);
        make.width.equalTo(qqShareButton.mas_width);
    }];
    [concelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(blackBgView);
        make.bottom.equalTo(blackBgView.mas_bottom);
        make.width.equalTo(self.mas_width);
        make.height.mas_equalTo(49);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"new_h"];
    imageView.image = image;
    imageView.size = image.size;
    [wechatShareButton addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wechatShareButton.mas_rightMargin);
        make.top.equalTo(wechatShareButton.mas_top).offset(adaptWidth750(4));
    }];
    
}

- (void)didClickButtonWithAnimation:(UIButton*)sender{
    [UIView animateWithDuration:0.2 animations:^{
        sender.transform = CGAffineTransformScale(sender.transform, 1.1, 1.1);
        
    }];
}

- (void)didClickButtonWithCancelAnimation:(UIButton*)sender{
    [UIView animateWithDuration:0.2 animations:^{
        sender.transform = CGAffineTransformScale(sender.transform, 0.909, 0.909);
    }];
}
- (void)didClickWechatShareButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickWechatShareButton)]) {
        [self.delegate didClickWechatShareButton];
    }
}

- (void)didClickTimeLineShareButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickTimeLineShareButton)]) {
        [self.delegate didClickTimeLineShareButton];
    }
}

- (void)didClickQQZoneShareButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickQQZoneShareButton)]) {
        [self.delegate didClickQQZoneShareButton];
    }
}

- (void)didClickQQChatShareButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickQQChatShareButton)]) {
        [self.delegate didClickQQChatShareButton];
    }
}

- (void)didClickConcelButton {
    [UIView animateWithDuration:0.3 animations:^{
        self.toolView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    }completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.toolView];
    if (translation.y > 0) {
        self.toolView.frame = CGRectMake(0,SCREEN_HEIGHT - adaptHeight1334(165 * 2)  + translation.y, self.bounds.size.width, SCREEN_HEIGHT*0.7);
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [recognizer velocityInView:self];

        if (self.toolView.frame.origin.y > SCREEN_HEIGHT*0.8 || velocity.y > 900) {
            [self didClickConcelButton];
        } else {
            [UIView animateWithDuration:0.1f animations:^{
                self.toolView.frame = CGRectMake(0,SCREEN_HEIGHT - adaptHeight1334(165 * 2), self.bounds.size.width, adaptHeight1334(165 * 2));
            } completion:^(BOOL finished) {
                self.toolView.frame = CGRectMake(0,SCREEN_HEIGHT - adaptHeight1334(165 * 2), self.bounds.size.width, adaptHeight1334(165 * 2));
                
            }];
        }
    }
}

- (void)showShareView {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.toolView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);

    [UIView animateWithDuration:.2 animations:^{
        self.toolView.frame = CGRectMake(0, SCREEN_HEIGHT - adaptHeight1334(392), SCREEN_WIDTH, adaptWidth750(392));
    }completion:^(BOOL finished){
  
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

@end
