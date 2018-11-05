//
//  PPSRedPointManager.m
//  NationalRedPacket
//
//  Created by Ying on 2018/3/26.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "RedPointManager.h"
#import "XLUpgradeManager.h"
#import "NSDateFormatter+Date.h"

@interface RedPointManager()
@property (assign, nonatomic) BOOL hasRedPoint;
@end

@implementation RedPointManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{ sharedInstance = [self new]; });
    return sharedInstance;
}

/**TODO: 检查版本红点逻辑*/
- (BOOL)isTabBarShouldAddRedPoint {
    return XLUpgradeManager.shared.isNeedUpgrade;
}

/**TODO: 每日红包红点逻辑*/
- (void)tabBarAddRedPoint {
    UITabBar *tabBar = [(UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController tabBar];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setyyyMMddFormat];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:XLJudgeUpdateRedPoint]) {
        NSString *defaultTime =[formater stringFromDate:[userDefault objectForKey:XLJudgeUpdateRedPoint]];
        NSString *currentTime = [formater stringFromDate:[NSDate date]];
        if (![defaultTime isEqualToString:currentTime]) {
            [tabBar showBadgeOnItemIndex:3];
            self.hasRedPoint = YES;
            [userDefault setObject:[NSDate date] forKey:XLJudgeUpdateRedPoint];
        } else {
            self.hasRedPoint = NO;
        }
    } else {
        NSDate *curDate = [NSDate date];//获取当前日期
        [userDefault setObject:curDate forKey:XLJudgeUpdateRedPoint];
        [tabBar showBadgeOnItemIndex:3];
        self.hasRedPoint = YES;
    }
}

/**TODO: 邀请红包红点逻辑*/
- (BOOL)hasInvitedCellRedPoint{
    return self.hasRedPoint;
}

/**TODO: 手动吊起红点逻辑*/
- (void)setRedPoint:(BOOL)hasRedPoint{
    self.hasRedPoint = hasRedPoint;
}

@end
