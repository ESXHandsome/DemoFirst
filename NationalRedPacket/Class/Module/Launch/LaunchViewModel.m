//
//  LaunchTool.m
//  NationalRedPacket
//
//  Created by Ying on 2018/4/12.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "LaunchViewModel.h"
#import "RewardManager.h"
#import "RedPointManager.h"
#import "AppDelegate.h"
#import "DeviceApi.h"
#import "NewUserGuideViewController.h"
#import "XLUpgradeManager.h"
#import "XLStartConfigManager.h"
#import "FloatViewManager.h"
#import "XLBadgeManager.h"
#import "XLDownloadVideo.h"
#import "XLSaveVideo.h"

@implementation LaunchViewModel

#pragma mark - Relogin
/**启动配置*/
- (void)startConfig {
    @weakify(self);
    /**先登录,登录完再拉数据*/
    [XLLoginManager.shared relogin:^(id responseDict) {
        @strongify(self);
        [self loginSuccess:responseDict];
    } failure:^(NSInteger errorCode) {
        @strongify(self);
        /**登录失败, 直接进主页*/
        [self resetWindowRootViewController];
        [MBProgressHUD showError:@"网络出现故障"];
    }];
}

- (void)loginSuccess:(id)responseDict {
    /**拉取悬浮窗数据,拉取完自动显示在视图上*/
    @weakify(self);
    [[FloatViewManager sharedInstance] fetchFloatViewResorce:^{
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(finishToFetchData)]) {
            [self.delegate finishToFetchData];
        }
    }];
    /**IM登录*/
    [XLNIMService.shared configNIMAccount:responseDict[@"imAccid"] token:responseDict[@"imToken"]];
    /**TODO:登录成功 展示广告,展示完成调prepareToResetRootViewController*/
    
    /**配置信息*/
    [XLStartConfigManager.shared fetchStartConfigData:^(XLStartConfigModel *model) {
        if (![[NSUserDefaults standardUserDefaults] objectForKey:XLUserDefaultNewUserGestureGuide] &&
            model.hotPageLeadImg == 1) {
            /**需要新手手势弹窗,所有不能展示H5入口弹窗*/
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:XLUserDefaultsNeedPopAlertView];
        }
    } failed:^{
        /**失败直接跳转*/
        @strongify(self);
        [self resetWindowRootViewController];
    }];
}

- (void)prepareToResetRootViewController {
    
    /**是否需要推荐页*/
    if (XLStartConfigManager.shared.startConfigModel.startRecommend && [self isNewUser]) {
        [self pushRecommendViewController];
    } else {
        [self resetWindowRootViewController];
    }
}

/**直接跳转到首页*/
- (void)resetWindowRootViewController{
    /**IM自动登录*/
    [XLNIMService.shared autoLogin];
    /**检测版本*/
    [self checkVersion];
    /**上传设备信息*/
    [DeviceApi uploadUserDeviceInfoIsLaunchAPP:YES];
    /**直接跳转主页*/
    [self pushMainViewController];
    /**消息红点**/
    [XLBadgeManager.sharedManager registProfile];
    /**TODU红点红包逻辑*/
    /**消息推送进入主页的回调**/
    if (XLLoginManager.shared.EnterRootViewController) {
        XLLoginManager.shared.EnterRootViewController();
    }
}

/**跳转到主页*/
- (void)pushMainViewController {
    [(AppDelegate*)[UIApplication sharedApplication].delegate resetToRootTabViewController];
//    [self reloadVideo];
}

/**下载未下完的视频*/

- (void)reloadVideo {
    /**看看上次是不是有没下载完的视频  给丫重新下载一遍*/
    if ([[NSUserDefaults standardUserDefaults] objectForKey:XLUnDownloadVideo]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[XLDownloadVideo sharedInstance] downloadVideo:[[NSUserDefaults standardUserDefaults] objectForKey:XLUnDownloadVideo] success:^(id  _Nonnull path) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [XLSaveVideo writeVideoToPhotoLibrary:[NSURL URLWithString:path]];
                });
            } progress:nil failed:^(id  _Nonnull error) {
            } ];
        });
    }
}

/**检查版本*/
- (void)checkVersion {
    [XLUpgradeManager.shared reloadUpgradeInfo:^(id responseDict) {
        if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UITabBarController class]]) {
            UITabBar *tabBar = [(UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController tabBar];
            if (XLUpgradeManager.shared.isNeedUpgrade) {
                [tabBar showBadgeOnItemIndex:3];
            }
        }
    } failure:^(NSInteger errorCode) {
        [MBProgressHUD showError:@"检查更新出现问题"];
    }];
}

/**推出推荐页*/
- (void)pushRecommendViewController {
    if (self.delegate && [self respondsToSelector:@selector(pushRecommendViewController)]) {
        [self.delegate pushRecommendViewController];
    }
}

- (BOOL)isNewUser {
    return ![NSUserDefaults.standardUserDefaults boolForKey:XLUserDefaultsIsNewUserKey];
}

@end
