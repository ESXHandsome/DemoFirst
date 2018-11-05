//
//  XLPlayer.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/4/10.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLPlayerConfigModel.h"

@class XLFeedListVideoShowViewDelegate,XLFeedDetailVideoShowViewDelegate;

typedef NS_ENUM(NSInteger, XLPlayerState) {
    XLPlayerStateWaiting,
    XLPlayerStatePlaying,
    XLPlayerStatePaused,
    XLPlayerStateStopped,
    XLPlayerStateBuffering,
    XLPlayerStateError
};

@protocol XLPlayerDelegate <NSObject>

@optional

/**
 视频播放进度更新
 */
- (void)playerProgressDidUpdate:(CGFloat)progress;

/**
 视频缓冲进度更新
 */
- (void)playerCacheProgressDidUpdate:(CGFloat)progress;

/**
 视频当前播放时间更新
 */
- (void)playerCurrentTimeDidUpdate:(CGFloat)currentTime;

/**
 视频播放状态改变
 */
- (void)playerStateDidUpdate:(XLPlayerState)state;

/**
 视频循环播放次数更新
 */
- (void)playerRepeatPlayCount:(NSInteger)repeatPlayCount;

/**
 播放完成
 */
- (void)playerPlayToEndTime;

/**
 视频播放出错
 */
- (void)playerDidCompleteWithError:(NSError *)error;

/**
 点击视频进行视频播放时，信息流需要判断一下，点击的视频与当前播放是否是同一个视频，是则续播，不是则切换播放的视频
 如果实现此代理方法，点击视频进行视频播放时，需要此代理方法实现
 如果没有实现此代理方法，则不判断直接播放
 */
- (void)playerCustomResumeWithPlayerModel:(XLPlayerConfigModel *)model ;

@end

@interface XLPlayer : NSObject

@property (assign, nonatomic) XLPlayerState state;
@property (assign, nonatomic) CGFloat progress;
@property (assign, nonatomic) CGFloat duration;
@property (assign, nonatomic) CGFloat currentPlayTime;
@property (assign, nonatomic) CGFloat cacheProgress;
@property (assign, nonatomic) NSInteger playTotalTime;
@property (strong, nonatomic) NSURL *videoURL;
@property (assign, nonatomic) BOOL mute;
@property (weak  , nonatomic) id<XLPlayerDelegate> delegate;
//@property (copy, nonatomic) AVLayerVideoGravity videoGravity;

+ (instancetype)sharedInstance;

/**
 视频播放
 */
- (void)playWithConfigModel:(XLPlayerConfigModel *)configModel;

/**
 播放
 */
- (void)resume;

/**
 暂停
 */
- (void)pause;

/**
 播放状态
 */
- (BOOL)isPlaying;

/**
 跳到某个时间进度
 */
//- (void)seekToT ime:(double)seconds;

/**
 清除缓存
 */
+ (BOOL)clearCache;

/**
 视频时长
 */
- (NSTimeInterval)duration;

/**
 当前播放时间
 */
- (NSTimeInterval)currentTime;

/**
 全屏
 */
- (void)resetPlayerLayerFrame:(CGRect)frame;

/**
 视频进度调整
 */
- (void)seekToTime:(double)seconds;

- (void)configVideoShow:(XLPlayerConfigModel *)configModel;

- (void)changePlayerLayerForShowView:(UIView *)view;

@end
