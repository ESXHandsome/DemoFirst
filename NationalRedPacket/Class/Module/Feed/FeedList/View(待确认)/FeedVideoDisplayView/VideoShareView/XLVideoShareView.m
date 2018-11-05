//
//  XLVideoShareView.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/7/5.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLVideoShareView.h"
#import "UIButton+XLEdgeInsetsButton.h"

@interface XLVideoShareView ()

/// 全屏关闭按钮
@property (strong, nonatomic) UIButton *topCloseButton;

@end

@implementation XLVideoShareView

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    
    UIView *alphaView = [UIView new];
    alphaView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    [self addSubview:alphaView];

    UIButton *shareGesture = [UIButton new];
    shareGesture.backgroundColor = [UIColor clearColor];
    [self addSubview:shareGesture];
    
    UIButton *shareContainerView = [UIButton new];
    shareContainerView.backgroundColor = [UIColor clearColor];
    [self addSubview:shareContainerView];

    [self addSubview:self.topCloseButton];
    
    // 重播
    UIButton *replayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [replayButton addTarget:self action:@selector(didClickReplayShareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [replayButton setImage:[UIImage imageNamed:@"video_replay_icon"] forState:UIControlStateNormal];
    [replayButton setTitleColor:[UIColor colorWithString:COLORffffff] forState:UIControlStateNormal];
    [shareContainerView addSubview:replayButton];
    
    UILabel *replayLabel = [UILabel new];
    replayLabel.text = @"重播";
    replayLabel.textColor = [UIColor colorWithString:COLORffffff];
    replayLabel.font = [UIFont systemFontOfSize:adaptFontSize(26)];
    [shareContainerView addSubview:replayLabel];

    // 分割线
    UIImageView *seprateLineImageView = [UIImageView new];
    seprateLineImageView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.8];
    [shareContainerView addSubview:seprateLineImageView];
    
    // 微信分享
    UIButton *wechatShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [wechatShareButton addTarget:self action:@selector(didClickWechatShareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [wechatShareButton setImage:[UIImage imageNamed:@"video_share_wecaht"] forState:UIControlStateNormal];
    [shareContainerView addSubview:wechatShareButton];
    
    UILabel *wechatLabel = [UILabel new];
    wechatLabel.text = @"微信";
    wechatLabel.textColor = [UIColor colorWithString:COLORffffff];
    wechatLabel.font = [UIFont systemFontOfSize:adaptFontSize(26)];
    [shareContainerView addSubview:wechatLabel];
    
    UIImageView *recommendImageView = [UIImageView new];
    recommendImageView.image = [UIImage imageNamed:@"share_new"];
    [shareContainerView addSubview:recommendImageView];
    
    // 朋友圈分享
    UIButton *timelineShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [timelineShareButton addTarget:self action:@selector(didClickTimelineShareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    timelineShareButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(26)];
    [timelineShareButton setImage:[UIImage imageNamed:@"video_share_timeline"] forState:UIControlStateNormal];
    [timelineShareButton setTitleColor:[UIColor colorWithString:COLORffffff] forState:UIControlStateNormal];
    [shareContainerView addSubview:timelineShareButton];
    
    UILabel *timelineLabel = [UILabel new];
    timelineLabel.text = @"朋友圈";
    timelineLabel.textColor = [UIColor colorWithString:COLORffffff];
    timelineLabel.font = [UIFont systemFontOfSize:adaptFontSize(26)];
    [shareContainerView addSubview:timelineLabel];
    
    // QQ空间分享
    UIButton *qqzoneShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [qqzoneShareButton addTarget:self action:@selector(didClickQQzoneShareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [qqzoneShareButton setImage:[UIImage imageNamed:@"video_share_qqzone"] forState:UIControlStateNormal];
    [shareContainerView addSubview:qqzoneShareButton];

    UILabel *qqzoneLabel = [UILabel new];
    qqzoneLabel.text = @"QQ空间";
    qqzoneLabel.textColor = [UIColor colorWithString:COLORffffff];
    qqzoneLabel.font = [UIFont systemFontOfSize:adaptFontSize(26)];
    [shareContainerView addSubview:qqzoneLabel];
    
    // QQ分享
    UIButton *qqShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [qqShareButton addTarget:self action:@selector(didClickQQShareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [qqShareButton setImage:[UIImage imageNamed:@"video_share_qq"] forState:UIControlStateNormal];
    [qqShareButton setTitleColor:[UIColor colorWithString:COLORffffff] forState:UIControlStateNormal];
    [shareContainerView addSubview:qqShareButton];
    
    UILabel *qqshareLabel = [UILabel new];
    qqshareLabel.text = @"QQ";
    qqshareLabel.textColor = [UIColor colorWithString:COLORffffff];
    qqshareLabel.font = [UIFont systemFontOfSize:adaptFontSize(26)];
    [shareContainerView addSubview:qqshareLabel];
    
    [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    [shareContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(100);
    }];
    [shareGesture mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    [replayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shareContainerView).mas_offset(adaptWidth750(46*2));
        make.width.mas_equalTo(adaptWidth750(64));
        make.height.mas_equalTo(adaptWidth750(64));
        make.centerY.equalTo(shareContainerView).mas_offset(adaptHeight1334(-30));
    }];
    [seprateLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(replayButton.mas_right).mas_offset(adaptWidth750(40));
        make.width.mas_equalTo(adaptWidth750(4));
        make.height.mas_equalTo(adaptWidth750(28));
        make.centerY.equalTo(replayButton);
    }];
    [wechatShareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(seprateLineImageView.mas_right).mas_offset(adaptWidth750(32));
        make.width.height.mas_equalTo(adaptWidth750(72));
        make.centerY.equalTo(shareContainerView).mas_offset(adaptHeight1334(-34));
    }];
    [recommendImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wechatShareButton.mas_top);
        make.centerX.equalTo(wechatShareButton.mas_right);
    }];
    [timelineShareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wechatShareButton.mas_right).mas_offset(adaptWidth750(48));
        make.width.height.mas_equalTo(adaptWidth750(72));
        make.centerY.equalTo(shareContainerView).mas_offset(adaptHeight1334(-34));
    }];
    [qqzoneShareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timelineShareButton.mas_right).mas_offset(adaptWidth750(48));
        make.width.height.mas_equalTo(adaptWidth750(72));
        make.centerY.equalTo(shareContainerView).mas_offset(adaptHeight1334(-34));
    }];
    [qqShareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qqzoneShareButton.mas_right).mas_offset(adaptWidth750(48));
        make.width.height.mas_equalTo(adaptWidth750(72));
        make.centerY.equalTo(shareContainerView).mas_offset(adaptHeight1334(-34));
    }];
    ///// 
    [replayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(replayButton);
        make.top.equalTo(replayButton.mas_bottom).mas_offset(adaptHeight1334(36));
    }];
    [wechatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wechatShareButton);
        make.top.equalTo(replayLabel);
    }];
    [timelineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(timelineShareButton);
        make.top.equalTo(replayLabel);
    }];
    [qqzoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(qqzoneShareButton);
        make.top.equalTo(replayLabel);
    }];
    [qqshareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(qqShareButton);
        make.top.equalTo(replayLabel);
    }];
    
    [self.topCloseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).mas_offset(adaptWidth750(32));
    }];
}

