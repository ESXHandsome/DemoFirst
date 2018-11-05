//
//  XLHomeVideoFeedListViewController.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/7/12.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLHomeVideoFeedListViewController.h"
#import "BaseFeedAuthorCell.h"
#import "XLHomeVideoFeedListViewModel.h"

@interface XLHomeVideoFeedListViewController ()

@end

@implementation XLHomeVideoFeedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)configureViewModel {
    self.viewModel = [XLHomeVideoFeedListViewModel new];
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
