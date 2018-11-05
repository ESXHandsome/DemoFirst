//
//  XLGDTAd.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/22.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XLGDTSplashAdDelegate <NSObject>

@optional;
/**
 广告关闭
 */
- (void)splashAdDidClose;

@end

@interface XLGDTSplashAd : NSObject

@property (weak, nonatomic) id<XLGDTSplashAdDelegate> delegate;

/**
 开屏广告初始化并展示
 */
- (void)showSplashAd;

/**
 记录应用挂起时间，用来判断再次启动时是否需要展示广告
 */
- (void)updateAplicationWillResignActiveTimestamp;

/**
 是否展示开屏广告
 */
- (BOOL)shouldShowSplashAd;

@end
