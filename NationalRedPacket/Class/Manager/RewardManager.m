//
//  LaunchRewardManager.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/3/21.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

/**
 用户启动奖励管理者
 
 应用退出时：
    更新本地存储的“上次退出时间”
 应用启动时：
    如果是新的一天，奖励次数置空
    每次启动App，如果距离上一次退出App大于等于5分钟，给予签到奖励
    每天最多给5次
 */

#import "RewardManager.h"
#import "UserRewardApi.h"
#import "XLRedPacketManager.h"
#import "PPSSuccessFloatView.h"
#import "NSDate+Compare.h"
#import "XLUserManager.h"

#define QUITE_TIME      @"QUITE_TIME"     // 退出时间
#define SIGNIN_COUNT    @"SIGN_IN_COUNT"   // 当天签到数
#define SIGNIN_REWARD_MAX_COUNT_ONEDAY  5 // 一天登录签到奖励最多次数 每天最多给5次
#define SIGNIN_REWARD_MAX_TIME_INTERVAL 5 // 一天登录签到奖励时间间隔 距离上一次退出App大于等于5分钟

#define UserDefault [NSUserDefaults standardUserDefaults]

static RewardManager *staticRewardManager = nil;
static XLRedPacketManager *redPacketManager = nil;

@interface RewardManager ()<NSCopying,NSMutableCopying>

@property (strong, nonatomic) XLRedPacketManager *redPacketManager;

@end

@implementation RewardManager

#pragma mark
#pragma mark Init

+ (instancetype)defaultRewardManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticRewardManager = [[super allocWithZone:NULL] init];
        redPacketManager = [XLRedPacketManager new];
        [self addNotification];
    });
    return staticRewardManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [RewardManager defaultRewardManager];
}

- (id)copyWithZone:(NSZone *)zone {
    return [RewardManager defaultRewardManager];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [RewardManager defaultRewardManager];
}

#pragma mark -
#pragma mark Public Method

/**
 更新应用退出时间
 */
+ (void)updateQuiteTime {
    [UserDefault setDouble: [[NSDate date] timeIntervalSince1970] forKey:QUITE_TIME];
    [UserDefault synchronize];
}

/**
 处理启动奖励
 */
+ (void)checkAndDealwithLaunchReward {
    [self updateTheDaySignInCount]; // 如果与上次登录不是同一天，更新当天签到次数
  
    if ([self shoudBeRewarded]) {
        [UserRewardApi fetchUserLaunchSignInSuccess:^(id responseDict) {
            if ([responseDict[@"result"] integerValue] == 0) {
                [self updateSignInCount: [self getTheDaySigninCount] + 1];
                [self showToast:responseDict];
                [self updateMemoryMoney:responseDict];
                [StatServiceApi statEvent:NEWS_GET_START_REWARD_SUCCESS];
            }
        } failure:^(NSInteger errorCode) {
            
        }];
    }
}

/**
 处理登录奖励
 */
+ (void)checkAndDealwithLoginReward {
    UserInfoModel *userInfoModel = XLLoginManager.shared.userInfo;
    if ([userInfoModel.loginIncome.have boolValue]) {
        // 展示开红包弹窗
        [redPacketManager showOpenViewWithType:RedPacketTypeLogin];
        [self resetLocalLoginRewardState];
    }
}

/**
 重置本地登录奖励
 */
+ (void)resetLocalLoginRewardState {
    UserInfoModel *userInfoModel = XLLoginManager.shared.userInfo;
    userInfoModel.loginIncome.have = @"0";
    XLLoginManager.shared.userInfo = userInfoModel;
}

#pragma mark -
#pragma mark Notification Event

+ (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActiveNotification)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

/**
 应用挂起监听事件
 */
+ (void)applicationWillResignActiveNotification {
    [RewardManager updateQuiteTime];
}

/**
 应用激活监听事件
 */
+ (void)applicationDidBecomeActiveNotification {
    if (XLLoginManager.shared.isVisitorLogined && [UIApplication.sharedApplication.keyWindow.rootViewController isKindOfClass:UITabBarController.class]) {
        // 请求启动奖励
        [RewardManager checkAndDealwithLaunchReward];
    }
}

#pragma mark -
#pragma mark Private Method

/**
 是否应该以及签到奖励
 */
+ (BOOL)shoudBeRewarded {
    if ([self getTheDaySigninCount] > SIGNIN_REWARD_MAX_COUNT_ONEDAY) {
        return false;
    }
    if ([self timeIntervalIsSuitable]) {
        return true;
    }
    return false;
}

/**
 更新当天签到次数
 */
+ (void)updateTheDaySignInCount {
    NSTimeInterval lastQuiteTime = [[UserDefault objectForKey:QUITE_TIME] longLongValue];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    
    if (![NSDate isTheSameDay:now time2:lastQuiteTime]) { // 上次登录时间不是今天，重置签到次数
        [self updateSignInCount:0];
    }
}

/**
 更新签到次数
 */
+ (void)updateSignInCount:(NSInteger)count {
    [UserDefault setInteger:count forKey:SIGNIN_COUNT];
    [UserDefault synchronize];
}

/**
 获取当天签到次数
 */
+ (NSInteger)getTheDaySigninCount {
    return [[UserDefault objectForKey:SIGNIN_COUNT] integerValue];
}

/**
 获取上次退出时间
 */
+ (long long)getLastQuiteTime {
    if ([[UserDefault objectForKey:QUITE_TIME] longLongValue] == 0) {
        return [[NSDate date] timeIntervalSince1970];
    }
    return [[UserDefault objectForKey:QUITE_TIME] longLongValue];
}

/**
 获取奖励成功Toast
 */
+ (void)showToast:(NSDictionary *)responseDict {
    PPSSuccessFloatView *successFloatView = [PPSSuccessFloatView new];
    [[UIApplication sharedApplication].keyWindow addSubview:successFloatView];
    [successFloatView pushView:@"欢迎回来" money:responseDict[@"money"]];
}

/**
 判断上次退出时间与现在时间差是否大于等于5分钟
 */
+ (BOOL)timeIntervalIsSuitable {
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval lastQuiteTime = [self getLastQuiteTime];
    NSInteger minute = (currentTime - lastQuiteTime) / 60;
    if (minute >= SIGNIN_REWARD_MAX_TIME_INTERVAL) {
        return true;
    }
    return false;
}


/**
 更新全局金币数量或者零钱数
 */
+ (void)updateMemoryMoney:(NSDictionary *)updateInfo {
   
    if ([updateInfo[@"moneyType"] isEqualToString:XLRewardCoinType]) {
        [XLUserManager.shared addGoldIncomeNumber:updateInfo[@"money"]];
    } else if ([updateInfo[@"moneyType"] isEqualToString:XLRewardMoneyType]) {
        [XLUserManager.shared addBalanceIncomeMoney:updateInfo[@"money"]];
    }
}

@end
