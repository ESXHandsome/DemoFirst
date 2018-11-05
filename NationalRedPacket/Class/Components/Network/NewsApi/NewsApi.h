//
//  NewsApi.h
//  NationalRedPacket
//
//  Created by sunmingyue on 17/11/14.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNetApi.h"
#import "XLFeedModel.h"

@interface NewsApi : BaseNetApi

+ (void)fetchNewClassify:(NSString *)classify
                 success:(SuccessBlock)success
                 failure:(FailureBlock)failure;

+ (void)fetchNewItem:(NSString *)action
             success:(SuccessBlock)success
             failure:(FailureBlock)failure;

+ (void)fetchCommentWithItemId:(NSString *)itemID
                          type:(NSString *)type
                     commentId:(NSString *)commentId
                     lastUpNum:(NSString *)lastUpNum
              specialCommentId:(NSString *)specialCommentId
        specialSecondCommentId:(NSString *)specialSecondCommentId
                       success:(SuccessBlock)success
                       failure:(FailureBlock)failure;

+ (void)fetchSecondaryCommentWithItemId:(NSString *)itemID
                              commentId:(NSString *)commentId
                                   type:(NSString *)type
                        secondCommentId:(NSString *)secondCommentId
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure;

+ (void)deleteSecondaryCommentWithItemId:(NSString *)itemId
                               commentId:(NSString *)commentId
                         secondCommentId:(NSString *)secondCommentId
                                    type:(NSString *)type
                                 success:(SuccessBlock)success
                                 failure:(FailureBlock)failure;

+ (void)praiseWithItemId:(NSString *)itemID
                    type:(NSString *)type
                  action:(NSString *)action
                 success:(SuccessBlock)success
                 failure:(FailureBlock)failure;

+ (void)treadWithItemId:(NSString *)itemID
                   type:(NSString *)type
                 action:(NSString *)action
                success:(SuccessBlock)success
                failure:(FailureBlock)failure;

+ (void)commentPraiseWithItemId:(NSString *)itemId
                      commentId:(NSString *)commentId
                           type:(NSString *)type
                         action:(BOOL)action
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure;

+ (void)deleteCommentWithItemId:(NSString *)itemId
                      commentId:(NSString *)commentId
                           type:(NSString *)type
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure;

+ (void)commentWithItemId:(NSString *)itemID
                     type:(NSString *)type
                  content:(NSString *)content
                imageInfo:(NSDictionary *)imageInfo
                  success:(SuccessBlock)success
                  failure:(FailureBlock)failure;

+ (void)commentWithCommentId:(NSString *)commentId
                  toAuthorId:(NSString *)toAuthorId
                        type:(NSString *)type
                     content:(NSString *)content
                     success:(SuccessBlock)success
                     failure:(FailureBlock)failure;

+ (void)followWithAuthorId:(NSString *)authorId
                    action:(BOOL)action
                   success:(SuccessBlock)success
                   failure:(FailureBlock)failure;

+ (void)fetchMyCollectionsWithAction:(NSString *)action
                              itemID:(NSString *)itemID
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure;

/**
 上传收藏信息流
 
 @param itemID 信息流ID
 @param type 类型
 @param action action
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)negativeFeedbackWithItemId:(NSString *)itemID
                              type:(NSString *)type
                            action:(NSString *)action
                          isReport:(BOOL)isReport
                           success:(SuccessBlock)success
                           failure:(FailureBlock)failure;

/**
 上传收藏信息流

 @param itemID 信息流ID
 @param type 类型
 @param action action
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)collectionWithItemId:(NSString *)itemID
                        type:(NSString *)type
                      action:(NSString *)action
                     success:(SuccessBlock)success
                     failure:(FailureBlock)failure;

/**
 * 拉取我的赞信息流
 *
 * @param action 动作 new or down
 * @param itemID itemID
 * @param success 拉取成功回调
 * @param failure 拉取失败回调
 */
+ (void)fetchMyLikesWithAction:(NSString *)action
                        itemID:(NSString *)itemID
                       success:(SuccessBlock)success
                       failure:(FailureBlock)failure;

/**
 * 拉取个人主页信息流
 *
 * @param action 动作 new or down
 * @param itemID itemID
 * @param contentType 内容类型 （动态 all) or (视频 video）
 * @param authorID 发布者ID
 * @param index 服务端数据回传
 * @param success 拉取成功回调
 * @param failure 拉取失败回调
 */
+ (void)fetchPersonalHomePageFeedsWithAction:(NSString *)action
                                      itemID:(NSString *)itemID
                                 contenttype:(NSString *)contentType
                                    authorID:(NSString *)authorID
                                       index:(NSString *)index
                                     success:(SuccessBlock)success
                                     failure:(FailureBlock)failure;

/**
 * 获取关注列表
 *
 * @param success 成功回调
 * @param failure 失败回调
 */
+ (void)fetchFollowListSuccess:(SuccessBlock)success
                       failure:(FailureBlock)failure;

/**
 * 获取关注信息流列表
 *
 * @param success 成功回调
 * @param failure 失败回调
 */
+ (void)fetchFollowFeedsWithItemID:(NSString *)itemID
                  withLatestItemID:(NSString *)lastItemID
                           success:(SuccessBlock)success
                           failure:(FailureBlock)failure;

/**
 评论举报

 @param commentId 评论id
 @param type 几级评论
 @param content 举报内容
 */
+ (void)reportCommentWithId:(NSString *)commentId
                commentType:(NSInteger)type
              reprotContent:(NSString *)content
                    success:(SuccessBlock)success
                    failure:(FailureBlock)failure;

/**
 拉取信息流内容

 @param feedId feedid
 @param feedType feedType
 @param success 成功
 @param failure 失败
 */
+ (void)fetchFeedDetailWithId:(NSString *)feedId
                     feedType:(NSString *)feedType
                      success:(SuccessBlock)success
                      failure:(FailureBlock)failure;

/**
 举报发布者

 @param publisherId 发布者id
 @param content 举报内容
 @param success 成功
 @param failure 失败
 */
+ (void)reprotPublisher:(NSString *)publisherId
                content:(NSString *)content
                success:(SuccessBlock)success
                failure:(FailureBlock)failure;

/**拉去我的帖子*/
+ (void)fetchMyUploadWithAction:(NSString *)action
                          index:(NSInteger)index
                         itemId:(NSString *)itemId
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure;

/**
 信息流转发成功
 
 @param itemId 信息流ID
 @param source 分享渠道
 @param success 成功
 @param failure 失败
 */
+ (void)feedForwardWithItemId:(NSString *)itemId
                       source:(NSString *)source
                         type:(NSString *)type
                      success:(SuccessBlock)success
                      failure:(FailureBlock)failure;


@end
