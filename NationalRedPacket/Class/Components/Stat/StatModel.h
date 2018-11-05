//
//  StatModel.h
//  StatProject
//
//  Created by 刘永杰 on 2017/12/29.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatModel : NSObject

#pragma mark - 配置参数
/** 用户ID */
@property (copy, nonatomic) NSString *user_id;

/** 设备ID */
@property (copy, nonatomic) NSString *device_id;

/** 渠道 invitation */
@property (copy, nonatomic) NSString *refer;

/** APP版本号 */
@property (copy, nonatomic) NSString *version;

/** 系统 iOS：2
        安卓：1 */
@property (copy, nonatomic) NSString *system;

/** 用户account */
@property (copy, nonatomic) NSString *account;

#pragma mark - 公共参数

/** 统计名称 */
@property (copy, nonatomic) NSString *action;

/** 统计时间 */
@property (copy, nonatomic) NSString *created_at;

/** 时长 */
@property (copy, nonatomic) NSString *time;

/** 来源 */
@property (copy, nonatomic) NSString *source;

/** 登录平台 */
@property (copy, nonatomic) NSString *platform;

/** 上一页面 */
@property (copy, nonatomic) NSString *from;

/** 当前页面 */
@property (copy, nonatomic) NSString *to;

#pragma mark - 文章/视频参数

/** 文章&视频发布者ID */
@property (copy, nonatomic) NSString *authorId;

/** 文章&视频来源
 注：1.此参数为自定义参数，用于区分来源 R:推荐 H:热力榜 */
@property (copy, nonatomic) NSString *origin;

/** 文章&视频ID */
@property (copy, nonatomic) NSString *item_id;

/** 文章或者视频类型 */
@property (copy, nonatomic) NSString *item_type;

/** 转发类型 */
@property (copy, nonatomic) NSString *forward_type;
/** 转发位置 */
@property (copy, nonatomic) NSString *position;

/** 播放时长 */
@property (copy, nonatomic) NSString *video_long;

/** 评论id */
@property (copy, nonatomic) NSString *comment_id;

/** 文章底部是否露出 */
@property (copy, nonatomic) NSString *isBottom;

#pragma mark - Publisher
/** 发现页关注时所在的类型精选、搞笑等，卡片的find_type为‘card’ */
@property (copy, nonatomic) NSString *find_type;

#pragma mark - Ad & H5

/** h5的id */
@property (copy, nonatomic) NSString *itemId;

/** 广告渠道 tencent,youkan */
@property (copy, nonatomic) NSString *channel;

/** 广告请求数 */
@property (copy, nonatomic) NSString *request;

/** 广告获取数 */
@property (copy, nonatomic) NSString *get;

/** 广告id */
@property (copy, nonatomic) NSString *adId;
#pragma mark - NIMSession

/** 会话id */
@property (copy, nonatomic) NSString *sessionid;

/** 会话类型 */
@property (copy, nonatomic) NSString *sessiontype;

/** 红包id */
@property (copy, nonatomic) NSString *luckyid;

/** 红包状态 */
@property (copy, nonatomic) NSString *status;

/** 消息类型 */
@property (copy, nonatomic) NSString *msgtype;

#pragma mark - Other
/** 1：男，2：女 */
@property (copy, nonatomic) NSString *sex;

/** banner的title */
@property (copy, nonatomic) NSString *title;

/** TAB的名称 HOME、FIND、MY */
@property (copy, nonatomic) NSString *tab;

/** hot：热门，attention：关注 */
@property (copy, nonatomic) NSString *type;

/** 评论 */
@property (copy, nonatomic) NSString *comment_type;

/** image  1, 0  */
@property (copy, nonatomic) NSString *image;

/** 点击进入个人主页是否是通过comment点击的  1, 0  */
@property (copy, nonatomic) NSString *comment;

/** 视频各种模式 */
@property (copy, nonatomic) NSString *mode;

/** 钱包跳转 */
@property (copy, nonatomic) NSString *moneyType;

/** APP是否活跃 */
@property (copy, nonatomic) NSString *app_alive;

/** push 内容 */
@property (copy, nonatomic) NSString *content;

/** 发布类型 图片/视频 */
@property (copy, nonatomic) NSString *uploadType;

@end
