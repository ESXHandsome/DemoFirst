//
//  XLFeedDataSourceChangingObservable.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/13.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLDataSourceChangingObservable.h"

@protocol XLFeedDataSourceChangingObservable <XLDataSourceChangingObservable>

/**
 更改一条 Feed 的点赞状态

 @param itemId ID
 @param isPraised 是否已点赞
 */
- (void)changeFeedPraiseForItemId:(NSString *)itemId isPraised:(BOOL)isPraised;

/**
 更改一条 Feed 的神评点赞状态
 
 @param itemId ID
 @param commentId 评论id
 @param isPraised 是否已点赞
 */
- (void)changeFeedSuperCommentForItemId:(NSString *)itemId commentId:(NSString *)commentId isPraised:(BOOL)isPraised;

/**
 更改一条 Feed 的踩状态
 
 @param itemId ID
 @param isTreaded 是否已踩
 */
- (void)changeFeedTreadForItemId:(NSString *)itemId isTreaded:(BOOL)isTreaded;

/**
 更改一条 Feed 的收藏状态

 @param itemId ID
 @param isCollection 是否已收藏
 */
- (void)changeFeedCollectionForItemId:(NSString *)itemId isCollection:(BOOL)isCollection;

/**
 更改一条 Feed 的评论数量

 @param itemId ID
 @param num 评论数量
 */
- (void)changeFeedCommentNumForItemId:(NSString *)itemId num:(NSInteger)num;

/**
 增加 Feed 的评论数量（+1）

 @param itemId ID
 */
- (void)increaseFeedCommentNumForItemId:(NSString *)itemId;

/**
 减少 Feed 的评论数量（-1）
 
 @param itemId ID
 */
- (void)decreaseFeedCommentNumForItemId:(NSString *)itemId;

/**
 增加 Feed 的转发数量（+1）

 @param itemId ID
 */
- (void)increaseFeedForwardNumForItemId:(NSString *)itemId;

@end
