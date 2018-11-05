//
//  UserManager.m
//  NationalRedPacket
//
//  Created by fensi on 2018/4/20.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLUserManager.h"
#import "UserApi.h"
#import "XLFeedCommentModel.h"
#import "NewsApi.h"

@interface XLUserManager ()

@property (assign, nonatomic) NSInteger repeatCount;

@property (strong, nonatomic) NSMutableArray *blacklistArray;

@end

@implementation XLUserManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{ sharedInstance = [self new]; });
    return sharedInstance;
}

- (BOOL)isOnceShared {
    return [NSUserDefaults.standardUserDefaults boolForKey:self.isOnceSharedKey];
}

- (void)setIsOnceShared:(BOOL)isOnceShared {
    [NSUserDefaults.standardUserDefaults setBool:isOnceShared forKey:self.isOnceSharedKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (NSString *)isOnceSharedKey {
    NSString *key = [XLLoginManager.shared.userId stringByAppendingString:XLUserDefaultsIsOnceSharedKey];
    key = [key stringByAppendingString:[NSString stringWithFormat:@"%unsigned long", XLLoginManager.shared.isAccountLogined]];
    return key;
}

- (void)addGoldIncomeNumber:(NSString *)goldNumber
{
    if (self.incomeInfoModel) {
        self.incomeInfoModel.myCoin = [NSString stringWithFormat:@"%ld",self.incomeInfoModel.myCoin.integerValue + goldNumber.integerValue];
        [self updateUserViewControllerHeadView];
    }
}

- (void)addInviteIncomeMoney:(NSString *)inviteMoney
{
    if (self.incomeInfoModel) {
        self.incomeInfoModel.inviteIncome = [NSString stringWithFormat:@"%.2f", self.incomeInfoModel.inviteIncome.floatValue + inviteMoney.floatValue];
        [self addBalanceIncomeMoney:inviteMoney];
    }
}


- (void)addBalanceIncomeMoney:(NSString *)balanceMoney
{
    if (self.incomeInfoModel) {
        self.incomeInfoModel.balance = [NSString stringWithFormat:@"%.2f", self.incomeInfoModel.balance.floatValue + balanceMoney.floatValue];
        [self updateUserViewControllerHeadView];
    }
}

- (void)subBalanceIncomeMoney:(NSString *)subMoney
{
    if (self.incomeInfoModel) {
        self.incomeInfoModel.balance = [NSString stringWithFormat:@"%.2f", self.incomeInfoModel.balance.floatValue - subMoney.floatValue];
        [self updateUserViewControllerHeadView];
    }
}

- (void)updateUserViewControllerHeadView
{
    NSArray *vcArray = [UIViewController currentViewController].rt_navigationController.rt_viewControllers;
    if (vcArray.count == 1 && [NSStringFromClass(((UIViewController *)(vcArray.firstObject)).class) isEqualToString:@"UserViewController"]) {
        [vcArray.firstObject viewWillAppear:YES];
    }
}

- (void)fetchUserInfo:(void(^)(void))finish{
    [UserApi fetchUserListAuthorId:nil Success:^(id responseDict) {
        self.userInfoModel = [PPSUserInfoModel yy_modelWithJSON:responseDict];
        if (!self.incomeInfoModel) {
            self.incomeInfoModel = [IncomeInfoModel new];
        }
        self.incomeInfoModel.balance = self.userInfoModel.userBalance.balance;
        self.incomeInfoModel.myCoin =  self.userInfoModel.userBalance.coin;
        self.incomeInfoModel.inviteIncome = self.userInfoModel.userBalance.inviteIncome;
        if(finish != nil){
            finish();
        }
    } failure:^(NSInteger errorCode) {
        self.repeatCount ++;
        if (self.repeatCount <= 3)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self fetchUserInfo:^{
                    finish();
                }];
            });
    }];
}
- (void)reloadUserInfoForTabBadge {
    
    [self fetchUserInfo:^{
        /**TODO: 邀请红包tab红点逻辑*/
//        if (self.userInfoModel.invitationLuckyMoney.haveLuckyMoney ||
//            self.userInfoModel.timeLuckyMoney.availability) {
//
//            UITabBar *tabBar = [(UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController tabBar];
//
//            if (![tabBar.selectedItem.title isEqualToString:@"我的"]) {
//                [tabBar showBadgeOnItemIndex:3];
//            }
//        }
    }];
}

