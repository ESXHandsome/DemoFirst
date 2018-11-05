
//
//  RootTabViewController.m
//  NationalRedPacket
//
//  Created by 孙明悦 on 2017/5/8.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "RootTabViewController.h"
#import "BaseNavigationController.h"
#import "UserViewController.h"
#import "UIImage+Tool.h"
#import "DiscoveryViewController.h"
#import "XLUserManager.h"
#import "NIMSessionListViewController.h"
#import "FloatViewManager.h"
#import "XLTabBar.h"
#import "XLPostAlertViewController.h"
#import "XLHomeViewController.h"

#define kClassKey   @"rootVCClassString"
#define kTitleKey   @"title"
#define kImgKey     @"imageName"
#define kSelImgKey  @"selectedImageName"

@interface RootTabViewController ()<UITabBarControllerDelegate>

@property (strong, nonatomic) NSMutableArray *chaildViewControllerArray;
@property (strong, nonatomic) UITabBarItem *lastItem;

@end

@implementation RootTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    [self setValue:[XLTabBar tabBarWithPublishTarget:self publishAction:@selector(publishButtonDidClick)] forKey:@"tabBar"];
    
    self.chaildViewControllerArray = [[NSMutableArray alloc] init];

    NSMutableArray *childItemsArray = [NSMutableArray new];
   
    [childItemsArray addObject:@{kClassKey  : @"XLHomeViewController",
                                 kTitleKey  : @"刷新",
                                 kImgKey    : @"tab_home",
                                 kSelImgKey : @"tab_home_slick"}];
    
    [childItemsArray addObject:@{kClassKey  : @"DiscoveryViewController",
                                 kTitleKey  : @"发现",
                                 kImgKey    : @"tab_find",
                                 kSelImgKey : @"tab_find_slick"}];
    
    [childItemsArray addObject:@{kClassKey  : @"NIMSessionListViewController",
                                 kTitleKey  : @"消息",
                                 kImgKey    : @"tab_news",
                                 kSelImgKey : @"tab_news_slick"}];
    
    [childItemsArray addObject: @{kClassKey  : @"UserViewController",
                                  kTitleKey  : @"我的",
                                  kImgKey    : @"my",
                                  kSelImgKey : @"my_slick"}];
    
    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        UIViewController *vc = [NSClassFromString(dict[kClassKey]) new];
        
        vc.title = dict[kTitleKey];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = dict[kTitleKey];

        item.image = [[UIImage imageNamed:dict[kImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:dict[kSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor colorWithString:COLOR333333] } forState:UIControlStateSelected];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor colorWithString:COLOR999999] } forState:UIControlStateNormal];
        [item setTitlePositionAdjustment:UIOffsetMake(0, -2)];
        [self.chaildViewControllerArray addObject:nav];
        
    }];

    [self setViewControllers:self.chaildViewControllerArray];
    
    [self configTabbarUI];
    [self reachabilityNetwork];
    
    // 刷新个人界面的状态
    [XLUserManager.shared reloadUserInfoForTabBadge];
    
    self.lastItem = self.tabBar.selectedItem;
    
}

- (void)reachabilityNetwork  //如果服务器登录失败了，就检测网络变化，等有网络了就立即登录
{
    if (!XLLoginManager.shared.isVisitorLogined) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didNetworkChangedNotification)
                                                     name:XLNetworkChangedNotification
                                                   object:nil];
    }
}

- (void)didNetworkChangedNotification
{
    [XLLoginManager.shared relogin:nil failure:nil];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    // 比较
    if ([tabBarController.childViewControllers.lastObject isEqual:viewController] && !XLLoginManager.shared.isAccountLogined) {
        
        @weakify(self);
        
        [LoginViewController showLoginVCFromSource:LoginSourceTypeUserTabbarClick].loginSuccess = ^(BOOL success) {
            @strongify(self);
            if (success) {
                [self setSelectedIndex:(int)(self.childViewControllers.count - 1)];
            }
        };
        
        return NO;
    }
    return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    if ([tabBar.selectedItem.title isEqualToString:@"刷新"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchNewData" object:nil userInfo:nil];
    }
    
    if (![self.lastItem.title isEqualToString:item.title]) {
        if ([self.lastItem.title isEqualToString:@"刷新"]) {
            self.lastItem.title = @"首页";
        }
    }
    //当前Tab的title是"神段子"的话，就修改为刷新
    if ([item.title isEqualToString:@"首页"]) {
        item.title = @"刷新";
    }
    
    if ([item.title isEqualToString:@"我的"] &&
        !XLUserManager.shared.userInfoModel.invitationLuckyMoney.haveLuckyMoney) {
        [self.tabBar hideBadgeOnItemIndex:(int)(self.childViewControllers.count - 1)];
    }
    
    NSString *statString;
    if ([item.title isEqualToString:@"首页"] || [item.title isEqualToString:@"刷新"]) {
        statString = @"HOME";
    } else if ([item.title isEqualToString:@"发现"]) {
        statString = @"FIND";
    } else if ([item.title isEqualToString:@"我的"]) {
        statString = @"MY";
    } else if ([item.title isEqualToString:@"消息"]) {
        statString = @"MSG";
    }
    if (![item.title isEqualToString:self.lastItem.title]) {
        [StatServiceApi statEvent:USER_TABBAR_CLICK model:nil otherString:statString];
    }
    
    self.lastItem = item;

}

/**
 发布按钮点击
 */
- (void)publishButtonDidClick {
    
    [StatServiceApi statEvent:USER_PUBLISH_CLICK];
    //发布前登录判断
    if (!XLLoginManager.shared.isAccountLogined) {
        [LoginViewController showLoginVCFromSource:LoginSourceTypePublishClick];
        return;
    }
    
    NSMutableArray *vcArray = [StatServiceApi.sharedService screenDisplayViewController];
    for (UIViewController *vc in vcArray) {
        [vc viewWillDisappear:YES];
        [vc viewDidDisappear:YES];
    }
    
    XLPostAlertViewController *controller = [[XLPostAlertViewController alloc] init];
    controller.currentArray = vcArray;
    [controller presentPostAlertViewController:self];
}

- (void)configTabbarUI {
    NSDictionary *titleTextSelectAttributes = [NSDictionary dictionaryWithObject:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    NSDictionary *titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor greenColor] forKey:NSForegroundColorAttributeName];
    
    [self.tabBarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    [self.tabBarItem setTitleTextAttributes:titleTextSelectAttributes forState:UIControlStateSelected];
    
    UIImage *tabBgImage = [UIImage createImageWithColor:[UIColor colorWithString:COLORffffff] size:CGSizeMake(1, 1)];
    [[UITabBar appearance] setBackgroundImage:tabBgImage];
    
    [UITabBar appearance].translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
