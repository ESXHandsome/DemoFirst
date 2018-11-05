//
//  SuspensionViewManage.h
//  NationalRedPacket
//
//  Created by Ying on 2018/1/24.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FloatViewModel.h"
#import "FloatView.h"
#import "XLAppletsModel.h"

@interface FloatViewManager : NSObject

@property (strong, nonatomic) FloatViewModel *floatViewModel;           /// 悬浮窗数据模型
@property (strong, nonatomic) FloatViewModel *popAlertModel;             /// 弹窗数据模型
@property (strong, nonatomic) FloatView *floatView;                     /// 悬浮窗视图
@property (assign, nonatomic) AppearAnimationMode appearMode;           /// 出现位置信息
@property (assign, nonatomic) DisappearAnimationMode disappearMode;     /// 消失位置信息
@property (assign, nonatomic) StayMode stayMode;                        /// 悬浮位置信息
@property (assign, nonatomic) CloseButtonPosition closeButtonMode;      /// 关闭按钮位置信息
@property (copy, nonatomic)   NSString *currentClassString;             /// 当前悬浮窗类名
@property (strong, nonatomic) UIViewController *currentViewController;  /// 当前视图控制器
@property (strong, nonatomic) NSArray<XLAppletsModel *> *appletsArray;  /// 小程序入口

/**
 单例类

 @return self
 */
+ (instancetype) sharedInstance;

/**
 获取当前视图控制器

 @param currentViewController 当前控制器
 */
- (void)getCurrentVeiwController:(UIViewController*)currentViewController;

/**
 展示悬浮视图
 */
- (void)showSuspensionView;

/**
 拉去悬浮视图数据
 */
- (void)fetchFloatViewResorce:(void(^)(void))success;

/**
 展示H5入口弹窗
 */
- (void)showH5AlertView;
@end
