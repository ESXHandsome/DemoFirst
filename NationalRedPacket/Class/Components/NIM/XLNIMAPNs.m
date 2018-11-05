//
//  XLNIMAPNs.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/20.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLNIMAPNs.h"
#import "XLNIMConst.h"
#import "NewsApi.h"
#import "XLNotificationModel.h"
#import "AppDelegate.h"

#import "NIMSessionViewController.h"
#import "FeedDetailViewController.h"
#import "FeedImageDetailViewController.h"
#import "FeedVideoDetailViewController.h"

#import "XLSessionFansViewController.h"
#import "XLSessionVisitorViewController.h"
#import "XLSessionLikedViewController.h"
#import "XLSessionCommentViewController.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

/// 用于判断是否点击推送消息启动应用
static BOOL isClickPushLaunch;

@implementation XLNIMAPNs

#pragma mark - Public

+ (void)configRemoteNotification {
    isClickPushLaunch = YES;
    
    [[NIMSDK sharedSDK] registerWithAppID:XLNIMAppKey cerName:XLNIMAPNSCertificateName];
    UIUserNotificationType types = UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound |      UNNotificationPresentationOptionAlert;
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound |      UNNotificationPresentationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        [StatServiceApi statEvent:ALLOW_PUSH model:nil otherString:(!error && granted) ? @"1" : @"2"];
    }];
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                             categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

+ (void)remoteNotificationTypePush:(NSDictionary *)userInfo {
    
    [StatServiceApi statEvent:PUSH_CLICK model:nil otherString:[NSString stringWithFormat:@"%@&%@", isClickPushLaunch ? @"0" : @"1", userInfo[@"attach"]]];
    
    XLNotificationModel *notificationModel = [XLNotificationModel yy_modelWithJSON:userInfo[@"attach"]];
    //如果推送无attach 附加信息，直接return, 否则会导致第一个if判断永远可走
    if (![userInfo.allKeys containsObject:@"attach"]) {
        return;
    }
    //延迟0.5秒执行，避免直观感觉太唐突
    [self performSelector:@selector(handlePageSwitchWithNotificationModel:) withObject:notificationModel afterDelay:0.5];
    isClickPushLaunch = NO;
    
}

+ (void)clearAPNsBadgeCount {
    
    [NIMSDK.sharedSDK.apnsManager registerBadgeCountHandler:^NSUInteger{
        return 0;
    }];
}

+ (void)updatePushLaunchClickState:(BOOL)isClickPushLaunch {
    isClickPushLaunch = isClickPushLaunch;
}

#pragma mark - Private

+ (void)handlePageSwitchWithNotificationModel:(XLNotificationModel *)notificationModel {
    
    UIViewController *currentVC = [UIViewController currentViewController];
    if (!XLLoginManager.shared.isVisitorLogined) {  //通过推送消息打开的APP,需要等待进入主页的回调，才能进行跳转
        XLLoginManager.shared.EnterRootViewController = ^{
            [self performSelector:@selector(handlePageSwitchWithNotificationModel:) withObject:notificationModel afterDelay:0.2];
        };
        return;
    }
    switch (notificationModel.action) {
        case NotificationJumpTypeSession: {
            [self pushSessionViewControllerWithNotificationModel:notificationModel];
            break;
        }
        case NotificationJumpTypeHome: {
            [(AppDelegate*)[UIApplication sharedApplication].delegate resetToRootTabViewController];
            break;
        }
        case NotificationJumpTypeHomeRefresh: {
            [(AppDelegate*)[UIApplication sharedApplication].delegate resetToRootTabViewController];
            break;
        }
        case NotificationJumpTypeFeedDetail: {
            [self pushFeedDetailWithNotificationModel:notificationModel];
            break;
        }
        case NotificationJumpTypeSessionFans: {
            [currentVC showViewController:[XLSessionFansViewController new] sender:nil];
            break;
        }
        case NotificationJumpTypeSessionVisitor: {
            [currentVC showViewController:[XLSessionVisitorViewController new] sender:nil];
            break;
        }
        case NotificationJumpTypeSessionPraise: {
            [currentVC showViewController:[XLSessionLikedViewController new] sender:nil];
            break;
        }
        case NotificationJumpTypeSessionComment: {
            [currentVC showViewController:[XLSessionCommentViewController new] sender:nil];
            break;
        }
    }
}

/**
 跳转Feed流，暂时请求到模型数据后再跳转，FeedDetail加载模型，改动过大，后续修改此逻辑
 
 @param notificationModel 推送模型
 */
+ (void)pushFeedDetailWithNotificationModel:(XLNotificationModel *)notificationModel {
        
    [NewsApi fetchFeedDetailWithId:notificationModel.feedId feedType:notificationModel.itemType success:^(id responseDict) {
        
        XLFeedModel *feedModel = [XLFeedModel yy_modelWithDictionary:responseDict];
        
        FeedDetailViewController *detailVC;
        if ([notificationModel.itemType isEqualToString:@"image"]) {
            detailVC = [FeedImageDetailViewController new];
            
        } else if ([notificationModel.itemType isEqualToString:@"video_horiz"] ||
                   [notificationModel.itemType isEqualToString:@"video_verti"]) {
            detailVC = [FeedVideoDetailViewController new];
        }
        
        detailVC.viewModel = [[FeedDetailViewModel alloc] initWithFeed:feedModel];
        
        [[UIViewController currentViewController].navigationController pushViewController:detailVC animated:YES];
        
    } failure:^(NSInteger errorCode) {
        
    }];
}

+ (void)pushSessionViewControllerWithNotificationModel:(XLNotificationModel *)notificationModel {

    NIMSession *session = [NIMSession session:notificationModel.teamId type:notificationModel.sessionType.integerValue == 0 ? NIMSessionTypeTeam : NIMSessionTypeP2P];
    
    [UIApplication.sharedApplication openURL:[NSURL routerURLWithAliasName:@"NIMSessionViewController" optionsBlock:^(NSMutableDictionary *options) {
        options[XLRouterOptionControllerShowTypeKey] = @(XLRouterOptionControllerShowTypeNavigate);
        options[XLRouterOptionControllerArgumentkey] = @{XLRouterArgumentSessionKey : session};
    }]];
}

@end
