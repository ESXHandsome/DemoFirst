//
//  VideoDisplayView.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/5/7.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "VideoDisplayView.h"
#import "XLPlayerConfigModel.h"
#import "XLPlayerManager.h"
#import "FeedDetailViewModel.h"
#import "FeedVideoHorizonalCell.h"
#import "FeedVideoVerticalCell.h"
#import "NSString+NumberAdapt.h"
#import "XLVideoShareView.h"
#import "XLShareAlertViewModel.h"

@interface VideoDisplayView ()<XLPlayerDelegate, UIGestureRecognizerDelegate, XLViewPlayToEndOperationDelegate>
/// 封面图
@property (strong, nonatomic) UIImageView *coverImageView;
/// 显示视频画面，XLPlayer 把 Layer 加到这个 View 上面
@property (strong, nonatomic) UIView *videoShowView;
/// 全屏黑色背景图
@property (strong, nonatomic) UIImageView *fullScreenBlackBgImageView;
/// 视频遮罩
@property (strong, nonatomic) UIImageView *videoBottomMaskImageView;
/// 全屏关闭按钮
@property (strong, nonatomic) UIButton *topCloseButton;

/// 暂停按钮
@property (strong, nonatomic) UIButton *pauseButton;
/// 暂停按钮
@property (strong, nonatomic) UIButton *pauseTapButton;
/// 浏览次数
@property (strong, nonatomic) UILabel *browseLabel;
/// 视频时长
@property (strong, nonatomic) UILabel *videoDurationLabel;
/// 视频播放时间
@property (strong, nonatomic) UILabel *videoCurrentPlayTimeLabel;
/// 视频剩余播放
@property (strong, nonatomic) UILabel *videoRemainPlayTimeLabel;
/// 视频进度拖动杆
@property (strong, nonatomic) UISlider *progressSlider;
/// 视频加载进度提示窗
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
/// 视频播放完成分享视图
@property (strong, nonatomic) XLVideoShareView  *videoShareView;

@property (strong, nonatomic) UIProgressView *rateProgressView;
@property (strong, nonatomic) UIProgressView *cacheProgressView;
@property (strong, nonatomic) UIButton *fullScreenButton;

@property (assign, nonatomic) BOOL isFullScreen;
@property (assign, nonatomic) UIInterfaceOrientation currentOrientation;
@property (assign, nonatomic) NSInteger videoPlayRetryCount;
@property (assign, nonatomic) BOOL isSliderSelected;

@property (strong, nonatomic) FeedDetailViewModel *viewModel;
@property (strong, nonatomic) XLShareAlertViewModel *shareAlertViewModel;

@end

@implementation VideoDisplayView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self setupViewsContraint];
        self.currentOrientation = UIInterfaceOrientationPortrait;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapVideoShowViewAction)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applicationWillWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.coverImageView];
    [self addSubview:self.fullScreenBlackBgImageView];
    [self addSubview:self.videoShowView];
    [self addSubview:self.videoBottomMaskImageView];
    [self addSubview:self.cacheProgressView];
    [self addSubview:self.rateProgressView];
    [self addSubview:self.pauseButton];
    [self addSubview:self.browseLabel];
    [self addSubview:self.videoDurationLabel];
    [self addSubview:self.activityIndicatorView];
    
    [self addSubview:self.adjustProgressContainerView];
    [self addSubview:self.topCloseButton];
    
    [self.adjustProgressContainerView addSubview:self.pauseTapButton];
    [self.adjustProgressContainerView addSubview:self.videoCurrentPlayTimeLabel];
    [self.adjustProgressContainerView addSubview:self.progressSlider];
    [self.adjustProgressContainerView addSubview:self.videoRemainPlayTimeLabel];
    [self.adjustProgressContainerView addSubview:self.fullScreenButton];
    
    [self addSubview:self.videoShareView];
}

