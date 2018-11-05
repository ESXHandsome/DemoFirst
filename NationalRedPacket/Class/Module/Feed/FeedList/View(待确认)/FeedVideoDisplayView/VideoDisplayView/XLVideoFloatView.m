//
//  XLVideoFloatView.m
//  NationalRedPacket
//
//  Created by bulangguo on 2018/7/18.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLVideoFloatView.h"
#import "XLPlayer.h"
#import "XLPlayerManager.h"

@interface XLVideoFloatView () <XLPlayerDelegate>

///封面图
@property (strong, nonatomic) UIImageView             *coverImageView;
///关闭
@property (strong, nonatomic) UIButton                *closeButton;
///播放开关
@property (strong, nonatomic) CancleHighlightedButton *playSwitchButton;
///重播
@property (strong, nonatomic) UIButton                *replayButton;

@end

@implementation XLVideoFloatView

- (void)setupViews {
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.coverImageView];
    [self addSubview:self.closeButton];
    [self addSubview:self.playSwitchButton];
    [self addSubview:self.replayButton];
    [self addSubview:self.bottomProgressView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tapGesture];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(adaptWidth750(20));
    }];
    
    [self.playSwitchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.replayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.bottomProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(2);
    }];
}

#pragma mark - Public Methods

/**
 播放播放结束
 */
- (void)videoDidCompletedPlaying {
    
    self.replayButton.hidden = NO;
    self.playSwitchButton.hidden = YES;
    [self.viewModel statEndVideoFloat];
    
}

- (void)setFeedModel:(XLFeedModel *)feedModel {
    _feedModel = feedModel;
    
    self.replayButton.hidden = !feedModel.isVideoPlayToEndTime;
    self.playSwitchButton.hidden = feedModel.isVideoPlayToEndTime;
    
    //封面
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:feedModel.picture.firstObject]];
    
}

- (void)setConfigModel:(XLPlayerConfigModel *)configModel {
    _configModel = configModel;
    
    //进度条
    NSDictionary *videoProgressInfo = [XLPlayerManager.shared progressForVideoURL:configModel.videoURL];
    double progress = [videoProgressInfo[XLVideoProgress] doubleValue];
    self.bottomProgressView.progress = progress;
    
}

- (void)resetViewControl {
    
    self.clickCloseButton = NO;
    
    if (self.feedModel.isVideoPlayToEndTime) {
        self.replayButton.hidden = NO;
        self.playSwitchButton.hidden = YES;
        self.bottomProgressView.progress = 0;
        return;
    }
    
    if (XLPlayer.sharedInstance.isPlaying) {
        self.playSwitchButton.selected = YES;
        self.playSwitchButton.hidden = YES;
        self.replayButton.hidden = YES;
    } else {
        self.playSwitchButton.selected = NO;
        self.playSwitchButton.hidden = NO;
    }
}

#pragma mark - Event

- (void)closeButtonDidClick:(UIButton *)sender {
    self.hidden = YES;
    
    self.playSwitchButton.selected = NO;
    self.clickCloseButton = XLPlayer.sharedInstance.isPlaying;
    
    [XLPlayer.sharedInstance pause];
    
    [StatServiceApi statEvent:VIDEO_FLOAT_CLOSE_CLICK];
}

// 播放/暂停按钮  点击
- (void)playSwitchButtonDidClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        if (![XLPlayer.sharedInstance.videoURL isEqual: self.configModel.videoURL]) {
            [XLPlayer.sharedInstance playWithConfigModel:self.configModel];
            [XLPlayer.sharedInstance changePlayerLayerForShowView:self.coverImageView];
        } else {
            [XLPlayer.sharedInstance resume];
        }
        self.playSwitchButton.hidden = YES;
        [StatServiceApi statEvent:VIDEO_FLOAT_PAUSE_CLICK model:self.feedModel otherString:@"start"];
        [self.viewModel statBeginVideoFloat];
    } else {
        self.playSwitchButton.hidden = NO;
        [XLPlayer.sharedInstance pause];
        [StatServiceApi statEvent:VIDEO_FLOAT_PAUSE_CLICK model:self.feedModel otherString:@"pause"];
        [self.viewModel statEndVideoFloat];
    }
    
    XLPlayerManager.shared.currentPlayingCell.videoDisPlayView.isManuallyPause = !sender.selected;    
}

// 重播
- (void)replayButtonDidClick:(UIButton *)sender {
    
    sender.hidden = YES;
    self.bottomProgressView.progress = 0;
    self.playSwitchButton.selected = YES;
    
    [XLPlayer.sharedInstance seekToTime:0];
    [XLPlayer.sharedInstance resume];
    
    self.feedModel.isVideoPlayToEndTime = NO;
    
    [StatServiceApi statEvent:VIDEO_FLOAT_REPLAY_CLICK model:self.feedModel];
    
    [self.viewModel statBeginVideoFloat];
    
}

//view点击
- (void)tapAction {
    
    if (!self.replayButton.hidden) {
        return;
    }
    [self playSwitchButtonDidClick:self.playSwitchButton];
}

#pragma mark - lazy loading

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        self.coverImageView = [UIImageView new];
        self.coverImageView.backgroundColor = [UIColor colorWithString:COLOREDECED];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverImageView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeButton setBackgroundImage:[UIImage imageNamed:@"float_close"] forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(closeButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (CancleHighlightedButton *)playSwitchButton {
    if (!_playSwitchButton) {
        self.playSwitchButton = [CancleHighlightedButton buttonWithType:UIButtonTypeCustom];
        [self.playSwitchButton setBackgroundImage:[UIImage imageNamed:@"float_play"] forState:UIControlStateNormal];
        [self.playSwitchButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [self.playSwitchButton addTarget:self action:@selector(playSwitchButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playSwitchButton;
}

- (UIButton *)replayButton {
    if (!_replayButton) {
        self.replayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.replayButton setBackgroundImage:[UIImage imageNamed:@"float_replay"] forState:UIControlStateNormal];
        self.replayButton.hidden = YES;
        [self.replayButton addTarget:self action:@selector(replayButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _replayButton;
}

- (UIProgressView *)bottomProgressView {
    if (!_bottomProgressView) {
        self.bottomProgressView = [UIProgressView new];
        self.bottomProgressView.progress = 0.5;
        self.bottomProgressView.progressTintColor = [UIColor colorWithString:COLORFE6969];
        self.bottomProgressView.trackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    }
    return _bottomProgressView;
}

@end
