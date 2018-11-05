//
//  UserViewController.m
//  NationalRedPacket
//
//  Created by 王海玉 on 2017/12/29.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "UserViewController.h"
#import "WechatLogin.h"
#import "UserFeedbackViewController.h"
#import "UserFollowingViewController.h"
#import "AboutUsViewController.h"
#import "AlertView.h"
#import "UserViewHeaderView.h"
#import "WXApi.h"
#import "UserLikeFeedListViewController.h"
#import "XLTableViewTaskCell.h"
#import "PPSUesrTableViewCell.h"
#import "SettingsViewController.h"
#import "StatServiceApi.h"
#import "WechatShare.h"
#import "ShareImageTool.h"
#import "RedPointManager.h"
#import "PPSSuccessFloatView.h"
#import "XLRedPacketManager.h"
#import "TotalAssetViewController.h"
#import "XLUserManager.h"
#import "UserApi.h"
#import "UserCollectionFeedListViewController.h"
#import "XLStartConfigManager.h"
#import "XLMyUploadViewController.h"
#import "XLEditPersonInfoViewController.h"
#import "XLH5WebViewController.h"

#define kImgHeight (adaptHeight1334(428) - NAVIGATION_BAR_HEIGHT)

@interface UserViewController () <XLRedPacketManagerDelegate, HeaderViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *rowArray;
@property (strong, nonatomic) NSMutableArray *iconArray;
@property (strong, nonatomic) AlertView *logOutAlertView;
@property (strong, nonatomic) AlertView *updateAlertView;
@property (strong, nonatomic) XLUserManager *userInfoModelCenter;
@property (strong, nonatomic) UserViewHeaderView *headView;
@property (strong, nonatomic) PPSSuccessFloatView *floatView;
@property (strong, nonatomic) XLRedPacketManager *redPacketManager;
@property (assign, nonatomic) BOOL redPointShow;
@property (assign, nonatomic) BOOL invitedRedPointShow;
@end

@implementation UserViewController

- (instancetype)init {

    self = [super init];
    if (self) {

    }
    return self;

}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    /**检查红包状态*/
    [self checkInviteRedPacket];
    
    /**从后台进入前台后调用*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForegroundNotification)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    /**重新加载数据*/
//    if (!_userInfoModelCenter.userInfoModel) {
     [self reloadData];
//    }
    
    /**配置头视图数据,头像,名称,邀请码*/
    if (XLLoginManager.shared.userInfo) {
        [self.headView userHeaderView:XLLoginManager.shared.userInfo.avatar
                           authorName:XLLoginManager.shared.userInfo.nickname
                          invitedCode:XLLoginManager.shared.userInfo.inviteCode];
    }

}


- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    /**销毁前移除对程序进入后台的监听*/
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];

}

- (void)viewDidLoad {

    [super viewDidLoad];
  
    self.view.backgroundColor = [UIColor colorWithString:COLORF8F7F9];
    [self.view addSubview:self.tableView];
    
    /**设置界面标题*/
    self.title = @"我的";
    
//    /**适配11.0*/
//    if (@available(iOS 11.0, *)) {
//
//        /**界面展开不覆盖navigation*/
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    
    /**配置cell数组*/
    [self setUpData];
    
    /**配置tableView*/
    [self setUpTableView];
    
    /**监测网络状态,当网络改变的情况,刷新界面数据*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:XLNetworkChangedNotification object:nil];

}

/**重新加载数据*/
- (void)reloadData{
    
    /**现在好像没啥要重新加载的, 有可能是拉去到需要展示红包*/
    [XLLoginManager.shared reloadUserInfo:^(UserInfoModel *model) {
        [self.headView userHeaderView:model.avatar
                           authorName:model.nickname
                          invitedCode:model.inviteCode];
    } failure:^(NSInteger errorCode) {
    }];
    
    [XLUserManager.shared fetchUserInfo:^{
        
    }];
    
}

/**往tableView中添加cell, 到最后也没用到, 以后再研究研究*/
- (void)addCellInSection:(NSInteger)section name:(NSString *)name icon:(NSString *)icon{

    if (section > self.rowArray.count || section < 0) {
        [self.rowArray addObject:@[name]];
        [self.iconArray addObject:@[icon]];
    }

}

- (void)setUpData {
    self.rowArray = @[@[@""],@[@"我的钱包"],@[@"我的帖子",@"我的关注", @"我的收藏", @"我的赞"], @[@"设置"]].mutableCopy;
    self.iconArray =@[@[@""],@[@"my_wallet"],@[@"my_post",@"my_collection",@"my_eye", @"my_like"] ,@[@"my_setup"]].mutableCopy;
    
    if (XLUserManager.shared.userInfoModel.invitationLuckyMoney.show.boolValue) {
        [self.rowArray insertObject:@[@""] atIndex:0];
        [self.iconArray insertObject:@[@""] atIndex:0];
    }
}

- (void)setUpTableView {

    self.tableView.backgroundColor = [UIColor colorWithString:@"#F8F7F9"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorColor = [UIColor colorWithString:@"#DEDFE0"];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.sectionFooterHeight = adaptHeight1334(20);
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,0.0f,_tableView.bounds.size.width,0.01f)];

}

