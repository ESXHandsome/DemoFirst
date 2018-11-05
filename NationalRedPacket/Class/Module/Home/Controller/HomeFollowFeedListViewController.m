//
//  HomeFollowFeedListViewController.m
//  NationalRedPacket
//
//  Created by fensi on 2018/5/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "HomeFollowFeedListViewController.h"
#import "HomeFollowFeedListViewModel.h"
#import "DiscoverGuidanceView.h"
#import "BaseFeedAuthorCell.h"

@interface HomeFollowFeedListViewController () <HomeFollowFeedListViewModelDelegate>

@property (strong, nonatomic) DiscoverGuidanceView *discoverGuidanceView;

@end

@implementation HomeFollowFeedListViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configureViewModel {
    
    HomeFollowFeedListViewModel *viewModel = [HomeFollowFeedListViewModel new];
    viewModel.delegate = self;
    
    self.viewModel = viewModel;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:BaseFeedCell.class]) {
        [[(BaseFeedCell *)cell lineView] mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(adaptHeight1334(20));
        }];
        if ([cell isKindOfClass:BaseFeedAuthorCell.class]) {
            [(BaseFeedAuthorCell *)cell hiddenPublishTimeLabel];
        }
    }
    return cell;
}

#pragma mark - HomeFollowFeedListViewModelDelegate

- (void)didChangedFollowingFeedState:(BOOL)isHasNewFeed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedList:didChangedFollowingFeedState:)]) {
        [self.delegate feedList:self didChangedFollowingFeedState:isHasNewFeed];
    }
}

- (void)showDiscoverGuidance {
    [self.discoverGuidanceView removeFromSuperview];
    [self.view addSubview:self.discoverGuidanceView];
    self.discoverGuidanceView.frame = CGRectMake(SCREEN_WIDTH/5 + SCREEN_WIDTH/10 - adaptWidth750(149), SCREEN_HEIGHT - TAB_BAR_HEIGHT - 12 - adaptHeight1334(2*137), adaptWidth750(2*149), adaptHeight1334(2*137));
}

- (void)hideDiscoverGuidance {
    [self.discoverGuidanceView removeFromSuperview];
    self.discoverGuidanceView = nil;
}

#pragma mark - Custom Accessors

- (DiscoverGuidanceView *)discoverGuidanceView {
    if (!_discoverGuidanceView) {
        _discoverGuidanceView = [DiscoverGuidanceView new];
    }
    return _discoverGuidanceView;
}

- (CGFloat)tableViewHeight {
    return SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT;
}

- (BOOL)isNeedTopTip {
    return YES;
}

- (BOOL)isNeedRefreshHeader {
    return YES;
}

- (BOOL)isNeedRefreshFloat {
    return YES;
}

- (NSString *)emptyTitle {
    return XLAlertNoFollowing;
}

- (NSString *)emptyImageName {
    return @"no_person";
}

@end