- (void)setupViewsContraint {
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    [self.fullScreenBlackBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    [self.videoShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    [self.videoBottomMaskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(adaptHeight1334(250));
    }];
    [self.topCloseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).mas_offset(adaptWidth750(32));
    }];
    [self.rateProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(adaptHeight1334(4));
    }];
    [self.cacheProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.rateProgressView);
    }];
    [self.pauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.width.mas_equalTo(adaptWidth750(88));
        make.height.mas_equalTo(adaptWidth750(88));
    }];
    [self.browseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).mas_offset(adaptWidth750(32));
        make.bottom.equalTo(self.mas_bottom).mas_offset(adaptHeight1334(-26));
    }];
    [self.videoDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).mas_offset(adaptWidth750(-32));
        make.bottom.equalTo(self.mas_bottom).mas_offset(adaptHeight1334(-26));
        make.width.mas_equalTo(adaptWidth750(70));
    }];
    [self.fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).mas_offset(adaptWidth750(-32));
        make.bottom.equalTo(self.mas_bottom).mas_offset(adaptHeight1334(-32));
    }];
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.width.height.mas_equalTo(adaptWidth750(80));
        make.width.mas_equalTo(adaptWidth750(70));
    }];
    [self.adjustProgressContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.right.equalTo(self);
    }];
    [self.pauseTapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.adjustProgressContainerView);
        make.width.mas_equalTo(adaptWidth750(88));
        make.height.mas_equalTo(adaptWidth750(88));
    }];
    [self.videoCurrentPlayTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.adjustProgressContainerView).mas_offset(adaptWidth750(32));
        make.bottom.equalTo(self.adjustProgressContainerView).mas_offset(adaptHeight1334(-24));
    }];
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.videoCurrentPlayTimeLabel);
        make.left.equalTo(self.videoCurrentPlayTimeLabel.mas_right).mas_offset(adaptWidth750(16));
        make.right.equalTo(self.videoRemainPlayTimeLabel.mas_left).mas_offset(adaptWidth750(-16));
    }];
    [self.videoRemainPlayTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fullScreenButton.mas_left).mas_offset(adaptWidth750(-16));
        make.centerY.equalTo(self.videoCurrentPlayTimeLabel);
    }];
    [self.fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.adjustProgressContainerView).mas_offset(adaptWidth750(-32));
        make.width.height.mas_equalTo(adaptWidth750(40));
        make.centerY.equalTo(self.videoCurrentPlayTimeLabel);
    }];
    [self.videoShareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [XLPlayer.sharedInstance resetPlayerLayerFrame:XLPlayerManager.shared.currentDisplayView.bounds];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - UIApplicationDelgate

/**
 APP将要进入后台
 */
- (void)applicationWillResignActive {
    if (!(self.width == SCREEN_WIDTH && self.height == SCREEN_HEIGHT)) {
        return;
    }
    
    [self endStatPage];
}

/**
 APP将要进入前台
 */
- (void)applicationWillWillEnterForeground {
    if (!(self.width == SCREEN_WIDTH && self.height == SCREEN_HEIGHT)) {
        return;
    }
    if (!self.isManuallyPause) {
        [self videoResume];
    }
    
    [self startStatPage];
}

#pragma mark - Life Style (全屏显示和关闭  全屏相当于一个界面，需要跟踪统计)

- (void)viewWillAppear:(BOOL)animated {
    
    BOOL tempIsPlay = self.isPlaying;
    
    NSArray *vcArray = [[StatServiceApi sharedService] screenDisplayViewController];
    for (UIViewController *vc in vcArray) {
        if ([UIView isDisplayedInScreenForView:vc.view]) {
            [vc viewWillDisappear:NO];
            [vc viewDidDisappear:NO];
            [self resumePlay:tempIsPlay];
        }
    }
    
    [StatServiceApi sharedService].currentVCStr = @"FeedVideoFullScreenViewController";
    
    [self startStatPage];
}

- (void)viewDidDisAppear:(BOOL)animated {
    
    [self endStatPage];
    
    [StatServiceApi sharedService].lastVCStr = @"FeedVideoFullScreenViewController";
    
    NSArray *vcArray = [[StatServiceApi sharedService] screenDisplayViewController];
    for (UIViewController *vc in vcArray) {
        [vc viewWillAppear:YES];
    }
}

- (void)resumePlay:(BOOL)tempIsPlay {
    
    if ([self.playerConfigModel.videoURL isEqual:XLPlayer.sharedInstance.videoURL]) {
        [self videoResume];
        if (!tempIsPlay) {
            [self videoPause];
        }
    } else {
        //页面消失的时候视频暂停了，调用开始播放
        [self playVideoWithConfigModel:self.playerConfigModel];
        [self videoPause];
    }
}

- (void)startStatPage {
    self.viewModel = [FeedDetailViewModel new];
    self.viewModel.feed = self.feedModel;
    [self.viewModel resetArrayAndKey];
    if (self.isPlaying) {
        [self.viewModel statBeginContent];
    }
}

- (void)endStatPage {
    [self.viewModel statEndContent];
    [StatServiceApi statEvent:VIDEO_MAX_SCREEN_DURATION model:self.feedModel timeDuration:[self.viewModel statEndVideoContentDuration]];
    //避免全屏进入时Feed流预览统计定时器仍在计时，退出全屏时，预览时间累加错误问题，这里重置为0
    XLPlayer.sharedInstance.playTotalTime = 0;
}

#pragma mark - Event Response

/**
 全屏按钮点击事件
 */
- (void)didClickFullScreenButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    
    [StatServiceApi statEvent:VIDEO_MAX_SCREEN_CLCK model:self.feedModel otherString:button.selected ?  @"max" : @"min"];
    
    [self configFullOrHalfScreenAction];
}

/**
 暂停按钮点击事件
 */
- (void)didClickPauseButtonAction:(UIButton *)button {
    [self didTapVideoShowViewAction];
}

/**
 暂停按钮点击事件
 */
