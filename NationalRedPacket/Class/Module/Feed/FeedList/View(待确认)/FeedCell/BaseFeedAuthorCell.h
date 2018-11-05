//
//  BaseWithAuthorCell.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/2/19.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFeedCell.h"
#import "TopAuthorView.h"
#import "CommentContainerView.h"
#import "FeedCellDelegate.h"
#import "FeedCommentListViewController.h"

@interface BaseFeedAuthorCell : BaseFeedCell <TopAuthorViewDelegate, CommentContainerViewDelegate>

@property (strong, nonatomic) TopAuthorView *topAuthorView;
@property (strong, nonatomic) CommentContainerView *commentContainerView;
@property (strong, nonatomic) FeedCommentListViewController *commentListVC;
@property (strong, nonatomic) UITableView   *commentTableView;
@property (weak, nonatomic) id<FeedCellDelegate> cellDelegate;

- (void)hiddenFollowButton:(BOOL)hidden;
- (void)updateDataWithModel:(XLFeedModel *)model;
- (void)hiddenPublishTimeLabel;
- (void)setupAuthorCellSubViews;

@end
