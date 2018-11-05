//
//  UserCollectionFeedListViewController.m
//  NationalRedPacket
//
//  Created by fensi on 2018/5/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "UserCollectionFeedListViewController.h"
#import "UserCollectionFeedListViewModel.h"
#import "BaseFeedAuthorCell.h"

@interface UserCollectionFeedListViewController ()

@end

@implementation UserCollectionFeedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的收藏";
}

- (void)configureViewModel {
    self.viewModel = [UserCollectionFeedListViewModel new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:BaseFeedAuthorCell.class]) {
        [[(BaseFeedAuthorCell *)cell topAuthorView] hiddenFollowButton:NO];
    }
    
    return cell;
}

- (NSString *)emptyTitle {
    return @"你还没有收藏任何东西";
}

- (NSString *)emptyImageName {
    return @"my_collection_empty";
}

- (CGFloat)emptyViewOffset {
    return 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

@end
