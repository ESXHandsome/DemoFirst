//
//  PublisherVideoFeedListViewController.m
//  NationalRedPacket
//
//  Created by fensi on 2018/5/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "PublisherVideoFeedListViewController.h"
#import "PublisherVideoFeedListViewModel.h"
#import "BaseFeedAuthorCell.h"

@interface PublisherVideoFeedListViewController ()

@end

@implementation PublisherVideoFeedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)configureViewModel {
    
    PublisherVideoFeedListViewModel *viewModel = [PublisherVideoFeedListViewModel new];
    viewModel.personalModel = self.personalModel;
    
    self.viewModel = viewModel;
    
}

#pragma mark - UITableViewDataSource

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [super scrollViewDidScroll:scrollView];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedList:scrollViewDidScroll:)]) {
        [self.delegate feedList:self scrollViewDidScroll:scrollView];
    }
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
    return @"暂无视频";
}

- (NSString *)emptyImageName {
    return @"personal_novideo";
}

- (CGFloat)tableHeaderViewHeight {
    return adaptHeight1334(2 * (292+40)) - NAVIGATION_BAR_HEIGHT;
}

@end
