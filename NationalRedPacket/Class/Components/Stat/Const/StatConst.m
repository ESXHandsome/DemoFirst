//
//  StatConst.m
//  StatProject
//
//  Created by 刘永杰 on 2017/12/29.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "StatConst.h"

/** 渠道 */
NSString * const APP_REFER =  @"invitation";

#pragma mark - Launch

/** 开屏页打点 */
NSString * const APP_LAUNCHPAGE = @"USER_OPEN_SCREEN";

/** 新用户性别选择页面 */
NSString * const NEW_USER_GENDER_PAGE_PV = @"START_UP_SEX_PAGE_PV";

/** 新用户关注选择页面 */
NSString * const NEW_USER_FOLLOW_PAGE_PV = @"START_UP_ATTENTION_PAGE_PV";

/** 打开app */
NSString * const APP_LAUNCH = @"USER_OPEN_APP";

#pragma mark USER

/** 启动页选择男女打点 */
NSString * const USER_GUIDEPAGE_CHOOSE_GENDER = @"START_UP_CHOOSE_SEX";

/** 点击TabBar */
NSString * const USER_TABBAR_CLICK = @"TAB_CLICK";

/** 自动播放控制切换 */
NSString * const AUTO_PLAY_SWITCH = @"AUTO_PLAY_CLICK";

/** 我的页面邀请点击 */
NSString * const INVITE_MY_CLICK = @"INVITE_MY_CLICK";

#pragma mark - Login

/** 点击登录按钮 */
NSString * const USER_CLICK_LOGIN = @"USER_CLICK_LOGIN";

/** 登录成功 */
NSString * const USER_LOGIN_SUCCESS = @"USER_LOGIN_SUCCESS";

/** 退出登录 */
NSString * const USER_QUIT_LOGIN = @"USER_QUIT_LOGIN";

#pragma mark - Publisher

/** 关注 */
NSString * const FOLLOW_CLICK = @"ATTENTION_CLICK";

/** 个人主页点击 */
NSString * const PERSONPAGE_CLICK = @"PERSONPAGE_CLICK";

/** 我的关注点击 */
NSString * const USER_FOLLOW_CLICK = @"MYATTENTION_CLICK";

/** 我的赞点击 */
NSString * const USER_PRAISE_CLICK = @"MYPRAISE_CLICK";

/** 我的收藏点击 */
NSString * const USER_COLLECTION_CLICK = @"MYCOLLECTION_CLICK";

/** 我的帖子点击 */
NSString * const MY_UPLOAD_CLICK = @"MY_UPLOAD_CLICK";

/** 个人信息编辑点击 */
NSString * const USER_INFO_EDIT_CLICK = @"PERSON_INFO_EDIT";

/** 用户上滑打点  */
NSString * const USER_UP_FETCH = @"USER_UP_FETCH";

/** 用户下滑打点  */
NSString * const USER_DOWN_FETCH = @"USER_DOWN_FETCH";

/** 发现页banner点击 */
NSString * const DISCOVERY_BANNER_CLICK = @"FIND_BANNER_CLICK";

#pragma mark - HOME_FEED

/** home页热门与关注切换 */
NSString * const HOME_FEED_TYPE_CLICK = @"HOME_TYPE_CLICK";

/** 热门页引导展示 */
NSString * const HOT_PAGE_LEAD_LOOK = @"HOT_PAGE_LEAD_LOOK";

/** 热门页引导点击 */
NSString * const HOT_PAGE_LEAD_CLICK = @"HOT_PAGE_LEAD_CLICK";

/** 首页悬浮刷新按钮点击 */
NSString * const FLOAT_REFRESH_CLICK = @"FLOAT_REFRESH_CLICK";

#pragma mark - VIDEO

/** 视频声音开关点击 */
NSString * const VIDEO_SOUND_CLICK = @"VIDEO_SOUND_CLICK";

/** 视频暂停点击 */
NSString * const VIDEO_PAUSE_CLICK = @"VIDEO_PAUSE_CLICK";

/** 视频最大化点击 */
NSString * const VIDEO_MAX_SCREEN_CLCK = @"VIDEO_MAX_SCREEN_CLCK";

/** 视频重播点击 */
NSString * const VIDEO_REPLAY_CLICK = @"VIDEO_REPLAY_CLICK";

