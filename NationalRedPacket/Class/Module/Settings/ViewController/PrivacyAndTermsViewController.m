//
//  permissionDeclarationViewController.m
//  NationalRedPacket
//
//  Created by 王海玉 on 2018/1/2.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "PrivacyAndTermsViewController.h"
#import <WebKit/WebKit.h>

#define URL_PRIVACY_TERMS @"http://quanminhongbao.jipi-nobug.cn/V2/Alipaywebview/declaration"

@interface PrivacyAndTermsViewController () <WKNavigationDelegate>
@property (strong, nonatomic) WKWebView * webView;
@end

@implementation PrivacyAndTermsViewController

#pragma mark -
#pragma mark ViewController life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"神段子软件许可协议";
    
    [self initWebView];
    [self loadPrivacyTermsWebView];
}

#pragma mark -
#pragma mark init subviews

- (void)initWebView {
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.size.height)];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
}

- (void)loadPrivacyTermsWebView {
    NSURL *url = [NSURL URLWithString:URL_PRIVACY_TERMS];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark -
#pragma mark WKWebView Delegate

- (void)webView:(WKWebView *)webView
didStartProvisionalNavigation:(WKNavigation *)navigation {
    [XLReloadFailView hideReloadFailInView:self.view];
}

- (void)webView:(WKWebView *)webView
didFailProvisionalNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    [XLReloadFailView showReloadFailInView:self.view reloadAction:^{
        [self loadPrivacyTermsWebView];
    }];
}

@end
