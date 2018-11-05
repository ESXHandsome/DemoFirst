//
//  FeedVideoDetailViewController.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/7.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "FeedVideoDetailViewController.h"
#import "FeedVideoDetailCell.h"
#import "XLPlayer.h"
#import "XLVideoFloatView.h"

typedef NS_ENUM(NSUInteger, VideoShowType) {
    VideoShowTypeHorizontal,              //横版
    VideoShowTypeVerticalFullScreen,      //竖版全屏
    VideoShowTypeVerticalOptionExceed,    //竖版非全屏 超出导航和工具栏
    VideoShowTypeVerticalOptionLess,      //竖版非全屏 未超出导航和工具栏
};

@interface FeedVideoDetailViewController () <VideoDisplayViewDelegate, FeedCellDelegate>

@property (strong, nonatomic) FeedVideoDetailCell *videoHeaderView;
@property (strong, nonatomic) XLVideoFloatView    *videoFloatView;
@property (assign, nonatomic) VideoShowType       videoShowType;
@property (strong, nonatomic) XLPlayerConfigModel *configModel;
@property (strong, nonatomic) UIImageView         *topShadowImageView;
/// 是否已改变视频播放位置
@property (assign, nonatomic) BOOL hasChangeVideoLayerPlace;
/// 是否透明导航
@property (assign, nonatomic) BOOL topNavigationTransparency;
/// 是否半透明工具栏
@property (assign, nonatomic) BOOL toolBarTranslucent;
/// 视频是否在播放范围
@property (assign, nonatomic) BOOL videoPlayArea;
///
@property (assign, nonatomic) BOOL isViewDidDisappear;
@property (assign, nonatomic) BOOL isViewWillDisappear;

@end

@implementation FeedVideoDetailViewController

@synthesize topNavigationTransparency = _topNavigationTransparency;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showFollowHeight = - MAXFLOAT;
    [self updateNavigationBarFollowButton];
    
    [self.navigationController.navigationBar addSubview:self.topShadowImageView];

    [self playHeaderVideoAfter:YES];
    
    if (self.videoShowType == VideoShowTypeVerticalFullScreen ||
        self.videoShowType == VideoShowTypeVerticalOptionExceed) {
        
        [self changeSubviewsFrame];
        
        self.topNavigationTransparency = !self.shouldScrollToCommentView;
        
        if (self.videoShowType == VideoShowTypeVerticalOptionExceed) {
            self.bottomToolbarView.translucent = NO;
        } else {
            self.bottomToolbarView.translucent = !self.shouldScrollToCommentView;
        }
    }
    
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)configHeaderView {
    
    self.tableView.tableHeaderView = self.videoHeaderView;
    [self.view addSubview:self.videoFloatView];
    
    CGFloat floatWidth;
    if (self.viewModel.feed.type.integerValue == XLFeedCellVideoHorizonalWithAuthorType) {
        floatWidth = adaptWidth750(400);
    } else {
        floatWidth = adaptWidth750(112*2);
    }
    [self.videoFloatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-adaptWidth750(20));
        make.top.equalTo(self.view).offset(NAVIGATION_BAR_HEIGHT + adaptWidth750(20));
        make.width.mas_equalTo(floatWidth);
        make.height.mas_equalTo(floatWidth * self.viewModel.feed.height/self.viewModel.feed.width);
    }];
    
    self.videoFloatView.configModel = self.configModel;
    self.videoFloatView.feedModel = self.viewModel.feed;
    self.videoFloatView.viewModel = self.viewModel;
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.isVideoPlaying) {
        [self.viewModel statEndContent];
    }
    if (!animated && !self.viewModel.feed
        .isVideoPlayToEndTime) {
        [self resumeVideo];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.isViewWillDisappear && !self.isViewDidDisappear && !self.viewModel.feed
        .isVideoPlayToEndTime) {
        [self resumeVideo];
    } else if (self.isViewDidDisappear) {
        [self playHeaderVideoAfter:NO];
        if (!self.videoPlayArea && [XLPlayer.sharedInstance.videoURL isEqual:self.configModel.videoURL]) {
            [XLPlayer.sharedInstance changePlayerLayerForShowView:self.videoFloatView.subviews[0]];
        }
        [self.videoFloatView resetViewControl];
    }
    self.isViewDidDisappear = NO;
    self.isViewWillDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isViewWillDisappear = YES;
    self.isVideoPlaying = XLPlayer.sharedInstance.isPlaying;
    
    [self pauseVideo];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.isViewDidDisappear = YES;
    self.viewModel.feed.currentTime = self.videoHeaderView.videoDisplayView.videoCurrentPlayTime;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
  
    if (self.videoDetailEndPlay_block && !self.isEnterPersonal) {
        self.videoDetailEndPlay_block(self.isVideoPlaying,self.viewModel.feed.isVideoPlayToEndTime);
    }
}

