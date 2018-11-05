//
//  NewsApi.m
//  NationalRedPacket
//
//  Created by sunmingyue on 17/11/14.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "NewsApi.h"
#import "NewsRequestURL.h"
#import "XLFeedCommentModel.h"
#import <SDWebImage/SDWebImagePrefetcher.h>
#import "XLDataSourceManager.h"
#import "XLPublisherDataSource.h"
#import "XLFeedAdNativeExpressModel.h"
#import "XLGDTAdManager.h"

@implementation NewsApi

+ (void)fetchNewClassify:(NSString *)classify
                 success:(SuccessBlock)success
                 failure:(FailureBlock)failure {
    
    [self httpRequestWithURL:URL_FETCH_NEW_CLASSIFY withParam:@{@"type" : classify} success:^(id responseDict) {
        
        if (![responseDict[@"item"] isKindOfClass:[NSArray class]]) {
            failure(-1);
        }
        success([self dealwithDataWithResponseDict:responseDict]);
        
    } failure:failure];
}

+ (void)fetchNewItem:(NSString *)action
             success:(SuccessBlock)success
             failure:(FailureBlock)failure {
    
    [self httpRequestWithURL:URL_FETCH_NEW_ITEM
                   withParam:@{@"action":action}
                     success:^(id response) {
                         
                         if (![response[@"item"] isKindOfClass:[NSArray class]]) {
                             failure(-1);
                         }
                         success([self dealwithDataWithResponseDict:response]);
                         
                     } failure:failure];
}

+ (NSDictionary *)dealwithDataWithResponseDict:(NSDictionary *)response {
    NSMutableArray *modelDataArray = (NSMutableArray *)[NSArray yy_modelArrayWithClass:XLFeedModel.class json:response[@"item"]];
    
    // 视频首帧图片缓存
    NSMutableArray *tempCacheArray = [NSMutableArray new];
    for (int i = 0; i < modelDataArray.count; i ++) {
        XLFeedModel *model = modelDataArray[i];
        if (([model.type integerValue]== XLFeedCellVideoVerticalWithAuthorType ||
             [model.type integerValue] == XLFeedCellVideoHorizonalWithAuthorType) &&
            model.picture.firstObject) {
            [tempCacheArray addObject:[NSURL URLWithString:model.picture.firstObject]];
        }
    }
    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:tempCacheArray];
    
    return response;
}



+ (void)fetchCommentWithItemId:(NSString *)itemID
                          type:(NSString *)type
                     commentId:(NSString *)commentId
                     lastUpNum:(NSString *)lastUpNum
              specialCommentId:(NSString *)specialCommentId
        specialSecondCommentId:(NSString *)specialSecondCommentId
                       success:(SuccessBlock)success
                       failure:(FailureBlock)failure {
    
    NSMutableDictionary *dic = @{@"itemId":itemID,
                                 @"type":type,
                                 @"commentId":commentId,
                                 @"upNum" : lastUpNum,
                                 }.mutableCopy;
    if (specialCommentId) {
        [dic setObject:specialCommentId forKey:@"specialCommentId"];
    }
    if (specialSecondCommentId) {
        [dic setObject:specialSecondCommentId forKey:@"specialSecondCommentId"];
    }
    [self httpRequestWithURL:URL_FETCH_COMMENT
                   withParam:dic
                     success:^(id responseDict) {
                         
                         if (![responseDict[@"commentNum"] isKindOfClass:[NSNull class]]) {
                             [XLDataSourceManager.shared changeFeedCommentNumForItemId:itemID num:[responseDict[@"commentNum"] integerValue]];
                         }
                         
                         if (success) {
                             success(responseDict);
                         }
                     }
                     failure:failure];
}

+ (void)fetchSecondaryCommentWithItemId:(NSString *)itemID
                              commentId:(NSString *)commentId
                                   type:(NSString *)type
                        secondCommentId:(NSString *)secondCommentId
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure {
    
    [self httpRequestWithURL:URL_FETCH_SECONDARY_COMMENT
                   withParam:@{
                               @"type":type,
                               @"commentId":commentId,
                               @"secondCommentId":secondCommentId,
                               }
                     success:^(id responseDict) {
                         
                         if (success) {
                             success(responseDict);
                         }
                     }
                     failure:failure];
}

