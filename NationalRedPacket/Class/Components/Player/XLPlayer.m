//
//  XLPlayer.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/4/10.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLPlayer.h"
#import "XLResourceLoader.h"
#import "NSURL+ResourceLoader.h"

static dispatch_queue_t resurceLoaderQueue;

@interface XLPlayer ()<XLResourceLoaderDelegate>

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *currentPlayerItem;
@property (strong, nonatomic) AVPlayerLayer  *currentPlayerLayer;
@property (strong, nonatomic) XLResourceLoader *resourceLoader;
@property (strong, nonatomic) id timeObserve;
@property (strong, nonatomic) NSTimer *videoPlayDurationTimer;
@property (assign, nonatomic) BOOL isPlaying;
@property (strong, nonatomic) NSURL *lastPlayedURL;
@property (strong, nonatomic) XLPlayerConfigModel *playerConfigModel;

@end

@implementation XLPlayer

#pragma mark -
#pragma mark Public Method

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static XLPlayer *sInstance;
    dispatch_once(&onceToken, ^{
        sInstance = [[self alloc] init];
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    });
    return sInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.videoPlayDurationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(videoPlayDurationTimerEvent) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.videoPlayDurationTimer forMode:NSRunLoopCommonModes];
        
        resurceLoaderQueue = dispatch_queue_create("video_loader_serial_queue",DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

/**
 视频播放
 */
- (void)playWithConfigModel:(XLPlayerConfigModel *)configModel {
    
    /**是否线程问题？？？ 切换到主线程处理视频显示操作*/
    self.playTotalTime = 0;
    
    // 不是用缓存播放时，清除缓存
    if (!configModel.shouldCache) {
        [XLFileHandler clearCacheWithFileURL:configModel.videoURL];
    }

    if (configModel.shouldCache && [configModel.videoURL isEqual:self.lastPlayedURL] && self.state == XLPlayerStatePlaying) {
        
        [self.currentPlayerLayer removeFromSuperlayer];
        [self configVideoShow:configModel];
        [self resume];

        return;
    }
    self.playerConfigModel = configModel;
    self.lastPlayedURL = configModel.videoURL;
    
    // 监听移除
    [self resetPlayer];
    
    self.state = XLPlayerStateBuffering;
    
    // 配置视频资源
    [self configVideoResource:configModel];
    
    // 配置player播放资源
    if (!self.player) {
        self.player = [AVPlayer playerWithPlayerItem:self.currentPlayerItem];
    } else {
        [self.player replaceCurrentItemWithPlayerItem:self.currentPlayerItem];
    }
    // 添加监听
    [self addObserver];
  
    // 配置视频画面
    [self configVideoShow:configModel];
    
    // [self.player setMuted:self.mute];
    
    // 调整视频进度
    if (configModel.seekToTime > 0) {
        [self seekToTime:configModel.seekToTime];
    }
    [self resume];
}

/**
 视频播放
 */
- (void)resume {
    [self.player play];
    self.videoPlayDurationTimer.fireDate = [NSDate distantPast];
    self.isPlaying = YES;
}

/**
 视频暂停
 */
- (void)pause {
    [self.player pause];
    self.videoPlayDurationTimer.fireDate = [NSDate distantFuture];
    self.isPlaying = NO;
}

/**
 静音
 */
- (void)setMute:(BOOL)mute {
    if (_mute != mute) {
        [self.player setMuted:mute];
    }
    _mute = mute;
}

/**
 是否正在播放
 
 @return 视频播放状态
 */
- (BOOL)isPlaying{
   return _isPlaying;
}

- (NSURL *)videoURL {
    return self.playerConfigModel.videoURL;
}

/**
 视频进度跳转
 暂停后滑动slider后     暂停播放状态
 播放中后滑动slider后   自动播放状态
 @param seconds 跳转到指定秒数
 */

- (void)seekToTime:(double)seconds {
    self.resourceLoader.seekRequired = YES;
    self.state = XLPlayerStateBuffering;
    [self.player seekToTime:CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC)
            toleranceBefore: kCMTimeZero
             toleranceAfter: kCMTimeZero
          completionHandler: ^(BOOL finished) {
              if (finished) {
                  self.state = XLPlayerStatePlaying;
              }
              [self resume];
          }];
}