/** 视频进度条拖动 */
NSString * const VIDEO_PROGRESS_BAR_CLICK = @"VIDEO_PROGRESS_BAR_CLICK";

/** 视频悬浮窗关闭按钮点击 */
NSString * const VIDEO_FLOAT_CLOSE_CLICK = @"VIDEO_COMMENT_PLAY_CLOSE";

/** 视频悬浮窗暂停按钮点击 */
NSString * const VIDEO_FLOAT_PAUSE_CLICK = @"VIDEO_COMMENT_PLAY_PAUSE_CLICK";

/** 视频悬浮窗重播按钮点击 */
NSString * const VIDEO_FLOAT_REPLAY_CLICK = @"VIDEO_COMMENT_PLAY_REPLAY_CLICK";

/** 视频下载点击 */
NSString * const VIDEO_DOWNLOAD_CLICK = @"VIDEO_DOWNLOAD_CLICK";


#pragma mark - IMAGE

/** 点击图片到浏览页 */
NSString * const IMAGE_BROWSER_CLICK = @"IMAGE_SCAN_CLICK";

/** 保存 */
NSString * const IMAGE_SAVE = @"IMAGE_SAVE";

#pragma mark - COMMENT

/** 二级评论查看更多 */
NSString * const SECOND_COMMENT_LOAD_MORE = @"SECOND_COMMENT_READ_MORE";

/** 发布二级评论打点 */
NSString * const SECOND_COMMENT = @"SECOND_COMMENT";

/** 评论图片点击 */
NSString * const COMMENT_IMAGE_CLICK = @"COMMENT_IMAGE_CLICK";

/** 评论输入框展示 */
NSString * const COMMENT_KEYBOARD_SHOW = @"INPUTBOX_SHOW";

/** 取消评论转发 */
NSString * const COMMEENT_FORWARD_CANCEL = @"CANCEL_SAMETIME_FORWARD";



#pragma mark - FEED_COMMEN （待重构）

/** 首页浏览视频 */
NSString * const VIDEO_BROWSE = @"VIDEO_LOOK";
/** 浏览图片 */
NSString * const IMAGE_BROWSE = @"IMAGE_LOOK";
/** 首页浏览文章 */
NSString * const ARTICLE_BROWSE = @"ARTICLE_LOOK";


/** 首页点击视频 */
NSString * const VIDEO_CLICK = @"VIDEO_CLICK";
/** 点击图片 */
NSString * const IMAGE_DETAIL_CLICK = @"IMAGE_DETAIL_CLICK";
/** 首页点击文章 */
NSString * const ARTICLE_CLICK = @"ARTICLE_CLICK";



/** 视频点赞 */
NSString * const VIDEO_LIKE = @"VIDEO_LIKE";
/** 文章点赞 */
NSString * const ARTICLE_LIKE = @"ARTICLE_LIKE";
/** 图片点赞 */
NSString * const IMAGE_LIKE = @"IMAGE_LIKE";

/** 视频踩 */
NSString * const VIDEO_TREAD = @"VIDEO_TREAD";
/** 图片踩 */
NSString * const IMAGE_TREAD = @"IMAGE_TREAD";


/** 视频评论 */
NSString * const VIDEO_COMMENT = @"VIDEO_COMMENT";
/** 文章评论 */
NSString * const ARTICLE_COMMENT = @"ARTICLE_COMMENT";
/** 图片评论 */
NSString * const IMAGE_COMMENT = @"IMAGE_COMMENT";


/** 视频转发按钮点击 */
NSString * const VIDEO_FORWARD = @"VIDEO_FORWARD";
/** 图片转发按钮点击 */
NSString * const IMAGE_FORWARD = @"IMAGE_FORWARD";
/** 文章转发按钮点击 */
NSString * const ARTICLE_FORWARD = @"ARTICLE_FORWARD";


/** 视频转发渠道点击 */
NSString * const VIDEO_FORWARD_TYPE = @"VIDEO_FORWARD_TYPE";
/** 文章转发渠道点击 */
NSString * const ARTICLE_FORWARD_TYPE = @"ARTICLE_FORWARD_TYPE";
/** 图片转发渠道点击 */
NSString * const IMAGE_FORWARD_TYPE = @"IMAGE_FORWARD_TYPE";


