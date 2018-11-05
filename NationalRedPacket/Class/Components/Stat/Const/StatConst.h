//
//  StatConst.h
//  StatProject
//
//  Created by 刘永杰 on 2017/12/29.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 渠道 */
extern NSString * const APP_REFER;

#pragma mark - Launch

/** 开屏页打点 */
extern NSString * const APP_LAUNCHPAGE;

/** 新用户性别选择页面 */
extern NSString * const NEW_USER_GENDER_PAGE_PV;

/** 新用户关注选择页面 */
extern NSString * const NEW_USER_FOLLOW_PAGE_PV;

/** 打开app */
extern NSString * const APP_LAUNCH;

#pragma mark - USER

/** 启动页选择男女打点 */
extern NSString * const USER_GUIDEPAGE_CHOOSE_GENDER;

/** 点击TabBar */
extern NSString * const USER_TABBAR_CLICK;

/** 自动播放控制切换 */
extern NSString * const AUTO_PLAY_SWITCH;

/** 我的页面邀请点击 */
extern NSString * const INVITE_MY_CLICK;

#pragma mark - Login

/** 点击登录按钮 */
extern NSString * const USER_CLICK_LOGIN;

/** 登录成功 */
extern NSString * const USER_LOGIN_SUCCESS;

/** 退出登录 */
extern NSString * const USER_QUIT_LOGIN;

/** 我的关注点击 */
extern NSString * const USER_FOLLOW_CLICK;

/** 我的赞点击 */
extern NSString * const USER_PRAISE_CLICK;

/** 我的收藏点击 */
extern NSString * const USER_COLLECTION_CLICK;

/** 我的帖子点击 */
extern NSString * const MY_UPLOAD_CLICK;

/** 个人信息编辑点击 */
extern NSString * const USER_INFO_EDIT_CLICK;

#pragma mark - Publisher

/** 关注 */
extern NSString * const FOLLOW_CLICK;

/** 个人主页点击 */
extern NSString * const PERSONPAGE_CLICK;

/** 用户上滑打点  */
extern NSString * const USER_UP_FETCH;

/** 用户下滑打点  */
extern NSString * const USER_DOWN_FETCH;

/** 发现页banner点击 */
extern NSString * const DISCOVERY_BANNER_CLICK;

#pragma mark - HOME_FEED

/** home页热门与关注切换 */
extern NSString * const HOME_FEED_TYPE_CLICK;

/** 热门页引导展示 */
extern NSString * const HOT_PAGE_LEAD_LOOK;

/** 热门页引导点击 */
extern NSString * const HOT_PAGE_LEAD_CLICK;

/** 首页悬浮刷新按钮点击 */
extern NSString * const FLOAT_REFRESH_CLICK;

#pragma mark - VIDEO

/** 视频声音开关点击 */
extern NSString * const VIDEO_SOUND_CLICK;

/** 视频暂停点击 */
extern NSString * const VIDEO_PAUSE_CLICK;

/** 视频最大化点击 */
extern NSString * const VIDEO_MAX_SCREEN_CLCK;

/** 视频重播点击 */
extern NSString * const VIDEO_REPLAY_CLICK;

/** 视频进度条拖动 */
extern NSString * const VIDEO_PROGRESS_BAR_CLICK;

/** 视频悬浮窗关闭按钮点击 */
extern NSString * const VIDEO_FLOAT_CLOSE_CLICK;

/** 视频悬浮窗暂停按钮点击 */
extern NSString * const VIDEO_FLOAT_PAUSE_CLICK;

/** 视频悬浮窗重播按钮点击 */
extern NSString * const VIDEO_FLOAT_REPLAY_CLICK;

/** 视频下载点击 */
extern NSString * const VIDEO_DOWNLOAD_CLICK;

#pragma mark - IMAGE

/** 保存 */
extern NSString * const IMAGE_SAVE;

/** 点击图片到浏览页 */
extern NSString * const IMAGE_BROWSER_CLICK;

#pragma mark - COMMENT

/** 二级评论查看更多 */
extern NSString * const SECOND_COMMENT_LOAD_MORE;

/** 发布二级评论打点 */
extern NSString * const SECOND_COMMENT;