- (void)didClickPauseTapButtonAction:(UIButton *)button {
    if (XLPlayer.sharedInstance.isPlaying) {
        [self videoPause];
        self.pauseTapButton.selected = NO;
        [self hiddeVideoPauseControls:YES];
        [StatServiceApi statEvent:VIDEO_PAUSE_CLICK model:self.feedModel otherString:@"pause"];
    } else {
        self.pauseTapButton.selected = YES;
        [self videoResume];
        [StatServiceApi statEvent:VIDEO_PAUSE_CLICK model:self.feedModel otherString:@"start"];
    }
    [self updateVideoManuallyPauseState:!XLPlayer.sharedInstance.isPlaying];
    [self autoHiddenAdjustProgressContainerView];
}

/**
 视频画面单击暂停/播放事件
 */
- (void)didTapVideoShowViewAction {
    // 当前播放视频属于当前视图
    if ([XLPlayer.sharedInstance.videoURL isEqual: self.playerConfigModel.videoURL] && [XLPlayerManager.shared.currentDisplayView isEqual:self]) {
       
        // 视频正在播放,显示/隐藏 进度调整视图
        if (XLPlayer.sharedInstance.isPlaying) {
            [self progressContainerViewHidden:!self.adjustProgressContainerView.hidden];
            self.rateProgressView.hidden = !self.rateProgressView.hidden;
            self.cacheProgressView.hidden = !self.cacheProgressView.hidden;
            [self autoHiddenAdjustProgressContainerView];
            self.pauseTapButton.selected = YES;
            return;
        }
        // 视频暂停时，进度调整视图隐藏状态，播放视频
        if (self.adjustProgressContainerView.hidden && !self.pauseButton.hidden) {
            [self playVideoWithConfigModel:self.playerConfigModel];
            return;
        }
        // 视频暂停时，进度调整视图隐藏状态，播放视频
        if (self.adjustProgressContainerView.hidden && self.pauseButton.hidden) {
            [self progressContainerViewHidden:!self.adjustProgressContainerView.hidden];
            return;
        }
        // 视频暂停时，进度调整视图显示状态，将进度调整视频隐藏
        [self progressContainerViewHidden:!self.adjustProgressContainerView.hidden];
        self.rateProgressView.hidden = !self.rateProgressView.hidden;
        self.cacheProgressView.hidden = !self.cacheProgressView.hidden;
        
    } else { // 当前播放视频不属于当前视图
        if (self.isFeedVideo) { // 如果是信息流视频，更新播放当前播放的CELL
            XLPlayerManager.shared.currentPlayingCell.videoDisPlayView.isManuallyPause = YES;
            if ([self.superview.superview.superview isKindOfClass:FeedVideoHorizonalCell.class] || [self.superview.superview.superview isKindOfClass:FeedVideoVerticalCell.class]) {
                XLPlayerManager.shared.currentPlayingCell = (BaseVideoCell *)self.superview.superview.superview;
            }
        }
        if ([XLPlayer.sharedInstance.videoURL isEqual: self.playerConfigModel.videoURL]) {
            [self videoPlay];
        } else {
            [self playVideoWithConfigModel:self.playerConfigModel];
        }
        [self updateVideoManuallyPauseState:!XLPlayer.sharedInstance.isPlaying];
    }
}

/**
 顶部关闭按钮
 */
- (void)didClickCloseButtonAction {
    [self didClickFullScreenButtonAction:self.fullScreenButton];
}

/**
 进度条拖拽事件
 */
- (void)progressSliderValueChangedAction:(UISlider *)slider {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenAdjustProgressContainerView) object:nil];
}

/**
 进度条按下事件
 */
- (void)progressSliderTouchDownAction:(UISlider *)slider {
    self.isSliderSelected = YES;
    [XLPlayer.sharedInstance pause];
    
    [StatServiceApi statEvent:VIDEO_PROGRESS_BAR_CLICK model:self.feedModel];
}

/**
 进度条按下事件
 */
- (void)progressSliderTouchUpAction:(UISlider *)slider {
    
    [self autoHiddenAdjustProgressContainerView];
    [XLPlayer.sharedInstance seekToTime:slider.value * XLPlayer.sharedInstance.duration];
  
    self.isSliderSelected = NO;
}

/**
 自动隐藏进度调整视图
 */
- (void)autoHiddenAdjustProgressContainerView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenAdjustProgressContainerView) object:nil];
    [self performSelector:@selector(hiddenAdjustProgressContainerView) withObject:nil afterDelay:2];
}

/**
 隐藏进度调整视图
 */
- (void)hiddenAdjustProgressContainerView {
    if (XLPlayer.sharedInstance.isPlaying && [XLPlayer.sharedInstance.videoURL isEqual: self.playerConfigModel.videoURL]) {
        [self progressContainerViewHidden:YES];
        self.rateProgressView.hidden = NO;
        self.cacheProgressView.hidden = NO;
    }
}

