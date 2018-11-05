//
//  WechatApi.h
//  Kratos
//
//  Created by Zhangziqi on 16/5/5.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLFeedModel.h"
#import "WXApi.h"

typedef NS_ENUM(NSUInteger, WechatScene) {
    WechatSceneSession,  /**< 微信好友 */
    WechatSceneTimeline, /**< 朋友圈 */
    WechatSceneFavorite, /**< 微信收藏 */
};

typedef void(^WechatShareReqCallback)(int code);

/**
 *  本协议是用于请求微信API后的回调
 */
@protocol WechatAPIDelegate <NSObject>

/**
 *  调用微信API成功时的回调
 *
 *  @param response 返回值
 */
- (void)success:(NSDictionary *_Nonnull)response;

/**
 *  调用微信API失败时的回调
 *
 *  @param error 错误信息
 */
- (void)failure:(NSError *_Nonnull)error;

@end

@interface WechatShare : NSObject

@property (weak, nonatomic) id <WechatAPIDelegate> _Nullable delegate; /**< 遵循WechatAPIDelegate协议的对象 */
@property (copy, nonatomic) WechatShareReqCallback _Nullable sendReqCallback;

/**
 *  获取微信Api的单例对象
 *
 *  @return 单例对象
 */
+ (instancetype _Nonnull)sharedInstance;

/**
 *  分享图片到微信
 *
 *  @param image 要分享的图片本地地址
 *  @param thumb 分享图片的缩略图
 *  @param scene 分享微信场景
 */
- (void)shareImage:(UIImage *_Nonnull)image
        thumbImage:(UIImage *_Nullable)thumb
                to:(WechatScene)scene
   sendReqCallback:(WechatShareReqCallback)sendReqCallback;

/**
 分享文章到微信

 @param newsDetailModel 文章数据
 @param scene 分享微信场景
 */
- (void)shareNewsDetail:(XLFeedModel *_Nullable)newsDetailModel
                      to:(WechatScene)scene
         sendReqCallback:(WechatShareReqCallback)sendReqCallback;

/**
 *  处理微信的回调，在AppDelegate中使用
 *
 *  @param url 回调的URL
 */
- (void)handleOpenUrl:(NSURL *_Nonnull)url;


/**
 分享url

 @param title 标题
 @param content 内容
 @param url 跳转地址
 @param imageUrl 图片地址
 @param scene 类型
 @param sendReqCallback 回调
 */
- (void)shareUrl:(NSString *_Nonnull)title
         content:(NSString *_Nullable)content
             url:(NSString* )url
           image:(NSString *)imageUrl
              to:(WechatScene)scene
 sendReqCallback:(WechatShareReqCallback)sendReqCallback;

/**
 分享视频

 @param title 标题
 @param content 内容
 @param url feed链接
 @param scene 类型
 @param sendReqCallback 回调
 */
- (void)shareFeed:(NSString *)title
          content:(NSString *)content
          feedUrl:(NSString *)url
         imageUrl:(NSString *)imageUrl
         feedType:(NSString *)feedType
               to:(WechatScene)scene
  sendReqCallback:(WechatShareReqCallback)sendReqCallback;


@end
