//
//  StatDurationConst.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/18.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "StatDurationConst.h"

/** APP停留时长 */
NSString * const APP_ACTIVITY_DURATION = @"USER_STAY_LONG";

/** APP后台停留时长 */
NSString * const APP_BACKGROUND_DURATION = @"APP_BACKGROUND_DURATION";

#pragma mark - 视频时长

/** 首页视频预览播放时长 */
NSString * const VIDEO_PREVIEW_DURATION = @"VIDEO_PREVIEW_LONG";

/** 视频最大化播放时长 */
NSString * const VIDEO_MAX_SCREEN_DURATION = @"VIDEO_MAX_LONG";

/*************************** 详情页 *******************************/

/** 视频详情页时长 */
NSString * const VIDEO_DETAIL_DURATION = @"VIDEO_DETAIL_LONG";

/** 视频详情页内容阅读时长 */
NSString * const VIDEO_DURATION = @"VIDEO_LONG";

/** 视频评论停留时长 */
NSString * const VIDEO_COMMENT_DURATION = @"VIDEO_COMMENT_LONG";

/** 视频悬浮窗播放时长 */
NSString * const VIDEO_FLOAT_PLAY_DURATION = @"VIDEO_COMMENT_PLAY_LONG";

/** 视频详情页评论图片浏览页时长 */
NSString * const VIDEO_COMMENT_BROWSER_DURATION = @"VIDEO_COMMENT_SCAN_IMAGE_LONG";


#pragma mark - 图片时长

/** 图片停留时长 */
NSString * const IMAGE_STAY_DURATION = @"IMAGE_STAY_LONG";

/** 图片预览页时长 */
NSString * const IMAGE_BROWSER_DURATION = @"IMAGE_SCAN_LONG";

/*************************** 详情页 *******************************/

/** 图片详情页时长 */
NSString * const IMAGE_DETAIL_DURATION = @"IMAGE_DETAIL_LONG";

/** 图片详情页内容阅读时长 */
NSString * const IMAGE_READ_DURATION = @"IMAGE_READ_LONG";

/** 图片详情页阅读评论的时长 */
NSString * const IMAGE_COMMENT_DURATION = @"IMAGE_COMMENT_LONG";

/** 图片详情页评论图片浏览页时长 */
NSString * const IMAGE_COMMENT_BROWSER_DURATION = @"IMAGE_COMMENT_SCAN_IMAGE_LONG";


#pragma mark - 特殊处理的页面时长，需要加额外业务相关参数(强业务)
/** 个人主页停留 */  
NSString * const PERSON_PAGE_DURATION = @"PERSONPAGE_LONG";

/** 首页停留时长 */
NSString * const HOME_PAGE_DURATION = @"HOME_LONG";

/** feed关注页停留时长 */
NSString * const FOLLOWING_FEED_PAGE_DURATION = @"ATTENTION_PAGE_LONG";

/** 首页视频页停留时长 */
NSString * const HOME_VIDEO_PAGE_DURATION = @"VIDEO_PAGE_LONG";

/** 首页趣图页停留时长 */
NSString * const HOME_IMAGE_PAGE_DURATION = @"IMAGE_PAGE_LONG";

/** 会话列表停留 （需要sessionId） */
NSString * const SESSION_DETAIL_LONG = @"SESSION_DETAIL_LONG";