- (void)progressContainerViewHidden:(BOOL)hidden {
    self.adjustProgressContainerView.hidden = hidden;
    if (self.delegate && [self.delegate respondsToSelector:@selector(videDisplayView:progressViewHidden:)]) {
        [self.delegate videDisplayView:self progressViewHidden:hidden];
    }
}

/**
 浏览次数、暂停按钮、视频时长控件是否隐藏
 */
- (void)hiddeVideoPauseControls:(BOOL)hidden {
    if (!hidden && !self.adjustProgressContainerView.hidden) {
        return;
    }
    self.browseLabel.hidden = hidden;
    self.videoDurationLabel.hidden = hidden;
    self.pauseButton.hidden = hidden;
    self.pauseButton.selected = NO;
}

#pragma mark - VideoShareView Delegate

- (void)didClickOperationButton:(XLViewPlayToEndOperationType)type {
    if (type == XLViewPlayToEndOperationTypeReplay) {
        [XLPlayer.sharedInstance seekToTime:0];
        self.videoShareView.hidden = YES;
        self.rateProgressView.hidden = NO;
        self.cacheProgressView.hidden = NO;
        
        if ([XLPlayer.sharedInstance.videoURL isEqual: self.playerConfigModel.videoURL]) {
            [self videoPlay];
        } else {
            [self playVideoWithConfigModel:self.playerConfigModel];
        }
        
        [StatServiceApi statEvent:VIDEO_REPLAY_CLICK model:self.feedModel];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickReplayButtonWithVideoDisplayView:)]) {
            [self.delegate didClickReplayButtonWithVideoDisplayView:self];
        }
    } else if (type == XLViewPlayToEndOperationTypeWechat) {
        self.shareAlertViewModel.shareFeedModel = [self configShareModel];
        [self.shareAlertViewModel chooseToOpen:@"微信"];
    } else if (type == XLViewPlayToEndOperationTypeTimeLine) {
        self.shareAlertViewModel.shareFeedModel = [self configShareModel];
        [self.shareAlertViewModel chooseToOpen:@"朋友圈"];
    } else if (type == XLViewPlayToEndOperationTypeQQZone) {
        self.shareAlertViewModel.shareFeedModel = [self configShareModel];
        [self.shareAlertViewModel chooseToOpen:@"QQ空间"];
    } else if (type == XLViewPlayToEndOperationTypeQQChat) {
        self.shareAlertViewModel.shareFeedModel = [self configShareModel];
        [self.shareAlertViewModel chooseToOpen:@"QQ"];
    }
}

- (id<XLShareModelDelegate>)configShareModel {
    XLShareFeedModel *model = [[XLShareFeedModel alloc] init];
    /**信息流分享*/
    self.feedModel.shareCompleteURL = [XLFeedModel completeShareURL:self.feedModel withRefrence:@"*FEED*"];
    model.title = self.feedModel.title;
    model.imageUrl = self.feedModel.picture.firstObject;
    model.feedUrl = self.feedModel.shareCompleteURL;
    model.feedType = self.feedModel.type;
    model.originModel = self.feedModel;
    model.position = @"1";
    return model;
}

- (void)videoShareViewDidClickCloseButton {
    [self configFullOrHalfScreenAction];
}

#pragma mark - XLPlayer Delegate

- (void)playerStateDidUpdate:(XLPlayerState)state {
    if (state == XLPlayerStatePlaying) {
        self.videoPlayRetryCount = 0;
        [self.activityIndicatorView stopAnimating];
    } else if (state == XLPlayerStateBuffering) {
        [self.activityIndicatorView startAnimating];
    } else if (state == XLPlayerStateError) {
        self.playerConfigModel.shouldCache = NO;
        if (self.videoPlayRetryCount < 2) {
            self.videoPlayRetryCount ++;
            if (XLPlayer.sharedInstance.isPlaying && [UIView isDisplayedInScreenForView:self.playerConfigModel.videoShowView] && [self.playerConfigModel.videoURL isEqual:XLPlayer.sharedInstance.videoURL]) {
                [XLPlayer.sharedInstance playWithConfigModel:self.playerConfigModel];
            }
        }
    }
}

/**
 视频播放进度更新
 */
- (void)playerProgressDidUpdate:(CGFloat)progress {
    if (self.isFeedVideo) {
        if (progress == 0 && XLPlayerManager.shared.currentPlayingCell.videoDisPlayView.rateProgressView.progress != 1) {
            return;
        }
        [XLPlayerManager.shared.currentPlayingCell.videoDisPlayView.rateProgressView setProgress:progress animated:NO];
    } else {
        if (progress == 0 && self.rateProgressView.progress != 1) {
            return;
        }
        [self.rateProgressView setProgress:progress animated:!(progress == 0)];
    }
    if (!self.isSliderSelected) {
        self.progressSlider.value = progress;
    }
    self.videoCurrentPlayTimeLabel.text = [self countdownWithTimeInterval:self.videoCurrentPlayTime];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(videDisplayView:playerProgressDidUpdate:)]) {
        [self.delegate videDisplayView:self playerProgressDidUpdate:progress];
    }
}