+ (void)praiseWithItemId:(NSString *)itemID
                    type:(NSString *)type
                  action:(NSString *)action
                 success:(SuccessBlock)success
                 failure:(FailureBlock)failure{
    [self httpRequestWithURL:URL_PRAISE
                   withParam:@{@"itemId":itemID,
                               @"type":type,
                               @"action":action
                               }
                     success:^(id responseDict) {
                         
                         [XLDataSourceManager.shared changeFeedPraiseForItemId:itemID isPraised:[action isEqualToString:@"praise"]];
                         
                         if (success) {
                             success(responseDict);
                         }
                     }
                     failure:failure];
}

/**
 踩
 */
+ (void)treadWithItemId:(NSString *)itemID
                    type:(NSString *)type
                  action:(NSString *)action
                 success:(SuccessBlock)success
                 failure:(FailureBlock)failure{
    [self httpRequestWithURL:URL_TREAD
                   withParam:@{@"itemId":itemID,
                               @"type":type,
                               @"action":action
                               }
                     success:^(id responseDict) {
                         
                         [XLDataSourceManager.shared changeFeedTreadForItemId:itemID isTreaded:[action isEqualToString:@"tread"]];
                         
                         if (success) {
                             success(responseDict);
                         }
                     }
                     failure:failure];
}
/*负反馈上传*/
+ (void)negativeFeedbackWithItemId:(NSString *)itemID
                              type:(NSString *)type
                            action:(NSString *)action
                          isReport:(BOOL)isReport
                           success:(SuccessBlock)success
                           failure:(FailureBlock)failure {
    [self httpRequestWithURL:URL_NEGATIVE_FEEDBACK
                   withParam:@{@"itemId":itemID,
                               @"type":type,
                               @"content":action,
                               @"isReport":isReport ? @"1" : @"0"
                               }
                     success:^(id responseDict) {
                         if (success) {
                             success(responseDict);
                         }
                     }
                     failure:failure];
    
}

/*收藏上传*/
+ (void)collectionWithItemId:(NSString *)itemID
                    type:(NSString *)type
                  action:(NSString *)action
                 success:(SuccessBlock)success
                 failure:(FailureBlock)failure{
    [self httpRequestWithURL:URL_COLLECTION
                   withParam:@{@"itemId":itemID,
                               @"type":type,
                               @"action":action
                               }
                     success:^(id responseDict) {
                         
                         [XLDataSourceManager.shared changeFeedCollectionForItemId:itemID isCollection:[action isEqualToString:@"yes"]];
                         
                         if (success) {
                             success(responseDict);
                         }
                     }
                     failure:failure];
}

+ (void)commentPraiseWithItemId:(NSString *)itemId
                      commentId:(NSString *)commentId
                           type:(NSString *)type
                         action:(BOOL)action
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure
{
    [self httpRequestWithURL:URL_COMMENTPRAISE
                   withParam:@{@"itemId" : itemId,
                               @"commentId" : commentId,
                               @"type" : type,
                               @"action" : action ? @"praise" : @"noPraise"
                               }
                     success:^(id responseDict) {
                         
                         [XLDataSourceManager.shared changeFeedSuperCommentForItemId:itemId commentId:commentId isPraised:action];
                         
                         if (success) {
                             success(responseDict);
                         }
                     }
                     failure:failure];
}

+ (void)deleteCommentWithItemId:(NSString *)itemId
                      commentId:(NSString *)commentId
                           type:(NSString *)type
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure
{
    [self httpRequestWithURL:URL_DELETECOMMENT
                   withParam:@{@"itemId" : itemId,
                               @"commentId" : commentId,
                               @"type" : type,
                               }
                     success:^(id responseDict) {
                         [XLDataSourceManager.shared decreaseFeedCommentNumForItemId:itemId];
                         if (success) {
                             success(responseDict);
                         }
                     }
                     failure:failure];
}

+ (void)deleteSecondaryCommentWithItemId:(NSString *)itemId
                               commentId:(NSString *)commentId
                               secondCommentId:(NSString *)secondCommentId
                                    type:(NSString *)type
                                 success:(SuccessBlock)success
                                 failure:(FailureBlock)failure {
   
    [self httpRequestWithURL:URL_DELETE_SECONDARY_COMMENT
                   withParam:@{@"itemId" : itemId,
                               @"commentId" : commentId,
                               @"secondCommentId" : secondCommentId,
                               @"type" : type,
                               }
                     success:^(id responseDict) {
                         if (success) {
                             success(responseDict);
                         }
                     }
                     failure:failure];
}

