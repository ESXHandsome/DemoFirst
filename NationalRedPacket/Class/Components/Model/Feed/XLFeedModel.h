//
//  XLFeedModel.h
//  WatermelonNews
//
//  Created by sunmingyue on 17/11/14.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CMTime.h>
#import "PPSDAOHomeFeedModel.h"
#import "XLPublisherModel.h"
#import "XLFeedAdNativeExpressModel.h"

static NSString *const WX_MOMENT    = @"WXMomentPic";
static NSString *const WX_SESSION   = @"WXSessionPic";
static NSString *const QQ_SESSION   = @"QQSessionPic";
static NSString *const QQ_ZONE      = @"qqzone";

@class ImageModel;
@class AdModel;
@class XLFeedCommentModel;

@interface XLFeedModel : NSObject <NSCopying>

@property (copy, nonatomic) NSString *itemId;
@property (copy, nonatomic) NSString *transmissionID;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *type; // 1-大图文章，2-小图文章，3-3图文章，4-竖版视频，5-横版视频
@property (copy, nonatomic) NSString *downloadUrl;
@property (assign, nonatomic) NSInteger praiseNum;
@property (assign, nonatomic) NSInteger commentNum;
@property (assign, nonatomic) NSInteger forwardNum;
@property (assign, nonatomic) NSInteger treadNum;
@property (assign, nonatomic) BOOL isRead;
@property (assign, nonatomic) BOOL isPraise; // 0-未点赞，1-已点赞
@property (assign, nonatomic) BOOL isTread; // 0-未踩，1-已踩
@property (assign, nonatomic) BOOL isFollowed; // 0-未关注，1-已关注
@property (assign, nonatomic) BOOL isCollection; /// 0-未收藏, 1-已收藏
@property (assign, nonatomic) BOOL videoHasPlayed;
@property (assign, nonatomic) BOOL allowComment; //0-不允许，1-允许
@property (assign, nonatomic) BOOL isAllContent;
@property (assign, nonatomic) BOOL isNeedFullButton;
@property (assign, nonatomic) BOOL isMyUpload;  ///（0：非自己发布，1：自己发布）

@property (strong, nonatomic) NSArray *picture;
@property (copy, nonatomic) NSString *source_detail;
@property (copy, nonatomic) NSString *shareUrl;
@property (copy, nonatomic) NSString *duration;
@property (copy, nonatomic) NSIndexPath *indexPath;
@property (copy, nonatomic) NSString *subtitle;
@property (copy, nonatomic) NSString *origin;
@property (copy, nonatomic) NSString *videoLong;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGFloat width;
@property (copy, nonatomic) NSString *source;
@property (copy, nonatomic) NSString *itemType;
@property (assign, nonatomic) NSInteger watchNum;
@property (copy, nonatomic) NSString *articalCommentText;
@property (strong, nonatomic) NSString *createdTime;  // 数据拉取时间
@property (assign, nonatomic) NSTimeInterval currentTime;
@property (copy, nonatomic) NSString *isBottom;
@property (copy, nonatomic) NSString *share;
@property (copy, nonatomic) NSString *shareCompleteURL; // 分享完整URL
@property (copy, nonatomic) NSString *authorId;       // 发布者ID
@property (copy, nonatomic) NSString *nickname;       // 发布者昵称
@property (copy, nonatomic) NSString *icon;           // 发布者头像
@property (copy, nonatomic) NSString *sex;            // 发布者性别
@property (copy, nonatomic) NSString *age;            // 发布者年龄
@property (copy, nonatomic) NSString *location;       // 发布者位置
@property (copy, nonatomic) NSString *constellation;  // 发布者星座
@property (copy, nonatomic) NSString *intro;          // 发布者简介
@property (assign, nonatomic) NSInteger fansCount;      // 发布者粉丝数
@property (assign, nonatomic) NSInteger attentionCount; // 发布者关注数
@property (copy, nonatomic) NSString *index;          // 个人主页item内数据，回传给服务端统计
@property (copy, nonatomic) NSString *releaseTime;    // 发布时间
@property (copy, nonatomic) NSString *topic;          // 话题
@property (copy, nonatomic) NSString *summary;        // 摘要
@property (strong, nonatomic) NSArray<ImageModel *> *image;  //图片模型数组,用于type类型是image时
@property (assign, nonatomic) NSInteger *imageNum;    //图片数量
@property (copy, nonatomic) NSString *originalTime;   //发布时间
@property (strong, nonatomic) NSArray<AdModel *> *ads;
@property (strong, nonatomic) AdModel *adModel;
@property (assign, nonatomic) BOOL isNoInfo;
@property (strong, nonatomic) NSArray<XLFeedCommentModel *> *bestComment;
@property (strong, nonatomic) NSArray<XLFeedAdNativeExpressModel *> *otherAds;
@property (strong, nonatomic) XLFeedAdNativeExpressModel *nativeExpressModel;
@property (assign, nonatomic) BOOL isVideoPlayToEndTime; // 视频播放结束

@property (copy, nonatomic) NSString *href; //文本链接文字

+ (NSString *)completeShareURL:(XLFeedModel *)model withRefrence:(NSString *)reference;

//更新本地模型数据库
+ (void)updateDataBaseModel:(XLFeedModel *)model;

#pragma mark - 模型 -> 模型
// XLFeedModel ==》PPSDAOHomeFeedModel
+ (PPSDAOHomeFeedModel *)transformXLFeedModel:(XLFeedModel *)model;

// PPSDAOHomeFeedModel ==》XLFeedModel
+ (XLFeedModel *)transformPPSDAOHomeFeedModel:(PPSDAOHomeFeedModel *)model;

// PPSDAOHomeFeedModelArray ==》XLFeedModelArray
+ (NSMutableArray<PPSDAOHomeFeedModel *> *)transformXLFeedModelArray:(NSMutableArray<XLFeedModel *> *)array;

// PPSDAOHomeFeedModelArray ==》XLFeedModelArray
+ (NSMutableArray<XLFeedModel *> *)transformPPSDAOHomeFeedModelArray:(NSMutableArray<PPSDAOHomeFeedModel *> *)array;

@end

@interface AdModel : NSObject

/// 广告id
@property (copy, nonatomic) NSString *adId;
/// 广告类型
@property (copy, nonatomic) NSString *type;
/// 广告位置
@property (assign, nonatomic) NSInteger position;
/// 点击相应动作，web：跳转网页
@property (copy, nonatomic) NSString *action;
/// 广告展示的图片
@property (copy, nonatomic) NSString *image;
/// 点击广告跳转的链接
@property (copy, nonatomic) NSString *url;
/// 广告标题
@property (copy, nonatomic) NSString *title;

@end

@interface ImageModel : NSObject

@property (copy, nonatomic) NSString *originalImage; //原图
@property (copy, nonatomic) NSString *preview; //预览图
@property (copy, nonatomic) NSString *width;   //宽
@property (copy, nonatomic) NSString *height;  //高
///自定义属性 是否显示 "点击查看全图" 按钮
@property (assign, nonatomic) BOOL   isShowFullButton;
@property (copy, nonatomic) NSString *previewGif; //预览gif图
@property (assign, nonatomic) BOOL   isOnLocal;  ///是否为本地图片
@property (copy, nonatomic) NSString *imagePath;
@end
