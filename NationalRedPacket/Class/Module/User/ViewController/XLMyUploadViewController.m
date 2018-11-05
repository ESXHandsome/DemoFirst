//
//  XLMyUploadViewController.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/12.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLMyUploadViewController.h"
#import "XLFeedDataSource.h"
#import "BaseFeedAuthorCell.h"
#import "XLMyUploadViewModel.h"

@interface XLMyUploadViewController () <UIGestureRecognizerDelegate>

@end

@implementation XLMyUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的帖子";
    if (self.isUploadAlertPush) {
        BaseNavigationController * nav = (BaseNavigationController *)self.navigationController.navigationController;
        nav.enableRightGesture = NO;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:GetImage(@"return_black") style:normal target:self action:@selector(cancelButtonAction)];
    }
    
}

- (void)cancelButtonAction {
    if ([self.delegate respondsToSelector:@selector(didClickCancelButton)]) {
        [self.delegate didClickCancelButton];
    }
}

- (void)configureViewModel {
    self.viewModel = [XLMyUpLoadViewModel new];
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
    return @"你还没有发布过任何帖子";
}

- (NSString *)emptyImageName {
    return @"my_like_empty";
}

- (CGFloat)emptyViewOffset {
    return -10;
}

- (void)viewDidDisappear:(BOOL)animated {
//    BaseNavigationController * nav = (BaseNavigationController *)self.navigationController;
//    nav.enableRightGesture = YES;
}

@end
