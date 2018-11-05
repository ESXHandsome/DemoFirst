//
//  UserLikeFeedListViewController.m
//  NationalRedPacket
//
//  Created by fensi on 2018/5/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "UserLikeFeedListViewController.h"
#import "UserLikeFeedListViewModel.h"
#import "XLFeedDataSource.h"
#import "BaseFeedAuthorCell.h"

@interface UserLikeFeedListViewController ()

@end

@implementation UserLikeFeedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的赞";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)configureViewModel {
    self.viewModel = [UserLikeFeedListViewModel new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:BaseFeedAuthorCell.class]) {
        [[(BaseFeedAuthorCell *)cell topAuthorView] hiddenFollowButton:NO];
    }
    
    return cell;
}

- (void)reloadModel:(XLFeedModel *)model atIndexPath:(NSIndexPath *)indexPath {
    
    [super reloadModel:model atIndexPath:indexPath];
    
    [self removeNoPraiseCellWithIndex:indexPath.row model:model];
}

- (void)didClickCellPraiseButtonEvent:(XLFeedModel *)model {
    
    [super didClickCellPraiseButtonEvent:model];
    
    [self removeNoPraiseCellWithIndex:[self.viewModel.dataSource.elements indexOfObject:model] model:model];
}

- (void)removeNoPraiseCellWithIndex:(NSInteger)index model:(XLFeedModel *)model {
    
    if (model.isPraise) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    [self.viewModel.dataSource removeElementAtIndex:index];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    if (!self.viewModel.dataSource.elements.count) {
        [self showEmpty];
    }
}

- (NSString *)emptyTitle {
    return @"你还没有点赞任何人";
}

- (NSString *)emptyImageName {
    return @"my_like_empty";
}

- (CGFloat)emptyViewOffset {
    return -10;
}
@end
