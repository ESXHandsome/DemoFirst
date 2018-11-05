//
//  SessionsMessageApi.m
//  NationalRedPacket
//
//  Created by Ying on 2018/5/30.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "SessionsMessageApi.h"

@implementation SessionsMessageApi

+ (void)fetchMessageType:(NSInteger)type
                  action:(NSString *)action
                  lastId:(NSString *)lastId
                 success:(SuccessBlock)success
                 failure:(FailureBlock)failure {
    
    [self httpRequestWithURL:URL_FETCH_MESSAGE_LIST
                   withParam:@{
                               @"type":[NSNumber numberWithInteger:type],
                               @"action":action,
                               @"lastId":lastId
                               }
                     success:success
                     failure:failure];
}

/**拉去赞*/
+ (void)fetchReceivePraise:(NSString *)action id:(NSInteger)sigh success:(SuccessBlock)success
                   failure:(FailureBlock)failure{
    [self httpRequestWithURL:URL_FETCH_RECEIVE_PRAISE
                   withParam:@{
                               @"action":action,
                               @"id":[NSNumber numberWithInteger:sigh]
                               }
                     success:success
                     failure:failure];
}

/**拉去评论*/
+ (void)fetchReceiveComment:(NSString *)action id:(NSInteger)sigh success:(SuccessBlock)success
                    failure:(FailureBlock)failure{
    [self httpRequestWithURL:URL_FETCH_RECEIVE_COMMENT
                   withParam:@{
                               @"action":action,
                               @"id":[NSNumber numberWithInteger:sigh]
                               }
                     success:success failure:failure];
}
@end