/**
 播放视频，首次进入时播放
 */
- (void)playHeaderVideoAfter:(BOOL)isAfter {
    
    self.videoHeaderView.videoDisplayView.playerConfigModel = self.configModel;
    self.videoHeaderView.videoDisplayView.isManuallyPause = !self.isVideoPlaying;
    XLPlayer.sharedInstance.delegate = self.videoHeaderView.videoDisplayView;
    
    if (isAfter) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.isVideoPlaying) {
                [self.videoHeaderView.videoDisplayView playVideoWithConfigModel:self.configModel];
            }
        });
    } else {
        if (self.isVideoPlaying) {
            [self.videoHeaderView.videoDisplayView playVideoWithConfigModel:self.configModel];
        }
    }

}

/**
 tableView 正在滚动
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:self.tableView];
    
    if (self.videoShowType == VideoShowTypeVerticalFullScreen ||
        self.videoShowType == VideoShowTypeVerticalOptionExceed) {
        
        self.topNavigationTransparency = self.topNavigationTransparency;
        
        if (!self.topNavigationTransparency) { //导航渐变效果
            if (scrollView.mj_offsetY < self.videoHeaderView.videoDisplayView.height/2) {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor whiteColor] colorWithAlphaComponent:(scrollView.mj_offsetY - self.videoHeaderView.videoDisplayView.height*1/3) / (NAVIGATION_BAR_HEIGHT*2)] size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
            }
        }
        
        if (self.videoShowType == VideoShowTypeVerticalOptionExceed) {
            self.bottomToolbarView.translucent = NO;
        } else {
            self.bottomToolbarView.translucent = self.toolBarTranslucent;
            if (self.toolBarTranslucent) {
                self.bottomToolbarView.hidden = !self.videoHeaderView.videoDisplayView.adjustProgressContainerView.hidden;
            } else {
                self.bottomToolbarView.hidden = self.toolBarTranslucent;
            }
        }
    }
    
    if (self.videoPlayArea) {
        
        if (!self.hasChangeVideoLayerPlace) {
            return;
        }
        self.hasChangeVideoLayerPlace = NO;
        [self.viewModel statEndVideoFloat];
        
        self.videoFloatView.hidden = YES;
        if ([XLPlayer.sharedInstance.videoURL isEqual:self.configModel.videoURL]) {
            [XLPlayer.sharedInstance changePlayerLayerForShowView: self.videoHeaderView.videoDisplayView.feedVideoShowView];
        }
        if (self.videoFloatView.isClickCloseButton) {
            [self resumeVideo];
        }
        [self.videoHeaderView.videoDisplayView resetViewControl];
        
    } else {
        
        if (self.hasChangeVideoLayerPlace) {
            return;
        }
        self.hasChangeVideoLayerPlace = YES;
        if (self.isVideoPlaying) {
            [self.viewModel statBeginVideoFloat];
        }
        
        self.videoFloatView.hidden = NO;
        if ([XLPlayer.sharedInstance.videoURL isEqual:self.configModel.videoURL]) {
            [XLPlayer.sharedInstance changePlayerLayerForShowView:self.videoFloatView.subviews[0]];
        }
        [self.videoFloatView resetViewControl];
        
    }
}

/**
 暂停播放
 */
