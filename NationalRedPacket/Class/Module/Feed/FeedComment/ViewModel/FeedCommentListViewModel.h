//
//  FeedCommentListViewModel.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/23.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedCommentListSectionModel.h"

@class FeedCommentListViewModel;

@protocol FeedCommentListViewModelDelegate <NSObject>

/**
 增加新的分组集合，加载新数据时回调

 @param viewModel FeedCommentListViewModel 实例
 @param sections 分组集合
 */
- (void)viewModel:(FeedCommentListViewModel *)viewModel didAppendSections:(NSArray<FeedCommentListSectionModel *> *)sections;

@end

@interface FeedCommentListViewModel : NSObject

@property (strong, nonatomic, readonly) XLFeedModel *feed;
@property (copy, nonatomic) NSString *specialCommentId;
@property (copy, nonatomic) NSString *specialSecondCommentId;

@property (assign, nonatomic) BOOL isFirstFetch;
@property (assign, nonatomic) BOOL isAllData;
@property (assign, nonatomic) BOOL isSpecialComment;
@property (assign, nonatomic) BOOL isSpecialSecondComment;

/// 代理委托
@property (weak, nonatomic) id<FeedCommentListViewModelDelegate> delegate;

/// 分组集合（一级评论集合）
@property (strong, nonatomic, readonly) NSArray<FeedCommentListSectionModel *> *sections;

/**
 依赖外部传入的 Feed 进行初始化

 @param feed 信息流实例
 @return 类型实例
 */
- (instancetype)initWithFeed:(XLFeedModel *)feed;

/**
 手动增加一级评论

 @param array 一级评论数组
 */
- (void)addFeedCommentWithModelArray:(NSMutableArray <XLFeedCommentModel *> *)array;

/**
 加载更多
 */
- (void)loadMore;

/**
 二级评论加载更多
 */
- (void)loadMoreSecondaryMomentWithRowModel:(FeedCommentListRowModel *)rowModel
                                    success:(FeedCommentRowsChangedBlock)success
                                    failure:(FailureBlock)failure;
/**
 删除一级评论

 @param rowModel 评论模型
 @param success 成功回调
 @param failure 失败回调
 */
- (void)deleteFeedCommentWithModel:(FeedCommentListRowModel *)rowModel success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 删除二级评论
 
 @param rowModel 评论模型
 @param success 成功回调
 @param failure 失败回调
 */
- (void)deleteSecondaryCommentWithModel:(FeedCommentListRowModel *)rowModel
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure;

/**
 点赞/取消点赞一级评论

 @param commentId 评论id
 @param isPraise 赞/取消赞
 @param success 成功回调
 @param failure 失败回调
 */
- (void)praiseFeedCommentWithCommentId:(NSString *)commentId isPraise:(BOOL)isPraise success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 评论feed流

 @param content 文字内容
 @param picture 图片内容
 @param isForward 是否同时转发
 @param success 成功回调
 @param failure 失败回调
 */
- (void)commentFeedWithContent:(NSString *)content picture:(UIImage *)picture pictureFileURL:(NSURL *)pictureFileURL isForward:(BOOL)isForward success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 回复评论

 @param row 行数据
 @param content 评论内容
 @param isForward 是否同时转发
 @param success 成功回调
 @param failure 失败回调
 */
- (void)replyCommentRow:(FeedCommentListRowModel *)row content:(NSString *)content isForward:(BOOL)isForward success:(FeedCommentRowsChangedBlock)success failure:(FailureBlock)failure;

@end
