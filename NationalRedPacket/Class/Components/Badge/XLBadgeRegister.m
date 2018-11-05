//
//  XLBadgeRegister.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/4.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLBadgeRegister.h"

NSString *const XLBadgeIMTabBarKey = @"XLBadgeIMTabBarKey";

NSString *const XLBadgeSessionListKey = @"XLBadgeSessionListKey";

NSString *const XLBadgeSessionFansKey = @"XLBadgeSessionFansKey";
NSString *const XLBadgeSessionVisitorKey = @"XLBadgeSessionVisitorKey";
NSString *const XLBadgeSessionCommentKey = @"XLBadgeSessionCommentKey";
NSString *const XLBadgeSessionLikeKey = @"XLBadgeSessionLikeKey";

@implementation XLBadgeRegister

+ (NSArray *)registProfiles {
    return @[
             @{XLBadgeIMTabBarKey:@[XLBadgeSessionFansKey,
                                     XLBadgeSessionVisitorKey,
                                     XLBadgeSessionCommentKey,
                                     XLBadgeSessionLikeKey,
                                     XLBadgeSessionListKey]
               }
             ];
}

@end