#pragma mark - Public Method

- (void)hiddeTopCloseButton:(BOOL)hidden {
    self.topCloseButton.hidden = hidden;
}

#pragma mark - Event Response

- (void)didClickReplayShareButtonAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOperationButton:)]) {
        [self.delegate didClickOperationButton:XLViewPlayToEndOperationTypeReplay];
    }
}

- (void)didClickWechatShareButtonAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOperationButton:)]) {
        [self.delegate didClickOperationButton:XLViewPlayToEndOperationTypeWechat];
    }
}

- (void)didClickTimelineShareButtonAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOperationButton:)]) {
        [self.delegate didClickOperationButton:XLViewPlayToEndOperationTypeTimeLine];
    }
}

- (void)didClickQQzoneShareButtonAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOperationButton:)]) {
        [self.delegate didClickOperationButton:XLViewPlayToEndOperationTypeQQZone];
    }
}

- (void)didClickQQShareButtonAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOperationButton:)]) {
        [self.delegate didClickOperationButton:XLViewPlayToEndOperationTypeQQChat];
    }
}

- (void)didClickCloseButtonAction {
    self.topCloseButton.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoShareViewDidClickCloseButton)]) {
        [self.delegate videoShareViewDidClickCloseButton];
    }
}

#pragma mark - Custom Accessor

- (UIButton *)topCloseButton {
    if (!_topCloseButton) {
        _topCloseButton = [UIButton new];
        _topCloseButton.hidden = YES;
        [_topCloseButton setImage:[UIImage imageNamed:@"fullscreen_close_icon"] forState:UIControlStateNormal];
        [_topCloseButton addTarget:self action:@selector(didClickCloseButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topCloseButton;
}

@end
