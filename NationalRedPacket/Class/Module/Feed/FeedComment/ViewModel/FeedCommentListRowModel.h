//
//  FeedCommentListRowModel.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/23.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLFeedCommentModel.h"

typedef NS_ENUM(NSUInteger, FeedCommentListRowType) {
    FeedCommentListFirstlyRowType,              // 一级评论
    FeedCommentListSecondaryRowType,            // 二级评论
    FeedCommentListSecondaryTopRowType,         // 二级评论顶部
    FeedCommentListSecondaryUnfoldTipRowType,   // 二级评论展开
    FeedCommentListSecondaryBottomRowType,      // 二级评论底部
};

@class FeedCommentListSectionModel;

@interface FeedCommentListRowModel : NSObject

/**
 转换二级评论模型集合为评论行集合
 
 @param comments 评论模型集合
 @param section 关联的分组实例
 @return 评论行集合
 */
+ (NSArray<FeedCommentListRowModel *> *)rowModelsFromSecondaryComments:(NSArray<XLFeedCommentModel *> *)comments section:(FeedCommentListSectionModel *)section;

///是否已显示全部数据
@property (assign, nonatomic) BOOL isAllContent;

/// 行数据类型
@property (assign, nonatomic, readonly) FeedCommentListRowType type;

/// 一级或二级评论数据（FeedCommentListFirstlyRowType, FeedCommentListSecondaryRowType）
@property (strong, nonatomic, readonly) XLFeedCommentModel *comment;

/// 关联的分组实例
@property (weak, nonatomic) FeedCommentListSectionModel *section;

/**
 初始化一级评论的行数据

 @param comment 一级评论
 @param section 关联的分组实例
 @return 实例类型
 */
- (instancetype)initFirstlyRowTypeWithComment:(XLFeedCommentModel *)comment section:(FeedCommentListSectionModel *)section;

/**
 初始化二级评论的行数据

 @param comment 二级评论
 @param section 关联的分组实例
 @return 实例类型
 */
- (instancetype)initSecondaryRowTypeWithComment:(XLFeedCommentModel *)comment section:(FeedCommentListSectionModel *)section;

/**
 初始化二级评论展开的行数据

 @param section 关联的分组实例
 @return 实例类型
 */
- (instancetype)initSecondaryUnfoldTipRowTypeWithSection:(FeedCommentListSectionModel *)section;

/**
 初始化二级评论顶部的行数据

 @return 实例类型
 */
- (instancetype)initSecondaryTopRowType;

/**
 初始化二级评论底部的行数据

 @return 实例类型
 */
- (instancetype)initSecondaryBottomRowType;

- (instancetype)init __attribute__((unavailable("请使用指定初始化方法")));
+ (instancetype)new __attribute__((unavailable("请使用指定初始化方法")));

@end
