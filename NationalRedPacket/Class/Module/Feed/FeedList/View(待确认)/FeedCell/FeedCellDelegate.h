//
//  FeedCellDelegate.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/2/19.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XLFeedModel;
@class FollowButton;

@protocol FeedCellDelegate <NSObject>

@optional

- (void)didClickCellPraiseButtonEvent:(XLFeedModel *)model;
- (void)didClickCellTreadButtonEvent:(XLFeedModel *)model;
- (void)didClickCellCommentButtonEvent:(XLFeedModel *)model;
- (void)didClickCellForwardButtonEvent:(XLFeedModel *)model;
- (void)didClickCellSuperCommentButtonEvent:(XLFeedModel *)model;

- (void)didClickAvatarButtonEvent:(XLFeedModel *)model;
- (void)didClickFollowButtonEvent:(XLFeedModel *)model
                 withFollowButton:(FollowButton *)followButton;

- (void)tableCell:(UITableViewCell *)cell deleteModel:(XLFeedModel *)model;

- (void)didClickManagementSpecificationButtonEvent:(XLFeedModel *)model;

@end

