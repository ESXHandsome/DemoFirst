//
//  VideoPlayerTool.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/1/11.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "VideoPlayerTool.h"
#import "VideoControlsContainerView.h"
#import "VideoDownloadManager.h"
#import "StatServiceApi.h"

// 播放器的几种状态
typedef NS_ENUM(NSInteger, VideoListPlayerState) {
    VideoListPlayerStateBuffering,  // 缓冲中
    VideoListPlayerStatePlaying,    // 播放中
};

static VideoPlayComplete videoPlayComplete;

@interface VideoPlayerTool ()


@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) UIView *videoShowView;
@property (nonatomic, strong) NSString *videoURL;
@property (nonatomic, strong) VideoDownloadManager *videoDownloadManager;
@property (nonatomic, assign) VideoListPlayerState videoPlayState;
@property (nonatomic, strong) VideoControlsContainerView *controlsContainerView;
@property (nonatomic, strong) NSTimer *videoPlayDurationTimer;

@end

@implementation VideoPlayerTool

#pragma mark -
#pragma mark Tool Initialize

+ (instancetype)sharedInstance {
    static VideoPlayerTool *fm = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        fm = [[self alloc] init];
    });
    return fm;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:nil];
        self.videoPlayDurationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(videoPlayDurationTimerEvent) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.videoPlayDurationTimer forMode:NSRunLoopCommonModes];
        avPlayer = [[AVPlayer alloc] init];
    }
    return self;
}

#pragma mark -
#pragma mark Public Method

- (void)playWithPlayerItem:(PPSPlayerItem *)playerItem
                  showView:(UIView *)showView
                completion:(VideoPlayComplete)completion{
    videoPlayComplete = completion;
    
    self.videoShowView = showView;
    self.playerItem = playerItem;
    self.videoPlayDuration = 0;
    self.videoDownloadManager = [[VideoDownloadManager alloc] initWithURL:self.playerItem.videoURL.absoluteString withDelegate:self];

    [self setupChildContorols];
}

- (void)play {
    [avPlayer play];
    self.isPlaying = YES;
    self.videoPlayDurationTimer.fireDate = [NSDate distantPast];
}

- (void)pause {
    [avPlayer pause];
    self.isPlaying = NO;
    self.videoPlayDurationTimer.fireDate = [NSDate distantFuture];
}

/**
 * 视频播放进度
 *
 * @return 播放进度
 */
- (CMTime)currentTime {    
    return avPlayer.currentTime;
}

/**
 * 视频跳转
 *
 * @param time 跳转到的时间
 */
- (void)seekToTime:(CMTime)time {
    if (CMTIME_IS_INVALID(time)) {
        return;
    }
    [avPlayer seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
}

#pragma mark -
#pragma mark Private Method

- (void)setupChildContorols {
    [self.videoShowView addSubview:self.controlsContainerView];
}

/**
 * 视频播放
 *
 * @param videoUrl 视频资源文件地址
 */
- (void)videoPlayWithURL:(NSURL *)videoUrl {
    [self removePlayerItemNotification];
    [self addPlayerItemNotification];
  
#warning 崩溃检查
    @try {
       [avPlayer replaceCurrentItemWithPlayerItem:self.playerItem];
    } @catch (NSException *exception) {
        return;
    }
    
    avPlayer.volume = 0;
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self clipPlayerLayer];

    [self.videoShowView.layer addSublayer:self.playerLayer];

    self.videoListPlayState = VideoListPlayerStateBuffering;
    
    if (videoPlayComplete) {
        videoPlayComplete(true,self.videoShowView);
    }
    [self play];

}

- (void)addPlayerItemNotification {
    [self.playerItem addObserver:self forKeyPath:@"status"
                           options:NSKeyValueObservingOptionNew
                           context:nil];
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty"
                           options:NSKeyValueObservingOptionNew
                           context:nil];
    [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp"
                           options:NSKeyValueObservingOptionNew
                           context:nil];
}

