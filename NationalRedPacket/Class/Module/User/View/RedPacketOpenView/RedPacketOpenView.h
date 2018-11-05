//
//  RedPacketOpenView.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/3/21.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareConfigModel.h"

/**
 红包类型
 
 - RedPacketTypeLogin: 登录奖励红包
 - RedPacketTypeTiming: 定时红包
 - RedPacketTypeInvite: 邀请奖励红包
 */
typedef NS_ENUM (NSInteger, RedPacketType) {
    RedPacketTypeLogin = 2,
    RedPacketTypeTiming = 3,
    RedPacketTypeInvite = 4
};

/**
 开红包状态

 - RedPacketStateNormal: 等待打开状态
 - RedPacketStateOpening: 正在打开状态
 - RedPacketStateOpenedSuccess: 红包打开成功状态
 - RedPacketStateOpenedFailure: 红包打开失败状态
 */
typedef NS_ENUM(NSInteger, RedPacketOpenViewState) {
    RedPacketStateDefault = 2,
    RedPacketStateOpening = 3,
    RedPacketStateOpenedSuccess = 4,
    RedPacketStateOpenedFailure = 5,
    RedPacketStateSharedSuccess = 6
};

/**
 开红包视图关闭方式

 - RedPacketOpenViewCloseTypeButton: 点击关闭按钮关闭
 - RedPacketOpenViewCloseTypeBackground: 点击背景关闭
 - RedPacketOpenViewCloseTypeALL: 点击关闭按钮关闭与点击背景关闭
 - RedPacketOpenViewCloseTypeNone: 无关闭操作
 */
typedef NS_ENUM(NSInteger, RedPacketOpenViewCloseType) {
    RedPacketOpenViewCloseTypeButton = 2,
    RedPacketOpenViewCloseTypeBackground = 3,
    RedPacketOpenViewCloseTypeDefault = 4,
    RedPacketOpenViewCloseTypeNone = 5
};

@protocol OpenViewDelegate <NSObject>

@optional

/**
 “開”按钮点击事件回调
 */
- (void)didClickOpenButtonEvent;

/**
 分享按钮点击事件回调
 */
- (void)didClickShareButtonEvent:(ShareConfigModel *)shareConfigModel;

/**
 确认按钮点击事件回调
 */
- (void)didClickConfirmButtonEvent:(NSDictionary *)updateInfo;

/**
 关闭按钮点击事件回调
 */
- (void)didClickCloseButtonEvent:(NSDictionary *)updateInfo;

@end

@interface RedPacketOpenView : UIView

/// 视图状态 Default state is RedPacketOpenViewCloseTypeALL
@property (assign, nonatomic) RedPacketOpenViewState openViewState;

/// 视图关闭类型。Default type is RedPacketOpenViewCloseTypeALL
@property (assign, nonatomic) RedPacketOpenViewCloseType openViewCloseType;

/// 视图代理
@property (weak, nonatomic) id<OpenViewDelegate> openViewDelegate;

/// 红包类型
@property (assign, nonatomic) RedPacketType redPacketType;


/**
 展示开红包弹窗

 @param type 红包类型
 */
- (void)showWithRedPacketType:(RedPacketType)type;

/**
 更新开红包弹窗状态

 @param state 状态
 @param updateInfo 更新信息
 */
- (void)updateOpenViewState:(RedPacketOpenViewState)state
             withUpdateInfo:(NSDictionary *)updateInfo;

/**
 停止“開”旋转动画
 */
- (void)stopOpenButtonAnimation;

@end