/**
 列入黑名单
 
 @param userId 用户id
 */
- (void)blacklistUser:(NSString *)userId {
    
    [NewsApi followWithAuthorId:userId action:NO success:nil failure:nil];
    
    if ([self.blacklistArray containsObject:userId]) {
        return;  //如已添加，不必重复添加
    }
    
    [self.blacklistArray addObject:userId];
    [NSUserDefaults.standardUserDefaults setObject:self.blacklistArray forKey:self.blacklistKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

/**
 检查用户是否在黑名单中
 
 @param userId 用户id
 @return 是否在
 */
- (BOOL)checkUserInBlacklist:(NSString *)userId {
    return [self.blacklistArray containsObject:userId];
}

/**
 移除黑名单用户的信息流内容
 
 @param feedArray feedArray
 */
- (void)deleteUserFeedInBlacklist:(NSMutableArray *)feedArray {
    
    // 黑名单用户发布内容数组
    NSMutableArray *blacklistUserModelArray = [NSMutableArray array];
    for (XLFeedModel *model in feedArray) {
        if ([self checkUserInBlacklist:model.authorId]) {
            [blacklistUserModelArray addObject:model];
        }
    }
    // 移除黑名单用户发布内容
    [feedArray removeObjectsInArray:blacklistUserModelArray];
}

/**
 移除黑名单用户的评论内容
 
 @param commentArray commentArray
 */
- (void)deleteUserCommentInBlacklist:(NSMutableArray *)commentArray {
    
    NSMutableArray *blacklistUserCommentArray = [NSMutableArray array];
    for (XLFeedCommentModel *model in commentArray) {
        if ([self checkUserInBlacklist:model.fromAuthorId]) {
            [blacklistUserCommentArray addObject:model];
        }
    }
    // 移除黑名单用户发布内容
    [commentArray removeObjectsInArray:blacklistUserCommentArray];
}

/**
 移除发布者列表中的黑名单用户
 
 @param publisherArray publisherArray
 */
- (void)deletePublisherInBalcklist:(NSMutableArray *)publisherArray {
    
    NSMutableArray *blacklistPublisherArray = [NSMutableArray array];
    for (XLPublisherModel *model in publisherArray) {
        if ([self checkUserInBlacklist:model.authorId]) {
            [blacklistPublisherArray addObject:model];
        }
    }
    // 移除黑名单用户发布者
    [publisherArray removeObjectsInArray:blacklistPublisherArray];
}

- (NSMutableArray *)blacklistArray {
    
    if (!_blacklistArray) {
        NSMutableArray *localArray = [[NSUserDefaults.standardUserDefaults objectForKey:self.blacklistKey] mutableCopy];
        _blacklistArray = localArray ?: [NSMutableArray array];
    }
    return _blacklistArray;
    
}

- (NSString *)blacklistKey {
    return [NSString stringWithFormat:@"%@_%@", XLLoginManager.shared.userId, @"blacklist"];
}

- (BOOL)registrationHourMoreThan24h {
    double firstLaunchTimestamp = [[NSUserDefaults.standardUserDefaults objectForKey:XLUserDefaultsAPPFirstLaunchTimestamps] doubleValue];
    double nowTimestamp = [[NSDate date] timeIntervalSince1970];
    
    // 距离首次启动的24h内，不展示广告
    if ((nowTimestamp - firstLaunchTimestamp) / (60 * 60) > 24) {
        return YES;
    }
    return NO;
}
@end
