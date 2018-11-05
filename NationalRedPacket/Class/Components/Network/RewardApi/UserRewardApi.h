//
//  UserRewardApi.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/3/21.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNetApi.h"

@interface UserRewardApi : BaseNetApi

/**
 获取用户登录签到奖励
 */
+ (void)fetchUserLaunchSignInSuccess:(SuccessBlock)success
                             failure:(FailureBlock)failure;

/**
 获取登录奖励
 */
+ (void)fetchUserNewLoginMoneySuccess:(SuccessBlock)success
                          failure:(FailureBlock)failure;

/**
 取消登录奖励
 */
+ (void)fetchUserConcelNewLoginMoneySuccess:(SuccessBlock)success
                                    failure:(FailureBlock)failure;

/**
 获取定时红包
 */
+ (void)fetchTimeRedPacketMoneySuccess:(SuccessBlock)success
                               failure:(FailureBlock)failure;

/**
 获取分享红包
 */
+ (void)fetchShareRedPacketMoneySuccess:(SuccessBlock)success
                                failure:(FailureBlock)failure;

/**
 获取定时红包状态
 */
+ (void)fetchTimeRedPacketStateSuccess:(SuccessBlock)success
                               failure:(FailureBlock)failure;

/**
 获取邀请红包奖励
 */
+ (void)fetchInviteRedPacketStateSuccess:(SuccessBlock)success
                                 failure:(FailureBlock)failure;

@end