+ (void)commentWithItemId:(NSString *)itemID
                     type:(NSString *)type
                  content:(NSString *)content
                imageInfo:(NSDictionary *)imageInfo
                  success:(SuccessBlock)success
                  failure:(FailureBlock)failure {
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:1];
    
    if (imageInfo) {
        [images addObject:imageInfo];
    }
    
    XLLog(@"%@", images.yy_modelToJSONString);
    
    [self httpRequestWithURL:URL_COMMENT
                   withParam:@{@"itemId":itemID,
                               @"type":type,
                               @"content":content,
                               @"images": images.yy_modelToJSONString
                               }
                     success:^(id responseDict) {
                         [XLDataSourceManager.shared increaseFeedCommentNumForItemId:itemID];
                         if (success) {
                             success(responseDict);
                         }
                     }
                     failure:failure];
}

+ (void)commentWithCommentId:(NSString *)commentId
                  toAuthorId:(NSString *)toAuthorId
                        type:(NSString *)type
                     content:(NSString *)content
                     success:(SuccessBlock)success
                     failure:(FailureBlock)failure {
    
    [self httpRequestWithURL:URL_SECONDARY_COMMENT
                   withParam:@{@"commentId":commentId,
                               @"toAuthorId":toAuthorId,
                               @"type":type,
                               @"content": content
                               }
                     success:success
                     failure:failure];
}

+ (void)followWithAuthorId:(NSString *)authorId
                    action:(BOOL)action
                   success:(SuccessBlock)success
                   failure:(FailureBlock)failure {
    [self httpRequestWithURL:URL_FOLLOW
                   withParam:@{@"authorId" : [NSString replaceNil:authorId],
                               @"action"   : action ? @"yes" : @"no"
                               }
                     success:^(id responseDict) {
                         
                         [XLDataSourceManager.shared changePublisherFollowForAuthorId:authorId isFollowed:action];
                         
                         if (action) {
                             [XLPublisherDataSource addFollowingAuthorId:authorId];
                         } else {
                             [XLPublisherDataSource removeFollowingAuthorId:authorId];
                         }
                         
                         if (success) {
                             success(responseDict);
                         }
                     }
                     failure:failure];
}

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
                       failure:(FailureBlock)failure {
    
    [self httpRequestWithURL:URL_MYPRISE
                   withParam:@{@"action":action,
                               @"itemId":itemID == nil ? @"" :itemID}
                     success:^(id response) {
                         
                         if (![response[@"item"] isKindOfClass:[NSArray class]]) {
                             failure(-1);
                         }
                         success([self dealwithDataWithResponseDict:response]);
                         
                     } failure:^(NSInteger errorCode) {
                         failure(errorCode);
                     }];
}


/**
 拉去我的收藏数据源

 @param action action
 @param itemID item
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)fetchMyCollectionsWithAction:(NSString *)action
                        itemID:(NSString *)itemID
                       success:(SuccessBlock)success
                       failure:(FailureBlock)failure {
    
    [self httpRequestWithURL:URL_MYCOLLECTION
                   withParam:@{@"action":action,
                               @"itemId":itemID == nil ? @"" :itemID}
                     success:^(id response) {
                         
                         if (![response[@"item"] isKindOfClass:[NSArray class]]) {
                             failure(-1);
                         }
                         success([self dealwithDataWithResponseDict:response]);
                         
                     } failure:^(NSInteger errorCode) {
                         failure(errorCode);
                     }];
}

+ (void)fetchMyUploadWithAction:(NSString *)action
                          index:(NSInteger)index
                         itemId:(NSString *)itemId
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure {
    [self httpRequestWithURL:URL_FETCH_MY_UPLOAD
                    withParam:@{@"action":action,
                                @"index":[NSNumber numberWithInteger:index],
                                @"itemId":itemId == nil ? @"" :itemId}
                     success:^(id responseDict) {
                         if (![responseDict[@"item"] isKindOfClass:[NSArray class]]) {
                             failure(-1);
                         }
                         success([self dealwithDataWithResponseDict:responseDict]);
                     } failure:^(NSInteger errorCode) {
                         failure(errorCode);
                     }];
    
}

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
                                     failure:(FailureBlock)failure {
    
    [self httpRequestWithURL:URL_PERSONAL
                   withParam:@{@"action":[NSString replaceNil:action],
                               @"itemId":[NSString replaceNil:itemID],
                               @"type":[NSString replaceNil:contentType],
                               @"authorId":[NSString replaceNil:authorID],
                               @"index":[NSString replaceNil:index]
                               }
                     success:^(id response) {
                         
                         if (![response[@"item"] isKindOfClass:[NSArray class]]) {
                             failure(-1);
                         }
                         success([self dealwithDataWithResponseDict:response]);
                         
                     } failure:^(NSInteger errorCode) {
                         failure(errorCode);
                     }];
}

/**
 * 获取关注列表
 *
 * @param success 成功回调
 * @param failure 失败回调
 */