- (void)pauseVideo {
    
    if (XLPlayer.sharedInstance.isPlaying) {
        [self.videoHeaderView.videoDisplayView videoPause];
    }
    [self.videoFloatView resetViewControl];
}

/**
 继续播放
 */
- (void)resumeVideo {
    
    if (!XLPlayer.sharedInstance.isPlaying && !self.videoHeaderView.videoDisplayView.isManuallyPause) {
        [self.videoHeaderView.videoDisplayView videoResume];
    }
    [self.videoFloatView resetViewControl];
}

- (void)changeSubviewsFrame {
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.tableView.rowHeight = SCREEN_HEIGHT;
    self.videoOffsetHeight = NAVIGATION_BAR_HEIGHT - adaptHeight1334(12);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_HEIGHT;
}

#pragma mark - Notification Event

- (void)applicationWillResignActiveNotification {
    [self pauseVideo];
}

- (void)applicationDidBecomeActiveNotification {
    [self resumeVideo];
}

#pragma mark - VideoDisplayViewDelegate
- (void)videoDisplayView:(VideoDisplayView *)videoDisplayView videoDidManuallyPause:(BOOL)isManuallyPause {
    self.isVideoPlaying = !isManuallyPause;

    if (isManuallyPause) {
        [self.viewModel statEndContent];
    } else {
        [self.viewModel statBeginContent];
    }
}

- (void)videoDisplayView:(VideoDisplayView *)videoView didPlayCompletedVideo:(XLPlayerConfigModel *)playerModel {
    [self.viewModel statEndContent];
    [self.videoFloatView videoDidCompletedPlaying];
}

- (void)didClickReplayButtonWithVideoDisplayView:(VideoDisplayView *)videoView {
    [self.viewModel statBeginContent];
}

- (void)videDisplayView:(VideoDisplayView *)videoView playerProgressDidUpdate:(CGFloat)progress {
    self.videoFloatView.bottomProgressView.progress = progress;
}

- (void)videDisplayView:(VideoDisplayView *)displayView progressViewHidden:(BOOL)hidden {
    if (self.toolBarTranslucent) {
        self.bottomToolbarView.hidden = !hidden;
    }
}

#pragma mark - FeedDetailViewModelDelegate
- (void)feedModelDidUpdate:(XLFeedModel *)feed {
    
    [super feedModelDidUpdate:feed];
    
    [self.videoHeaderView updateDetailInfo];
}

#pragma mark - Setter
- (void)setTopNavigationTransparency:(BOOL)topNavigationTransparency {
    _topNavigationTransparency = topNavigationTransparency;
    
    [self.navigationController.navigationBar setBackgroundImage:topNavigationTransparency ? [UIImage new] : nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:topNavigationTransparency ? [UIImage new] : nil];
    self.topShadowImageView.hidden = !topNavigationTransparency;
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithString:topNavigationTransparency ? COLORffffff : COLOR333333];
    [((UIButton *)[self.navigationItem.leftBarButtonItem customView]) setImage:[UIImage imageNamed:topNavigationTransparency ? @"video_nav_back" : @"return_black"] forState:UIControlStateNormal];
    self.navigationBarfollowView.transparency = topNavigationTransparency;
    
    self.tableView.bounces = !topNavigationTransparency;
    [UIApplication sharedApplication].statusBarStyle = topNavigationTransparency ?UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