/** 评论图片点击 */
extern NSString * const COMMENT_IMAGE_CLICK;

/** 评论输入框展示 */
extern NSString * const COMMENT_KEYBOARD_SHOW;

/** 取消评论转发 */
extern NSString * const COMMEENT_FORWARD_CANCEL;



#pragma mark - FEED_COMMEN （待重构）

/** 首页浏览视频 */
extern NSString * const VIDEO_BROWSE;
/** 浏览图片 */
extern NSString * const IMAGE_BROWSE;
/** 首页浏览文章 */
extern NSString * const ARTICLE_BROWSE;

/** 首页点击文章 */
extern NSString * const ARTICLE_CLICK;
/** 首页点击视频 */
extern NSString * const VIDEO_CLICK;
/** 点击图片到详情页 */
extern NSString * const IMAGE_DETAIL_CLICK;

/** 视频点赞 */
extern NSString * const VIDEO_LIKE;
/** 文章点赞 */
extern NSString * const ARTICLE_LIKE;
/** 图片点赞 */
extern NSString * const IMAGE_LIKE;

/** 视频踩 */
extern NSString * const VIDEO_TREAD;
/** 图片踩 */
extern NSString * const IMAGE_TREAD;

/** 文章评论 */
extern NSString * const ARTICLE_COMMENT;
/** 视频评论 */
extern NSString * const VIDEO_COMMENT;
/** 图片评论 */
extern NSString * const IMAGE_COMMENT;

/** 视频转发按钮点击 */
extern NSString * const VIDEO_FORWARD;
/** 文章转发按钮点击 */
extern NSString * const ARTICLE_FORWARD;
/** 图片转发按钮点击 */
extern NSString * const IMAGE_FORWARD;

/** 视频转发渠道点击 */
extern NSString * const VIDEO_FORWARD_TYPE;
/** 文章转发渠道点击 */
extern NSString * const ARTICLE_FORWARD_TYPE;
/** 图片转发渠道点击 */
extern NSString * const IMAGE_FORWARD_TYPE;

/** 视频转发成功 */
extern NSString * const VIDEO_FORWARDED;
/** 文章转发成功 */
extern NSString * const ARTICLE_FORWARDED;
/** 图片转发成功 */
extern NSString * const IMAGE_FORWARDED;

/** 视频收藏点击 */
extern NSString * const VIDEO_COLLECTION_CLICK;
/** 图片收藏点击 */
extern NSString * const IMAGE_COLLECTION_CLICK;

/** 视频评论点赞 */
extern NSString * const VIDEO_COMMENT_LIKE;
/** 图片评论点赞 */
extern NSString * const IMAGE_COMMENT_LIKE;

/** 视频神评论点赞 */
extern NSString * const VIDEO_BEST_COMMENT_LIKE;
/** 图片神评论点赞 */
extern NSString * const IMAGE_BEST_COMMENT_LIKE;

/** 图片点击评论进入详情 */
extern NSString * const IMAGE_JUMP_COMMENT_CLCK;
/** 视频点击评论进入详情 */
extern NSString * const VIDEO_JUMP_COMMENT_CLCK;

/** 视频神评点击 */
extern NSString * const VIDEO_BEST_COMMENT_CLICK;
/** 图片神评点击 */
extern NSString * const IMAGE_BEST_COMMENT_CLICK;

/** 视频右上角菜单按钮点击 */
extern NSString * const VIDEO_MENU_CLICK;
/** 图片右上角菜单按钮点击 */
extern NSString * const IMAGE_MENU_CLICK;

/** 详情页点击相关推荐 */
extern NSString * const ARTICLE_CLICK_DETAIL;

#pragma mark - Session

/** 粉丝按钮点击 */
extern NSString * const FANS_BUTTON_CLICK;

/** 访客按钮点击 */
extern NSString * const VISITOR_BUTTON_CLICK;

/** 收到赞按钮点击 */
extern NSString * const RECEIVE_LIKE_CLICK;

/** 收到评论按钮点击 */
extern NSString * const RECEIVE_COMMENT_CLICK;

/** 会话列表点击 */
extern NSString * const SESSION_LIST_CLICK;

