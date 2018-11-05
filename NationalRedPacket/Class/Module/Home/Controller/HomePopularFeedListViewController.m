//
//  HomePopularFeedListViewController.m
//  NationalRedPacket
//
//  Created by fensi on 2018/5/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "HomePopularFeedListViewController.h"
#import "HomePopularFeedListViewModel.h"
#import "BaseFeedAuthorCell.h"
#import "FeedCommentListRowModel.h"
#import "XLAppletsView.h"
#import "FloatViewManager.h"
#import "XLStartConfigManager.h"
#import "NewUserGestureGuideView.h"
#import "XLH5WebViewController.h"

@interface HomePopularFeedListViewController () < XLAppletsViewDelegate ,NewUserGestureGuideViewDelegate>

@end

@implementation HomePopularFeedListViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configH5AppletsView];
    
    [self newUserGestureGuide];
}

#pragma mark -
#pragma mark - 新手引导

- (void)newUserGestureGuide {
    /**是否需要新手引导*/
    if (![[NSUserDefaults standardUserDefaults] objectForKey:XLUserDefaultNewUserGestureGuide] &&
        XLStartConfigManager.shared.startConfigModel.hotPageLeadImg == 1) {
        /**新用户手势引导页*/
        NewUserGestureGuideView *guideView = [[NewUserGestureGuideView alloc] init];
        guideView.delegate = self;
        guideView.frame = self.view.frame;
        [[UIApplication sharedApplication].keyWindow addSubview:guideView];
        [guideView showGestureAnimation];
    }
}

- (void)configH5AppletsView {
    
    if ([FloatViewManager sharedInstance].appletsArray && [FloatViewManager sharedInstance].appletsArray.count > 0) {
        XLAppletsView *headerView = [[XLAppletsView alloc] init];
        headerView.delegate = self;
        headerView.height = adaptHeight1334(109*2);
        [headerView congifCell:[FloatViewManager sharedInstance].appletsArray];
        self.tableView.tableHeaderView = headerView;
    }
}

- (void)configureViewModel {
    self.viewModel = [HomePopularFeedListViewModel new];
}

- (void)reloadModel:(XLFeedModel *)model atIndexPath:(NSIndexPath *)indexPath {
    [super reloadModel:model atIndexPath:indexPath];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [[(BaseFeedAuthorCell *)cell topAuthorView] setPublishTime:model.createdTime.integerValue];
}

#pragma mark -
#pragma mark - applets view delegate

- (void)didSelectItemToPushWebView:(NSString *)urlString {
    XLH5WebViewController *webViewController = [[XLH5WebViewController alloc] init];
    webViewController.urlString = urlString;
    [self showViewController:webViewController sender:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        
    if ([cell isKindOfClass:BaseFeedCell.class]) {
        [[(BaseFeedCell *)cell lineView] mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(adaptHeight1334(20));
        }];
    }
    if ([cell isKindOfClass:BaseFeedAuthorCell.class]) {
        XLFeedModel *model = self.viewModel.dataSource.elements[indexPath.row];
        [[(BaseFeedAuthorCell *)cell topAuthorView] setPublishTime:model.createdTime.integerValue];
        [(BaseFeedAuthorCell *)cell topAuthorView].negativeFeedbackDelegate = self;
        [[(BaseFeedAuthorCell *)cell topAuthorView] showFeedbackButton];
        [[(BaseFeedAuthorCell *)cell topAuthorView] hiddenPublishLabel];
    }
    return cell;
}

#pragma mark -
#pragma mark - NewUserGestureGuideViewDelegate

- (void)gestureGuideViewWillDisappear {
    [FloatViewManager.sharedInstance showH5AlertView];
}

#pragma mark - Custom Accessors

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

@end
