//
//  RedPacketManager.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/3/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RedPacketOpenView.h"

@protocol XLRedPacketManagerDelegate <NSObject>

@optional
/**
 定时红包状态更新回调

 @param isAvailable 定时红包是否可用
 @param countDown 倒计时时间戳
 @param availableTime 红包可用时间
 */
- (void)timingRedPacketAvailable:(BOOL)isAvailable
                   withCountDown:(long)countDown
               withAvailableTime:(NSString *)availableTime;

@end

@interface XLRedPacketManager : NSObject

@property (weak, nonatomic) id<XLRedPacketManagerDelegate> redPacketDelegate;

/**
 显示开红包浮窗

 @param redPacketType 红包类型
 */
- (void)showOpenViewWithType:(RedPacketType)redPacketType;

/**
 获取定时红包状态
 */
- (void)fetchTimingRedPacketState;

@end
