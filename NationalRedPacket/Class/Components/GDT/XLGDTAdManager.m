//
//  XLGDTAdManager.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/22.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLGDTAdManager.h"
#import "XLGDTSplashAd.h"

@interface XLGDTAdManager ()<XLGDTSplashAdDelegate, XLGDTNativeExpressAdDelegate>

@property (strong, nonatomic) XLGDTSplashAd *splashAd;
@property (strong, nonatomic) XLGDTNativeExpressAd *hotNativeExpressAd;
@property (strong, nonatomic) XLGDTNativeExpressAd *followNativeExpressAd;

@property (assign, nonatomic) BOOL isNotFirstBecomeActive;

@end

@implementation XLGDTAdManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static XLGDTAdManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [XLGDTAdManager new];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {

        self.splashAd = [XLGDTSplashAd new];
        self.splashAd.delegate = self;
    
        [self.hotNativeExpressAd fetchNativeExpressAd:5 withType:NativeExpressTypeHot];
        [self.followNativeExpressAd fetchNativeExpressAd:5 withType:NativeExpressTypeFollow];

        [self addNotification];

        double firstLaunchTimestamp = [[NSUserDefaults.standardUserDefaults objectForKey:XLUserDefaultsAPPFirstLaunchTimestamps] doubleValue];
        if (firstLaunchTimestamp == 0) {
            NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
            [NSUserDefaults.standardUserDefaults setDouble:timestamp forKey:XLUserDefaultsAPPFirstLaunchTimestamps];
            [NSUserDefaults.standardUserDefaults synchronize];
        }
    }
    return self;
}

/**
 是否展示开屏广告
 */
- (BOOL)shouldShowSplashAd {
    return [self.splashAd shouldShowSplashAd];
}

/**
 展示开屏广告
 */
- (void)showSplashAd {
    [self.splashAd showSplashAd];
}

/**
 拉取原生模板广告到本地
 */
- (void)fetchNativeExpressAd:(NativeExpressType)type {
    [[self adNativeExpressAd:type] fetchNativeExpressAd:5 withType:type];
}

/**
 获取一个原生模板广告
 */
- (XLFeedAdNativeExpressModel *)getExpressAdWithNativeExpressType:(NativeExpressType)type {
    NSMutableArray *adArray = [self adArrayWithNativeExpressType:type];

    // 本地没有原生模板广告
    if (adArray.count == 0) {
        [[self adNativeExpressAd:type] fetchNativeExpressAd:5 withType:type];
        return nil;
    }
    XLFeedAdNativeExpressModel *model = adArray[0];
    NSTimeInterval fetchTimestamp = model.fetchTimestamp;
    NSTimeInterval nowTimestamp = [[NSDate date] timeIntervalSince1970];
    // 如果广告过期，将广告移除，获取下一个广告
    if ((nowTimestamp - fetchTimestamp)/60 > 30) {
        [adArray removeObject:model];
        return [self getExpressAdWithNativeExpressType:type];
    }
    [adArray removeObject:model];
  
    // 本地没有原生模板广告
    if (adArray.count == 0) {
        [[self adNativeExpressAd:type] fetchNativeExpressAd:5 withType:type];
    }
    return model;
}

#pragma mark - SplashAd Delegate

- (void)splashAdDidClose {
    if(self.delegate && [self.delegate respondsToSelector:@selector(gdtSplashAdDidClose)]) {
        [self.delegate gdtSplashAdDidClose];
    }
}

#pragma mark - NativeExpressAd Delegate

- (void)nativeExpressAdDidFetchSuccess:(NSArray *)dataArray nativeExpressType:(NativeExpressType)type {
    if (type == NativeExpressTypeHot) {
        [self.hotNativeExpressMArray addObjectsFromArray:dataArray];
    } else {
        [self.followNativeExpressMArray addObjectsFromArray:dataArray];
    }
}

- (void)nativeExpressAdDidFetchFailure:(NSError *)error {
    
}

#pragma mark - Notification

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActiveNotification)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActiveNotification)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

/**
 应用挂起时，记录本次退出时间，下次启动时，根据时间间隔，判断是否展示广告
 */
- (void)applicationWillResignActiveNotification {
    [self.splashAd updateAplicationWillResignActiveTimestamp];
}

- (void)applicationDidBecomeActiveNotification {
    if (self.isNotFirstBecomeActive && [self shouldShowSplashAd] && [self isAppResignMoreThan3Min]) {
        [self.splashAd showSplashAd];
    }
    self.isNotFirstBecomeActive = YES;
}

#pragma mark - Private

/**
 删除使用过的模板广告
 
 @param indexSet index集合
 */
- (void)removeExpressAdAtIndexs:(NSIndexSet *)indexSet withNativeExpressType:(NativeExpressType)type {
    NSMutableArray *adArray = [self adArrayWithNativeExpressType:type];
    [adArray removeObjectsAtIndexes:indexSet];
    if (adArray.count < 3) {
        [[self adNativeExpressAd:type] fetchNativeExpressAd:5 withType:type];
    }
}

/**
 删除使用过的模板广告
 */
- (void)removeExpressAdAtIndex:(NSInteger)index withNativeExpressType:(NativeExpressType)type {
    NSMutableArray *adArray = [self adArrayWithNativeExpressType:type];
    [adArray removeObjectAtIndex:index];
    if (adArray.count < 3) {
        [[self adNativeExpressAd:type] fetchNativeExpressAd:5 withType:type];
    }
}

- (NSMutableArray *)adArrayWithNativeExpressType:(NativeExpressType)type {
    if (type == NativeExpressTypeHot) {
        return self.hotNativeExpressMArray;
    }
    return self.followNativeExpressMArray;
}

- (BOOL)isAppResignMoreThan3Min {
    double nowTimestamp = [[NSDate date] timeIntervalSince1970];
    double lastResignActiveTimestamp = [[NSUserDefaults.standardUserDefaults objectForKey:XLUserDefaultsResignActiveTimestamps] doubleValue];
    // 后台到前台，3分钟之内不显示广告
    if ((nowTimestamp - lastResignActiveTimestamp) / 60 > 3) {
        return YES;
    }
    return NO;
}

#pragma mark - Custom Accessor

- (NSMutableArray<XLFeedAdNativeExpressModel *> *)hotNativeExpressMArray {
    if (!_hotNativeExpressMArray) {
        _hotNativeExpressMArray = [NSMutableArray new];
    }
    return _hotNativeExpressMArray;
}

- (NSMutableArray<XLFeedAdNativeExpressModel *> *)followNativeExpressMArray {
    if (!_followNativeExpressMArray) {
        _followNativeExpressMArray = [NSMutableArray new];
    }
    return _followNativeExpressMArray;
}

- (XLGDTNativeExpressAd *)adNativeExpressAd:(NativeExpressType)type {
    if (type == NativeExpressTypeHot) {
        return self.hotNativeExpressAd;
    } else {
        return self.followNativeExpressAd;
    }
}

- (XLGDTNativeExpressAd *)hotNativeExpressAd {
    if (!_hotNativeExpressAd) {
        _hotNativeExpressAd = [XLGDTNativeExpressAd new];
        _hotNativeExpressAd.delegate = self;
    }
    return _hotNativeExpressAd;
}

- (XLGDTNativeExpressAd *)followNativeExpressAd {
    if (!_followNativeExpressAd) {
        _followNativeExpressAd = [XLGDTNativeExpressAd new];
        _followNativeExpressAd.delegate = self;
    }
    return _followNativeExpressAd;
}

@end
