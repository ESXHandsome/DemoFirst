//
//  RedPacketOpenView.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/3/21.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLSessionViewModel.h"
#import "XLSessionRedPacketWaitOpenModel.h"

/**
 开红包视图关闭方式
 
 - RedPacketOpenViewCloseTypeButton: 点击关闭按钮关闭
 - RedPacketOpenViewCloseTypeBackground: 点击背景关闭
 - RedPacketOpenViewCloseTypeALL: 点击关闭按钮关闭与点击背景关闭
 - RedPacketOpenViewCloseTypeNone: 无关闭操作
 */
typedef NS_ENUM(NSInteger, XLRedPacketOpenViewCloseType) {
    XLRedPacketOpenViewCloseTypeButton,
    XLRedPacketOpenViewCloseTypeBackground ,
    XLRedPacketOpenViewCloseTypeDefault,
    XLRedPacketOpenViewCloseTypeNone
};

@protocol XLOpenViewDelegate <NSObject>

@optional

/**
 “開”按钮点击事件回调
 */
- (void)openButtonDidClickWithMessage:(NIMMessage *)message
                         openViewInfo:(XLSessionRedPacketWaitOpenModel *)waitOpenModel;


/**
 关闭按钮点击事件回调
 */
- (void)didClickCloseButtonEvent:(NSDictionary *)updateInfo;

/**
 查看详情按钮点击事件回调
 */
- (void)detailButtonDidClickWithMessage:(NIMMessage *)message;

@end

@interface XLSessionRedPacketOpenView : UIView

/// 视图关闭类型。Default type is RedPacketOpenViewCloseTypeALL
@property (assign, nonatomic) XLRedPacketOpenViewCloseType openViewCloseType;

/// 视图代理
@property (weak, nonatomic) id<XLOpenViewDelegate> delegate;


/**
 展示开红包弹窗
*/
- (void)showRedPacketOpenViewWithMessage:(NIMMessage *)message
                            openViewInfo:(XLSessionRedPacketWaitOpenModel *)waitOpenModel;

/**
 更新开红包弹窗状态
 */
- (void)updateRedPacketOpenViewWithMessage:(NIMMessage *)message
                            openViewInfo:(XLSessionRedPacketWaitOpenModel *)waitOpenModel;

/**
 停止“開”旋转动画
 */
- (void)stopOpenButtonAnimation;

@end