- (NSString *)countdownWithTimeInterval:(long long)timeInterval {
    NSInteger min = timeInterval / 60;
    NSInteger second = timeInterval % 60;
    return  [NSString stringWithFormat:@"%02ld:%02ld",(long)min, (long)second];
}

/**
 视频缓冲进度更新
 */
- (void)playerCacheProgressDidUpdate:(CGFloat)progress {
    if (self.isFeedVideo) {
        [XLPlayerManager.shared.currentPlayingCell.videoDisPlayView.cacheProgressView setProgress:progress animated:NO];
    } else {
        [self.cacheProgressView setProgress:progress animated:NO];
    }
}

- (void)playerPlayToEndTime {
    [self setShareViewHidden:NO];
    
    self.feedModel.isVideoPlayToEndTime = YES;
   
    [self.videoShareView hiddeTopCloseButton:!self.isFullScreen];
    [self progressContainerViewHidden:YES];
    
    if (!self.isFullScreen && [[UIViewController currentViewController] isKindOfClass:[RTContainerController class]] && ![[(RTContainerController *)[UIViewController currentViewController] contentViewController] isMemberOfClass:NSClassFromString(@"FeedVideoDetailViewController")]) {
        NSString *playTotalTime = [NSString stringWithFormat:@"%ld",(long)[XLPlayer.sharedInstance playTotalTime]];
        [StatServiceApi statEvent:VIDEO_PREVIEW_DURATION
                            model:self.feedModel
                     timeDuration:playTotalTime];
        XLPlayer.sharedInstance.playTotalTime = 0;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoDisplayView:didPlayCompletedVideo:)]  ) {
        [self.delegate videoDisplayView:self didPlayCompletedVideo:self.playerConfigModel];
    }
    
    //重置视频进度
    [XLPlayerManager.shared updateVideoProgress:0
                                       duration:XLPlayer.sharedInstance.duration withVideoURL:XLPlayer.sharedInstance.videoURL];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"]) {
        return NO;
    }
    return YES;
}

#pragma mark - Public

- (void)setPlayerConfigModel:(XLPlayerConfigModel *)playerConfigModel {
    _playerConfigModel = playerConfigModel;
    _playerConfigModel.videoShowView = self.videoShowView;
    
    NSDictionary *videoProgressInfo = [XLPlayerManager.shared progressForVideoURL:self.playerConfigModel.videoURL];
    double progress = [videoProgressInfo[XLVideoProgress] doubleValue];
    self.rateProgressView.progress = progress;
    self.progressSlider.value = progress;
    self.videoCurrentPlayTimeLabel.text = [self countdownWithTimeInterval:[videoProgressInfo[XLVideoDuration] doubleValue]];;
    self.videoRemainPlayTimeLabel.text = self.feedModel.duration;

    self.browseLabel.text = [NSString stringWithFormat:@"%@次播放", [NSString numberAdaptWithInteger:self.feedModel.watchNum]];
    self.videoDurationLabel.text = self.feedModel.duration;

    [self setShareViewHidden:!self.feedModel.isVideoPlayToEndTime];
    [self hiddeVideoPauseControls:self.feedModel.isVideoPlayToEndTime];
    
}

/**
 视频播放
 */
- (void)playVideoWithConfigModel:(XLPlayerConfigModel *)configModel {
    self.playerConfigModel = configModel;
    if (!self.isShareViewIsHidden) {
        return;
    }
    [self videoPlay];
}

/**
 视频暂停
 */
- (void)videoPause {
    [XLPlayer.sharedInstance pause];
  
    [self hiddeVideoPauseControls:NO];
    [self.activityIndicatorView stopAnimating];
    
    // 更新视频进度
    [XLPlayerManager.shared updateVideoProgress:XLPlayer.sharedInstance.progress
                                       duration:XLPlayer.sharedInstance.duration withVideoURL:XLPlayer.sharedInstance.videoURL];
}

/**
 视频播放
 */
- (void)videoResume {
    //    if (self.isFeedVideo) {
    //        [XLPlayer.sharedInstance setMute:XLPlayerManager.shared.feedVideoMute];
    //    }
    self.videoShowView.hidden = NO;
    self.feedModel.isVideoPlayToEndTime = NO;

    [self hiddeVideoPauseControls:YES];
    [XLPlayer.sharedInstance resume];
    
    if (XLPlayer.sharedInstance.state == XLPlayerStateBuffering) {
        [self.activityIndicatorView startAnimating];
    }
    
}

/**
 设置“画面显示视图”不隐藏
 */
- (void)setVideoDisplayViewHidden:(BOOL)hidden {
    self.videoShowView.hidden = hidden;
    
    if (hidden == NO) {
        BOOL isExistAVPlayer = NO;
        for (AVPlayerLayer *layer in self.feedVideoShowView.layer.sublayers) {
            if ([layer isKindOfClass:[AVPlayerLayer class]]) {
                isExistAVPlayer = YES;
                break;
            }
        }
        if (isExistAVPlayer == NO) {
            [XLPlayer.sharedInstance configVideoShow:self.playerConfigModel];
        }
    }
}