+ (void)fetchFollowListSuccess:(SuccessBlock)success
                       failure:(FailureBlock)failure {
    [self httpRequestWithURL:URL_FOLLOW_LIST
                   withParam:nil
                     success:^(id responseDict) {
                         NSArray *dataArray = responseDict[@"list"];
                         NSMutableArray *modelDataArray = [NSMutableArray new];
                         
                         for (int i = 0; i < dataArray.count; i ++) {
                             NSDictionary *authorDict = [dataArray objectAtIndex:i];
                             [modelDataArray addObject:authorDict[@"authorId"]];
                         }
                         success(modelDataArray);
                     }
                     failure:^(NSInteger errorCode) {
                         failure(errorCode);
                     }];
}

/**
 * 获取关注信息流列表
 *
 * @param success 成功回调
 * @param failure 失败回调
 */
+ (void)fetchFollowFeedsWithItemID:(NSString *)itemID
                  withLatestItemID:(NSString *)lastItemID
                           success:(SuccessBlock)success
                           failure:(FailureBlock)failure {
    
    [self httpRequestWithURL:URL_FETCH_FOLLOW_FEEDS
                   withParam:@{@"id":itemID,
                               @"lastId":lastItemID
                               }
                     success:^(id response) {
                         
                         NSLog(@"%@",response);
                         
                         if (![response[@"item"] isKindOfClass:[NSArray class]]) {
                             failure(-1);
                         }
                         success(response);
                         
                     } failure:^(NSInteger errorCode) {
                         failure(errorCode);
                     }];
}

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
                    failure:(FailureBlock)failure {
    
    NSDictionary *dic = @{@"commentId" : commentId,
                          @"type" : type == 1 ? @"first" : @"second",
                          @"content" : content
                          };
    [self httpRequestWithURL:URL_REPORT_COMMENT withParam:dic success:^(id responseDict) {
        if (success) {
            success(responseDict);
        }
    } failure:^(NSInteger errorCode) {
        if (failure) {
            failure(errorCode);
        }
    }];
}

+ (void)fetchFeedDetailWithId:(NSString *)feedId
                     feedType:(NSString *)feedType
                      success:(SuccessBlock)success
                      failure:(FailureBlock)failure {
    
    NSDictionary *dic = @{@"itemId"   : feedId   ?: @"",
                          @"itemType" : feedType ?: @""};
    [self httpRequestWithURL:URL_FETCH_FEED_DETAIL withParam:dic success:^(id responseDict) {
        if (success) {
            success(responseDict);
        }
    } failure:^(NSInteger errorCode) {
        if (failure) {
            failure(errorCode);
        }
    }];
}

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
                failure:(FailureBlock)failure {
    
    NSDictionary *dic = @{@"authorId" : publisherId,
                          @"content"  : content
                          };
    [self httpRequestWithURL:URL_REPORT_PUBLISHER withParam:dic success:^(id responseDict) {
        if (success) {
            success(responseDict);
        }
    } failure:^(NSInteger errorCode) {
        if (failure) {
            failure(errorCode);
        }
    }];
    
}

+ (void)feedForwardWithItemId:(NSString *)itemId
                       source:(NSString *)source
                         type:(NSString *)type
                      success:(SuccessBlock)success
                      failure:(FailureBlock)failure {
    NSDictionary *dic = @{@"itemId" : itemId,
                          @"source" : source,
                          @"type"   : type
                          };
    [self httpRequestWithURL:URL_FEED_FORWARD withParam:dic success:^(id responseDict) {
        if (success) {
            success(responseDict);
        }
    } failure:^(NSInteger errorCode) {
        if (failure) {
            failure(errorCode);
        }
    }];
}

@end
