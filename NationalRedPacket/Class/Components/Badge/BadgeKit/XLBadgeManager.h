//
//  XLBadgeManager.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/4.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XLBadgeInfo;

@interface XLBadgeManager : NSObject

+ (instancetype)sharedManager;

/**
 注册
 */
- (void)registProfile;

/**
 *  add item to manager, it contains red dot action and key.
 */
- (void)addRedDotItem:(XLBadgeInfo *)item forKey:(NSString *)key;

/**
 *  remove item from manager, when red dot view released.
 */
- (void)removeRedDotItemForKey:(NSString *)key;

/**
 重置key对应的红点个数
 */
- (void)resetBadgeCount:(NSString *)countString forKey:(NSString *)key;

@end
