//
//  PersonalHomepageViewController.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/1/25.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "PublisherViewController.h"
#import "PublisherLatestFeedListViewController.h"
#import "PublisherVideoFeedListViewController.h"
#import "PersonalTopView.h"
#import "PersonalBackgroundView.h"
#import "FollowButton.h"
#import "BaseNavigationController.h"
#import "PersonalScrollView.h"
#import "NewsApi.h"
#import "UITableView+VideoPlay.h"
#import "GifPlayManager.h"
#import "XLPublisherDataSource.h"
#import "PublisherApi.h"
#import "XLMoreActionView.h"
#import "XLReportSheetAlertViewController.h"
#import "XLUserManager.h"

#define kItemheight (adaptHeight1334(40*2))

@interface PublisherViewController () <UIScrollViewDelegate, PersonalTopViewDelegate, FollowButtonDelegate, XLDataSourceDelegate, PublisherLatestFeedListViewControllerDelegate, PublisherVideoFeedListViewControllerDelegate, XLMoreActionViewDelegate>

@property (strong, nonatomic) XLPublisherDataSource *dataSource;
@property (strong, nonatomic) PersonalScrollView *scrollView;
@property (strong, nonatomic) PersonalTopView *personalTopView;
@property (strong, nonatomic) UIView *navigationAlphaView;
@property (strong, nonatomic) UIButton *navigationAlphaBackButton;
@property (strong, nonatomic) UILabel  *navigationTitleLabel;
@property (strong, nonatomic) FollowButton *navigationAlphaFollowButton;
@property (strong, nonatomic) UIBarButtonItem *navgationLeftItemButton;

@property (strong, nonatomic) XLMoreActionView *moreActionView;

@property (strong, nonatomic) PublisherLatestFeedListViewController *latestFeedList;
@property (strong, nonatomic) PublisherVideoFeedListViewController *videoFeedList;

@property (strong, nonatomic) UITableView *dynamicTableView;
@property (strong, nonatomic) UITableView *videoTableView;

@property (assign, nonatomic) BOOL videoTableHasAdd;

@end

@implementation PublisherViewController

#pragma mark -
#pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    if (self.model.isNoInfo) {
        [self fetchPublisherInfo];
    } else {
        [self setupPageInfo];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickMoreButton)];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithString: COLORffffff];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [StatServiceApi statEventBegin:PERSON_PAGE_DURATION model:self.model];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [StatServiceApi statEventEnd:PERSON_PAGE_DURATION model:self.model];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.personalHomepageControllerWillDisplayBlock) {
        self.personalHomepageControllerWillDisplayBlock();
    }
}

- (void)loadView {
    [super loadView];
    if (!self.model) {
        XLPublisherModel *model = [XLPublisherModel new];
        model.authorId = self.publisherId;
        model.isNoInfo = YES;
        self.model = model;
    } else {
        self.model.isNoInfo = NO;
    }
    PersonalBackgroundView *view = [[PersonalBackgroundView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.topView = self.personalTopView;
    view.scrollView = self.scrollView;
    view.dynamicView = self.dynamicTableView;
    view.videoView = self.videoTableView;
    self.view = view;
}

#pragma mark -
#pragma mark DataSource

- (XLPublisherModel *)model {
    return self.dataSource.elements.firstObject;
}

- (void)setModel:(XLPublisherModel *)model {
    if (self.dataSource == nil) {
        self.dataSource = [[XLPublisherDataSource alloc] init];
        self.dataSource.delegate = self;
    }
    [self.dataSource setElementsFromArray:@[model]];
}

- (void)dataSource:(XLDataSource *)dataSource didChangedForIndex:(NSInteger)index {
    self.personalTopView.model = self.model;
    self.navigationAlphaFollowButton.followed = self.model.isFollowed;
}

/**
 拉取个人信息
 */
- (void)fetchPublisherInfo {
    @weakify(self)
    [XLLoadingView showLoadingInView:self.view];
    [PublisherApi fetchPublisherInfoWithPublisherId:self.model.authorId Success:^(id responseDict) {
        @strongify(self);
        
        XLPublisherModel *model = [XLPublisherModel yy_modelWithDictionary:responseDict];
        model.authorId = self.publisherId;
        self.model = model;
        
        [XLLoadingView hideLoadingForView:self.view];
        [self setupPageInfo];
    } failure:^(NSInteger errorCode) {
        @strongify(self);
        [XLLoadingView hideLoadingForView:self.view];
        [XLReloadFailView showReloadFailInView:self.view reloadAction:^{
            @strongify(self);
            [self fetchPublisherInfo];
        }];
        XLReloadFailView *failView = [XLReloadFailView reloadFailForView:self.view];
        failView.y = NAVIGATION_BAR_HEIGHT;
    }];
}

- (void)setupPageInfo {
    
    self.navigationTitleLabel.text = self.model.nickname;
    self.personalTopView.model = self.model;
    self.navigationAlphaFollowButton.followed = self.model.isFollowed;
}

#pragma mark -
#pragma mark UI Initialize

- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.personalTopView];
   
    [self setupNavigationBar];
}

