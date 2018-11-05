//
//  FeedArticleViewController.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/24.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "FeedArticleDetailViewController.h"
#import <WebKit/WebKit.h>
#import "FeedCommentSectionHeaderView.h"

static NSString *const previewLoad       = @"previewLoad";
static NSString *const previewHeadHeight = @"previewHeadHeight";
static NSString *const previewFollowTap  = @"previewFollowTap";
static NSString *const previewAuthor     = @"previewAuthor";

@interface FeedArticleDetailViewController ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) FeedCommentSectionHeaderView *sectionHeaderView;

@end

@implementation FeedArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.sectionHeaderView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(self.view.height - self.sectionHeaderView.height);
    }];
    
    [self.sectionHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.webView.mas_bottom);
        make.height.mas_equalTo(self.sectionHeaderView.height);
    }];
    
    [self requestArticleContent];
}

- (void)dealloc
{
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

/**
 文章内容H5
 */
- (void)requestArticleContent
{
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.baidu.com"] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:3*24*60*60]];
}

#pragma mark - WKWebViewDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    //传递参数给H5页面
    NSString * jsStr = [NSString stringWithFormat:@"followBtnSize(%f,%f)", adaptWidth750(54*2) -2,26.0];
    [webView evaluateJavaScript:jsStr completionHandler:nil];
    
    //禁用缩放及双击手势
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    
    [self callBackWebFollowState:self.feedModel.isFollowed];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.commentTableView.mj_footer beginRefreshing];
//        self.startTime = time(0);
//        [self startGCDTimer];
//        [XLLoadingView hideLoadingForView:self.view];
//        if (self.shouldScrollToCommentView) {
//        }
    });
    
}

- (void)callBackWebFollowState:(BOOL)isFollow
{
    //传递参数给H5页面
    NSString *followStr;
    if (isFollow) {
        followStr = @"true";
    } else {
        followStr = @"false";
    }
    NSString * jsStr1 = [NSString stringWithFormat:@"follow('%@')", followStr];
    [self.webView evaluateJavaScript:jsStr1 completionHandler:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //传递参数给H5页面
        NSString * jsStr = [NSString stringWithFormat:@"followBtnSize(%f,%f)", adaptWidth750(54*2) -2,26.0];
        [self.webView evaluateJavaScript:jsStr completionHandler:nil];
    });
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [XLLoadingView hideLoadingForView:self.view];
    [XLReloadFailView showReloadFailInView:self.view reloadAction:^{
//        [self requestNetWorkData];
    }];
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    [self.webView reload];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    XLLog(@"JS 调用了 %@ 方法，传回参数 %@",message.name,message.body);
    if ([message.name isEqualToString:previewHeadHeight]) {  // 滑动交互隐藏高度
//        self.webFollowButtonHeight = [message.body floatValue];
    } else if ([message.name isEqualToString:previewFollowTap]) { // 关注/取消关注
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self followButtonClick:self.followHeaderView.followButton];
//        });
//        [self.followHeaderView.followButton startAnimation];
    } else if ([message.name isEqualToString:previewAuthor]) {
//        [self pushPersonalHomepage];
    } else if ([message.name isEqualToString:previewLoad]) {
        
    }
}

#pragma mark - WKWebView KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"contentSize"]){
        if (object == self.webView.scrollView) {
            CGFloat newHeight = self.webView.scrollView.contentSize.height;
            if (self.webView.frame.size.height == newHeight) {
                return;
            }
            self.view.height = newHeight + self.sectionHeaderView.height;
            [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self.view);
                make.height.mas_equalTo(self.view.height - self.sectionHeaderView.height);
            }];
            
        }
    } else {
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (WKWebView *)webView
{
    if (!_webView) {
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        
        [userContentController addScriptMessageHandler:self name:previewLoad];
        [userContentController addScriptMessageHandler:self name:previewHeadHeight];
        [userContentController addScriptMessageHandler:self name:previewFollowTap];
        [userContentController addScriptMessageHandler:self name:previewAuthor];
        
        configuration.userContentController = userContentController;
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        configuration.preferences = preferences;
        
        self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        self.webView.backgroundColor = [UIColor whiteColor];
        self.webView.UIDelegate = self;
        self.webView.navigationDelegate = self;
        self.webView.scrollView.scrollEnabled = NO;
        self.webView.scrollView.bounces = NO;
        self.webView.opaque = NO;
        self.webView.userInteractionEnabled = NO;
        [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}

- (FeedCommentSectionHeaderView *)sectionHeaderView
{
    if (!_sectionHeaderView) {
        _sectionHeaderView = [FeedCommentSectionHeaderView new];
        [_sectionHeaderView setSectionTitle:@"热门评论"];
    }
    return _sectionHeaderView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
