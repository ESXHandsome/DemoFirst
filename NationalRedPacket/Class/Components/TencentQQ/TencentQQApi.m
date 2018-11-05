//
//  TencentQQApi.m
//  Kratos
//
//  Created by Zhangziqi on 16/5/10.
//  Copyright © 2016年 lyq. All rights reserved.
//

#import "TencentQQApi.h"
#import <UIKit/UIKit.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "UIImage+Tool.h"
#import "ThirdpartyLoginApi.h"

#define URL_JOIN_GROUP @"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external"
#define DEFAULT_GROUP_NUMBER @"476531342"
#define DEFAULT_GROUP_KEY    @"QbEhJOzm1oFn2CE2iymQIC5Lvn-EEsBh"

@interface TencentQQApi () <QQApiInterfaceDelegate, TencentLoginDelegate, TencentSessionDelegate>
@property (strong, nonatomic) SendReqCallback sendReqCallback; /**< 向QQ发送消息后，回调的block */
@property (strong, nonatomic) LoginCallback   loginCallback; /**< 向QQ发送消息后，回调的block */
@property (strong, nonatomic) TencentOAuth    *tencentOAuth;
@end

@implementation TencentQQApi

#pragma -
#pragma initialize

/**
 *  获取QQApi的单例对象
 *
 *  @return 单例对象
 */
+ (instancetype _Nonnull)sharedInstance {
    static TencentQQApi *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TencentQQApi alloc] init];
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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:XLQQAppId andDelegate:self];
#pragma clang diagnostic pop
    }
    return self;
}

#pragma mark - Login
- (void)loginCallback:(LoginCallback _Nullable)callback
{
    _loginCallback = callback;
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_SHARE,
                            nil];
    
    [_tencentOAuth authorize:permissions inSafari:NO];
    
    self.isLoggingIn = YES;

}

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin
{
    [ThirdpartyLoginApi requestThirdpartyLoginPlatform:@"QQ" openId:self.tencentOAuth.openId accessToken:self.tencentOAuth.accessToken success:^(id res) {
        [self qqLoginCallBackWithCode:0];
    } failure:^(NSInteger errorCode) {
        [self qqLoginCallBackWithCode:4];
    }];
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    [self qqLoginCallBackWithCode:1];
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork
{
    [self qqLoginCallBackWithCode:2];
}

#pragma mark - foreground check

- (void)applicationWillEnterForegroundLoginCheck {
    // 两秒后检查登录状态
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        if (self.isLoggingIn) {
            [self qqLoginCallBackWithCode:3];
        }
    });
}

- (void)qqLoginCallBackWithCode:(NSInteger)code {
    
    self.isLoggingIn = NO;
    
    ThirdpartyLoginModel *model = [ThirdpartyLoginModel new];
    model.code = code;
    model.openId = self.tencentOAuth.openId;
    model.accessToken = self.tencentOAuth.accessToken;
    model.platform = @"QQ";
    self.loginCallback(model);
    
}

/**
 处理QQ请求的回调

 @param url 回调的URL
 */
- (void)handleOpenUrl:(NSURL *_Nonnull)url {
    
    [TencentOAuth HandleOpenURL:url];
    [QQApiInterface handleOpenURL:url delegate:self];
}

#pragma -
#pragma mark Share Methods

/**
 分享文字消息到QQ
 
 @param text 要分享的文字
 @param scene 分享的场景，QQ好友、QQ空间
 */
