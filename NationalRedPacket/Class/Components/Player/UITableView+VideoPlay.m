//
//  UITableView+VideoPlay.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/1/12.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "UITableView+VideoPlay.h"
#import "BaseVideoCell.h"
#import "GifPlayManager.h"
#import "XLPlayerConfigModel.h"
#import "XLPlayer.h"
#import "XLPlayerManager.h"
#import "XLLoginManager.h"

@implementation UITableView (VideoPlay)

#pragma mark -
#pragma mark Public Method

/**
 * 视频自动播放
 */
- (void)handleScrollAutoPlayWithCompareCurrentCell:(BOOL)shouldCompareCurrentCell {
//    // 云控自动播放
//    if (!XLLoginManager.shared.userInfo.autoPlay) {
//        return;
//    }
    
    BaseVideoCell *cell = [self findTheBestToPlayVideoCell];
    if (!cell) {
        [XLPlayerManager.shared.currentPlayingCell.videoDisPlayView setShareViewHidden:YES];
        XLPlayerManager.shared.currentPlayingCell.model.isVideoPlayToEndTime = NO;
        
        if (XLPlayerManager.shared.currentPlayingCell.videoDisPlayView.isManuallyPause) {
            XLPlayerManager.shared.currentPlayingCell.videoDisPlayView.isManuallyPause = NO;
            [self statVideoPreview];
        }
        if (self.isPlaying) {
            [self pause];
            [self statVideoPreview];
        }
        return;
    }
    if (cell.videoDisPlayView.isManuallyPause && [cell.model.itemId isEqualToString:XLPlayerManager.shared.currentPlayingCell.model.itemId]) {
        return;
    }
    if (shouldCompareCurrentCell && [self isPlaying] && ([cell.model.itemId isEqualToString:XLPlayerManager.shared.currentPlayingCell.model.itemId]) && [cell.model.url isEqualToString:XLPlayer.sharedInstance.videoURL.absoluteString]) {
        [XLPlayerManager.shared.currentPlayingCell.videoDisPlayView setVideoDisplayViewHidden:NO];
        return;
    }
    [self videoPlayWithCell:cell shouldCompareCurrentCell:shouldCompareCurrentCell];
}

/**
 * 播放指定的cell的视频
 */
- (void)handleScrollWithCell:(BaseVideoCell *)cell withShouldCompareCurrentCell:(BOOL)shouldCompareCurrentCell {
    // 云控自动播放
//    if (!XLLoginManager.shared.userInfo.autoPlay) {
//        return;
//    }
    
    if (shouldCompareCurrentCell && ([cell.model.itemId isEqualToString:XLPlayerManager.shared.currentPlayingCell.model.itemId])) {
        [self play];
        return;
    }
    [self videoPlayWithCell:cell shouldCompareCurrentCell:shouldCompareCurrentCell];
}

- (void)handleNonAutoPlay {
    BaseVideoCell *cell = [self findTheBestToPlayVideoCell];
    if (![cell.model.itemId isEqualToString:XLPlayerManager.shared.currentPlayingCell.model.itemId]) {
        if (self.isPlaying) {
            [self pause];
        } else {
            [self pause];
            [XLPlayerManager.shared.currentPlayingCell.videoDisPlayView setShareViewHidden:YES];
            XLPlayerManager.shared.currentPlayingCell.model.isVideoPlayToEndTime = NO;
        }
    }
}

/**
 * 视频播放进度
 *
 * @return 播放进度
 */
- (NSTimeInterval)currentTime {
    return [[XLPlayer sharedInstance] currentTime];
}

/**
 视频暂停
 */
- (void)pause {
    XLPlayerManager.shared.currentPlayingCell.model.currentTime = self.currentTime;
    [XLPlayerManager.shared.currentPlayingCell.videoDisPlayView videoPause];
    [XLPlayerManager.shared.currentPlayingCell.videoDisPlayView setVideoDisplayViewHidden:YES];
    [XLPlayerManager.shared.currentPlayingCell.videoDisPlayView setPauseButtonHidden:NO];

    /**GifPlayManager不应该直接在这里操作*/
    [[GifPlayManager sharedManager] rebootGifCell];
}

/**
 视频播放
 */
- (void)play {
    [XLPlayerManager.shared.currentPlayingCell.videoDisPlayView videoResume];
}

/**
 视频是否正在播放
 
 @return 视频播放状态
 */
- (BOOL)isPlaying {
    return [XLPlayer.sharedInstance isPlaying];
}

/**
 * 视频播放时长
 *
 * @return 视频播放时长
 */
- (NSInteger)videoPlayDuration {
    return [XLPlayer.sharedInstance duration];
}

- (NSString *)currentVideoPlayURLString {
    return XLPlayer.sharedInstance.videoURL.absoluteString;
}

#pragma mark -
#pragma mark UIScrollView Delegate

/**
 * 视频是否自动播放
 *
 * @return 自动播放
 */
- (BOOL)videoShouldAutoPlay {
    if (![NetworkManager.shared.netWorkTypeString isEqualToString:XLAlertNetworkWIFI]) {
        return XLPlayerManager.shared.video4GShouldAutoPlay;
    }
    return XLPlayerManager.shared.videoWifiShouldAutoPlay;
}

#pragma mark -
#pragma mark Private Method

