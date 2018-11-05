//
//  XLPlayerManager.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/5/9.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoDisplayView.h"
#import "BaseVideoCell.h"
#import "XLPlayerConfigModel.h"

#define XLVideoProgress @"Progress"
#define XLVideoDuration @"Duration"

@interface XLPlayerManager : NSObject

/// 信息流列表视频静音
@property (assign, nonatomic) BOOL feedVideoMute;
@property (assign, nonatomic) BOOL videoWifiShouldAutoPlay;
@property (assign, nonatomic) BOOL video4GShouldAutoPlay;
@property (strong, nonatomic) VideoDisplayView *currentDisplayView;
@property (strong, nonatomic) BaseVideoCell *currentPlayingCell;
@property (strong, nonatomic) NSMutableDictionary *videoProgressDictionary;

+ (instancetype)shared;

- (void)updateVideoProgress:(NSTimeInterval)progress
                   duration:(CGFloat)duration
               withVideoURL:(NSURL *)videoURL;

- (NSDictionary *)progressForVideoURL:(NSURL *)videoURL;

@end