- (void)shareTextMessage:(NSString *_Nonnull)text
                      to:(QQScene)scene
                callback:(SendReqCallback _Nullable)callback {
    
    _sendReqCallback = callback;
    
    QQApiObject *txtObj = [QQApiTextObject new];
    
    if (scene == QQSceneSession) {
        QQApiTextObject *obj = [QQApiTextObject new];
        [obj setText:text];
        txtObj = obj;
    } else if (scene == QQSceneQzone) {
        QQApiImageArrayForQZoneObject *obj = [QQApiImageArrayForQZoneObject new];
        [obj setTitle:text];
        [obj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
        txtObj = obj;
    }
    
    [self shareObject:txtObj toScene:scene];
}

/**
 分享图片到QQ
 
 @param image 要分享的图片
 @param title 分享的标题
 @param description 分享的描述
 @param scene 分享的场景，QQ好友、QQ空间
 */
- (void)shareImage:(UIImage *_Nonnull)image
             title:(NSString *_Nonnull)title
       description:(NSString *_Nonnull)description
                to:(QQScene)scene
          callback:(SendReqCallback _Nullable)callback {
    
    _sendReqCallback = callback;
    
    NSData *imgData = UIImageJPEGRepresentation(image, 0.1);

    QQApiObject *imgObj = nil;
    
    if (scene == QQSceneSession) {
        QQApiImageObject *obj = [QQApiImageObject new];
        [obj setData:imgData];
        [obj setPreviewImageData:imgData];
        [obj setTitle:title];
        [obj setDescription:description];
        imgObj = obj;
    } else if (scene == QQSceneQzone) {
        QQApiImageArrayForQZoneObject *obj = [QQApiImageArrayForQZoneObject new];
        [obj setImageDataArray:@[imgData]];
        [obj setTitle:title];
        imgObj = obj;
    }
    
    [self shareObject:imgObj toScene:scene];
}

/**
 分享网页到QQ
 
 @param url 要分享网页的URL
 @param title 分享内容的标题
 @param description 分享内容的描述
 @param thumb 分享内容的缩略图
 @param scene 分享的场景，QQ好友、QQ空间
 */
- (void)shareWebpage:(NSString *_Nonnull)url
               title:(NSString *_Nonnull)title
         description:(NSString *_Nonnull)description
               thumb:(NSString *_Nonnull)thumb
                  to:(QQScene)scene
            callback:(SendReqCallback _Nullable)callback {
    
    _sendReqCallback = callback;

    QQApiNewsObject *newsObj = [QQApiNewsObject new];
    [newsObj setUrl:[NSURL URLWithString:url]];
    [newsObj setTitle:title];
    [newsObj setDescription:description];
    [newsObj setPreviewImageData:[NSData dataWithContentsOfFile:thumb]];
    [newsObj setTargetContentType:QQApiURLTargetTypeNews];
    
    [self shareObject:newsObj toScene:scene];
}

/**
 QQ分享
 
 @param articleModel 文章
 @param scene QQ好友或QQ空间
 */
- (void)shareNewsArticle:(XLFeedModel *_Nullable)articleModel
                      to:(QQScene)scene
                callback:(SendReqCallback _Nullable)callback {
    _sendReqCallback = callback;
    
    QQApiNewsObject *newsObj = [QQApiNewsObject new];

    [newsObj setUrl:[NSURL URLWithString:articleModel.shareCompleteURL]];
    NSString *title = articleModel.title;
    if (title.length > 120) {
        title = [title substringToIndex:120];
    }
    [newsObj setTitle:title.length != 0 ? title : @"神段子"];
    [newsObj setDescription:@"『神奇的不只是段子』"];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:articleModel.picture.firstObject];
    image = [UIImage compressImage:image toByte:20 * 1024];

    if (image == nil) {
        image = [UIImage imageNamed:@"details_icon_red_details_logo"];
    }
    [newsObj setPreviewImageData:UIImageJPEGRepresentation(image, 1)];
    [newsObj setTargetContentType:QQApiURLTargetTypeNews];
    
    [self shareObject:newsObj toScene:scene];
}