/** 视频转发成功 */
NSString * const VIDEO_FORWARDED = @"VIDEO_FORWARDED";
/** 文章转发成功 */
NSString * const ARTICLE_FORWARDED = @"ARTICLE_FORWARDED";
/** 图片转发成功 */
NSString * const IMAGE_FORWARDED = @"IMAGE_FORWARDED";


/** 视频收藏点击 */
NSString * const VIDEO_COLLECTION_CLICK = @"VIDEO_COLLECTION_CLICK";
/** 图片收藏点击 */
NSString * const IMAGE_COLLECTION_CLICK = @"IMAGE_COLLECTION_CLICK";


/** 视频评论点赞 */
NSString * const VIDEO_COMMENT_LIKE = @"VIDEO_COMMENT_LIKE";
/** 图片评论点赞 */
NSString * const IMAGE_COMMENT_LIKE = @"IMAGE_COMMENT_LIKE";

/** 视频神评论点赞 */
NSString * const VIDEO_BEST_COMMENT_LIKE = @"VIDEO_BEST_COMMENT_LIKE";
/** 图片神评论点赞 */
NSString * const IMAGE_BEST_COMMENT_LIKE = @"IMAGE_BEST_COMMENT_LIKE";

/** 图片点击评论进入详情 */
NSString * const IMAGE_JUMP_COMMENT_CLCK = @"IMAGE_JUMP_COMMENT_CLCK";
/** 视频点击评论进入详情 */
NSString * const VIDEO_JUMP_COMMENT_CLCK = @"VIDEO_JUMP_COMMENT_CLCK";

/** 视频神评点击 */
NSString * const VIDEO_BEST_COMMENT_CLICK = @"VIDEO_BEST_COMMENT_CLICK";
/** 图片神评点击 */
NSString * const IMAGE_BEST_COMMENT_CLICK = @"IMAGE_BEST_COMMENT_CLICK";

/** 视频右上角菜单按钮点击 */
NSString * const VIDEO_MENU_CLICK = @"VIDEO_MENU_CLICK";
/** 图片右上角菜单按钮点击 */
NSString * const IMAGE_MENU_CLICK = @"IMAGE_MENU_CLICK";


/** 详情页点击相关推荐 */
NSString * const ARTICLE_CLICK_DETAIL = @"ARTICLE_CLICK_DETAIL";


#pragma mark - Session

/** 粉丝按钮点击 */
NSString * const FANS_BUTTON_CLICK = @"FANS_BUTTON_CLICK";

/** 访客按钮点击 */
NSString * const VISITOR_BUTTON_CLICK = @"VISITOR_BUTTON_CLICK";

/** 收到赞按钮点击 */
NSString * const RECEIVE_LIKE_CLICK = @"RECEIVE_LIKE_CLICK";

/** 收到评论按钮点击 */
NSString * const RECEIVE_COMMENT_CLICK = @"RECEIVE_COMMENT_CLICK";

/** 会话列表点击 */
NSString * const SESSION_LIST_CLICK = @"SESSION_LIST_CLICK";

/** 消息发送 */
NSString * const MESSAGE_SEND = @"MSG_SEND";

/** 群链接点击 */
NSString * const GROUP_LINK_CLICK = @"GROUP_LINK_CLICK";

/** 我的钱包点击 */
NSString * const MY_WALLET_CLICK = @"MY_WALLET_CLICK";

/** 开红包点击 */
NSString * const LUCKYMONEY_OPEN = @"LUCKYMONEY_OPEN";

/** 红包消息点击 */
NSString * const LUCKYMONEY_CLICK = @"LUCKYMONEY_CLICK";

/** 红包详情页点击 */
NSString * const LUCKYMONEY_DETAIL = @"LUCKYMONEY_DETAIL";

/** 消息展示 */
NSString * const MSG_LOOK = @"MSG_LOOK";

/** 消息点击 */
NSString * const MSG_CLICK = @"MSG_CLICK";

/** 允许push */
NSString * const ALLOW_PUSH = @"ALLOW_SEND";

/** push 点击 */
NSString * const PUSH_CLICK = @"PUSH_CLICK";

