//
//  WechatShare.m
//  Kratos
//
//  Created by Zhangziqi on 16/5/5.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import "WechatShare.h"
#import "WechatAuthSDK.h"
#import "MBProgressHUD.h"
#import "UIImage+Tool.h"

#define IDENTIFIER_LOGIN @"IDENTIFIER_LOGIN"
#define WECHAT_ERROR_DOMAIN @"DOMAIN_ERROR_WECHAT"

@interface WechatShare () <WXApiDelegate>
@property (strong, nonatomic) NSMutableDictionary *identifierDict; /**< 处于安全性考虑，保存了向微信请求时的state，收到微信回调时会做校验 */
@property (atomic) BOOL isLogining; /**< 标识微信登录是否正在进行中，防止重复请求微信登录 */
@end

@implementation WechatShare

#pragma -
#pragma initialize

/**
 *  获取微信Api的单例对象
 *
 *  @return 单例对象
 */
+ (instancetype _Nonnull)sharedInstance {
    static WechatShare *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WechatShare alloc] init];
    });
    return instance;
}

/**
 *  初始化方法
 *
 *  @return 实例对象
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        _identifierDict = [NSMutableDictionary dictionaryWithCapacity:5];
        [WXApi registerApp:XLWechatId];
    }
    return self;
}

#pragma -
#pragma Handle Wechat Callback

/**
 *  处理微信的回调，在AppDelegate中使用
 *
 *  @param url 回调的URL
 */
- (void)handleOpenUrl:(NSURL *_Nonnull)url {
    [WXApi handleOpenURL:url delegate:self];
}

#pragma -
#pragma WXApiDelegate Protocol Implemetation

/**
 *  处理微信向应用发送的请求
 *
 *  @param req 请求
 */
-(void)onReq:(BaseReq *_Nonnull)req {
    // 目前不会用到这个方法
}

/**
 *  处理微信向应用发送的响应
 *
 *  @param resp 响应
 */
- (void)onResp:(BaseResp *_Nonnull)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        [self handleLoginResponse:(SendAuthResp *)resp];
    }
}

/**
 *  处理微信请求回调
 *
 *  @param resp 微信的返回值
 */
- (void)handleLoginResponse:(SendAuthResp *_Nonnull)resp {
    // 如果error code不为0，代表登录时发生错误
    if (resp.errCode != 0 && _delegate &&
        [_delegate respondsToSelector:@selector(failure:)]) {
        [_delegate failure:[NSError errorWithDomain:WECHAT_ERROR_DOMAIN
                                               code:resp.errCode
                                           userInfo:nil]];
        return;
    }
    
    // 如果记录的随机串和回调带回的随机串不一致，那么不做处理
    if (![_identifierDict[IDENTIFIER_LOGIN] isEqualToString:resp.state]) {
        return;
    }
    
    [_identifierDict removeObjectForKey:IDENTIFIER_LOGIN];
    
}

#pragma mark -
#pragma mark Share Oper

- (void)shareImage:(UIImage *_Nonnull)image
        thumbImage:(UIImage *_Nullable)thumb
                to:(WechatScene)scene
   sendReqCallback:(WechatShareReqCallback)sendReqCallback{
    
    _sendReqCallback = sendReqCallback;

    WXImageObject *imageObject = [WXImageObject object];
    [imageObject setImageData:UIImageJPEGRepresentation(image, 1)];
    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:thumb];
    [message setMediaObject:imageObject];
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    [req setBText:NO];
    [req setMessage:message];
    [req setScene:scene];
    
    [WXApi sendReq:req];
}

/**
 分享文章到微信
 
 @param detailModel 文章数据
 @param scene 分享微信场景
 */
- (void)shareNewsDetail:(XLFeedModel *_Nullable)detailModel
                     to:(WechatScene)scene
        sendReqCallback:(WechatShareReqCallback)sendReqCallback{
    
    _sendReqCallback = sendReqCallback;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = detailModel.title;
    message.description = @"『神奇的不只是段子』";
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:detailModel.picture.firstObject];
    if (image == nil) {
        image = [UIImage imageNamed:@"details_icon_red_details_logo"];
    }
    [message setThumbImage:[UIImage compressImage:image toByte:20 * 1024]];
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = detailModel.shareCompleteURL;
    message.mediaObject = webpageObject;
    
    WXVideoObject *videoObject = [WXVideoObject object];
    videoObject.videoUrl = detailModel.shareCompleteURL;
    
    if (detailModel.type.integerValue == XLFeedCellVideoVerticalType ||
        detailModel.type.integerValue == XLFeedCellVideoHorizonalType ||
        detailModel.type.integerValue == XLFeedCellVideoVerticalWithAuthorType ||
        detailModel.type.integerValue == XLFeedCellVideoHorizonalWithAuthorType) {
        
        WXVideoObject *videoObject = [WXVideoObject object];
        videoObject.videoUrl = detailModel.shareCompleteURL;
        message.mediaObject = videoObject;
    } else {
        WXWebpageObject *webpageObject = [WXWebpageObject object];
        webpageObject.webpageUrl = detailModel.shareCompleteURL;
        message.mediaObject = webpageObject;
    }
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    [req setBText:NO];
    [req setMessage:message];
    [req setScene:scene];
    
    [WXApi sendReq:req];
}

- (void)shareFeed:(NSString *)title
          content:(NSString *)content
          feedUrl:(NSString *)feedUrl
         imageUrl:(NSString *)imageUrl
         feedType:(NSString *)feedType
               to:(WechatScene)scene
  sendReqCallback:(WechatShareReqCallback)sendReqCallback {
    
    _sendReqCallback = sendReqCallback;
    WXMediaMessage *message = [WXMediaMessage message];
    
    message.title = title;
    message.description = content ? content : @"『神奇的不只是段子』";
    
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
    if (image == nil) {
        image = [UIImage imageNamed:@"details_icon_red_details_logo"];
    }
    [message setThumbImage:[UIImage compressImage:image toByte:20 * 1024]];
    
    if (feedType.integerValue == XLFeedCellMultiPictureType) {
        WXWebpageObject *webpageObject = [WXWebpageObject object];
        webpageObject.webpageUrl = feedUrl;
        message.mediaObject = webpageObject;
    } else {
        WXVideoObject *videoObject = [WXVideoObject object];
        videoObject.videoUrl = feedUrl;
        message.mediaObject = videoObject;
    }
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    [req setBText:NO];
    [req setMessage:message];
    [req setScene:scene];
    
    [WXApi sendReq:req];
    
}

- (void)shareUrl:(NSString *_Nonnull)title
        content:(NSString *_Nullable)content
             url:(NSString* )url
           image:(NSString *)imageUrl
                to:(WechatScene)scene
   sendReqCallback:(WechatShareReqCallback)sendReqCallback {
    
    _sendReqCallback = sendReqCallback;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = content;
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
    if (image == nil) {
        image = GetImage(@"details_icon_red_details_logo");
    }
    [message setThumbImage:[UIImage compressImage:image toByte:20 * 1024]];
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = url;
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    [req setBText:NO];
    [req setMessage:message];
    [req setScene:scene];
    
    [WXApi sendReq:req];
    
    
    
}



@end
