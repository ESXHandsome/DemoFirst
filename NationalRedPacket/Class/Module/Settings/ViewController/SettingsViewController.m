//
//  SetUpTableViewController.m
//  NationalRedPacket
//
//  Created by Ying on 2018/3/21.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "SettingsViewController.h"
#import "PPSSetUpTableViewCell.h"
#import "AboutUsViewController.h"
#import "AlertView.h"
#import "AppDelegate.h"
#import "XLUpgradeManager.h"
#import "XLNIMService.h"
#import "XLBadgeManager.h"
#import "XLVideoAutoPlaySettingCell.h"
#import "XLPlayerManager.h"
#import "XLH5WebViewController.h"
#import "UserProtocolURL.h"

@interface SettingsViewController ()
@property (strong, nonatomic) NSMutableArray *rowArray;
@property (strong, nonatomic) UIAlertController *updateAlertView;
@property (strong, nonatomic) UIAlertController *logOutAlertView;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    
    self.title = @"设置";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:18]}];
    
    self.rowArray = @[@[@"WIFI下视频/动图自动播放",@"3G/4G下视频/动图自动播放"],@[@"神段子社区公约", @"神段子社区管理规范"],@[@"关于我们"],@[@"退出登录"]].mutableCopy;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.rowArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0 || section == 1) ? 2 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XLVideoAutoPlaySettingCell *cell = [[XLVideoAutoPlaySettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XLVideoAutoPlaySettingCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        BOOL isSwitch;
        if (indexPath.row == 0) {
            isSwitch = XLPlayerManager.shared.videoWifiShouldAutoPlay;
        } else {
            isSwitch = XLPlayerManager.shared.video4GShouldAutoPlay;
        }
        
        [cell setTitleLabelText:self.rowArray[indexPath.section][indexPath.row] isSwitch:isSwitch];
        cell.switchChangedBlock = ^(BOOL isOn) {
            if (indexPath.row == 0) {
                XLPlayerManager.shared.videoWifiShouldAutoPlay = isOn;
                [StatServiceApi statEvent:AUTO_PLAY_SWITCH model:nil otherString:[NSString stringWithFormat:@"%@,%@", isOn ? @"on" : @"off", @"wifi"]];
            } else {
                XLPlayerManager.shared.video4GShouldAutoPlay = isOn;
                [StatServiceApi statEvent:AUTO_PLAY_SWITCH model:nil otherString:[NSString stringWithFormat:@"%@,%@", isOn ? @"on" : @"off", @"4G"]];
            }
        };
        return cell;
    }
    
    PPSSetUpTableViewCell *cell = [[PPSSetUpTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    [cell setTitleLabelText:self.rowArray[indexPath.section][indexPath.row]];
    
    if(indexPath.section == 2 || indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if(indexPath.section == 3) {
        [cell setLabelLocation];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return adaptHeight1334(52*2);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (section == 0 || section == 1 || section == 2) ? adaptHeight1334(15*2) : 1 ;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor colorWithString:@"#F7F7F7"];
    return headView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        XLH5WebViewController *webViewController = [XLH5WebViewController new];
        if (indexPath.row == 0) {
            webViewController.urlString = URL_COMMUNITY_CONVERTION;
        } else if (indexPath.row == 1) {
            webViewController.urlString = URL_MANAGERMENT_SEPECIFICATION;
        }
        [self.navigationController pushViewController:webViewController animated:YES];
    }
    if(indexPath.section == 2 && indexPath.row == 0){
        [self showViewController:[AboutUsViewController new] sender:nil];
    } else if (indexPath.section == 3){
        [self presentViewController:self.logOutAlertView animated:YES completion:nil];
    }
}

- (void)setUpTableView {
    self.tableView.backgroundColor = [UIColor colorWithString:COLORF7F7F7];
    self.tableView.separatorColor = [UIColor colorWithString:@"#F1F1F1"];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, adaptHeight1334(30))];
    self.tableView.tableFooterView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.height = SCREEN_HEIGHT + adaptHeight1334(10);
}
- (UIAlertController *)logOutAlertView {
    if (!_logOutAlertView) {
        _logOutAlertView = [UIAlertController alertControllerWithTitle:@"退出确认" message:@"退出当前帐号，将不能发布评论" preferredStyle:UIAlertControllerStyleAlert];
        [_logOutAlertView addAction:[UIAlertAction actionWithTitle:@"确认退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self logOut];
        }]];
        UIAlertAction *cancelButton =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [_logOutAlertView addAction:cancelButton];
        _logOutAlertView.preferredAction = cancelButton;
    }
    return _logOutAlertView;
}

- (void)logOut {
    [MBProgressHUD showChrysanthemum:@"正在退出"];
    self.view.userInteractionEnabled = NO;
    [XLLoginManager.shared logoutWithIsEnforce:NO success:^(id responseDict) {
        self.view.userInteractionEnabled = YES;
        
        [XLNIMService.shared autoLogin];
        [AppDelegate.shared resetToRootTabViewController];
        [MBProgressHUD showError:@"退出成功"];
        
        // 更新小红点数据
        [XLBadgeManager.sharedManager registProfile];
   
        // 更新私聊红包详情显示标识
        [NSUserDefaults.standardUserDefaults setBool:NO forKey:XLUserDefaultsFollowRedPacketShowDetail];
        [NSUserDefaults.standardUserDefaults synchronize];
        
    } failure:^(NSInteger errorCode) {
        self.view.userInteractionEnabled = YES;
        [MBProgressHUD showError:@"退出失败"];
    }];
}

- (UIAlertController *)updateAlertView {
    if (!_updateAlertView) {
        _updateAlertView = [UIAlertController alertControllerWithTitle:@"发现新版本" message:XLUpgradeManager.shared.message preferredStyle:UIAlertControllerStyleAlert];
        [_updateAlertView addAction:[UIAlertAction actionWithTitle:@"暂不更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        }]];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [XLUpgradeManager.shared upgrade];
        }];
        [_updateAlertView addAction:action];
        _updateAlertView.preferredAction = action;
    }
    return _updateAlertView;
}
@end
