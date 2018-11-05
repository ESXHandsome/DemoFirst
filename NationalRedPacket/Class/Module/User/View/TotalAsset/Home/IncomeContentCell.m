//
//  IncomeContentCell.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/21.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "IncomeContentCell.h"
#import "IncomeListController.h"
#import "TotalAssetViewController.h"
#import "PersonalScrollView.h"

@interface IncomeContentCell ()<UIScrollViewDelegate>

@property (strong, nonatomic) PersonalScrollView   *containerView;
@property (strong, nonatomic) NSMutableArray       *vcArray;

@end

@implementation IncomeContentCell

- (void)setupViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.containerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kContentCellHeight);
    [self.contentView addSubview:self.containerView];
    
    [self confignChildViewController];

}

//数据赋值
- (void)updateGoldListView:(NSArray *)goldListArray
{
    IncomeListController *listVC = self.vcArray[0];
    listVC.dataArray = goldListArray;
    [listVC.tableView reloadData];
}
- (void)updateMoneyListView:(NSArray *)moneyListArray
{
    IncomeListController *listVC = self.vcArray[1];
    listVC.dataArray = moneyListArray;
    [listVC.tableView reloadData];
}

/**
 配置子控制器
 */
- (void)confignChildViewController
{
    self.vcArray = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        IncomeListController *listVC = [IncomeListController new];
        listVC.incomeType = i == 0 ? IncomeTypeGold : IncomeTypeMoney;
        [self.vcArray addObject:listVC];
        listVC.view.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, kContentCellHeight);
        [_containerView addSubview:listVC.view];
    }
}

/**
 切换子view
 
 @param index index
 */
-(void)switchChildViewControllerIndex:(NSInteger)index animated:(BOOL)animated
{
    IncomeListController *listVC = self.vcArray[index];
    //已经添加了，不必重复操作
    if(!listVC.view.window){
        listVC.view.frame = CGRectMake(SCREEN_WIDTH * index, 0, SCREEN_WIDTH, kContentCellHeight);
        [_containerView addSubview:listVC.view];
    }
    [self.containerView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:animated];
    if (animated == NO) {
        [((TotalAssetViewController *)self.viewController) setTableViewScroll:YES];
    }
}

/**
 滑动状态切换

 @param canScroll 滑动状态
 */
- (void)setCanScroll:(BOOL)canScroll
{
    _canScroll = canScroll;
    for (IncomeListController *listVC in self.vcArray) {
        listVC.canScroll = canScroll;
        if (!canScroll) {
            [listVC.tableView setContentOffset:CGPointZero];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat myFloat = scrollView.contentOffset.x;
    NSInteger index = myFloat / self.frame.size.width;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didSelectSegmentControlIndex:)]) {
        [self.delegate didSelectSegmentControlIndex:index];
    }
    [((TotalAssetViewController *)self.viewController) setTableViewScroll:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [((TotalAssetViewController *)self.viewController) setTableViewScroll:NO];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(scrollAnimationWithOffSet:)]) {
        [self.delegate scrollAnimationWithOffSet:scrollView.mj_offsetX];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [((TotalAssetViewController *)self.viewController) setTableViewScroll:YES];
}

#pragma mark - Lazy Loading
- (PersonalScrollView *)containerView
{
    if (!_containerView) {
        
        _containerView = [PersonalScrollView new];
        _containerView.backgroundColor = [UIColor colorWithString:COLORF6F6F6];
        _containerView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, kContentCellHeight);
        _containerView.pagingEnabled = YES;
        _containerView.delegate = self;
        _containerView.showsHorizontalScrollIndicator = NO;
        _containerView.showsVerticalScrollIndicator = NO;
        _containerView.xl_interactiveGestureConflict = YES;
    }
    return _containerView;
}

@end