/** 消息发送 */
extern NSString * const MESSAGE_SEND;

/** 群链接点击 */
extern NSString * const GROUP_LINK_CLICK;

/** 我的钱包点击 */
extern NSString * const MY_WALLET_CLICK;

/** 开红包点击 */
extern NSString * const LUCKYMONEY_OPEN;

/** 红包消息点击 */
extern NSString * const LUCKYMONEY_CLICK;

/** 红包详情页点击 */
extern NSString * const LUCKYMONEY_DETAIL;

/** 消息展示 */
extern NSString * const MSG_LOOK;

/** 消息点击 */
extern NSString * const MSG_CLICK;

/** 允许push */
extern NSString * const ALLOW_PUSH;

/** push 点击 */
extern NSString * const PUSH_CLICK;

/** 退群 */
extern NSString * const QUIT_TEAM_CLICK;

/** 消息免打扰 */
extern NSString * const SHIELD_TEAM_CLICK;

#pragma mark - Ad
/** 开屏广告展示 */
extern NSString * const SCREEN_AD_LOOK;

/** 开屏广告点击 */
extern NSString * const SCREEN_AD_CLICK;

/** 开屏广告关闭点击 */
extern NSString * const SCREEN_AD_CLOSE_CLICK;

/** 原生广告请求 */
extern NSString * const FEED_AD_REQUEST;

/** 原生广告展示 */
extern NSString * const FEED_AD_LOOK;

/** 原生广告点击 */
extern NSString * const FEED_AD_CLICK;

/** 原生广告关闭点击 */
extern NSString * const FEED_AD_CLOSE_CLICK;

#pragma mark - H5

/** feed顶部入口H5展示 */
extern NSString * const TOP_H5_LOOK;

/** feed顶部入口H5点击 */
extern NSString * const TOP_H5_CLICK;

/** 悬浮窗H5展示 */
extern NSString * const FLOATING_H5_LOOK;

/** 悬浮窗H5点击 */
extern NSString * const FLOATING_H5_CLICK;

/** 弹窗H5展示 */
extern NSString * const POP_H5_LOOK;

/** 弹窗H5点击 */
extern NSString * const POP_H5_CLICK;

#pragma mark - Publish

/** 用户点击上传 */
extern NSString * const USER_PUBLISH_CLICK;

/** 用户上传功能点击发送 */
extern NSString * const USER_PUBLISH_SEND_CLICK;

/** 用户上传成功 */
extern NSString * const USER_PUBLISH_SUCCESS;


#pragma mark - 广告渠道
extern NSString * const TENCENT_CHANNEL;
extern NSString * const YOUKAN_CHANNEL;

#pragma mark - 转发渠道
extern NSString * const WECHAT_SESSION_CHANNEL;
extern NSString * const WECHAT_MOMENTS_CHANNEL;
extern NSString * const QQ_ZONE_CHANNEL;
extern NSString * const QQ_SESSION_CHANNEL;

#pragma mark - 登录成功渠道
extern NSString * const VIDEO_LIKE_CHANNEL;
extern NSString * const VIDEO_TREAD_CHANNEL;
extern NSString * const VIDEO_COLLECTION_CHANNEL;
extern NSString * const VIDEO_COMMENT_CHANNEL;
extern NSString * const ARTICLE_LIKE_CHANNEL;
extern NSString * const ARTICLE_TREAD_CHANNEL;
extern NSString * const ARTICLE_COLLECTION_CHANNEL;
extern NSString * const ARTICLE_COMMENT_CHANNEL;
extern NSString * const IMAGE_LIKE_CHANNEL;
extern NSString * const IMAGE_TREAD_CHANNEL;
extern NSString * const IMAGE_COLLECTION_CHANNEL;
extern NSString * const IMAGE_COMMENT_CHANNEL;
extern NSString * const COMMENT_LIKE_CHANNEL;
extern NSString * const BUTTON_CLICK_CHANNEL;
extern NSString * const FOLLOW_ACTION_CHANNEL;
extern NSString * const REDPACKET_CLICK_CHANNEL;
extern NSString * const PUBLISH_CLICK_CHANNEL;