/**
 重置静音按钮显示
 */
- (void)configMuteButtonDisplay {
    // self.muteButton.selected = !XLPlayerManager.shared.feedVideoMute;
}

/**
 配置视频封面图片
 */
- (void)configCoverImageViewWithURL:(NSURL *)imageURL {
    [self.coverImageView sd_setImageWithURL:imageURL];
}

/**
 设置静音按钮隐藏
 */
- (void)setMuteButtonUnavailable {
    // self.muteButton.hidden = YES;
    // [XLPlayer.sharedInstance setMute:NO];
}

/**
 设置全屏按钮隐藏与显示
 */
- (void)setFullScreenButtonHidden:(BOOL)hidden {
    self.fullScreenButton.hidden = hidden;
}

- (void)setPauseButtonHidden:(BOOL)hidden {
    [self hiddeVideoPauseControls:hidden];
    self.videoShareView.hidden = YES;
    [self progressContainerViewHidden:YES];
}

- (CGFloat)videoCurrentPlayTime {
    return XLPlayer.sharedInstance.currentPlayTime;
}

- (BOOL)isPlaying {
    return XLPlayer.sharedInstance.isPlaying;
}

- (void)resetVideoShow {
    if (self.isPlaying) {
        [self hiddeVideoPauseControls:YES];
    }
    self.videoShowView.hidden = NO;
    [XLPlayer.sharedInstance configVideoShow:self.playerConfigModel];
}

- (void)resetViewControl {
    
    if (self.feedModel.isVideoPlayToEndTime) {
        self.videoShareView.hidden = NO;
        return;
    }
    
    if (XLPlayer.sharedInstance.isPlaying) {
        self.videoShareView.hidden = YES;
        self.pauseButton.selected = YES;
        [self hiddeVideoPauseControls:YES];
    } else {
        self.pauseButton.selected = NO;
        [self hiddeVideoPauseControls:NO];
    }
    
}

/**
 设置分享视图显示
 */
- (void)setShareViewHidden:(BOOL)hidden {
    self.videoShareView.hidden = hidden;
}

#pragma mark - Private

- (void)videoPlay {
    //    if (self.isFeedVideo) {
    //        [XLPlayer.sharedInstance setMute:XLPlayerManager.shared.feedVideoMute];
    //    }
    self.feedModel.isVideoPlayToEndTime = NO;

    [self configVideoChildControls];
    XLPlayer.sharedInstance.delegate = self;
    
    NSDictionary *videoInfo = [XLPlayerManager.shared progressForVideoURL:self.playerConfigModel.videoURL];
    double progress = [videoInfo[XLVideoProgress] doubleValue] * [videoInfo[XLVideoDuration] doubleValue];
    
    self.playerConfigModel.seekToTime = progress;
    
    [XLPlayer.sharedInstance playWithConfigModel:self.playerConfigModel];
}

- (void)configVideoChildControls {
    self.videoShowView.hidden = NO;
    [self hiddeVideoPauseControls:YES];
    
    if (XLPlayerManager.shared.currentDisplayView && ![XLPlayerManager.shared.currentDisplayView isEqual:self]) {
        [XLPlayerManager.shared.currentDisplayView setPauseButtonHidden:NO];
    }
    XLPlayerManager.shared.currentDisplayView = self;
}

- (void)configFullOrHalfScreenAction {
    if (self.isFullScreen) {
        [self concelFullScreen];
        self.fullScreenButton.selected = NO;
        [self viewDidDisAppear:YES];
        
    } else {
        [self viewWillAppear:YES];
        if (self.playerConfigModel.fullScreenShouldRotate) {
            [self horizonVideoFullScreen];
        } else {
            [self verticalVideoFullScreen];
        }
    }
    self.isFullScreen = !self.isFullScreen;
    [self configFullScreenVideo:self.isFullScreen];
}

- (void)updateVideoManuallyPauseState:(BOOL)pause {
    self.isManuallyPause = pause;
    XLPlayerManager.shared.currentPlayingCell.videoDisPlayView.isManuallyPause = pause;
}

/**
 设置全屏/非全屏控件显示
 */
- (void)configFullScreenVideo:(BOOL)isFullScreen {
    // self.muteButton.hidden = self.playerConfigModel.configNoMuteButton ?: isFullScreen;
    self.topCloseButton.hidden = !isFullScreen;
    [self.videoShareView hiddeTopCloseButton:!isFullScreen];
    self.fullScreenBlackBgImageView.hidden = !isFullScreen;
    
    // BOOL mute = self.isFeedVideo ? XLPlayerManager.shared.feedVideoMute : NO;
    // [XLPlayer.sharedInstance setMute:isFullScreen ? NO : mute];
    
    [[UIApplication sharedApplication] setStatusBarHidden:self.isFullScreen];
}

