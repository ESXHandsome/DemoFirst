//
//  FeedCommentListSectionModel.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/23.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedCommentListRowModel.h"

typedef void(^FeedCommentRowsChangedBlock)(NSArray<NSNumber *> *inserts, NSArray<NSNumber *> *deletes, NSArray<NSNumber *> *reloads);

@interface FeedCommentListSectionModel : NSObject

/**
 转换一级评论模型集合为评论分组集合
 
 @param comments 评论模型集合
 @return 评论分组集合
 */
+ (NSArray<FeedCommentListSectionModel *> *)sectionModelsFromFirstlyComments:(NSArray<XLFeedCommentModel *> *)comments;

/// 行数据集合
@property (strong, nonatomic, readonly) NSArray<FeedCommentListRowModel *> *rows;

/// 一级评论行
@property (strong, nonatomic, readonly) FeedCommentListRowModel *firstlyCommentRow;

/// 当前的二级评论数量
@property (assign, nonatomic, readonly) NSInteger secondaryCommentCount;

/// 二级评论总数量
@property (assign, nonatomic, readonly) NSInteger secondaryCommentTotalCount;

/// 二级评论的最后一条
@property (strong, nonatomic) FeedCommentListRowModel *lastSecondaryCommentRow;

/**
 从一级评论模型初始化

 @param comment 一级评论模型
 @return 评论分组
 */
- (instancetype)initWithComment:(XLFeedCommentModel *)comment;
- (instancetype)init __attribute__((unavailable("请使用 initWithFeedComment")));
+ (instancetype)new __attribute__((unavailable("请使用 initWithFeedComment")));

/**
 增加我发的二级评论

 @param comment 评论模型
 */
- (void)insertMySecondaryComment:(XLFeedCommentModel *)comment rowsChanged:(FeedCommentRowsChangedBlock)rowsChanged;

/**
 增加二级评论集合

 @param comments 评论模型集合
 */
- (void)insertSecondaryCommentsFromArray:(NSArray<XLFeedCommentModel *> *)comments rowsChanged:(FeedCommentRowsChangedBlock)rowsChanged;

/**
 删除二级评论行

 @param row 评论行模型
 */
- (void)removeSecondaryCommentRow:(FeedCommentListRowModel *)row;

@end