#pragma mark - getter
- (VideoShowType)videoShowType {
    
    VideoShowType showType = VideoShowTypeHorizontal;
    
    CGFloat videoWidth = self.viewModel.feed.width;
    CGFloat videoHeight = self.viewModel.feed.height;
    CGFloat videoScale = videoHeight/videoWidth;
    CGFloat screenScale = SCREEN_HEIGHT/SCREEN_WIDTH;
    
    videoWidth = SCREEN_WIDTH;
    videoHeight = videoWidth * videoScale; //缩放后的视频高度
    
    if (videoHeight > videoWidth) {
        if (videoScale >= screenScale) {
            showType = VideoShowTypeVerticalFullScreen;
        } else {
            if (SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT >= videoHeight) {
                showType = VideoShowTypeVerticalOptionLess;
            } else {
                showType = VideoShowTypeVerticalOptionExceed;
                if (SCREEN_HEIGHT  - TAB_BAR_HEIGHT < videoHeight) {
                    showType = VideoShowTypeVerticalFullScreen;
                }
            }
        }
    } else {
        showType = VideoShowTypeHorizontal;
    }
    return showType;
}

- (BOOL)toolBarTranslucent {
    return [self screenAreaWithNumber:SCREEN_HEIGHT - TAB_BAR_HEIGHT];
}

- (BOOL)topNavigationTransparency {
    return [self screenAreaWithNumber:SCREEN_HEIGHT*2/3.0];
}

- (BOOL)videoPlayArea {
    return [self screenAreaWithNumber:NAVIGATION_BAR_HEIGHT];
}

//是否在范围内
- (BOOL)screenAreaWithNumber:(CGFloat)number {
    //frame 转换
    return [self screenAreaWithView:self.videoHeaderView.videoDisplayView number:number];
}

#pragma mark - Lazy Loading
- (FeedVideoDetailCell *)videoHeaderView {
    if (!_videoHeaderView) {
        _videoHeaderView = [FeedVideoDetailCell new];
        [_videoHeaderView configModelData:self.viewModel.feed indexPath:nil];
        _videoHeaderView.height = [self.tableView fd_systemFittingHeightForConfiguratedCell:_videoHeaderView]+1;
        _videoHeaderView.videoDisplayView.delegate = self;
        _videoHeaderView.cellDelegate = self;
    }
    return _videoHeaderView;
}

- (XLVideoFloatView *)videoFloatView {
    if (!_videoFloatView) {
        _videoFloatView = [XLVideoFloatView new];
        _videoFloatView.hidden = YES;
    }
    return _videoFloatView;
}

- (UIImageView *)topShadowImageView {
    if (!_topShadowImageView) {
        _topShadowImageView = [UIImageView new];
        _topShadowImageView.image = [UIImage imageNamed:@"video_full_shadow"];
        _topShadowImageView.frame = CGRectMake(0, -20, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT);
        _topShadowImageView.hidden = YES;
    }
    return _topShadowImageView;
}

- (CGFloat)commentAreaHeight {
    if (self.videoShowType == VideoShowTypeVerticalFullScreen ||
        self.videoShowType == VideoShowTypeVerticalOptionExceed) {
        return self.tableView.tableHeaderView.height + adaptHeight1334(12) - NAVIGATION_BAR_HEIGHT;
    }
    return self.tableView.tableHeaderView.height + adaptHeight1334(12);
}

- (CGFloat)statSeparateHeight {
    return self.videoHeaderView.videoDisplayView.height/2.0;
}

- (XLPlayerConfigModel *)configModel {
    if (!_configModel) {
        self.configModel = [XLPlayerConfigModel new];
        self.configModel.videoURL = [NSURL URLWithString:self.viewModel.feed.url];
        self.configModel.shouldCache = YES;
        self.configModel.configNoMuteButton = YES;
        self.configModel.displayViewFatherView = self.videoHeaderView.videoDisplayView.superview;
        self.configModel.fullScreenShouldRotate = self.viewModel.feed.type.integerValue == XLFeedCellVideoHorizonalWithAuthorType;
    }
    return _configModel;
}

@end
