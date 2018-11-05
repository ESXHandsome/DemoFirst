//
//  XLGDTAd.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/22.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLGDTSplashAd.h"
#import "GDTSplashAd.h"
#import "AppDelegate.h"

@interface XLGDTSplashAd () <GDTSplashAdDelegate>

@property (strong, nonatomic) GDTSplashAd *splashAd;
@property (strong, nonatomic) UIView *bottomView;

@end

@implementation XLGDTSplashAd

/**
 开屏广告初始化并展示
 */
- (void)showSplashAd {
    if (![self shouldShowSplashAd]) {
        [self adDisplayFinished];
        return;
    }
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
        [self adDisplayFinished];
        return;
    }
    ScreenAdModel *splashAd = [ScreenAdModel yy_modelWithJSON:[NSUserDefaults.standardUserDefaults objectForKey:XLUserDefaultsSplashAdInfo]];
    if (!splashAd) {
        [self adDisplayFinished];
        return;
    }
    self.splashAd = [[GDTSplashAd alloc] initWithAppkey:splashAd.appId placementId:splashAd.adId];
    self.splashAd.delegate = self;
    // 设置开屏拉取时长限制，若超时则不再展示广告
    self.splashAd.fetchDelay = 3;
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, adaptHeight1334(120*2))];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.clipsToBounds = YES;
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"launch_bottom"]];
    [self.bottomView addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.centerX.equalTo(self.bottomView.mas_centerX);
        make.bottom.equalTo(self.bottomView.mas_bottom);
        make.height.mas_equalTo(adaptHeight1334(135*2));
    }];
    UIWindow *window = AppDelegate.shared.window;
    //如果window已有弹出的视图，会导致广告无法弹出，页面卡死，这里需要先把视图关闭，再弹出广告
    if (window.rootViewController.presentedViewController != nil) {
        [window.rootViewController dismissViewControllerAnimated:NO completion:nil];
    }
    [self.splashAd loadAdAndShowInWindow:window withBottomView:self.bottomView skipView:nil];
}

/**
 记录应用挂起时间，用来判断再次启动时是否需要展示广告
 */
- (void)updateAplicationWillResignActiveTimestamp {
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    [NSUserDefaults.standardUserDefaults setDouble:timestamp forKey:XLUserDefaultsResignActiveTimestamps];
    [NSUserDefaults.standardUserDefaults synchronize];
}

#pragma mark - Private

/**
 判断是否应该展示广告
 */
- (BOOL)shouldShowSplashAd {
    // 云控显示不显示开屏广告
    ScreenAdModel *splashAd = [ScreenAdModel yy_modelWithJSON:[NSUserDefaults.standardUserDefaults objectForKey:XLUserDefaultsSplashAdInfo]];
    if (!splashAd) {
        return NO;
    }
    if (!splashAd.show) {
        return NO;
    }
    if (![XLUserManager.shared registrationHourMoreThan24h]) {
        return NO;
    }
    return YES;
}

#pragma mark - GDTSplashAd Delegate

/**
 *  开屏广告成功展示
 */
-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd {
    [StatServiceApi statEvent:SCREEN_AD_LOOK model:nil otherString:TENCENT_CHANNEL];
}

/**
 开屏广告展示失败
 */
-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error {
    if (error.code != 3001) {  //如果因为网络错误，导致开屏广告加载失败的话，不需要回调处理
        [self adDisplayFinished];
    }
}

/**
 开屏广告点击回调
 */
- (void)splashAdClicked:(GDTSplashAd *)splashAd {
    [StatServiceApi statEvent:SCREEN_AD_CLICK model:nil otherString:TENCENT_CHANNEL];
}

/**
 点击跳过
 */
- (void)splashAdWillClosed:(GDTSplashAd *)splashAd {
    [self adDisplayFinished];
    [StatServiceApi statEvent:SCREEN_AD_CLOSE_CLICK model:nil otherString:TENCENT_CHANNEL];
}

/**
 开屏广告关闭回调
 */
- (void)splashAdClosed:(GDTSplashAd *)splashAd {
    if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UITabBarController class]]) {
        return;
    }
    [self adDisplayFinished];
}

/**
 点击以后全屏广告页将要关闭
 */
- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd {
    [self adDisplayFinished];
}

/**
 点击以后全屏广告页已经关闭
 */
- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd {
    if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UITabBarController class]]) {
        return;
    }
    [self adDisplayFinished];
}

/**
 广告关闭时
 */
- (void)adDisplayFinished {
    if (self.delegate && [self.delegate respondsToSelector:@selector(splashAdDidClose)]) {
        [self.delegate splashAdDidClose];
    }
}

@end
