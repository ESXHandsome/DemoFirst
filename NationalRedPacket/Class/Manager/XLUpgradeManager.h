//
//  UpgradeManager.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/20.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLUpgradeManager : NSObject

/// 是否需要提示更新
@property (assign, nonatomic, readonly) BOOL isNeedUpgrade;

/// 提示更新的描述信息
@property (strong, nonatomic, readonly) NSString *_Nullable message;

/** 单例 */
+ (instancetype)shared;

/**
 重新加载升级信息
 */
- (void)reloadUpgradeInfo:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 升级，会跳转至外部地址
 */
- (void)upgrade;

@end