/**
 竖屏全屏
 */
- (void)verticalVideoFullScreen {
    [self removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(SCREEN_HEIGHT));
        make.center.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    self.currentOrientation = UIInterfaceOrientationPortrait;
    [self startTransformAnimation:UIInterfaceOrientationPortrait];
}

/**
 横屏全屏
 */
- (void)horizonVideoFullScreen {
    if (self.currentOrientation == UIInterfaceOrientationLandscapeRight) {
        return;
    }
    [self removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SCREEN_HEIGHT));
        make.height.equalTo(@(SCREEN_WIDTH));
        make.center.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    self.currentOrientation = UIInterfaceOrientationLandscapeRight;
    [self startTransformAnimation:UIInterfaceOrientationLandscapeRight];
}

/**
 设置竖屏的约束
 */
- (void)concelFullScreen {
    [self.videoShareView hiddeTopCloseButton:YES];
    [self addPlayerToFatherView:self.playerConfigModel.displayViewFatherView];
    self.currentOrientation = UIInterfaceOrientationPortrait;
    [self startTransformAnimation:UIInterfaceOrientationPortrait];
}

/**
 player添加到fatherView上
 */
- (void)addPlayerToFatherView:(UIView *)view {
    // 这里应该添加判断，因为view有可能为空，当view为空时[view addSubview:self]会crash
    if (view) {
        [self removeFromSuperview];
        [view addSubview:self];
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsZero);
        }];
    }
}

/**
 全屏动画
 */
- (void)startTransformAnimation:(UIInterfaceOrientation)orientation {
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
    // 获取旋转状态条需要的时间:
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    // 给你的播放视频的view视图设置旋转
    self.transform = CGAffineTransformIdentity;
    self.transform = [self getTransformRotationAngle:orientation];
    // 开始旋转
    [UIView commitAnimations];
}

/**
 根据要进行旋转的方向来计算旋转的角度
 
 @return 角度
 */
- (CGAffineTransform)getTransformRotationAngle:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}
- (void)updateCoverImageWidth:(CGFloat)width height:(CGFloat)height {
    [self.coverImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
}

#pragma mark - Custom Accessor

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [UIImageView new];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.image = [UIImage imageNamed:@"default_image_bg"];
    }
    return _coverImageView;
}

- (UIImageView *)fullScreenBlackBgImageView {
    if (!_fullScreenBlackBgImageView) {
        _fullScreenBlackBgImageView = [UIImageView new];
        _fullScreenBlackBgImageView.hidden = YES;
        _fullScreenBlackBgImageView.backgroundColor = [UIColor blackColor];
    }
    return _fullScreenBlackBgImageView;
}

- (UIView *)videoShowView {
    if (!_videoShowView) {
        _videoShowView = [UIView new];
    }
    return _videoShowView;
}

- (UILabel *)browseLabel {
    if (!_browseLabel) {
        _browseLabel = [UILabel new];
        _browseLabel.font = [UIFont systemFontOfSize:adaptFontSize(24)];
        _browseLabel.textColor = [UIColor colorWithString:COLORffffff];
    }
    return _browseLabel;
}

- (UILabel *)videoDurationLabel {
    if (!_videoDurationLabel) {
        _videoDurationLabel = [UILabel new];
        _videoDurationLabel.font = [UIFont systemFontOfSize:adaptFontSize(24)];
        _videoDurationLabel.textColor = [UIColor colorWithString:COLORffffff];
    }
    return _videoDurationLabel;
}

- (UIView *)feedVideoShowView {
    return self.videoShowView;
}

