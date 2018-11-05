//
//  AppDelegate.m
//  NationalRedPacket
//
//  Created by 孙明悦 on 2017/5/31.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "AppDelegate.h"
#import "Jailbroken.h"
#import "TalkingData.h"
#import "BaseNavigationController.h"
#import "LaunchViewController.h"
#import "WechatLogin.h"
#import "RootTabViewController.h"
#import "TencentQQApi.h"
#import "WechatShare.h"
#import "RewardManager.h"
#import "FloatViewManager.h"
#import "DeviceApi.h"
#import "XLFileHandler.h"

#import "XLBadgeManager.h"
#import "XLNIMAPNs.h"

#import "XLRouter.h"
#import "XLSessionFansViewController.h"
#import "XLSessionVisitorViewController.h"
#import "TotalAssetViewController.h"
#import "NIMSessionViewController.h"
#import "XLRedPacketDetailViewController.h"

#import "XLGDTAdManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (instancetype)shared {
    return (AppDelegate *)UIApplication.sharedApplication.delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self configLocalSettings];
    });
    
    [self configSDKs];
    
    // 注册页面跳转路由
    [self registRoute];
    
    self.window = [[UIWindow alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    LaunchViewController *launchViewController = [[LaunchViewController alloc] init];
    self.window.rootViewController = launchViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)resetToRootTabViewController {
    self.window.rootViewController = [RootTabViewController new];
    [self.window makeKeyAndVisible];
}

- (void)resetToRootViewContoller:(UIViewController *)controller {
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
}

/**
 本地数据初始化设置
 */
- (void)configLocalSettings {
#ifdef DEBUG
#else
    [self antiJailbroken]; //越狱不能使用
#endif
    [NetworkManager.shared configNetworkMonitor];
    
    [RewardManager defaultRewardManager];
    
    [XLLoginManager shared];
    
    [XLBadgeManager.sharedManager registProfile];

    [XLGDTAdManager shared];
    // 清除音频文件
    [XLFileHandler clearCache];
    

}

/**
 配置第三方SDK
 */
- (void)configSDKs {
    
    [SDImageCache sharedImageCache].maxMemoryCost = 30 * 1024 * 1024;
    [SDImageCache sharedImageCache].maxMemoryCountLimit = 50;
    [SDImageCache sharedImageCache].config.shouldDecompressImages = NO;
    [SDWebImageDownloader sharedDownloader].shouldDecompressImages = NO;
    
    [TencentQQApi sharedInstance];
    [WechatShare sharedInstance];
    
    [TalkingData setExceptionReportEnabled:YES];
    [TalkingData sessionStarted:XLTakingDataToken withChannelId:XLAppChannel];
 
    // 配置云信
    [XLNIMService.shared initNIMSDKConfig];

    // 配置云信推送
    [XLNIMAPNs configRemoteNotification];
    
    // 清空推送未读个数
    [XLNIMAPNs clearAPNsBadgeCount];
}

#pragma mark - Open URL

- (void)registRoute {
    [XLRouter.sharedInstance registerRoutable:[XLSessionFansViewController class]];
    [XLRouter.sharedInstance registerRoutable:[XLSessionVisitorViewController class]];
    [XLRouter.sharedInstance registerRoutable:[TotalAssetViewController class]];
    [XLRouter.sharedInstance registerRoutable:[NIMSessionViewController class]];
    [XLRouter.sharedInstance registerRoutable:[XLRedPacketDetailViewController class]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    [WXApi handleOpenURL:url delegate:WechatLogin.shared];
    [[TencentQQApi sharedInstance] handleOpenUrl:url];
    [[WechatShare sharedInstance] handleOpenUrl:url];

    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options {
    
    [XLRouter.sharedInstance handleURL:url options:options];
    [WXApi handleOpenURL:url delegate:WechatLogin.shared];
    [[TencentQQApi sharedInstance] handleOpenUrl:url];
    [[WechatShare sharedInstance] handleOpenUrl:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    [WXApi handleOpenURL:url delegate:WechatLogin.shared];
    [[TencentQQApi sharedInstance] handleOpenUrl:url];
    [[WechatShare sharedInstance] handleOpenUrl:url];

    return YES;
}

#pragma mark - System Application Delegate

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    completionHandler(UIBackgroundFetchResultNewData);
    
    [XLNIMAPNs remoteNotificationTypePush:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
   
    [XLNIMAPNs remoteNotificationTypePush:userInfo];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
   
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    
    [StatServiceApi statEventEnd:APP_ACTIVITY_DURATION];
    [DeviceApi uploadUserDeviceInfoIsLaunchAPP:NO];
    [StatServiceApi statEventBegin:APP_BACKGROUND_DURATION];

    [XLNIMAPNs clearAPNsBadgeCount];
    [XLNIMAPNs updatePushLaunchClickState:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application cancelAllLocalNotifications];
    [application setApplicationIconBadgeNumber:0];

    [StatServiceApi statEventBegin:APP_ACTIVITY_DURATION];
    [WechatLogin.shared applicationWillEnterForegroundLoginCheck];
    [TencentQQApi.sharedInstance applicationWillEnterForegroundLoginCheck];
    [DeviceApi uploadUserDeviceInfoIsLaunchAPP:YES];
    [StatServiceApi statEventEnd:APP_BACKGROUND_DURATION];
   
    [XLNIMAPNs clearAPNsBadgeCount];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [XLFileHandler clearCache];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[SDImageCache sharedImageCache] clearMemory];
}

#pragma mark - Private

- (void)antiJailbroken {
    int res = 0;
    [Jailbroken detect:&res];
    if (res != 0) {
        exit(0);
    }
}

@end