- (void)setupNavigationBar {

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, adaptWidth750(28), 22)];
    [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -adaptWidth750(10), 0, adaptWidth750(10))];
    [backButton setImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(didClickBackeButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    [self.navigationController.navigationBar addSubview:self.navigationAlphaView];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:nil
                                                                 action:nil];
    self.navigationItem.backBarButtonItem = barButton;
}

#pragma mark -
#pragma mark ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger minOffset = ceil(self.personalTopView.height - kItemheight - 64);
    NSInteger dynamicOffset = ceil(self.dynamicTableView.contentOffset.y); //动态偏移
    NSInteger videoOffset = ceil(self.videoTableView.contentOffset.y);     //视频偏移
    
    if (self.personalTopView.selectedItemIndex == 0) {
        
        if (dynamicOffset < minOffset) {
            [self.videoTableView setContentOffset:CGPointMake(0, dynamicOffset) animated:NO];
        } else {
            if (videoOffset == 0 || videoOffset <= minOffset) {  //初始状态
                [self.videoTableView setContentOffset:CGPointMake(0, minOffset) animated:NO];
            }
        }
        
        CGFloat segmentSelectedLineOffset = adaptWidth750(120) * scrollView.contentOffset.x / SCREEN_WIDTH;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.personalTopView.segmentSelectedLine.frame = CGRectMake(adaptWidth750(30) + segmentSelectedLineOffset, self.personalTopView.height - adaptHeight1334(1), adaptHeight1334(60), adaptHeight1334(2));
        }];
        
    } else {
        
        if (videoOffset < minOffset) {
            [self.dynamicTableView setContentOffset:CGPointMake(0, videoOffset) animated:NO];
        } else {
            if (dynamicOffset == 0 || dynamicOffset <= minOffset) {  //初始状态
                [self.dynamicTableView setContentOffset:CGPointMake(0, minOffset) animated:NO];
            }
        }

        CGFloat segmentSelectedLineOffset = adaptWidth750(120) * (SCREEN_WIDTH - scrollView.contentOffset.x) / SCREEN_WIDTH;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.personalTopView.segmentSelectedLine.frame = CGRectMake(adaptWidth750(150) - segmentSelectedLineOffset, self.personalTopView.height - adaptHeight1334(2), adaptHeight1334(60), adaptHeight1334(2));
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == SCREEN_WIDTH) {
        [self addVideoTableView];
    }
    NSInteger index = ceilf(scrollView.contentOffset.x / SCREEN_WIDTH);
    self.personalTopView.selectedItemIndex = index;
    [self handleVideoPlay:scrollView];
}

- (void)handleVideoPlay:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == SCREEN_WIDTH) {
        [self.dynamicTableView pause];
        [self.dynamicTableView setContentOffset:self.dynamicTableView.contentOffset animated:NO];
        [self.videoTableView play];
        [self.videoTableView handleScrollAutoPlayWithCompareCurrentCell:NO];
        [[GifPlayManager sharedManager] pauseGifCell];
        [GifPlayManager sharedManager].playingGifCell = nil;
        [GifPlayManager sharedManager].playingGifCell.containerView.isPlaying = NO;
    } else if (scrollView.contentOffset.x == 0) {
        [self.videoTableView pause];
        [self.videoTableView setContentOffset:self.videoTableView.contentOffset animated:NO];

        [self.dynamicTableView play];
        [self.dynamicTableView handleScrollAutoPlayWithCompareCurrentCell:NO];
        [GifPlayManager sharedManager].currentTableView = self.dynamicTableView;
        [[GifPlayManager sharedManager] playGifCell];
        
    }
}

