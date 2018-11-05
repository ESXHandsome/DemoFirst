//
//  FeedSecondaryCommentCell.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/4/23.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "FeedCommentListRowModel.h"

@class FeedSecondaryCommentCell;

@protocol FeedSecondaryCommentCellDelegate <NSObject>

- (void)feedSecondaryCommenCell:(FeedSecondaryCommentCell *)cell nickNameDidClickWithAuthorID:(NSString *)authorID;

- (void)feedSecondaryCommentCell:(FeedSecondaryCommentCell *)cell deletedWithRowModel:(FeedCommentListRowModel *)feedCommentListRowModel;

- (void)feedSecondaryCommentCell:(FeedSecondaryCommentCell *)cell reportedWithRowModel:(FeedCommentListRowModel *)feedCommentListRowModel;

- (void)feedSecondaryCommentCell:(FeedSecondaryCommentCell *)cell replyWithRowModel:(FeedCommentListRowModel *)feedCommentListRowModel;

@end

@interface FeedSecondaryCommentCell : BaseTableViewCell

@property (weak, nonatomic) id<FeedSecondaryCommentCellDelegate> delegate;

@end