- (void)shareFeed:(NSString *)title
           content:(NSString *)content
               url:(NSString *)url
             image:(NSString *)imageString
                to:(QQScene)scene
          callback:(SendReqCallback _Nullable)callback {
    _sendReqCallback = callback;
    
    QQApiNewsObject *newsObj = [QQApiNewsObject new];
    
    [newsObj setUrl:[NSURL URLWithString:url]];
    if (title.length > 120) {
        title = [title substringToIndex:120];
    }
    [newsObj setTitle:title.length != 0 ? title : @"神段子"];
    [newsObj setDescription:content ? content :@"『神奇的不只是段子』"];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageString];
    image = [UIImage compressImage:image toByte:20 * 1024];
    
    if (image == nil) {
        image = [UIImage imageNamed:@"details_icon_red_details_logo"];
    }
    [newsObj setPreviewImageData:UIImageJPEGRepresentation(image, 1)];
    [newsObj setTargetContentType:QQApiURLTargetTypeNews];
    
    [self shareObject:newsObj toScene:scene];
}

- (void)shareNewsArticle:(NSString *_Nonnull)url
               title:(NSString *_Nonnull)title
         description:(NSString *_Nonnull)description
               thumb:(NSString *_Nonnull)thumb
                  to:(QQScene)scene
            callback:(SendReqCallback _Nullable)callback {
    
    _sendReqCallback = callback;
    
    QQApiNewsObject *newsObj = [QQApiNewsObject new];
    
    [newsObj setUrl:[NSURL URLWithString:url]];
    if (title.length > 120) {
        title = [title substringToIndex:120];
    }
    [newsObj setTitle:title.length != 0 ? title : @"神段子"];
    [newsObj setDescription:description];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumb];
    image = [UIImage compressImage:image toByte:20 * 1024];
    
    if (image == nil) {
        image = [UIImage imageNamed:@"details_icon_red_details_logo"];
    }
    [newsObj setPreviewImageData:UIImageJPEGRepresentation(image, 1)];
    [newsObj setTargetContentType:QQApiURLTargetTypeNews];
    
    [self shareObject:newsObj toScene:scene];
}

/**
 分享消息到QQ

 @param obj 要分享的消息对象
 @param scene 分享的场景，QQ好友、QQ空间
 */
- (void)shareObject:(QQApiObject *)obj
            toScene:(QQScene)scene {
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (scene == QQSceneSession) {
            QQApiSendResultCode code = [QQApiInterface sendReq:req];
            if (code == EQQAPISENDSUCESS) {
                XLLog(@"success");
            }
        } else if (scene == QQSceneQzone) {
            [QQApiInterface SendReqToQZone:req];
        }
    });
}

#pragma -
#pragma mark QQ Group

/**
 *  判断用户当前手机是否能加入QQ群
 *
 *  @return 能加入返回YES，否则返回NO
 */
+ (BOOL)canJoinGroup {
    NSString *urlString = [NSString stringWithFormat:URL_JOIN_GROUP, DEFAULT_GROUP_NUMBER, DEFAULT_GROUP_KEY];
    NSURL *url = [NSURL URLWithString:urlString];
    return [[UIApplication sharedApplication] canOpenURL:url];
}

/**
 *  加入指定的QQ群，如果Group或Key任一为空，那么加入默认的QQ群
 *
 *  @param group QQ群的群号
 *  @param key   QQ群的Key
 */
+ (void)joinGroup:(NSString *_Nullable)group
          withKey:(NSString *_Nullable)key {
    if (group == nil || key == nil) {
        group = DEFAULT_GROUP_NUMBER;
        key = DEFAULT_GROUP_KEY;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:URL_JOIN_GROUP, group, key]];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma -
#pragma mark QQApiInterfaceDelegate Protocol Implementation

- (void)onReq:(QQBaseReq *)req {
    
}

- (void)onResp:(QQBaseResp *)resp {
    if (resp.type == ESENDMESSAGETOQQRESPTYPE) {
        if (_sendReqCallback) {
            if ([resp.result isEqualToString:@"0"]) {
                _sendReqCallback(0, nil);
            } else {
                _sendReqCallback([resp.result intValue], resp.errorDescription);
            }
        }
    }
}

- (void)isOnlineResponse:(NSDictionary *)response {
    
}

@end