#pragma mark - Event Action
- (void)didClickMoreButton {
    
    [self.moreActionView show];
}

#pragma mark - XLMoreActionViewDelegate
- (void)didSelectedMoreActionView:(XLMoreActionView *)view index:(NSInteger)index {
    if (index == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            XLReportSheetAlertViewController *vc = [[XLReportSheetAlertViewController alloc] init];
            [vc presentReportAlertViewController:self publisherId:self.model.authorId complete:nil];
            [XLUserManager.shared blacklistUser:self.model.authorId];
        });
    } else {
        
        [XLUserManager.shared blacklistUser:self.model.authorId];
        [MBProgressHUD showSuccess:@"操作成功"];
    }
}

#pragma mark -
#pragma mark FeedList Delegate

- (void)feedList:(id)feedList scrollViewDidScroll:(UIScrollView *)scrollView {
    [self changeNavigationColor:scrollView];
    
    CGFloat personalInfoHeight = self.personalTopView.height - adaptHeight1334(80) - NAVIGATION_BAR_HEIGHT;
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY >= 0 && offsetY <= personalInfoHeight) {
        self.personalTopView.y = -offsetY;
    } else if (offsetY > personalInfoHeight) {
        self.personalTopView.y = - personalInfoHeight;
    } else if (offsetY < 0) {
        self.personalTopView.y = - offsetY;
    }
}

/**
 用户被永久封禁
 */
- (void)leadToUserPermanentBan {
    
    [XLEmptyDataView showEmptyDataInView:self.view withTitle:@"该用户发布违规内容\n已被管理员封禁" imageStr:@""];
    XLEmptyDataView *emptyView = [XLEmptyDataView emptyDataForView:self.view];
    emptyView.y = NAVIGATION_BAR_HEIGHT;
    emptyView.backgroundColor = [UIColor colorWithString:COLORF7F7F7];
    self.latestFeedList.tableView.scrollEnabled = NO;
    self.videoFeedList.tableView.scrollEnabled = NO;
    self.navigationAlphaView.alpha = 1;
    self.navigationAlphaBackButton.hidden = NO;
    self.navigationItem.leftBarButtonItem = nil;
}

#pragma mark
#pragma mark - PersonalTopView Delegate

- (void)didClickTopViewDynamicButton {
    if (self.scrollView.contentOffset.x > 0.5 * SCREEN_WIDTH) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        [self scrollViewDidEndDecelerating:self.scrollView];
    }
}

- (void)didClickTopViewVideoButton {
    if (self.scrollView.contentOffset.x < 0.5 * SCREEN_WIDTH) {
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
        [self scrollViewDidEndDecelerating:self.scrollView];
    }
}

- (void)didClickTopViewSegmentView:(NSInteger)selectedItemIndex {
    if (selectedItemIndex == 1) {
        [self addVideoTableView];
    }
}

- (void)didClickPersonalFollowButtonEvent:(XLPublisherModel *)model
                         withFollowButton:(FollowButton *)followButton {
    [self dealwithFollowButtonClickWithModel:model
                            withFollowButton:followButton];
}

- (void)followButtonClick:(FollowButton *)sender {
    [self dealwithFollowButtonClickWithModel:self.model
                            withFollowButton:sender];
}

- (void)dealwithFollowButtonClickWithModel:(XLPublisherModel *)model
                          withFollowButton:(FollowButton *)followButton {
    
    [self.navigationAlphaFollowButton startAnimation];
    [self.personalTopView.followButton startAnimation];
    
    [followButton startAnimation];
    
    [NewsApi followWithAuthorId:model.authorId
                         action:!followButton.followed
                        success:^(id responseDict) {
                            
                            if (followButton.followed) {
                                followButton.followed = NO;
                                
                            } else {
                                followButton.followed = YES;
                                [StatServiceApi statEvent:FOLLOW_CLICK model:model];
                                [MBProgressHUD showSuccess:@"关注成功"];
                            }
                            
                            self.navigationAlphaFollowButton.followed = followButton.followed;
                            self.personalTopView.followButton.followed = followButton.followed;
                            
                        } failure:^(NSInteger errorCode) {
                            [followButton stopAnimation];
                        }];
}

#pragma mark -
#pragma mark Private Method

#define BAR_BUTTON_ITEM_FOR_SOLID 982382176
#define BAR_BUTTON_ITEM_FOR_TRANSPARENT 982382177

