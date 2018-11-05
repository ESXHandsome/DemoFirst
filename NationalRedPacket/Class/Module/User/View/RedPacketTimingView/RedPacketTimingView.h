//
//  RedPacketTimingView.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/3/23.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPSUserInfoModel.h"

@protocol RedPacketTimingViewDelegate <NSObject>

/**
 红包点击事件回调
 */
- (void)didClickTimingRedPacketEvent;

/**
 红包状态改变事件回调
 */
- (void)timingRedPacketShowStateChanged:(BOOL)available;

@end

@interface RedPacketTimingView : UIView

@property (strong, nonatomic) PPSUserInfoModel *userInfoModel;

/// 红包是否可用
@property (assign, nonatomic) BOOL packetIsAvailable;

@property (weak, nonatomic) id<RedPacketTimingViewDelegate> timingRedPacketDelegate;

/**
 更新红包状态

 @param updateInfoModel 更新信息
 */
- (void)updateTimingRedPacketStateWithInfo:(PPSUserInfoModel *)updateInfoModel;

/**
 更新定时红包状态
 
 @param isAvailable 定时红包是否可用
 @param countDown 定时红包倒计时时间戳
 @param availableTime 开抢时间
 */
- (void)updateTimingRedPacketAvailable:(BOOL)isAvailable
                         withCountDown:(long)countDown
                     withAvailableTime:(NSString *)availableTime;
@end