- (void)videoPlayWithCell:(BaseVideoCell *)suitableCell
 shouldCompareCurrentCell:(BOOL)shouldCompareCurrentCell {
    if (suitableCell) {
        XLPlayerConfigModel *configModel = [self getConfiModelFromFeedCell:suitableCell shouldCache:YES];
        [self videoPlayOnCell:suitableCell configModel:configModel];
    }
}

/**
 * 视频播放
 */
- (void)videoPlayOnCell:(BaseVideoCell *)cell configModel:(XLPlayerConfigModel *)configModel {
    [self prepareCell:cell];
    [cell.videoDisPlayView playVideoWithConfigModel:configModel];
//    [XLPlayer.sharedInstance setMute:XLPlayerManager.shared.feedVideoMute];
}

/**
 组件播放器数据模型
 */
- (XLPlayerConfigModel *)getConfiModelFromFeedCell:(BaseVideoCell *)cell shouldCache:(BOOL)shouldCache {
    XLFeedModel *model = cell.model;
    
    XLPlayerConfigModel *configModel = [XLPlayerConfigModel new];
    configModel.videoURL = [NSURL URLWithString:model.url];
    configModel.shouldCache = shouldCache;
    configModel.displayViewFatherView = cell.videoDisPlayViewContainerView;
    configModel.fullScreenShouldRotate = model.type.integerValue == XLFeedCellVideoHorizonalWithAuthorType;
    // configModel.coverImageURL = [NSURL URLWithString:model.picture.firstObject];
    configModel.videoWidth = model.width;
    configModel.videoHeight = model.height;
    
    return configModel;
}

- (void)prepareCell:(BaseVideoCell *)cell {
    // 暂停正在播放的视频
    if (self.isPlaying) {
        [self pause];
    }
    
    // 视频预览时长打点
    [self trackingDataWithCurrentCell:XLPlayerManager.shared.currentPlayingCell withWillShowCell:cell];
    
    if (![cell.model.itemId isEqualToString:XLPlayerManager.shared.currentPlayingCell.model.itemId]) {
        [XLPlayerManager.shared.currentPlayingCell.videoDisPlayView setShareViewHidden:YES];
        cell.model.isVideoPlayToEndTime = NO;
    }
    
    [XLPlayerManager.shared.currentPlayingCell.videoDisPlayView setPauseButtonHidden:YES];

    // 正在播放的cell替换为新的cell
    XLPlayerManager.shared.currentPlayingCell = cell;
    
    [[GifPlayManager sharedManager] pauseGifCell];
}

/**
 * 查找即将播放视频cell
 *
 * @return 即将播放视频cell
 */
- (id)findTheBestToPlayVideoCell {
    NSArray *visibleCells = [self visibleCells];
    if (visibleCells.count == 0) return nil;
    
    BaseVideoCell *suitableCell;
    
    for (int i = 0; i < visibleCells.count; i++) {
        if ([[visibleCells objectAtIndex:i] isKindOfClass:[BaseVideoCell class]]) {
            BaseVideoCell *tempCell = visibleCells[i];
    
            // 顶部视频显示小于cell一半，不符合播放条件
            if (self.contentOffset.y - tempCell.frame.origin.y >  tempCell.frame.size.height/2) {
                continue;
            }
            // 底部视频显示小于cell一半，不符合播放条件
            if (SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT - (tempCell.frame.origin.y - self.contentOffset.y) < tempCell.frame.size.height/2) {
                continue;
            }
            if ([XLPlayerManager.shared.currentPlayingCell.model.itemId isEqualToString:tempCell.model.itemId]) {
                return tempCell;
            }
            if (!suitableCell) {
                suitableCell = tempCell;
            }
        }
    }
    return suitableCell;
}

- (void)trackingDataWithCurrentCell:(BaseVideoCell *)currentCell
                   withWillShowCell:(BaseVideoCell *)suitableCell {
    
    if ([currentCell.model.itemId isEqualToString:suitableCell.model.itemId] || currentCell == nil) {
        return;
    }
    [self statVideoPreview];
}

- (void)statVideoPreview {
    
    NSString *playTotalTime = [NSString stringWithFormat:@"%ld",(long)[XLPlayer.sharedInstance playTotalTime]];
    XLFeedModel *model = ((BaseVideoCell *)XLPlayerManager.shared.currentPlayingCell).model;
    
    if ([[model.itemId stringByAppendingString:playTotalTime] isEqualToString:StatServiceApi.sharedService.lastVideoStat]) {
        return;  //避免同一个点重复打，暂时这么处理
    }
    
    [StatServiceApi statEvent:VIDEO_PREVIEW_DURATION
                        model:model
                 timeDuration:playTotalTime];
    StatServiceApi.sharedService.lastVideoStat = [model.itemId stringByAppendingString:playTotalTime];
}

#pragma mark -
#pragma mark Setters and Getters

- (void)setCurrentPlayingCell:(BaseVideoCell *)currentPlayingCell{
    objc_setAssociatedObject(self, @selector(currentPlayingCell), currentPlayingCell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setIsPlaying:(BOOL)isPlaying {
    objc_setAssociatedObject(self, @selector(isPlaying), @(isPlaying), OBJC_ASSOCIATION_ASSIGN);
}

- (void)setIsVideoInterrupt:(BOOL)isVideoInterrupt {
    objc_setAssociatedObject(self, @selector(isVideoInterrupt), @(isVideoInterrupt), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isVideoInterrupt {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end
