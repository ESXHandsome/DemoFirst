//
//  XLHomeViewController.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/7/13.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLHomeViewController.h"
#import "XLFeedClassifySelectView.h"
#import "HomeFollowFeedListViewController.h"
#import "HomePopularFeedListViewController.h"
#import "XLHomeVideoFeedListViewController.h"
#import "XLHomeImageFeedListViewController.h"
#import "GifPlayManager.h"
#import "UITableView+VideoPlay.h"
#import "RewardManager.h"

@interface XLHomeViewController () <XLFeedClassifySelectViewDelegate, UIScrollViewDelegate, HomeFollowFeedListViewControllerDelegate>

@property (strong, nonatomic) XLFeedClassifySelectView *classifySelectView;
@property (strong, nonatomic) UIScrollView             *containerView;
@property (strong, nonatomic) NSMutableArray           *childClassStringArray;
@property (strong, nonatomic) NSMutableArray           *childTitleStringArray;
@property (strong, nonatomic) NSMutableArray           *pageClickStatStringArray;
@property (strong, nonatomic) NSMutableArray           *pageDurationStatStringArray;

///此参数用于判断是否是点击按钮的分类联动
@property (assign, nonatomic) BOOL                     isClickCategoryButton;

@property (assign, nonatomic) NSInteger                lastIndex;

@end

@implementation XLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"";
    self.lastIndex = 1;
    
    [self setupSubviews];
    
    // 检查登录奖励
    [RewardManager checkAndDealwithLoginReward];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchDownNewDataNotification) name:@"FetchNewData" object:nil];
    
}

/**
 配置子View
 */
- (void)setupSubviews {
    
    [self.navigationController.navigationBar addSubview:self.classifySelectView];
    [self.view addSubview:self.containerView];
    //添加子控制器
    [self configChildViewController];
    //添加第一个子控制器的View
    [self addChildViewControllerViews:1];
}

/**
 添加子控制器
 */
- (void)configChildViewController {
    
    [self.childClassStringArray enumerateObjectsUsingBlock:^(NSString *classString, NSUInteger idx, BOOL * _Nonnull stop) {
        BaseFeedListViewController *listVC = [NSClassFromString(classString) new];
        if ([listVC isKindOfClass:[HomeFollowFeedListViewController class]]) {
            ((HomeFollowFeedListViewController *)listVC).delegate = self;
        }
        [self addChildViewController:listVC];
    }];
}

/**
 添加子控制器view视图
 
 @param index index
 */
-(void)addChildViewControllerViews:(NSInteger)index {
    
    if (self.lastIndex != index) {
        
        [self feedListViewStatAndSwitchForIndex:index];
        
        self.lastIndex = index;
    }
    
    [self addChildViewControllerViewForIndex:index];
    //预加载 所有分类列表
    [self addChildViewControllerViewForIndex:index + 1];
    [self addChildViewControllerViewForIndex:index + 2];
    [self addChildViewControllerViewForIndex:index + 3];
}

- (void)addChildViewControllerViewForIndex:(NSInteger)index {
    
    if (index > self.childViewControllers.count - 1) {
        index = 0;
    }
    BaseFeedListViewController *listVC = self.childViewControllers[index];
    //已经添加了，不必重复操作
    if(!listVC.view.window){
        listVC.view.frame = CGRectMake(SCREEN_WIDTH * index, 0, SCREEN_WIDTH, self.containerView.height);
        [self.containerView addSubview:listVC.view];
    }
}

#pragma mark - PageStatAndSwitch

- (void)feedListViewStatAndSwitchForIndex:(NSInteger)index {
    
    BaseFeedListViewController *lastVC = self.childViewControllers[self.lastIndex];
    BaseFeedListViewController *currentVC = self.childViewControllers[index];
    
    [StatServiceApi statEvent:HOME_FEED_TYPE_CLICK model:nil otherString:self.pageClickStatStringArray[index]];
    [StatServiceApi statEventEnd:self.pageDurationStatStringArray[self.lastIndex]];
    
    //上一个控制器将要消失
    [lastVC viewWillDisappear:YES];
    
    [[GifPlayManager sharedManager] statEndImageCell];
    [lastVC.tableView statVideoPreview];
    
    //上一个控制器已经消失
    [lastVC viewDidDisappear:YES];
    
    //目前控制器将要显示
    [currentVC viewWillAppear:YES];
    
    //自动播放当前Feed动图
    [[GifPlayManager sharedManager] playGifCell];
    //自动播放当前Feed视频
    [currentVC autoPlayVideoWithVisibleCheck:NO];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //跟踪页面的特殊处理，因为页面消失时，子控制器也会调用viewDidDisappear，最后一个控制器永远是ViEW_IMAGE，所以这里延迟让当前的控制器调用一下viewDidDisappear，保证lastVC正确
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat offsetX = self.containerView.contentOffset.x;
        NSInteger index = offsetX / self.view.frame.size.width;
        BaseFeedListViewController *listVC = self.childViewControllers[index];
        [listVC viewDidDisappear:animated];
    });
}

