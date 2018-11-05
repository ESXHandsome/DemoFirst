//
//  StatServiceApi.h
//  StatProject
//
//  Created by 刘永杰 on 2018/1/2.
//  Copyright © 2018年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatModel.h"
#import "XLFeedModel.h"

@interface StatServiceApi : NSObject

@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *refer;
@property (copy, nonatomic) NSString *currentVCStr;
@property (copy, nonatomic) NSString *lastVCStr;
@property (strong, nonatomic) NSMutableDictionary *viewControllerDictionary;

@property (copy, nonatomic) NSString *lastVideoStat;

+ (instancetype)sharedService;

+ (void)initWithStatUserId:(NSString *)userId refer:(NSString *)refer;

- (NSString *)pageDurationValueWithViewController:(UIViewController *)viewController;

/**
 目前在屏幕上显示的控制器

 @return 控制器数组
 */
- (NSMutableArray *)screenDisplayViewController;

/**
 统计自定义事件

 @param event 事件名称
 */
+ (void)statEvent:(NSString *)event;

/**
统计带数据的自定义事件

 @param event 事件名称
 @param model 数据
 */
+ (void)statEvent:(NSString *)event model:(id)model;

/**
 统计带数据及二级参数的自定义事件
 
 @param event 事件名称
 @param model 数据
 @param otherString 二级参数
 */
+ (void)statEvent:(NSString *)event model:(id)model otherString:(NSString *)otherString;

/**
 统计带数据及二级参数的自定义事件
 
 @param event 事件名称
 @param model 数据
 @param timeDuration 二级参数时长
 */
+ (void)statEvent:(NSString *)event model:(id)model timeDuration:(NSString *)timeDuration;

/**
 统计自定义事件开始
 
 @param event 事件名称
 */
+ (void)statEventBegin:(NSString *)event;

/**
 统计自定义事件结束
 
 @param event 事件名称
 */
+ (void)statEventEnd:(NSString *)event;

/**
 统计自定义事件开始

 @param event 事件名称
 @param model 数据
 */
+ (void)statEventBegin:(NSString *)event model:(id)model;

/**
 统计自定义事件结束

 @param event 事件名称
 @param model 数据
 */
+ (void)statEventEnd:(NSString *)event model:(id)model;

@end
