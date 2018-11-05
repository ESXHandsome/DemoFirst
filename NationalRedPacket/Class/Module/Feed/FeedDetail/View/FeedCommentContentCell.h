//
//  FeedCommentListCell.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/7.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedCommentListViewController.h"
#import "FeedDetailViewModel.h"

#define kFeedCommentListHeight (SCREEN_HEIGHT - TAB_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - adaptHeight1334(44*2))

@interface FeedCommentContentCell : UITableViewCell

@property (assign, nonatomic) BOOL canScroll;
@property (strong, nonatomic) FeedCommentListViewController *commentListVC;

- (instancetype)initWithFeedModel:(FeedDetailViewModel *)viewModel;

@end