/**程序进入前台*/
- (void)applicationWillEnterForegroundNotification  {

    [self.redPacketManager fetchTimingRedPacketState];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        if (WechatLogin.shared.isLoggingIn) {
            WechatLogin.shared.isLoggingIn = NO;
            [MBProgressHUD showError:@"登录失败"];
        }
    });

}

#pragma mark -
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.iconArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.iconArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        return self.headView;
    }
    if (indexPath.section == 1 && XLUserManager.shared.userInfoModel.invitationLuckyMoney.show.boolValue) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:@"inviteCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone; 
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_setting_invite"]];
        [cell.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(cell.contentView);
        }];
        return cell;
    }
    PPSUesrTableViewCell *cell = [[PPSUesrTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    [cell initWithImageName:self.iconArray[indexPath.section][indexPath.row] labelText:self.rowArray[indexPath.section][indexPath.row] addRedPoint:NO];
     return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        return self.headView.height;
    }
    if (indexPath.section == 1 && XLUserManager.shared.userInfoModel.invitationLuckyMoney.show.boolValue) {
        return adaptHeight1334(62*2);

    }
    return adaptHeight1334(46*2);

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self showViewController:[XLEditPersonInfoViewController new] sender:nil];
        [StatServiceApi statEvent:USER_INFO_EDIT_CLICK];
    } else if(indexPath.section == 1  && XLUserManager.shared.userInfoModel.invitationLuckyMoney.show.boolValue) {
        /**邀请*/
        XLH5WebViewController *inviteWebViewController = [XLH5WebViewController new];
        inviteWebViewController.urlString = XLUserManager.shared.userInfoModel.invitationLuckyMoney.jumpUrl;
        [self.navigationController pushViewController:inviteWebViewController animated:YES];
        [StatServiceApi statEvent:INVITE_MY_CLICK];
    } else if(indexPath.section == 1 + XLUserManager.shared.userInfoModel.invitationLuckyMoney.show.boolValue) {
        /**我的钱包*/
        [self showViewController:[TotalAssetViewController new] sender:nil];
        [StatServiceApi statEvent:MY_WALLET_CLICK model:nil otherString:@"coin"];
    } else if (indexPath.section == 3 + XLUserManager.shared.userInfoModel.invitationLuckyMoney.show.boolValue) {
        /**设置*/
        [self showViewController:[SettingsViewController new] sender:nil];
    } else {
        switch (indexPath.row) {
            case 0:
                /**我的帖子*/
                [StatServiceApi statEvent:MY_UPLOAD_CLICK];
                [self showViewController:[XLMyUploadViewController new] sender:nil];
                break;
            case 1:
                /**我的关注*/
                [StatServiceApi statEvent:USER_FOLLOW_CLICK];
                [self showViewController:[UserFollowingViewController new] sender:nil];
                break;
            case 2:
                /**我的收藏*/
                [StatServiceApi statEvent:USER_COLLECTION_CLICK];
                [self showViewController:[UserCollectionFeedListViewController new] sender:nil];
                break;
            case 3:
                /**我的赞*/
                [StatServiceApi statEvent:USER_PRAISE_CLICK];
                [self showViewController:[UserLikeFeedListViewController new] sender:nil];
                break;
            default:
                break;
        }
    }

}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];

}

#pragma mark -
#pragma mark - HeadView Delegate

/**
 定时红包点击事件
 */
- (void)didClickTimingRedPacketEvent {

    [self.redPacketManager showOpenViewWithType:RedPacketTypeTiming];

}

/**
 定时红包倒计时结束
 
 @param available 红包是否可用
 */
- (void)headViewTimingRedPacketShowStateChanged:(BOOL)available {

    [self.redPacketManager fetchTimingRedPacketState];

}

#pragma mark -
#pragma mark - RedPacketManager Delegate

/**
 定时红包状态改变
 */
- (void)timingRedPacketAvailable:(BOOL)isAvailable
                   withCountDown:(long)countDown
               withAvailableTime:(NSString *)availableTime {

    [self.headView updateTimingRedPacketAvailable:isAvailable
                                    withCountDown:countDown
                                withAvailableTime:availableTime];

}

#pragma mark -
#pragma mark - Private Method

/**
 展示邀请红包
 */
- (void)checkInviteRedPacket {

    if (XLUserManager.shared.userInfoModel.invitationLuckyMoney.haveLuckyMoney) {
        [self.redPacketManager showOpenViewWithType:RedPacketTypeInvite];
    }

}

#pragma mark -
#pragma mark - Setters and Getters

- (XLRedPacketManager *)redPacketManager {

    if (!_redPacketManager) {
        _redPacketManager = [XLRedPacketManager new];
        _redPacketManager.redPacketDelegate = self;
    }
    return _redPacketManager;

}

- (UserViewHeaderView *)headView {

    if (!_headView) {
        /**控制红包显示状态*/
        if (XLStartConfigManager.shared.startConfigModel.myLuckymoney) {
            _headView = [[UserViewHeaderView alloc] initWithRedType:UserViewHeaderViewHasRedPackage];
        } else {
            _headView = [[UserViewHeaderView alloc] initWithRedType:UserViewHeaderViewNone];
        }
    }
    _headView.delegate = self;
    return _headView;

}

- (UITableView *)tableView {

    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.frame = self.view.frame;
    }
    return _tableView;

}

@end