// 视频裁剪
- (void)clipPlayerLayer {
    if (self.playerItem.videoWidth == 0) {
        return;
    }
    // 视频的宽高比
    float widthToHeightRatio = self.playerItem.videoWidth / self.playerItem.videoHeight;
    // 视频的高宽比
    float heightToWidthRatio = self.playerItem.videoHeight / self.playerItem.videoWidth;

    // 视频缩放后的目标高度
    float targetHeight = 0;
    // 视频缩放后的目标宽度
    float targetWidth = 0;

    if (self.playerItem.isLandscape) {
        // 横版视频以高度为基准缩放
        targetHeight = CGRectGetHeight(self.videoShowView.frame);
        targetWidth = targetHeight * widthToHeightRatio;

        if (targetWidth < CGRectGetWidth(self.videoShowView.frame)) {
            targetWidth = CGRectGetWidth(self.videoShowView.frame);
        }
    } else {
        // 竖版视频以宽度为基准缩放
        targetWidth = CGRectGetWidth(self.videoShowView.frame);
        targetHeight = targetWidth * heightToWidthRatio;
        if (targetHeight < CGRectGetHeight(self.videoShowView.frame)) {
            targetHeight = CGRectGetHeight(self.videoShowView.frame);
        }
    }

    CALayer *maskLayer = [CALayer layer];
    // 颜色不重要
    maskLayer.backgroundColor = [UIColor whiteColor].CGColor;

    float maskHeight = CGRectGetHeight(self.videoShowView.frame);
    float maskWidth = CGRectGetWidth(self.videoShowView.frame);
    float maskXOffset = 0;
    float maskYOffset = 0;
    if (self.playerItem.isLandscape) {
        //横版
        if (self.playerItem.videoWidth/self.playerItem.videoHeight > 1.78) {
            // 横版视频宽高比大于1.78 裁剪两边
            maskXOffset = (targetWidth - maskWidth)/2;
        } else {
            // 横版视频宽高比小于1.78 竖版视频裁剪上下，且按照比例（缩放后视频高度/缩放前视频高度）向上偏移100个点
            maskYOffset = (targetHeight - maskHeight)/2 * (targetHeight/self.playerItem.videoHeight);
        }
    } else {
        //竖版
        if ([self.playerItem.clipRule isEqualToString:@"1"]) {
            if (heightToWidthRatio > 1.6) {
                //裁掉下边
            } else {
                targetHeight = CGRectGetHeight(self.videoShowView.frame);
                targetWidth = targetHeight * widthToHeightRatio;
                if (targetWidth < CGRectGetWidth(self.videoShowView.frame)) {
                    targetWidth = CGRectGetWidth(self.videoShowView.frame);
                }
                //裁掉两边
                maskXOffset = (targetWidth - maskWidth)/2;
            }
        } else {
            if (heightToWidthRatio > 1.42) {
                //裁掉下边
            } else {
                targetHeight = CGRectGetHeight(self.videoShowView.frame);
                targetWidth = targetHeight * widthToHeightRatio;
                
                if (targetWidth < CGRectGetWidth(self.videoShowView.frame)) {
                    targetWidth = CGRectGetWidth(self.videoShowView.frame);
                }
                //裁掉两边
                maskXOffset = (targetWidth - maskWidth)/2;
            }
        }

//        // 竖版视频裁剪上下，且按照比例（缩放后视频高度/缩放前视频高度）向上偏移100个点
        maskYOffset = (targetHeight - maskHeight)/2 - 100 * (targetHeight/self.playerItem.videoHeight);
    }

    maskLayer.frame = CGRectMake(maskXOffset, maskYOffset, self.videoShowView.width, self.videoShowView.height);
    // 蒙版后不会把四周不显示的区域裁剪掉，所以视频的 Layer 要相应上移/左移
    self.playerLayer.frame =CGRectMake(-maskXOffset, -maskYOffset, targetWidth, targetHeight);
    self.playerLayer.backgroundColor = (__bridge CGColorRef _Nullable)([UIColor redColor]);
    self.playerLayer.mask = maskLayer;
    self.playerLayer.masksToBounds = YES;
}

- (void)removePlayerItemNotification {
    
#warning 第一次进入时移除监听崩溃需要处理
    [self.playerLayer removeFromSuperlayer];

    if (self.playerItem) {
        @try {
            [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
            [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
            [self.playerItem removeObserver:self forKeyPath:@"status"];
        } @catch (NSException *exception) {
            
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!avPlayer) return;
    
    if ([keyPath isEqualToString:@"status"] ) {
        AVPlayerItem *playerItem = (AVPlayerItem*)object;
        if (playerItem.status==AVPlayerStatusFailed) {

        }
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        self.videoListPlayState = VideoListPlayerStatePlaying;
    }
}

/**
 * 配置视频加载
 */
- (void)setupActivityIndicator {

    if (self.videoPlayState == VideoListPlayerStatePlaying) {
        self.controlsContainerView.fatherView = self.videoShowView;
        [self.controlsContainerView hideActivityIndicatorView];
        return;
    }
    if (self.videoPlayState == VideoListPlayerStateBuffering) {
        self.controlsContainerView.fatherView = self.videoShowView;
        [self.controlsContainerView showActivityIndicatorView];
    }
}

/**
 * 视频播放完成监听事件
 *
 * @param notification 播放完成通知
 */
- (void)playbackFinished:(NSNotification *)notification {

    if (self.isPlaying) {
        [self.playerItem seekToTime:kCMTimeZero]; // 跳转到初始
        [self play];
    }
}

- (void)videoPlayDurationTimerEvent {
    self.videoPlayDuration ++;
}

#pragma mark -
#pragma mark VideoDownloadManager Delegate

/**
 * 没有缓存的完整的文件，自己根据url地址来播放
 *
 * @param manager 视频下载manager
 */
- (void)didNoCacheFileWithManager:(VideoDownloadManager *)manager{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *url = [NSURL URLWithString:self.videoURL];
        [self videoPlayWithURL:url];
    });
}

/**
 * 获取到已经缓存好的文件，直接用本地路径播放
 *
 * @param manager 视频下载manager
 * @param filePath 文件本地地址
 */
- (void)didFileExistedWithManager:(VideoDownloadManager *)manager Path:(NSString *)filePath {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *url = [NSURL fileURLWithPath:filePath];
        [self videoPlayWithURL:url];
    });
}

#pragma mark -
#pragma mark Setters and Getters

- (VideoControlsContainerView *)controlsContainerView {
    if (_controlsContainerView == nil) {
        _controlsContainerView = [VideoControlsContainerView new];
    }
    return _controlsContainerView;
}

- (void)setVideoListPlayState:(VideoListPlayerState)videoListPlayState {
    _videoPlayState = videoListPlayState;
    [self setupActivityIndicator];
}

@end
