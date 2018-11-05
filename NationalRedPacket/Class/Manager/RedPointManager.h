//
//  PPSRedPointManager.h
//  NationalRedPacket
//
//  Created by Ying on 2018/3/26.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const XLJudgeUpdateRedPoint = @"date";

@interface RedPointManager : NSObject

/** 单例 */
+ (instancetype)shared;

- (BOOL)isTabBarShouldAddRedPoint;

/**
 每日红包红点逻辑
 */
- (void)tabBarAddRedPoint;
- (BOOL)hasInvitedCellRedPoint;
- (void)setRedPoint:(BOOL)hasRedPoint;
@end
