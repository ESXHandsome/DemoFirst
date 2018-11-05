//
//  XLBadgeRegister.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/4.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const XLBadgeIMTabBarKey;

extern NSString *const XLBadgeSessionListKey;

extern NSString *const XLBadgeSessionFansKey;
extern NSString *const XLBadgeSessionVisitorKey;
extern NSString *const XLBadgeSessionCommentKey;
extern NSString *const XLBadgeSessionLikeKey;

@interface XLBadgeRegister : NSObject

+ (NSArray *)registProfiles;

@end
