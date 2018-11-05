//
//  XLUserDefaultsConst.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/19.
//  Copyright © 2018年 XLook. All rights reserved.
//

#ifndef XLUserDefaultsConst_h
#define XLUserDefaultsConst_h

/// 账号 UUID
static NSString * const XLUserDefaultsUUIDKey = @"ACCOUNT_UUID";
/// 用户 UserId
static NSString * const XLUserDefaultsUserIdKey = @"XLUserDefaultsUserIdKey";

/// 第三方登录 OpenID
static NSString * const XLUserDefaultsThirdpartyOpenIdKey = @"THIRDPARTY_OPEN_ID";
/// 第三方登录 Token
static NSString * const XLUserDefaultsThirdpartyAccessTokenKey = @"THIRDPARTY_ACCESS_TOKEN";
/// 第三方登录 Platform
static NSString * const XLUserDefaultsThirdpartyPlatformKey = @"THIRDPARTY_PLATFORM";

/// 网易云信 Account
static NSString * const XLUserDefaultsNIMAccount = @"NIM_ACCOUNT";
/// 网易云信 Token
static NSString * const XLUserDefaultsNIMToken   = @"NIM_TOKEN";

/// 用户是否分享过
static NSString * const XLUserDefaultsIsOnceSharedKey = @"LIST_OR_ARTICLE_IS_SHARED";

/// 是否第一次播放视频
static NSString * const XLUserDefaultsIsFirstPlayVideoKey = @"IS_FIRSTPLAYVIDEO";
/// 是否是新用户
static NSString * const XLUserDefaultsIsNewUserKey = @"IS_NEW_USER";

/// 会话草稿
static NSString * const XLUserDefaultsSessionDraftKey = @"SESSION_DRAFT";


///新用户首次进入主页引导
static NSString * const XLUserDefaultNewUserGestureGuide = @"NEW_USER_GESTURE_GUDIE";

/// 私聊红包是否展示详情
static NSString * const XLUserDefaultsFollowRedPacketShowDetail = @"FOLLOW_REDPACKET_SHOW_DETAIL";

/// 应用挂起时间戳
static NSString * const XLUserDefaultsResignActiveTimestamps = @"APP_RESIGN_ACTIVE_TIMESTAMPS";

/// 应用第一次启动时间戳
static NSString * const XLUserDefaultsAPPFirstLaunchTimestamps = @"APP_FIRST_LAUNCH_TIMESTAMPS";

/// 程序是否需要弹窗
static NSString * const XLUserDefaultsNeedPopAlertView = @"APP_NEED_POP_AlERTVIEW";

/// 启动广告信息
static NSString * const XLUserDefaultsSplashAdInfo = @"SPLASH_AD_INFO";

/// 关注广告信息
static NSString * const XLUserDefaultsFollowAdInfo = @"FOLLOW_AD_INFO";

/// 热门广告信息
static NSString * const XLUserDefaultsHotAdInfo = @"HOT_AD_INFO";

/// 未下载完成的视频
static NSString * const XLUnDownloadVideo = @"UN_DOWNLOAD_VIDEO";

/// Wifi下视频自动播放
static NSString * const XLWifiVideoAutoPlay = @"XL_WIFI_VIDEO_AUTO_PLAY";

/// 4G下视频自动播放
static NSString * const XL4GVideoAutoPlay = @"XL_4G_VIDEO_AUTO_PLAY";

/// 用户修改过自动播放
static NSString * const XLUserChangeAutoPlaySetting = @"XL_USER_CHANGE_AUTO_PLAY";

#endif /* XLUserDefaultsConst_h */
