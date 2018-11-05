//
//  LaunchViewController.m
//  NationalRedPacket
//
//  Created by sunmingyue on 17/6/28.
//  Copyright © 2017年 孙明悦. All rights reserved.

#import "LaunchViewController.h"
#import "NewUserGuideViewController.h"
#import "LaunchViewModel.h"
#import "LoginApi.h"
#import "AppDelegate.h"
#import "XLGDTAdManager.h"


@interface LaunchViewController () <LaunchViewModelDelegate,XLGDTAdManagerDelegate>

@property (strong, nonatomic) LaunchViewModel *viewModel;
@property (assign, nonatomic) BOOL isFinishFetchData;
@property (assign, nonatomic) BOOL isFinishShowSplashAd;

@end

@implementation LaunchViewController

#pragma mark - Life Stytle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    /**构建视图*/
    [self setupUI];

    /**打点*/
    [StatServiceApi initWithStatUserId:XLLoginManager.shared.userId refer:APP_REFER];  //目的：统计未登录前的启动页
    [StatServiceApi statEvent:APP_LAUNCHPAGE];
    [StatServiceApi statEvent:APP_LAUNCH];
    [StatServiceApi statEventBegin:APP_ACTIVITY_DURATION];
    
    /**配置启动*/
    [self.viewModel startConfig];
    
    /**显示广告*/
    if ([XLGDTAdManager.shared shouldShowSplashAd]) {
        [XLGDTAdManager.shared showSplashAd];
        XLGDTAdManager.shared.delegate = self;
    }
}

#pragma mark -
#pragma mark - viewModel delegate

- (void)finishToFetchData {
    self.isFinishFetchData = YES;
    // 不需要展示广告时，数据请求成功之后直接页面跳转
    if (![XLGDTAdManager.shared shouldShowSplashAd]) {
        [self.viewModel prepareToResetRootViewController];
    } else if (self.isFinishShowSplashAd) {
        [self.viewModel prepareToResetRootViewController];
    }
}

- (void)pushRecommendViewController {
    NewUserGuideViewController *controller = [[NewUserGuideViewController alloc] init];
    [(AppDelegate*)[UIApplication sharedApplication].delegate resetToRootViewContoller:controller];
}

#pragma mark - XLGDTAd Delegate

/**
 广告关闭回调
 */
- (void)gdtSplashAdDidClose {
    self.isFinishShowSplashAd = YES;
    if (self.isFinishShowSplashAd) {
        [self.viewModel prepareToResetRootViewController];
    }
}

- (void)setupUI {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"launch_image"]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT - adaptHeight1334(135*2));
    }];

    UIView *logoContainer = [UIView new];
    [self.view addSubview:logoContainer];
    [logoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(imageView.mas_bottom);
    }];

    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"launch_bottom"]];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(logoContainer);
        make.bottom.equalTo(logoContainer.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(adaptHeight1334(135*2));
    }];
}
    
#pragma mark - Custom Accessor

- (LaunchViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[LaunchViewModel alloc] init];
        _viewModel.delegate = self;
    }
    return _viewModel;
}

@end
