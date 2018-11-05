//
//  XLGDTAdManager.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/22.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLGDTNativeExpressAd.h"

@protocol XLGDTAdManagerDelegate <NSObject>

- (void)gdtSplashAdDidClose;

@end

@interface XLGDTAdManager : NSObject

@property (weak, nonatomic) id<XLGDTAdManagerDelegate> delegate;

/// 未使用的模板广告
@property (strong, nonatomic) NSMutableArray<XLFeedAdNativeExpressModel *> *hotNativeExpressMArray;
@property (strong, nonatomic) NSMutableArray<XLFeedAdNativeExpressModel *> *followNativeExpressMArray;

+ (instancetype)shared;

/**
 是否展示开屏广告
 */
- (BOOL)shouldShowSplashAd;

/**
 展示开屏广告
 */
- (void)showSplashAd;

/**
 拉取原生模板广告
 */
- (void)fetchNativeExpressAd:(NativeExpressType)type;

/**
 获取广告，默认在nativeExpressMArray数组中，从index=0开始取广告，如果对应广告过期则移除，再取下一个广告
 */
- (XLFeedAdNativeExpressModel *)getExpressAdWithNativeExpressType:(NativeExpressType)type;

@end
