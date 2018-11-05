//
//  SessionViewModel.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 开红包状态
 
 - XLRedPacketStateNormal: 红包等待打开
 - XLRedPacketStateOpening: 红包正在打开
 - XLRedPacketStateExpired: 红包过期
 - XLRedPacketStateReceived: 红包已领取
 - XLRedPacketStateDeliveryFinished: 红包派送完
 */

// 红包状态，0:可抢;1:已抢完;2:超时;3:已抢过;4:其它错误
typedef NS_ENUM(NSInteger, XLRedPacketState) {
    XLRedPacketStateNormal = 0,
    XLRedPacketStateDeliveryFinished = 1,
    XLRedPacketStateExpired = 2,
    XLRedPacketStateReceived = 3,
    XLRedPacketStateError = 4,
};

@protocol SessionViewModelDelegate <NSObject>

- (void)didUpdateOpenViewState:(XLRedPacketState)redPacketState;

@end

@interface XLSessionViewModel : NSObject

/**
 根据错误码获取红包状态
 */
- (XLRedPacketState)redPacketStateForStatusCode:(NSInteger)status;

/**
 打开群红包之前，检测红包状态
 */
- (void)fetchRedPacketStateWithMessage:(NIMMessage *)message
                               success:(SuccessBlock)success
                               failure:(FailureBlock)failure;

/**
 开红包
 */
- (void)grabRedPacketWithMessage:(NIMMessage *)message
                         success:(SuccessBlock)success
                         failure:(FailureBlock)failure;

/**
 获取群红包详情
 */
- (void)fetchRedPacketDetailWithMessage:(NIMMessage *)message
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure;

/**
 获取跳转群ID
 */
- (void)fetchJumpTeamIDWithType:(NSString *)type
                        Success:(SuccessBlock)success
                       failure:(FailureBlock)failure;
@end
