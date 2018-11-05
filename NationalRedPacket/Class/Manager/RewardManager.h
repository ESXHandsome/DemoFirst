//
//  LaunchRewardManager.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/3/21.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RewardManager : NSObject

/**
 初始化全局变量
 */
+ (instancetype)defaultRewardManager;

/**
 更新应用退出时间
 */
+ (void)updateQuiteTime;

/**
 启动奖励
 */
+ (void)checkAndDealwithLaunchReward;

/**
 登录奖励
 */
+ (void)checkAndDealwithLoginReward;

/**
 更新本地登录奖励装填
 */
+ (void)resetLocalLoginRewardState;

@end
