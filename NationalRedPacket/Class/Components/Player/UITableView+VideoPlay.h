//
//  UITableView+VideoPlay.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/1/12.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (VideoPlay)

@property (assign, nonatomic) BOOL isPlaying; // 正在播放
@property (assign, nonatomic) BOOL isVideoInterrupt;

/**
 * 视频自动播放
 */
- (void)handleScrollAutoPlayWithCompareCurrentCell:(BOOL)shouldCompareCurrentCell;

/**
 * 播放指定的indexPath的视频
 */
- (void)handleScrollWithCell:(id)suitableCell withShouldCompareCurrentCell:(BOOL)shouldCompareCurrentCell;;

/**
 * 视频播放进度
 *
 * @return 播放进度
 */
- (NSTimeInterval)currentTime;

/**
 * 视频暂停
 */
- (void)pause;

/**
 * 视频播放
 */
- (void)play;

/**
 * 视频播放时长
 *
 * @return 视频播放时长
 */
- (NSInteger)videoPlayDuration;

/**
 * 视频是否需要自动播放
 */
- (BOOL)videoShouldAutoPlay;

/**
 处理视频非自动播放情况下移除出屏幕时，视频暂停
 */
- (void)handleNonAutoPlay;

/**
 当前播放的视频的URL
 */
- (NSString *)currentVideoPlayURLString;

- (void)statVideoPreview;

@end
