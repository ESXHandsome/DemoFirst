//
//  FeedCommentCell.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/23.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "FeedCommentListRowModel.h"
#import "XLPhotoShowView.h"
#import "XLMenuAttributedLabel.h"

@class FeedCommentCell, FLAnimatedImageView;

@protocol FeedCommentCellDelegate <NSObject>

/**
 评论点赞按钮

 @param cell 点击的cell
 @param praiseButton 点击的button
 @param rowModel 模型
 */
- (void)feedCommentCell:(FeedCommentCell *)cell didSelectPraiseButton:(UIButton *)praiseButton forRow:(FeedCommentListRowModel *)rowModel;

/**
 删除评论

 @param cell 点击的cellz
 @param rowModel 模型
 */
- (void)feedCommentCell:(FeedCommentCell *)cell deleteRow:(FeedCommentListRowModel *)rowModel;

/**
 回复评论
 
 @param cell 点击的cell
 @param rowModel 模型
 */
- (void)feedCommentCell:(FeedCommentCell *)cell replyRow:(FeedCommentListRowModel *)rowModel;

/**
 点击头像和昵称
 
 @param cell 点击的cell
 @param rowModel 模型
 */
- (void)feedCommentCell:(FeedCommentCell *)cell didSelectAvatarAndNicknameForRow:(FeedCommentListRowModel *)rowModel;

/**
 举报
 
 @param cell 点击的cell
 @param rowModel 模型
 */
- (void)feedCommentCell:(FeedCommentCell *)cell reportRow:(FeedCommentListRowModel *)rowModel;

/**
 全文按钮
 
 @param cell 点击的cell
 @param rowModel 模型
 */
- (void)feedCommentCell:(FeedCommentCell *)cell fullTextRow:(FeedCommentListRowModel *)rowModel;

/**
 点击了评论的cell的imageView
 
 @param cell 点击的cell
 @param imageView imageView
 @param rowModel 模型
 */
- (void)feedCommentCell:(FeedCommentCell *)cell didSelectContentImageView:(FLAnimatedImageView *)imageView forRow:(FeedCommentListRowModel *)rowModel;

/**
 cell的imageView
 
 @param cell 点击的cell
 @param rowModel 模型
 */
- (void)feedCommentCell:(FeedCommentCell *)cell didDismissImageBrowserForRow:(FeedCommentListRowModel *)rowModel;

@end

static NSString *const FeedCommentCellID = @"FeedCommentCellID";

@interface FeedCommentCell : BaseTableViewCell <PPSPhotoShowViewDelegate>

@property (weak, nonatomic) id <FeedCommentCellDelegate>delegate;

@property (strong, nonatomic) UIImageView                *headImageView;
@property (strong, nonatomic) UILabel                    *usernameLabel;
@property (strong, nonatomic) XLMenuAttributedLabel      *contentLabel;
@property (strong, nonatomic) FLAnimatedImageView        *contentImageView;
@property (strong, nonatomic) UILabel                    *timeLabel;
@property (strong, nonatomic) UIButton                   *replyButton;

@end
