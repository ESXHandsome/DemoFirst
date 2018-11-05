//
//  UserRewardApi.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/3/21.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "UserRewardApi.h"
#import "RewardRequestURL.h"

@implementation UserRewardApi

/**
 获取启动奖励
 */
+ (void)fetchUserLaunchSignInSuccess:(SuccessBlock)success
                             failure:(FailureBlock)failure {
    [self httpRequestWithURL:URL_LAUNCH_SIGN_IN_REWARD
                   withParam:nil
                     success:^(id response) {
                         success(response);
                     } failure:^(NSInteger errorCode) {
                         failure(errorCode);
                     }];
}

/**
 获取登录奖励
 */
+ (void)fetchUserNewLoginMoneySuccess:(SuccessBlock)success
                          failure:(FailureBlock)failure {
    [self httpRequestWithURL:URL_FETCH_NEWLOGIM_MONEY
                   withParam:nil
                     success:^(id response) {
                         success(response);
                     } failure:^(NSInteger errorCode) {
                         failure(errorCode);
                     }];
}

/**
 取消登录奖励
 */
+ (void)fetchUserConcelNewLoginMoneySuccess:(SuccessBlock)success
                              failure:(FailureBlock)failure {
    [self httpRequestWithURL:URL_FETCH_CONCEL_NEWLOGIM_MONEY
                   withParam:nil
                     success:^(id response) {
                         success(response);
                     } failure:^(NSInteger errorCode) {
                         failure(errorCode);
                     }];
}

/**
 获取定时红包
 */
+ (void)fetchTimeRedPacketMoneySuccess:(SuccessBlock)success
                                    failure:(FailureBlock)failure {
    [self httpRequestWithURL:URL_FETCH_TIME_REDPACKET_MONEY
                   withParam:nil
                     success:^(id response) {
                         success(response);
                     } failure:^(NSInteger errorCode) {
                         failure(errorCode);
                     }];
}

/**
 获取分享红包
 */
+ (void)fetchShareRedPacketMoneySuccess:(SuccessBlock)success
                                failure:(FailureBlock)failure {
    [self httpRequestWithURL:URL_FETCH_SHARE_REDPACKET_MONEY
                   withParam:nil
                     success:^(id response) {
                         success(response);
                     } failure:^(NSInteger errorCode) {
                         failure(errorCode);
                     }];
}

/**
 获取定时红包状态
 */
+ (void)fetchTimeRedPacketStateSuccess:(SuccessBlock)success
                               failure:(FailureBlock)failure {
    [self httpRequestWithURL:URL_FETCH_TIME_REDPACKET_STATE
                   withParam:nil
                     success:^(id response) {
                         success(response);
                     } failure:^(NSInteger errorCode) {
                         failure(errorCode);
                     }];
}

/**
 获取邀请红包奖励
 */
+ (void)fetchInviteRedPacketStateSuccess:(SuccessBlock)success
                               failure:(FailureBlock)failure {
    [self httpRequestWithURL:URL_FETCH_INVITE_REDPACKET_STATE
                   withParam:nil
                     success:^(id response) {
                         success(response);
                     } failure:^(NSInteger errorCode) {
                         failure(errorCode);
                     }];
}
@end