/**
 视频时长
 */
- (NSTimeInterval)duration {
    return CMTimeGetSeconds(self.currentPlayerItem.duration);
}

/**
 当前播放时间
 */
- (NSTimeInterval)currentTime {
    return CMTimeGetSeconds(self.currentPlayerItem.currentTime);
}

- (void)resetPlayerLayerFrame:(CGRect)frame {
    self.currentPlayerLayer.frame = frame;
}

+ (BOOL)clearCache {
    [XLFileHandler clearCache];
    return YES;
}

- (void)setVideoGravity:(AVLayerVideoGravity)videoGravity {
    self.currentPlayerLayer.videoGravity = videoGravity;
}

#pragma mark -
#pragma mark Private Method

/**
 配置视频画面
 */
- (void)configVideoShow:(XLPlayerConfigModel *)configModel {
    self.currentPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.currentPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.currentPlayerLayer.frame = configModel.videoShowView.bounds;
    [configModel.videoShowView.layer addSublayer:self.currentPlayerLayer];
}

- (void)changePlayerLayerForShowView:(UIView *)view {
    self.currentPlayerLayer.frame = view.bounds;
    [view.layer addSublayer:self.currentPlayerLayer];
}

/**
 配置视频资源
 */
- (void)configVideoResource:(XLPlayerConfigModel *)configModel {
    if (configModel.shouldCache) { // 需要使用缓存文件
        NSString *cacheFilePath = [XLFileHandler cacheFileExistsWithURL:configModel.videoURL];
        if (cacheFilePath) { // 有缓存，播放缓存文件
            NSURL *url = [NSURL fileURLWithPath:cacheFilePath];
            self.currentPlayerItem = [AVPlayerItem playerItemWithURL:url];
            self.state = XLPlayerStatePlaying;
            
        } else { // 没有缓存，播放网络文件，并缓存
            self.resourceLoader = [[XLResourceLoader alloc] init];
            self.resourceLoader.delegate = self;
            AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[configModel.videoURL customSchemeURL]
                                                    options:nil];
            /**队列在主线程吗？？？？？？*/
            [asset.resourceLoader setDelegate:self.resourceLoader queue:resurceLoaderQueue];
            self.currentPlayerItem = [AVPlayerItem playerItemWithAsset:asset];
        }
    } else {
        self.currentPlayerItem = [AVPlayerItem playerItemWithURL:configModel.videoURL];
    }
}

/**
 播放器释放
 */
- (void)resetPlayer {
    if (self.state == XLPlayerStateStopped) {
        return;
    }
    [self.currentPlayerLayer removeFromSuperlayer];
    [self.player pause];
    [self.resourceLoader stopLoading];
    [self removeObserver];
    self.resourceLoader = nil;
    self.currentPlayerItem = nil;
    self.progress = 0.0;
    self.duration = 0.0;
    self.state = XLPlayerStateStopped;
}

- (void)videoPlayDurationTimerEvent {
    self.playTotalTime ++;
}

#pragma mark -
#pragma mark - Notification

/**
 添加监听
 */
