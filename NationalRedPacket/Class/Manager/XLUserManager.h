//
//  UserManager.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/20.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IncomeInfoModel.h"
#import "PPSUserInfoModel.h"

@interface XLUserManager : NSObject

/// 是否执行过分享操作
@property (assign, nonatomic) BOOL isOnceShared;
/// 收入信息
@property (strong, nonatomic) IncomeInfoModel *incomeInfoModel;
/// 用户相关信息
@property (strong, nonatomic) PPSUserInfoModel *userInfoModel;

/** 单例 */
+ (instancetype)shared;

//增加金币收入数量
- (void)addGoldIncomeNumber:(NSString *)goldNumber;
//增加邀请收入零钱
- (void)addInviteIncomeMoney:(NSString *)inviteMoney;
//增加零钱收入（来自新手红包或其他收入来源）
- (void)addBalanceIncomeMoney:(NSString *)balanceMoney;
//减少零钱 (兑换减少或其他减少收入)
- (void)subBalanceIncomeMoney:(NSString *)subMoney;
//获取用户信息
- (void)fetchUserInfo:(void(^)(void))finish;
/**
 刷新用户信息，并设置 TabBar Badge
 */
- (void)reloadUserInfoForTabBadge;

/**
 列入黑名单

 @param userId 用户id
 */
- (void)blacklistUser:(NSString *)userId;

/**
 检查用户是否在黑名单中

 @param userId 用户id
 @return 是否在
 */
- (BOOL)checkUserInBlacklist:(NSString *)userId;

/**
 移除黑名单用户的信息流内容

 @param feedArray feedArray
 */
- (void)deleteUserFeedInBlacklist:(NSMutableArray *)feedArray;

/**
 移除黑名单用户的评论内容

 @param commentArray commentArray
 */
- (void)deleteUserCommentInBlacklist:(NSMutableArray *)commentArray;

/**
 移除发布者列表中的黑名单用户

 @param publisherArray publisherArray
 */
- (void)deletePublisherInBalcklist:(NSMutableArray *)publisherArray;

/**
 用户注册时间
 */
- (BOOL)registrationHourMoreThan24h;

@end
