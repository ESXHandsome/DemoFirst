//
//  permissionDeclarationViewController.m
//  NationalRedPacket
//
//  Created by 王海玉 on 2018/1/2.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "permissionDeclarationViewController.h"
#import <WebKit/WebKit.h>

@interface permissionDeclarationViewController ()<WKNavigationDelegate>

@property(nonatomic, strong) WKWebView * webView;


@end

@implementation permissionDeclarationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[WKWebView alloc] initWithFrame: self.view.frame];
    [self.view addSubview: self.webView];
    self.webView.navigationDelegate = self;
    
    NSURL * url = [NSURL URLWithString:@"http://quanminhongbao.jipi-nobug.cn/V2/Alipaywebview/declaration"];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