#pragma mark - Notification Event

- (void)fetchDownNewDataNotification {
    
    CGFloat offsetX = self.containerView.contentOffset.x;
    NSInteger index = offsetX / self.view.frame.size.width;
    BaseFeedListViewController *listVC = self.childViewControllers[index];
    [listVC.tableView.mj_header beginRefreshing];
    
}

#pragma mark - HomeFollowFeedListViewControllerDelegate

- (void)feedList:(HomeFollowFeedListViewController *)feedList didChangedFollowingFeedState:(BOOL)isHasNewFeed {
    [self.classifySelectView showClassifyRedDotTip:isHasNewFeed index:0];
}

#pragma mark - ContainerViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (self.isClickCategoryButton) {
        return;
    }
    [self.classifySelectView scrollAnimationView:scrollView];
    
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / self.view.frame.size.width;
    CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
    if (translatedPoint.x > 0) { //左滑
        if (offsetX / self.view.frame.size.width > index) {
            return;
        }
    }
    [self addChildViewControllerViews:index];
    if (translatedPoint.x > 0 && (offsetX / self.view.frame.size.width) > index){
        return;
    }
    [self.classifySelectView selectClassifyIndex:index];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isClickCategoryButton = NO;  //开始拖拽时开启
}

#pragma mark - XLFeedClassifySelectViewDelegate

- (void)classifySelectView:(XLFeedClassifySelectView *)selectView didSelectClassify:(NSInteger)index {
    self.isClickCategoryButton = YES;  //禁止滚动代理方法执行操作
    [self.containerView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:NO];
    [self addChildViewControllerViews:index];
}

#pragma mark - Lazying load

- (XLFeedClassifySelectView *)classifySelectView {
    
    if (!_classifySelectView) {
        self.classifySelectView = [XLFeedClassifySelectView new];
        [self.classifySelectView cofigureDelegate:self dataArray:nil];
    }
    return _classifySelectView;
}

- (UIScrollView *)containerView {
    
    if (!_containerView) {
        
        self.containerView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        self.containerView.backgroundColor = [UIColor whiteColor];
        self.containerView.contentSize = CGSizeMake(SCREEN_WIDTH * self.childTitleStringArray.count, self.containerView.height);
        self.containerView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        self.containerView.pagingEnabled = YES;
        self.containerView.bounces = NO;
        self.containerView.delegate = self;
        self.containerView.showsHorizontalScrollIndicator = NO;
        self.containerView.showsVerticalScrollIndicator = NO;
        self.containerView.xl_interactiveGestureConflict = YES;
        if (@available(iOS 11.0, *)) {
            self.containerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _containerView;
}

- (NSMutableArray *)childClassStringArray {
    if (!_childClassStringArray) {
        self.childClassStringArray = [NSMutableArray arrayWithCapacity:4];
        [self.childClassStringArray addObject:NSStringFromClass(HomeFollowFeedListViewController.class)];
        [self.childClassStringArray addObject:NSStringFromClass(HomePopularFeedListViewController.class)];
        [self.childClassStringArray addObject:NSStringFromClass(XLHomeVideoFeedListViewController.class)];
        [self.childClassStringArray addObject:NSStringFromClass(XLHomeImageFeedListViewController.class)];
    }
    return _childClassStringArray;
}

- (NSMutableArray *)childTitleStringArray {
    if (!_childTitleStringArray) {
        self.childTitleStringArray = @[@"关注", @"推荐", @"视频", @"趣图"].mutableCopy;
    }
    return _childTitleStringArray;
}

#pragma mark - Stat

- (NSMutableArray *)pageClickStatStringArray {
    if (!_pageClickStatStringArray) {
        self.pageClickStatStringArray = @[@"attention", @"hot", @"video", @"image"].mutableCopy;
    }
    return _pageClickStatStringArray;
}

- (NSMutableArray *)pageDurationStatStringArray {
    if (!_pageDurationStatStringArray) {
        self.pageDurationStatStringArray = @[FOLLOWING_FEED_PAGE_DURATION, HOME_PAGE_DURATION, HOME_VIDEO_PAGE_DURATION, HOME_IMAGE_PAGE_DURATION].mutableCopy;
    }
    return _pageDurationStatStringArray;
}

@end
