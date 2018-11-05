//
//  XLH5WebViewController.m
//  NationalRedPacket
//
//  Created by Ying on 2018/6/12.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLH5WebViewController.h"
#import <WebKit/WebKit.h>
#import "XLUserManager.h"
#import "XLLoginManager.h"
#import "ShareAlertView.h"
#import "ShareImageTool.h"
#import "WechatShare.h"
#import "TencentQQApi.h"
#import "UserApi.h"
#import "XLWebShareModel.h"

static NSString *const shareCustomInvatation = @"shareCustomInvatation";
static NSString *const checkUserLogin        = @"checkUserLogin";

@interface XLH5WebViewController () <WKUIDelegate,WKNavigationDelegate, WKScriptMessageHandler, ShareAlertViewDelegate>

@property (strong, nonatomic) WKWebView      *webView;
@property (strong, nonatomic) ShareAlertView *alertView;
@property (strong, nonatomic) NSMutableArray <XLWebShareModel *> *shareArray;

@end

@implementation XLH5WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigation];
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAVIGATION_BAR_HEIGHT);
        make.bottom.equalTo(self.view);
    }];
    
    /**加载中视图*/
    [XLLoadingView showLoadingInView:self.view];
    
    /**webView 加载H5*/
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self generateInviteUrl:self.urlString]]]];
    
    /**版本适配*/
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"title"];
}

/**
 拼接url

 @param origin 源地址
 @return 结果
 */
- (NSString *)generateInviteUrl:(NSString *)origin {
    
    if ([origin containsString:@"http://neptune.jipi-nobug.cn"]) {
        return [NSString stringWithFormat:@"%@?inviteCode=%@", origin, XLLoginManager.shared.userInfo.inviteCode];
    } else {
        return origin;
    }
}

- (void)setUpNavigation{

    self.title = @"加载中...";
    /**重新设置一下返回按钮*/
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, adaptWidth750(38), 22);
    [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -adaptWidth750(10), 0, adaptWidth750(10))];
    [backButton setImage:[UIImage imageNamed:@"return_black"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"return_black_highlighted"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(didClickBackeButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)didClickBackeButtonEvent{
    NSString *jsString = @"window.page.back()";
    @weakify(self);
    [self.webView evaluateJavaScript:jsString completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        @strongify(self);
        if (item) {
            return ;
        }
        if (self.webView.backForwardList.backList.count > 0) {
            [self.webView goBack];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark -
#pragma mark - webView delegate

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [XLLoadingView hideLoadingForView:self.view];
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [XLLoadingView hideLoadingForView:self.view];
    if (error) {
        [XLReloadFailView showReloadFailInView:self.view reloadAction:^{
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
        }];
    }
}

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    /**H5给我返回的回调, 通过message.body 获取返回的信息, 然后我去跳转, 这里应该能实现根据H5返回的数据进行跳转(个人猜测)*/
    if ([message.name isEqualToString:shareCustomInvatation]) {  //邀请好友
        XLLog(@"H5给的回调信息: %@",message.body);
        if (message.body == nil) { //判空处理
            return;
        }
        if ([message.body isKindOfClass:[NSArray class]]) {
            self.shareArray = [NSArray yy_modelArrayWithClass:XLWebShareModel.class json:message.body].mutableCopy;
        } else {
            self.shareArray = [NSMutableArray array];
            [self.shareArray addObject:[XLWebShareModel yy_modelWithJSON:message.body]];
        }
        [self prepareToShare];
    } else if ([message.name isEqualToString:checkUserLogin]) { //检查是否登录
        if (!XLLoginManager.shared.isAccountLogined) { //未登录，登录后刷新页面
            @weakify(self);
            [LoginViewController showLoginVCFromSource:LoginSourceTypeRedPacketClick].loginSuccess = ^(BOOL success) {
                @strongify(self);
                if (success) {
                    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self generateInviteUrl:self.urlString]]]];
                }
            };
        }
    }
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    [self.webView reload];
}

#pragma mark -
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            if(self.navigationController)
                self.navigationItem.title = self.webView.title;
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark -
#pragma mark - share alertView delegate

- (void)didSelectShareIndex:(NSInteger)index{
    
    [self shareToOtherAppWithModel:self.shareArray[index]];
}

#pragma mark - 预备分享
- (void)prepareToShare {
    if (self.shareArray.count > 1) {
        self.alertView = [ShareAlertView new];
        self.alertView.titleLabel.text = @"邀请好友";
        [self.alertView showShareViewWithSceneArray:[self.shareArray valueForKeyPath:@"shareMode"] delegate:self];
    } else {
        [self shareToOtherAppWithModel:self.shareArray.firstObject];
    }
}

- (void)shareToOtherAppWithModel:(XLWebShareModel *)model {
    
    if ([model.contentType isEqualToString:@"singleImage"]) {
        
        if ([model.shareMode isEqualToString:@"qq_zone"]) {
            [self shareImageToQQWithModel:model QQScene:QQSceneQzone];
        } else if ([model.shareMode isEqualToString:@"qq_session"]) {
            [self shareImageToQQWithModel:model QQScene:QQSceneSession];
        } else if ([model.shareMode isEqualToString:@"wechat_session"]) {
            [self shareImageToWechatWithModel:model WechatScene:WechatSceneSession];
        } else if ([model.shareMode isEqualToString:@"wechat_moments"]) {
            [self shareImageToWechatWithModel:model WechatScene:WechatSceneTimeline];
        }
        
    } else if ([model.contentType isEqualToString:@"singleLink"]) {
        
        if ([model.shareMode isEqualToString:@"qq_zone"]) {
            [self shareUrlToQQWithModel:model QQScene:QQSceneQzone];
        } else if ([model.shareMode isEqualToString:@"qq_session"]) {
            [self shareUrlToQQWithModel:model QQScene:QQSceneSession];
        } else if ([model.shareMode isEqualToString:@"wechat_session"]) {
            [self shareUrlToWechatWithModel:model WechatScene:WechatSceneSession];
        } else if ([model.shareMode isEqualToString:@"wechat_moments"]) {
            [self shareUrlToWechatWithModel:model WechatScene:WechatSceneTimeline];
        }
    }
}

