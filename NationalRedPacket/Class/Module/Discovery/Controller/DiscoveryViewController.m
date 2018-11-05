//
//  DiscoverViewController.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "DiscoverViewController.h"
#import "CategorySelectHeaderView.h"
#import "PublisherListViewController.h"
#import "DiscoveryViewModel.h"
#import "PublisherViewModel.h"

@interface DiscoveryViewController () <CategorySelectHeaderViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) CategorySelectHeaderView *categorySelectView;
@property (strong, nonatomic) UIScrollView             *containerView;

@property (strong, nonatomic) DiscoveryViewModel       *viewModel;
///此参数用于判断是否是点击按钮的分类联动
@property (assign, nonatomic) BOOL                     isClickCategoryButton;

@end

@implementation DiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavigationBar];
    [self fetchCategoryList];
}

/**
 获取分类列表
 */
- (void)fetchCategoryList
{
    [XLLoadingView showLoadingInView:self.view];
    [self.viewModel fetchCategoryListSuccess:^(id responseArray) {
        [XLLoadingView hideLoadingForView:self.view];
        [self setupSubviews];
        
    } failure:^(NSInteger errorCode) {
        [XLLoadingView hideLoadingForView:self.view];
        [XLReloadFailView showReloadFailInView:self.view offSet:adaptHeight1334(80) reloadAction:^{
            [self fetchCategoryList];
        }];
    }];
}

/**
 配置子View
 */
- (void)setupSubviews
{
    [self.navigationController.navigationBar addSubview:self.categorySelectView];
    [self.view addSubview:self.containerView];
    //添加子控制器
    [self configChildViewController];
    //添加第一个子控制器的View
    [self addChildViewControllerViews:0];
}

/**
 设置navigation
 */
- (void)setupNavigationBar
{
    self.navigationItem.title = @"";
    if (@available(iOS 11.0, *)) {
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

/**
 添加子控制器
 */
- (void)configChildViewController
{
    [self.viewModel.categoryListArray enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        PublisherListViewController *listVC = [PublisherListViewController new];
        listVC.viewModel = [[PublisherViewModel alloc] initWithCategoryTitle:title];
        [self addChildViewController:listVC];
    }];
}

/**
 添加子控制器view视图

 @param index index
 */
-(void)addChildViewControllerViews:(NSInteger)index
{
    [self addChildViewControllerViewForIndex:index];
    //预加载 后两个分类列表
    [self addChildViewControllerViewForIndex:index + 1];
    [self addChildViewControllerViewForIndex:index + 2];
}

- (void)addChildViewControllerViewForIndex:(NSInteger)index
{
    if (index > self.childViewControllers.count - 1) {
        return;
    }
    PublisherListViewController *listVC = self.childViewControllers[index];
    //已经添加了，不必重复操作
    if(!listVC.view.window){
        listVC.view.frame = CGRectMake(SCREEN_WIDTH * index, 0, SCREEN_WIDTH, self.containerView.height);
        [self.containerView addSubview:listVC.view];
    }
}

#pragma mark - ContainerViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isClickCategoryButton) {
        return;
    }
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / self.view.frame.size.width;
    CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
    [self addChildViewControllerViews:index];
    if (translatedPoint.x > 0 && (offsetX / self.view.frame.size.width) > index){
        return;
    }
    [self.categorySelectView selectCategoryIndex:index];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isClickCategoryButton = NO;  //开始拖拽时开启
}

#pragma mark - CategorySelectHeaderViewDelegate
- (void)categorySelectView:(CategorySelectHeaderView *)categorySelectView didSelectCategory:(NSInteger)categoryIndex
{
    self.isClickCategoryButton = YES;  //禁止滚动代理方法执行操作
    [self.containerView setContentOffset:CGPointMake(categoryIndex * SCREEN_WIDTH, 0) animated:NO];
    [self addChildViewControllerViews:categoryIndex];
}

#pragma mark - Lazying load

- (CategorySelectHeaderView *)categorySelectView
{
    if (!_categorySelectView) {
        self.categorySelectView = [CategorySelectHeaderView new];
        [self.categorySelectView cofigureDelegate:self dataArray:self.viewModel.categoryListArray];
    }
    return _categorySelectView;
}

- (UIScrollView *)containerView
{
    if (!_containerView) {
        
        self.containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT)];
        self.containerView.backgroundColor = [UIColor whiteColor];
        self.containerView.contentSize = CGSizeMake(SCREEN_WIDTH * self.viewModel.categoryListArray.count, self.containerView.height);
        self.containerView.pagingEnabled = YES;
        self.containerView.delegate = self;
        self.containerView.showsHorizontalScrollIndicator = NO;
        self.containerView.showsVerticalScrollIndicator = NO;
    }
    return _containerView;
}

- (DiscoveryViewModel *)viewModel
{
    if (!_viewModel) {
        self.viewModel = [DiscoveryViewModel new];
    }
    return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
