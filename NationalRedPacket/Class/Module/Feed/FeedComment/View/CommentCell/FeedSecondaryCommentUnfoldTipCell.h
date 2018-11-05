//
//  FeedSecondaryCommentUnfoldTipCell.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/4/23.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "FeedCommentListRowModel.h"

@class FeedSecondaryCommentUnfoldTipCell;

@protocol FeedSecondaryCommentUnfoldTipCellDelegate <NSObject>

- (void)feedSecondaryCommentCell:(FeedSecondaryCommentUnfoldTipCell *)cell
loadMoreButtonDidClickWithRowModel:(FeedCommentListRowModel *)feedCommentListRowModel;

@end

@interface FeedSecondaryCommentUnfoldTipCell : BaseTableViewCell

@property (assign, nonatomic) BOOL isLoadMoreButtonShowDetail;
@property (assign, nonatomic) NSInteger secondaryCommentTotalCount;

@property (weak, nonatomic) id<FeedSecondaryCommentUnfoldTipCellDelegate> delegate;

- (void)startLoading;
- (void)stopLoading;

@end