- (void)changeNavigationColor:(UIScrollView *)scrollView {

    CGFloat offsetY = scrollView.contentOffset.y;

    // 修改导航栏背景色
    if (offsetY > 0 ) {
        if (offsetY > adaptHeight1334(246) - NAVIGATION_BAR_HEIGHT) {
            self.navigationAlphaView.alpha = 1;
            self.navigationAlphaBackButton.hidden = NO;
            if (self.navigationItem.leftBarButtonItem.tag != BAR_BUTTON_ITEM_FOR_SOLID) {
                UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, adaptWidth750(28), 22)];
                [backButton addTarget:self action:@selector(didClickBackeButtonEvent) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
                self.navigationItem.leftBarButtonItem = backButtonItem;
                self.navigationItem.leftBarButtonItem.tag = BAR_BUTTON_ITEM_FOR_SOLID;
            }
            self.navigationController.navigationBar.tintColor = [UIColor clearColor];
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
        } else {
            self.navigationAlphaBackButton.hidden = YES;
            self.navigationAlphaView.alpha = scrollView.contentOffset.y / (adaptHeight1334(246) - NAVIGATION_BAR_HEIGHT);
            self.navigationController.navigationBar.tintColor = [UIColor colorWithString: COLORffffff];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            
            if (self.navigationItem.leftBarButtonItem.tag != BAR_BUTTON_ITEM_FOR_TRANSPARENT) {
                UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, adaptWidth750(28), 22)];
                [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -adaptWidth750(10), 0, adaptWidth750(10))];
                [backButton setImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
                [backButton addTarget:self action:@selector(didClickBackeButtonEvent) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
                self.navigationItem.leftBarButtonItem = backButtonItem;
                self.navigationItem.leftBarButtonItem.tag = BAR_BUTTON_ITEM_FOR_TRANSPARENT;
            }
        }
    } else {
        self.navigationAlphaView.alpha = 0;
    }
    // 修改导航栏内容透明度
    if (offsetY + NAVIGATION_BAR_HEIGHT > self.personalTopView.followButton.origin.y + self.personalTopView.followButton.size.height / 2) {
        
        CGFloat followButtonOriginY = self.personalTopView.followButton.origin.y;
        CGFloat followButtonHalfHeight = self.personalTopView.followButton.size.height / 2;
        CGFloat halfHeihtShouldOffset = followButtonOriginY - NAVIGATION_BAR_HEIGHT + followButtonHalfHeight;

        self.navigationAlphaFollowButton.alpha = (offsetY - halfHeihtShouldOffset) / followButtonHalfHeight;
        self.navigationTitleLabel.alpha = (offsetY - halfHeihtShouldOffset) / followButtonHalfHeight;

    } else {
        self.navigationAlphaFollowButton.alpha = 0;
        self.navigationTitleLabel.alpha = 0;
    }
}

- (void)addVideoTableView {
    if (!self.videoTableHasAdd) {
        [self.scrollView addSubview:self.videoFeedList.view];
        [self addChildViewController:self.videoFeedList];
        self.videoTableHasAdd = YES;
    }
}

#pragma mark -
#pragma mark Event Response

- (void)didClickBackeButtonEvent {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Setter and Getters

- (PersonalScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[PersonalScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.xl_interactiveGestureConflict = YES;
        
        [_scrollView addSubview:self.latestFeedList.view];
        [self addChildViewController:self.latestFeedList];
      
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}

- (PersonalTopView *)personalTopView {
    if (!_personalTopView) {
        _personalTopView = [PersonalTopView new];
        _personalTopView.personalDelegate = self;
        _personalTopView.frame = CGRectMake(0, 0, SCREEN_WIDTH, adaptHeight1334(2 * (272 + 40 + 20)));
    }
    return _personalTopView;
}

- (UIView *)navigationAlphaView {
    if (!_navigationAlphaView) {
        CGRect frame = self.navigationController.navigationBar.frame;
        CGFloat statusBarHeight = IS_IPHONE_X ? STATUS_BAR_HEIGHT : 20;
        
        _navigationAlphaView = [[UIView alloc] initWithFrame:CGRectMake(0, -statusBarHeight, frame.size.width, frame.size.height+statusBarHeight)];
        _navigationAlphaView.backgroundColor = [UIColor colorWithString:COLORffffff];
        _navigationAlphaView.alpha = 0;

        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height + statusBarHeight - 0.5, SCREEN_WIDTH, 0.5)];
        lineLabel.backgroundColor = [UIColor colorWithString:COLORCACACA];
        [_navigationAlphaView addSubview:lineLabel];

        [_navigationAlphaView addSubview:self.navigationTitleLabel];
        [_navigationAlphaView addSubview:self.navigationAlphaBackButton];
        [_navigationAlphaView addSubview:self.navigationAlphaFollowButton];
        
        [self.navigationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self->_navigationAlphaView);
            make.centerY.equalTo(self->_navigationAlphaView).mas_offset(statusBarHeight/2);
        }];
        
        [self.navigationAlphaFollowButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(adaptWidth750(140));
            make.height.mas_equalTo(32);
            make.right.equalTo(self->_navigationAlphaView.mas_right).mas_offset(-adaptWidth750(28));
            make.centerY.equalTo(self->_navigationTitleLabel);
        }];
        
        [self.navigationAlphaBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(44);
            make.height.mas_equalTo(44);
            make.left.mas_equalTo(0);
            make.centerY.mas_equalTo(self->_navigationTitleLabel);
        }];
    }
    return _navigationAlphaView;
}