#pragma mark - 调起分享操作

/**
 分享大图二维码到微信

 @param model 分享模型
 @param scene 分享场景
 */
- (void)shareImageToWechatWithModel:(XLWebShareModel *)model WechatScene:(WechatScene)scene {
    
    [StatServiceApi statEvent:NEWS_INVITE_TYPE model:nil otherString:scene == WechatSceneSession ? WECHAT_SESSION_CHANNEL : WECHAT_MOMENTS_CHANNEL];
    
    [self prepareSharedImageUrl:model.img QRcodeUrl:model.url success:^(UIImage *resultImage, UIImage *resultThumbImage) {
        [[WechatShare sharedInstance] shareImage:resultImage
                                      thumbImage:resultThumbImage
                                              to:scene
                                 sendReqCallback:^(int code) {
                                     if (code == 0) {
                                         [MBProgressHUD showSuccess:@"分享成功"];
                                     } else {
                                         [MBProgressHUD showError:@"分享失败" time:2.5];
                                     }
                                 }];
    }];
}

/**
 分享链接到微信
 
 @param model 分享模型
 @param scene 分享场景
 */
- (void)shareUrlToWechatWithModel:(XLWebShareModel *)model WechatScene:(WechatScene)scene {
    
    [StatServiceApi statEvent:NEWS_INVITE_TYPE model:nil otherString:scene == WechatSceneSession ? WECHAT_SESSION_CHANNEL : WECHAT_MOMENTS_CHANNEL];
    
    [[WechatShare sharedInstance] shareUrl:model.title
                                   content:model.content
                                       url:model.url
                                     image:model.img
                                        to:scene
                           sendReqCallback:^(int code) {
        if (code == 0) {
           [MBProgressHUD showSuccess:@"分享成功"];
        } else {
           [MBProgressHUD showError:@"分享失败" time:2.5];
        }
    }];
}

/**
 分享大图二维码到QQ
 
 @param model 分享模型
 @param scene 分享场景
 */
- (void)shareImageToQQWithModel:(XLWebShareModel *)model QQScene:(QQScene)scene{
    
    [StatServiceApi statEvent:NEWS_INVITE_TYPE model:nil otherString:scene == QQSceneQzone ? QQ_ZONE_CHANNEL : QQ_SESSION_CHANNEL];
    
    [self prepareSharedImageUrl:model.img QRcodeUrl:model.url success:^(UIImage *resultImage, UIImage *resultThumbImage) {
        [[TencentQQApi sharedInstance] shareImage:resultImage
                                            title:model.title
                                      description:model.content
                                               to:scene
                                         callback:^(int code, NSString * _Nullable description) {
                                             if (code == 0) {
                                                 [MBProgressHUD showError:@"分享成功" time:2.5];
                                             } else {
                                                 [MBProgressHUD showError:@"分享失败" time:2.5];
                                             }
                                         }];
    }];
    
}

/**
 分享链接到QQ
 
 @param model 分享模型
 @param scene 分享场景
 */
- (void)shareUrlToQQWithModel:(XLWebShareModel *)model QQScene:(QQScene)scene {
    
    [StatServiceApi statEvent:NEWS_INVITE_TYPE model:nil otherString:scene == QQSceneQzone ? QQ_ZONE_CHANNEL : QQ_SESSION_CHANNEL];
    
    [[TencentQQApi sharedInstance] shareNewsArticle:model.url
                                              title:model.title
                                        description:model.content
                                              thumb:model.img
                                                 to:scene
                                           callback:^(int code, NSString * _Nullable description) {
           if (code == 0) {
               [MBProgressHUD showError:@"分享成功" time:2.5];
           } else {
               [MBProgressHUD showError:@"分享失败" time:2.5];
           }
    }];
}

/**
 预备分享二维码大图

 @param imageUrl 图片url
 @param url 二维码url
 @param success 返回结果
 */
- (void)prepareSharedImageUrl:(NSString *)imageUrl QRcodeUrl:(NSString *)url success:(void(^)(UIImage *resultImage, UIImage *resultThumbImage))success {
    [MBProgressHUD showChrysanthemum:@"分享中，请稍后" toView:self.view];
    
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        /**下载图片完成*/
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.view.userInteractionEnabled = YES;
        image = [ShareImageTool createShareImageWithUrl:url image:image];
        UIImage *thumbImage = [UIImage imageWithImage:image scaledToSize:CGSizeMake(image.size.width / 5.0, image.size.height / 5.0)];
        /**进行完一系列配置工作,现在准备开始分享*/
        success(image, thumbImage);
    }];
}

#pragma mark -
#pragma mark - getter
- (WKWebView *)webView {
    if (!_webView) {
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        
        [userContentController addScriptMessageHandler:self name:shareCustomInvatation];
        [userContentController addScriptMessageHandler:self name:checkUserLogin];
        
        configuration.userContentController = userContentController;
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        configuration.preferences = preferences;
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        
    }
    return _webView;
}

@end
