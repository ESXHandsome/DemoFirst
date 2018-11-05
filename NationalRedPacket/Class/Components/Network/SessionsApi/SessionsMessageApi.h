//
//  SessionsMessageApi.h
//  NationalRedPacket
//
//  Created by Ying on 2018/5/30.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "BaseNetApi.h"

#define URL_FETCH_MESSAGE_LIST URL_BASE@"/Msg/fetchList"
#define URL_FETCH_RECEIVE_PRAISE URL_BASE@"/Item/receivePraise"
#define URL_FETCH_RECEIVE_COMMENT URL_BASE@"/Item/receiveComment"

@interface SessionsMessageApi : BaseNetApi

+ (void)fetchMessageType:(NSInteger)type
                  action:(NSString *)action
                  lastId:(NSString *)lastId
                 success:(SuccessBlock)success
                 failure:(FailureBlock)failure;

+ (void)fetchReceivePraise:(NSString *)action
                        id:(NSInteger)sigh
                   success:(SuccessBlock)success
                   failure:(FailureBlock)failure;

+ (void)fetchReceiveComment:(NSString *)action
                        id:(NSInteger)sigh
                    success:(SuccessBlock)success
                    failure:(FailureBlock)failure;

@end