- (UIButton *)navigationAlphaBackButton {
    if (!_navigationAlphaBackButton) {
       _navigationAlphaBackButton = [[UIButton alloc] initWithFrame:CGRectMake(12, (NAVIGATION_BAR_HEIGHT - 20)/2 + adaptHeight1334(38)/2, 11, 19)];
        [_navigationAlphaBackButton setImage:[UIImage imageNamed:@"return_black"] forState:UIControlStateNormal];
        [_navigationAlphaBackButton addTarget:self
                                       action:@selector(didClickBackeButtonEvent)
                             forControlEvents:UIControlEventTouchUpInside];
        _navigationAlphaBackButton.hidden = YES;
    }
    return _navigationAlphaBackButton;
}

- (UILabel *)navigationTitleLabel {
    if (!_navigationTitleLabel) {
        _navigationTitleLabel = [[UILabel alloc] init];
        _navigationTitleLabel.font = [UIFont boldSystemFontOfSize:18];
        _navigationTitleLabel.textColor = [UIColor colorWithString:COLOR333333];
        _navigationTitleLabel.alpha = 0;
    }
    return _navigationTitleLabel;
}

- (FollowButton *)navigationAlphaFollowButton {
    if (!_navigationAlphaFollowButton) {
        _navigationAlphaFollowButton = [FollowButton buttonWithType:FollowButtonTypePersonal];
        _navigationAlphaFollowButton.alpha = 0;
        _navigationAlphaFollowButton.delegate = self;
        _navigationAlphaFollowButton.followed = self.model.isFollowed;

    }
    return _navigationAlphaFollowButton;
}

- (UIBarButtonItem *)navgationLeftItemButton {
    if (!_navgationLeftItemButton) {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 14, 22)];
        [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
        [backButton setImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(didClickBackeButtonEvent)
             forControlEvents:UIControlEventTouchUpInside];
        _navgationLeftItemButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return _navgationLeftItemButton;
}

- (XLMoreActionView *)moreActionView {
    if (!_moreActionView) {
        _moreActionView = [XLMoreActionView new];
        _moreActionView.delegate = self;
    }
    return _moreActionView;
}

- (BaseFeedListViewController *)videoFeedList {
    if (!_videoFeedList) {
        _videoFeedList = [PublisherVideoFeedListViewController new];
        _videoFeedList.delegate = self;
        _videoFeedList.personalModel = self.model;
        _videoFeedList.view.x = SCREEN_WIDTH;
    }
    return _videoFeedList;
}

- (BaseFeedListViewController *)latestFeedList {
    if (!_latestFeedList) {
        _latestFeedList = [PublisherLatestFeedListViewController new];
        _latestFeedList.delegate = self;
        _latestFeedList.personalModel = self.model;
    }
    return _latestFeedList;
}

- (UITableView *)dynamicTableView {
    if (!_dynamicTableView) {
        _dynamicTableView = self.latestFeedList.tableView;
        
        if (@available(iOS 11.0, *)) {
            _dynamicTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _dynamicTableView;
}

- (UITableView *)videoTableView {
    if (!_videoTableView) {
        _videoTableView = self.videoFeedList.tableView;
        if (@available(iOS 11.0, *)) {
            _videoTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _videoTableView;
}

@end
