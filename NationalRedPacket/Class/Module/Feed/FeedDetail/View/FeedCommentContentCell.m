//
//  FeedCommentListCell.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/7.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "FeedCommentContentCell.h"
#import "FeedCommentSectionHeaderView.h"

@implementation FeedCommentContentCell

- (instancetype)initWithFeedModel:(FeedDetailViewModel *)viewModel {
    
    self = [super init];
    if (self) {
        [self setupViewsWithFeedModel:viewModel];
    }
    return self;
}

- (void)setupViewsWithFeedModel:(FeedDetailViewModel *)viewModel {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kFeedCommentListHeight + kSectionHeight);
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.frame];
    [self.contentView addSubview:scrollView];

    FeedCommentListViewController *listVC = [[FeedCommentListViewController alloc] initWithFeed:viewModel.feed];
    self.commentListVC = listVC;
    self.commentListVC.refreshAnimation = viewModel.isShowCommentRefreshAnination;
    self.commentListVC.appointCommentScroll = viewModel.isAppointCommentScroll;
    self.commentListVC.appointCommentId = viewModel.appointCommentId;
    self.commentListVC.appointSecondCommentId = viewModel.appointSecondCommentId;
    
    [scrollView addSubview:listVC.view];
    [scrollView addSubview:listVC.tableView];
    
    listVC.view.frame = self.contentView.frame;
    listVC.tableView.frame = listVC.view.frame;
    
    self.canScroll = NO;
    
}

/**
 滑动状态切换
 
 @param canScroll 滑动状态
 */
- (void)setCanScroll:(BOOL)canScroll
{
    _canScroll = canScroll;
    self.commentListVC.canScroll = canScroll;
    if (!canScroll) {
        [self.commentListVC.tableView setContentOffset:CGPointZero];
    }
}

@end
