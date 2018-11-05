//
//  XLPlayerManager.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/5/9.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLPlayerManager.h"

#define UserDefault [NSUserDefaults standardUserDefaults]
#define FeedVideoMute @"FeedVideoMute"
#define IsOldUser @"IsFirstLogin"

static XLPlayerManager *sharedInstance;

@implementation XLPlayerManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.videoProgressDictionary = [NSMutableDictionary new];
        
        BOOL isOldUser = [UserDefault boolForKey:IsOldUser];
        if (!isOldUser) {
            _feedVideoMute = YES;
            [UserDefault setBool:YES forKey:IsOldUser];
            [UserDefault setBool:_feedVideoMute forKey:FeedVideoMute];
            [UserDefault synchronize];
        } else {
            _feedVideoMute = [UserDefault boolForKey:FeedVideoMute];
        }
        if (![UserDefault boolForKey:XLUserChangeAutoPlaySetting]) {
            [UserDefault setBool:XLLoginManager.shared.userInfo.autoPlay forKey:XLWifiVideoAutoPlay];
        }

        _video4GShouldAutoPlay = [UserDefault boolForKey:XL4GVideoAutoPlay];
        _videoWifiShouldAutoPlay = [UserDefault boolForKey:XLWifiVideoAutoPlay];

    }
    return self;
}

- (void)setFeedVideoMute:(BOOL)feedVideoMute {
    if (feedVideoMute != _feedVideoMute) {
        [UserDefault setBool:feedVideoMute forKey:FeedVideoMute];
        [UserDefault synchronize];
    }
    _feedVideoMute = feedVideoMute;
}

- (void)setVideoWifiShouldAutoPlay:(BOOL)videoWifiShouldAutoPlay {
    if (videoWifiShouldAutoPlay != _videoWifiShouldAutoPlay) {
        [UserDefault setBool:videoWifiShouldAutoPlay forKey:XLWifiVideoAutoPlay];
        [UserDefault setBool:YES forKey:XLUserChangeAutoPlaySetting];
        [UserDefault synchronize];
    }
    _videoWifiShouldAutoPlay = videoWifiShouldAutoPlay;
}

- (void)setVideo4GShouldAutoPlay:(BOOL)video4GShouldAutoPlay {
    if (video4GShouldAutoPlay != _video4GShouldAutoPlay) {
        [UserDefault setBool:video4GShouldAutoPlay forKey:XL4GVideoAutoPlay];
        [UserDefault synchronize];
    }
    _video4GShouldAutoPlay = video4GShouldAutoPlay;
}

- (void)setCurrentPlayingCell:(BaseVideoCell *)currentPlayingCell {
    _currentPlayingCell = currentPlayingCell;
}

- (void)updateVideoProgress:(NSTimeInterval)progress
                   duration:(CGFloat)duration
               withVideoURL:(NSURL *)videoURL {
    if (videoURL) {
        [self.videoProgressDictionary setObject:@{
                                                  XLVideoProgress:@(progress).stringValue,
                                                  XLVideoDuration:@(duration).stringValue
                                                  } forKey:videoURL];
    }
}

- (NSDictionary *)progressForVideoURL:(NSURL *)videoURL {
    if (!videoURL) {
        return 0;
    }
    return [self.videoProgressDictionary objectForKey:videoURL];
}

@end
