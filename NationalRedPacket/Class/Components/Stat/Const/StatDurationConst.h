//
//  StatDurationConst.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/18.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

/** APP停留时长 */
extern NSString * const APP_ACTIVITY_DURATION;

/** APP后台停留时长 */
extern NSString * const APP_BACKGROUND_DURATION;

#pragma mark - 视频时长

/** 首页视频预览播放时长 */
extern NSString * const VIDEO_PREVIEW_DURATION;

/** 视频最大化播放时长 */
extern NSString * const VIDEO_MAX_SCREEN_DURATION;

/*************************** 详情页 *******************************/

/** 视频详情页时长 */
extern NSString * const VIDEO_DETAIL_DURATION;

/** 视频详情页内容阅读时长 */
extern NSString * const VIDEO_DURATION;

/** 视频评论停留时长 */
extern NSString * const VIDEO_COMMENT_DURATION;

/** 视频悬浮窗播放时长 */
extern NSString * const VIDEO_FLOAT_PLAY_DURATION;

/** 视频详情页评论图片浏览页时长 */
extern NSString * const VIDEO_COMMENT_BROWSER_DURATION;

#pragma mark - 图片时长

/** 图片停留时长 */
extern NSString * const IMAGE_STAY_DURATION;

/** 图片预览页时长 */
extern NSString * const IMAGE_BROWSER_DURATION;

/*************************** 详情页 *******************************/

/** 图片详情页时长 */
extern NSString * const IMAGE_DETAIL_DURATION;

/** 图片详情页内容阅读时长 */
extern NSString * const IMAGE_READ_DURATION;

/** 图片详情页阅读评论的时长 */
extern NSString * const IMAGE_COMMENT_DURATION;

/** 图片详情页评论图片浏览页时长 */
extern NSString * const IMAGE_COMMENT_BROWSER_DURATION;

#pragma mark - 特殊处理的页面时长，需要加额外业务相关参数(强业务)
/** 个人主页停留（需要加发布者id） */
extern NSString * const PERSON_PAGE_DURATION;

/** 首页停留时长 (左右切换) */
extern NSString * const HOME_PAGE_DURATION;

/** feed关注页停留时长 （左右切换） */
extern NSString * const FOLLOWING_FEED_PAGE_DURATION;

/** 首页视频页停留时长 */
extern NSString * const HOME_VIDEO_PAGE_DURATION;

/** 首页趣图页停留时长 */
extern NSString * const HOME_IMAGE_PAGE_DURATION;

/** 会话列表停留 （需要sessionId） */
extern NSString * const SESSION_DETAIL_LONG;