- (UIButton *)topCloseButton {
    if (!_topCloseButton) {
        _topCloseButton = [UIButton new];
        _topCloseButton.hidden = YES;
        [_topCloseButton setImage:[UIImage imageNamed:@"fullscreen_close_icon"] forState:UIControlStateNormal];
        [_topCloseButton addTarget:self action:@selector(didClickCloseButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topCloseButton;
}

- (UIProgressView *)cacheProgressView {
    if (!_cacheProgressView) {
        _cacheProgressView = [UIProgressView new];
        _cacheProgressView.progress = 0;
        _cacheProgressView.progressTintColor = [UIColor colorWithRed:255/255.0
                                                               green:255/255.0
                                                                blue:255/255.0
                                                               alpha:0.7];
        _cacheProgressView.trackTintColor = [UIColor colorWithRed:255/255.0
                                                            green:255/255.0
                                                             blue:255/255.0
                                                            alpha:0.3];
        
    }
    return _cacheProgressView;
}

- (UIProgressView *)rateProgressView {
    if (!_rateProgressView) {
        _rateProgressView = [UIProgressView new];
        _rateProgressView.progress = 0;
        _rateProgressView.progressTintColor = [UIColor colorWithString:COLORFE6969];
        _rateProgressView.trackTintColor = [UIColor clearColor];
    }
    return _rateProgressView;
}

- (UISlider *)progressSlider {
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc]init];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"video_progress_thumb"]
                              forState:UIControlStateNormal];
        //设置轨道的图片
        [_progressSlider setMaximumTrackImage:[UIImage imageNamed:@"video_progress_unplay"] forState:UIControlStateNormal];
        [_progressSlider setMinimumTrackImage:[UIImage imageNamed:@"video_progress_ played"] forState:UIControlStateNormal];
        self.progressSlider.value = 0.0;//指定初始值
        // 进度条的拖拽事件
        [_progressSlider addTarget:self action:@selector(progressSliderValueChangedAction:)
                  forControlEvents:UIControlEventValueChanged];
        [_progressSlider addTarget:self action:@selector(progressSliderTouchDownAction:) forControlEvents:UIControlEventTouchDown];        [_progressSlider addTarget:self action:@selector(progressSliderTouchUpAction:) forControlEvents:UIControlEventTouchUpInside];

        [_progressSlider addTarget:self action:@selector(progressSliderTouchUpAction:) forControlEvents:UIControlEventTouchUpOutside];
        [_progressSlider addTarget:self action:@selector(progressSliderTouchUpAction:) forControlEvents:UIControlEventTouchCancel];

        _progressSlider.backgroundColor = [UIColor clearColor];
    }
    return _progressSlider;
}

- (UILabel *)videoCurrentPlayTimeLabel {
    if (!_videoCurrentPlayTimeLabel) {
        _videoCurrentPlayTimeLabel = [UILabel new];
        _videoCurrentPlayTimeLabel.font = [UIFont systemFontOfSize:adaptFontSize(24)];
        _videoCurrentPlayTimeLabel.textColor = [UIColor colorWithString:COLORffffff];
    }
    return _videoCurrentPlayTimeLabel;
}

- (UILabel *)videoRemainPlayTimeLabel {
    if (!_videoRemainPlayTimeLabel) {
        _videoRemainPlayTimeLabel = [UILabel new];
        _videoRemainPlayTimeLabel.font = [UIFont systemFontOfSize:adaptFontSize(24)];
        _videoRemainPlayTimeLabel.textColor = [UIColor colorWithString:COLORffffff];
    }
    return _videoRemainPlayTimeLabel;
}

- (UIButton *)pauseButton {
    if (!_pauseButton) {
        _pauseButton = [UIButton new];
        [_pauseButton setImage:[UIImage imageNamed:@"video_pause_icon"] forState:UIControlStateNormal];
        [_pauseButton addTarget:self action:@selector(didClickPauseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pauseButton;
}

- (UIButton *)pauseTapButton {
    if (!_pauseTapButton) {
        _pauseTapButton = [UIButton new];
        [_pauseTapButton setImage:[UIImage imageNamed:@"video_pause_icon"] forState:UIControlStateNormal];
        [_pauseTapButton setImage:[UIImage imageNamed:@"video_resume_icon"] forState:UIControlStateSelected];
        [_pauseTapButton addTarget:self action:@selector(didClickPauseTapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pauseTapButton;
}

- (UIButton *)fullScreenButton {
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton new];
        [_fullScreenButton setBackgroundImage:[UIImage imageNamed:@"video_full"] forState:UIControlStateNormal];
        [_fullScreenButton setBackgroundImage:[UIImage imageNamed:@"video_concel_full"] forState:UIControlStateSelected];
        [_fullScreenButton addTarget:self action:@selector(didClickFullScreenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenButton;
}

- (UIView *)adjustProgressContainerView {
    if (!_adjustProgressContainerView) {
        _adjustProgressContainerView = [UIView new];
        _adjustProgressContainerView.hidden = YES;
    }
    return _adjustProgressContainerView;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicatorView.backgroundColor = [UIColor clearColor];
        [_activityIndicatorView stopAnimating]; // 结束旋转
        [_activityIndicatorView setHidesWhenStopped:YES]; //当旋转结束时隐藏
    }
    return _activityIndicatorView;
}

- (XLVideoShareView *)videoShareView {
    if (!_videoShareView) {
        _videoShareView = [XLVideoShareView new];
        _videoShareView.hidden = YES;
        _videoShareView.delegate = self;
    }
    return _videoShareView;
}

- (XLShareAlertViewModel *)shareAlertViewModel {
    if (!_shareAlertViewModel) {
        _shareAlertViewModel = [[XLShareAlertViewModel alloc] init];
    }
    return _shareAlertViewModel;
}

- (UIImageView *)videoBottomMaskImageView {
    if (!_videoBottomMaskImageView) {
        _videoBottomMaskImageView = [UIImageView new];
        _videoBottomMaskImageView.image = [UIImage imageNamed:@"home_video_mask"];
    }
    return _videoBottomMaskImageView;
}

- (BOOL)isShareViewIsHidden {
    return self.videoShareView.isHidden;
}

@end
