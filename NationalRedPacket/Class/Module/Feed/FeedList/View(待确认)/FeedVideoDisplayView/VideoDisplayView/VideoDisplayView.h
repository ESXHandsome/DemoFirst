//
//  VideoDisplayView.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/5/7.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPlayerConfigModel.h"
#import "XLPlayer.h"

@class VideoDisplayView;

@protocol VideoDisplayViewDelegate <NSObject>

@optional
/// 视频手动暂停与播放回调
- (void)videoDisplayView:(VideoDisplayView *)videoDisplayView
   videoDidManuallyPause:(BOOL)isManuallyPause;

/**
 视频播放结束

 @param videoView videoView
 @param playerModel playerModel
 */
- (void)videoDisplayView:(VideoDisplayView *)videoView didPlayCompletedVideo:(XLPlayerConfigModel *)playerModel;

/**
 视频重播点击

 @param videoView videoView
 */
- (void)didClickReplayButtonWithVideoDisplayView:(VideoDisplayView *)videoView;

/**
 视频进度
 
 @param videoView videoView
 */
- (void)videDisplayView:(VideoDisplayView *)videoView playerProgressDidUpdate:(CGFloat)progress;

/**
 视频进度显示与隐藏回调
  */
- (void)videDisplayView:(VideoDisplayView *)displayView progressViewHidden:(BOOL)hidden;

@end

@interface VideoDisplayView : UIView <XLPlayerDelegate>

/// 视频画面展示视图
@property (strong, nonatomic, readonly) UIView *feedVideoShowView;
/// 视频加载提示
@property (strong, nonatomic) UIView *adjustProgressContainerView;
/// 视频手动暂停
@property (assign, nonatomic) BOOL isManuallyPause;
/// 分享视图正在展示
@property (assign, nonatomic) BOOL isShareViewIsHidden;

/// 视频是否正在播放
@property (assign, nonatomic) BOOL isPlaying;
/// 视频是否是信息流预览视频（如果是信息流视频，手动播放时，需要更新正在播放cell，正在播放的cell是通过找VideoDisplayView的superview）
@property (assign, nonatomic) BOOL isFeedVideo;

@property (strong, nonatomic) XLPlayerConfigModel *playerConfigModel;

@property (strong, nonatomic) XLFeedModel *feedModel;

@property (weak, nonatomic) id<VideoDisplayViewDelegate> delegate;

/**
 视频播放
 */
- (void)playVideoWithConfigModel:(XLPlayerConfigModel *)model;

/**
 配置播放器封面图
  */
- (void)configCoverImageViewWithURL:(NSURL *)imageURL;

/**
 视频暂停
 */
- (void)videoPause;

/**
 视频播放
 */
- (void)videoResume;

/**
 重置静音按钮显示
 */
- (void)configMuteButtonDisplay;

/**
 设置“画面显示视图”隐藏/显示
 */
- (void)setVideoDisplayViewHidden:(BOOL)hidden;

/**
 设置静音按钮不可用
 */
- (void)setMuteButtonUnavailable;

/**
 设置全屏按钮隐藏与显示
 */
- (void)setFullScreenButtonHidden:(BOOL)hidden;

/**
 设置暂停按钮显示
 */
- (void)setPauseButtonHidden:(BOOL)hidden;

/**
 设置分享视图显示
 */
- (void)setShareViewHidden:(BOOL)hidden;

/**
 获取当前视频播放时间
 */
- (CGFloat)videoCurrentPlayTime;

- (void)resetVideoShow;

- (void)resetViewControl;

- (void)updateCoverImageWidth:(CGFloat)width height:(CGFloat)width;

@end