- (void)addObserver {
    // 播放完成监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidPlayToEndTimeNotificationEvent)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification object:self.currentPlayerItem];
    // 播放进度
    @weakify(self);
    self.timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, NSEC_PER_SEC)  queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        @strongify(self);
        self.currentPlayTime = CMTimeGetSeconds(time);
        CGFloat total = CMTimeGetSeconds(self.currentPlayerItem.duration);
        self.duration = total;
        if (total > 0) {
            self.progress = self.currentPlayTime / total;
        }
    }];
    [self.player addObserver:self forKeyPath:@"rate"
                     options:NSKeyValueObservingOptionNew context:nil];
    [self.currentPlayerItem addObserver:self forKeyPath:@"loadedTimeRanges"
                          options:NSKeyValueObservingOptionNew context:nil];
    [self.currentPlayerItem addObserver:self forKeyPath:@"status"
                          options:NSKeyValueObservingOptionNew context:nil];
    [self.currentPlayerItem addObserver:self forKeyPath:@"playbackBufferEmpty"
                          options:NSKeyValueObservingOptionNew context:nil];
    [self.currentPlayerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp"
                          options:NSKeyValueObservingOptionNew context:nil];
}

/**
 移除监听
 */
- (void)removeObserver {
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        if (self.timeObserve) {
            [self.player removeTimeObserver:self.timeObserve];
            self.timeObserve = nil;
        }
        if (self.currentPlayerItem) {
            [self.currentPlayerItem removeObserver:self forKeyPath:@"status"];
            [self.currentPlayerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
            [self.currentPlayerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
            [self.currentPlayerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
        }
        [self.player removeObserver:self forKeyPath:@"rate"];
        [self.player replaceCurrentItemWithPlayerItem:nil];
        
    } @catch (NSException *exception) {
        
    }
}

/**
 *  通过KVO监控播放器状态
 */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem*)object;

    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *loadedTimeRanges = [self.currentPlayerItem loadedTimeRanges];
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval timeInterval = startSeconds + durationSeconds;// 计算缓冲总进度
        CMTime duration = self.currentPlayerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        
        if (totalDuration > 0 && self.delegate && [self.delegate respondsToSelector:@selector(playerCacheProgressDidUpdate:)]) {
            [self.delegate playerCacheProgressDidUpdate:timeInterval / totalDuration];
        }
    } else if ([keyPath isEqualToString:@"rate"]) {

    } else if ([keyPath isEqualToString:@"status"] ) {
        if (playerItem.status == AVPlayerStatusFailed) {
            XLLog(@"----- AVPlayerStatusFailed -----");
            self.state = XLPlayerStateError;
        }
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {

        // 当缓冲是空的时候
        if (self.currentPlayerItem.playbackBufferEmpty) {
            self.state = XLPlayerStateBuffering;
        }
        
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        // 当缓冲好的时候
        if (self.currentPlayerItem.playbackLikelyToKeepUp && self.state == XLPlayerStateBuffering){
            self.state = XLPlayerStatePlaying;
        }
    }
}

/**
 播放完成监听事件
 */
- (void)playerItemDidPlayToEndTimeNotificationEvent {
    [self.currentPlayerItem seekToTime:kCMTimeZero];
    [self pause];
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerPlayToEndTime)]) {
        [self.delegate playerPlayToEndTime];
    }
}

#pragma mark -
#pragma mark LoaderDelegate

- (void)loader:(XLResourceLoader *)loader cacheProgress:(CGFloat)progress {
    self.cacheProgress = progress;
}

- (void)loader:(XLResourceLoader *)loader failLoadingWithError:(NSError *)error {

    self.state = XLPlayerStateError;
}

#pragma mark -
#pragma mark Setters and Getters

- (void)setProgress:(CGFloat)progress {
    _progress =  progress;
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerProgressDidUpdate:)]) {
        [self.delegate playerProgressDidUpdate:_progress];
    }
}

- (void)setCurrentPlayTime:(CGFloat)currentPlayTime {
    _currentPlayTime = currentPlayTime;
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerCurrentTimeDidUpdate:)]) {
        [self.delegate playerCurrentTimeDidUpdate:_currentPlayTime];
    }
}

- (void)setState:(XLPlayerState)state {
    _state = state;
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerStateDidUpdate:)]) {
        [self.delegate playerStateDidUpdate:state];
    }
}

@end
