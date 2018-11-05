//
//  XLGDTNativeExpressAd.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/22.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLGDTNativeExpressAd.h"
#import "GDTNativeExpressAd.h"
#import "GDTNativeExpressAdView.h"
#import "XLFeedAdNativeExpressModel.h"
#import "GDTNativeExpressAdView+Extention.h"

@interface XLGDTNativeExpressAd ()<GDTNativeExpressAdDelegete>

@property (strong, nonatomic) GDTNativeExpressAd *nativeExpressAd;
@property (strong, nonatomic) NSMutableArray<XLFeedAdNativeExpressModel *> *nativeExpressAdViewsArray;
@property (assign, nonatomic) NativeExpressType nativeExpressType;

@end

@implementation XLGDTNativeExpressAd

- (void)fetchNativeExpressAd:(int)preloadCount withType:(NativeExpressType)type {
    if (![XLUserManager.shared registrationHourMoreThan24h]) {
        return;
    }
    _nativeExpressType = type;
    
    if (type == NativeExpressTypeHot) {
        HotPageAdModel *hotAd = [HotPageAdModel yy_modelWithJSON:[NSUserDefaults.standardUserDefaults objectForKey:XLUserDefaultsHotAdInfo]];
        if (!hotAd) {
            return;
        }
        self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithAppkey:hotAd.appId placementId:hotAd.adId adSize:CGSizeMake(SCREEN_WIDTH, adaptHeight1334(327*2))];
    } else {
        AttentionPageAdModel *followAd = [AttentionPageAdModel yy_modelWithJSON:[NSUserDefaults.standardUserDefaults objectForKey:XLUserDefaultsFollowAdInfo]];
        if (!followAd) {
            return;
        }
        self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithAppkey:followAd.appId placementId:followAd.adId adSize:CGSizeMake(SCREEN_WIDTH, adaptHeight1334(327*2))];
    }
    self.nativeExpressAd.delegate = self;
    
    // 拉取5条广告
    [self.nativeExpressAd loadAd:preloadCount];
}

#pragma mark - GDTNativeExpressAd Delegate

/**
 拉取广告成功的回调
 */
- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views {
    self.nativeExpressAdViewsArray = [self transformModelWithDicArray:views].mutableCopy;

    if (self.nativeExpressAdViewsArray.count && self.delegate && [self.delegate respondsToSelector:@selector(nativeExpressAdDidFetchSuccess:nativeExpressType:)]) {
        [self.delegate nativeExpressAdDidFetchSuccess:self.nativeExpressAdViewsArray nativeExpressType:self.nativeExpressType];
    }
    
    NSString *adId;
    if (self.nativeExpressType == NativeExpressTypeHot) {
        HotPageAdModel *hotAd = [HotPageAdModel yy_modelWithJSON:[NSUserDefaults.standardUserDefaults objectForKey:XLUserDefaultsHotAdInfo]];
        adId = hotAd.adId;
    } else {
        AttentionPageAdModel *followAd = [AttentionPageAdModel yy_modelWithJSON:[NSUserDefaults.standardUserDefaults objectForKey:XLUserDefaultsFollowAdInfo]];
        adId = followAd.adId;
    }
    
    [StatServiceApi statEvent:FEED_AD_REQUEST model:nil otherString:[NSString stringWithFormat:@"%@,%@,%@,%ld", TENCENT_CHANNEL, adId, @"5", views.count]];
}

/**
 拉取广告失败的回调
 */
- (void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(nativeExpressAdDidFetchFailure:nativeExpressType:)]) {
        [self.delegate nativeExpressAdDidFetchFailure:error nativeExpressType:self.nativeExpressType];
    }
}

/**
 原生模板广告点击回调
 */
- (void)nativeExpressAdViewClicked:(GDTNativeExpressAdView *)nativeExpressAdView {
    [StatServiceApi statEvent:FEED_AD_CLICK model:nil otherString:TENCENT_CHANNEL];
}

/**
 原生模板广告曝光回调
 */
- (void)nativeExpressAdViewExposure:(GDTNativeExpressAdView *)nativeExpressAdView {
    [StatServiceApi statEvent:FEED_AD_LOOK model:nil otherString:TENCENT_CHANNEL];
}

- (void)nativeExpressAdViewClosed:(GDTNativeExpressAdView *)nativeExpressAdView {
    if (nativeExpressAdView.deleteBlock) {
        nativeExpressAdView.deleteBlock();
    }
    [StatServiceApi statEvent:FEED_AD_CLOSE_CLICK model:nil otherString:TENCENT_CHANNEL];
}

#pragma mark - Private

- (NSArray<XLFeedAdNativeExpressModel *> *)transformModelWithDicArray:(NSArray *)dataArray {
    NSMutableArray *modelArray = [NSMutableArray array];
    NSTimeInterval nowTimestamp = [[NSDate date] timeIntervalSince1970];
    for (GDTNativeExpressAdView *view in dataArray) {
        XLFeedAdNativeExpressModel *model = [XLFeedAdNativeExpressModel new];
        model.expressAdView = view;
        model.fetchTimestamp = nowTimestamp;
        [modelArray addObject:model];
    }
    return modelArray;
}
#pragma mark - Custom Accessor

- (NSMutableArray *)nativeExpressAdViewsArray {
    if (!_nativeExpressAdViewsArray) {
        _nativeExpressAdViewsArray = [NSMutableArray new];
    }
    return _nativeExpressAdViewsArray;
}

@end