/** 退群 */
NSString * const QUIT_TEAM_CLICK = @"QUIT_TEAM_CLICK";

/** 消息免打扰 */
NSString * const SHIELD_TEAM_CLICK = @"SHIELD_TEAM_CLICK";

#pragma mark - Ad
/** 开屏广告展示 */
NSString * const SCREEN_AD_LOOK = @"SCREEN_AD_LOOK";

/** 开屏广告点击 */
NSString * const SCREEN_AD_CLICK = @"SCREEN_AD_CLICK";

/** 开屏广告关闭点击 */
NSString * const SCREEN_AD_CLOSE_CLICK = @"SCREEN_AD_CLOSE_CLICK";

/** 原生广告请求 */
NSString * const FEED_AD_REQUEST = @"FEED_AD_REQUEST";

/** 原生广告展示 */
NSString * const FEED_AD_LOOK = @"FEED_AD_LOOK";

/** 原生广告点击 */
NSString * const FEED_AD_CLICK = @"FEED_AD_CLICK";

/** 原生广告关闭点击 */
NSString * const FEED_AD_CLOSE_CLICK = @"FEED_AD_CLOSE_CLICK";

#pragma mark - H5

/** feed顶部入口H5展示 */
NSString * const TOP_H5_LOOK = @"TOP_H5_LOOK";

/** feed顶部入口H5点击 */
NSString * const TOP_H5_CLICK = @"TOP_H5_CLICK";

/** 悬浮窗H5展示 */
NSString * const FLOATING_H5_LOOK = @"FLOATING_H5_LOOK";

/** 悬浮窗H5点击 */
NSString * const FLOATING_H5_CLICK = @"FLOATING_H5_CLICK";

/** 弹窗H5展示 */
NSString * const POP_H5_LOOK = @"POP_H5_LOOK";

/** 弹窗H5点击 */
NSString * const POP_H5_CLICK = @"POP_H5_CLICK";

#pragma mark - Publish

/** 用户点击上传 */
NSString * const USER_PUBLISH_CLICK = @"USER_UPLOAD_CLICK";

/** 用户上传功能点击发送 */
NSString * const USER_PUBLISH_SEND_CLICK = @"USER_UPLOAD_SEND_CLICK";

/** 用户上传成功 */
NSString * const USER_PUBLISH_SUCCESS = @"USER_UPLOAD_SUCCESS";


#pragma mark - 广告渠道
NSString * const TENCENT_CHANNEL = @"tencent";
NSString * const YOUKAN_CHANNEL = @"youkan";

#pragma mark - 转发渠道
NSString * const WECHAT_SESSION_CHANNEL = @"wechat_session";
NSString * const WECHAT_MOMENTS_CHANNEL = @"wechat_moments";
NSString * const QQ_ZONE_CHANNEL = @"qq_zone";
NSString * const QQ_SESSION_CHANNEL = @"qq_session";

#pragma mark - 登录成功渠道
NSString * const VIDEO_LIKE_CHANNEL = @"video_parise";
NSString * const VIDEO_TREAD_CHANNEL = @"video_tread";
NSString * const VIDEO_COLLECTION_CHANNEL = @"video_collection";
NSString * const VIDEO_COMMENT_CHANNEL = @"video_comment";
NSString * const ARTICLE_LIKE_CHANNEL = @"article_praise";
NSString * const ARTICLE_TREAD_CHANNEL = @"article_tread";
NSString * const ARTICLE_COLLECTION_CHANNEL = @"article_collection";
NSString * const ARTICLE_COMMENT_CHANNEL = @"article_comment";
NSString * const IMAGE_LIKE_CHANNEL = @"image_praise";
NSString * const IMAGE_TREAD_CHANNEL = @"image_tread";
NSString * const IMAGE_COLLECTION_CHANNEL = @"image_collection";
NSString * const IMAGE_COMMENT_CHANNEL = @"image_comment";
NSString * const COMMENT_LIKE_CHANNEL = @"comment_parise";
NSString * const BUTTON_CLICK_CHANNEL = @"click";
NSString * const FOLLOW_ACTION_CHANNEL = @"attention";
NSString * const REDPACKET_CLICK_CHANNEL = @"luckymoney_msg";
NSString * const PUBLISH_CLICK_CHANNEL = @"publish";

