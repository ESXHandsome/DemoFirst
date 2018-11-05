//
//  RedPacketApi.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNetApi.h"

@interface RedPacketApi : BaseNetApi

/**
 检查群红包状态

 @param packetID 红包ID
 @param teamID 群ID
 */
+ (void)fetchTeamRedPacketStateWithPacketID:(NSString *)packetID
                                     teamID:(NSString *)teamID
                                    success:(SuccessBlock)success
                                    failure:(FailureBlock)failure;

/**
 开群红包
 
 @param packetID 红包ID
 @param teamID 群ID
 */
+ (void)grabTeamRedPacketWithPacketID:(NSString *)packetID
                               teamID:(NSString *)teamID
                              success:(SuccessBlock)success
                              failure:(FailureBlock)failure;

/**
 获取群红包详情
 
 @param packetID 红包ID
 @param teamID 群ID
 */
+ (void)fetchTeamRedPacketDetailWithPacketID:(NSString *)packetID
                                      teamID:(NSString *)teamID
                                     success:(SuccessBlock)success
                                     failure:(FailureBlock)failure;

/**
 获取关注红包
 
 @param packetID 红包ID
 @param action 抢红包:get,检查红包:check,红包详情:detail
 */
+ (void)fetchFocusRedPacketDetailWithPacketID:(NSString *)packetID
                                       action:(NSString *)action
                                      success:(SuccessBlock)success
                                      failure:(FailureBlock)failure;

/**
 获取群id
 */
+ (void)fetchJumpTeamIDWithType:(NSString *)type
                        Success:(SuccessBlock)success
                       failure:(FailureBlock)failure;

@end
