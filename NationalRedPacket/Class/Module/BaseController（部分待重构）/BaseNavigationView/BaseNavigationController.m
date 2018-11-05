//
//  BaseNavigationController.m
//  NationalRedPacket
//
//  Created by 孙明悦 on 2017/5/31.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UIColor+NSString.h"
#import "UIImage+Tool.h"

@interface BaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
    self.useSystemBackBarButtonItem = YES;

    [self setupNavAppearance];
}

- (void)setupNavAppearance {
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
                                                           NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
    
    UIImage *backImage = [UIImage createImageWithColor:[UIColor colorWithString:COLORffffff] size:CGSizeMake(1, 1)];
    [self.navigationBar setBackgroundImage:backImage forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTintColor: [UIColor colorWithString:COLOR333333]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];

}

- (void)didClickBackeButtonEvent {
    [self popViewControllerAnimated:YES];
}

// tabbar下的navigationController在push时隐藏tabbar 并修改返回按钮样式
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, adaptWidth750(38), 22);
        [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -adaptWidth750(10), 0, adaptWidth750(10))];
        [backButton setImage:[UIImage imageNamed:@"return_black"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"return_black_highlighted"] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(didClickBackeButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        viewController.navigationItem.leftBarButtonItem = backButtonItem;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)setEnableRightGesture:(BOOL)enableRightGesture {
    _enableRightGesture = enableRightGesture;
    
    self.rt_navigationController.topViewController.fd_interactivePopDisabled = !enableRightGesture;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
