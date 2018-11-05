//
//  PublisherDynamicFeedListViewController.m
//  NationalRedPacket
//
//  Created by fensi on 2018/5/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "PublisherLatestFeedListViewController.h"
#import "PublisherLatestFeedListViewModel.h"
#import "BaseFeedAuthorCell.h"

@interface PublisherLatestFeedListViewController ()

@end

@implementation PublisherLatestFeedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)configureViewModel {
    
    PublisherLatestFeedListViewModel *viewModel = [PublisherLatestFeedListViewModel new];
    viewModel.personalModel = self.personalModel;
    
    self.viewModel = viewModel;
    
}

- (void)showLoadFailed {
    [super showLoadFailed];
    
    //如果是用户被封禁，则显示封禁页面
    if (((PublisherLatestFeedListViewModel *)self.viewModel).isPermanentBan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(leadToUserPermanentBan)]) {
            [self.delegate leadToUserPermanentBan];
        }
    }
}

#pragma mark - UITableViewDataSource

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [super scrollViewDidScroll:scrollView];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedList:scrollViewDidScroll:)]) {
        [self.delegate feedList:self scrollViewDidScroll:scrollView];
    }
}

- (BOOL)isAutoRefreshForFirstTime {
    return NO;
}

- (CGFloat)loadingViewOffset {
    return 150;
}

- (CGFloat)loadFailViewOffset {
    return 320;
}

- (CGFloat)emptyViewOffset {
    return 160;
}

- (NSString *)emptyTitle {
    return @"暂无动态";
}

- (NSString *)emptyImageName {
    return @"personal_nodynamic";
}

- (CGFloat)tableHeaderViewHeight {
    return adaptHeight1334(2 * (292+40)) - NAVIGATION_BAR_HEIGHT;
}

@end
