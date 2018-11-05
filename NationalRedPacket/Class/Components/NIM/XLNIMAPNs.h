//
//  XLNIMAPNs.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/20.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLNIMAPNs : NSObject

/**
 配置远程通知
 */
+ (void)configRemoteNotification;

/**
 点击通知，进行页面跳转
 
 @param userInfo 通知消息体
 */
+ (void)remoteNotificationTypePush:(NSDictionary *)userInfo;

+ (void)updatePushLaunchClickState:(BOOL)isClickPushLaunch;

/**
 清空badge数，并告诉云信服务器
 */
+ (void)clearAPNsBadgeCount;

@end
