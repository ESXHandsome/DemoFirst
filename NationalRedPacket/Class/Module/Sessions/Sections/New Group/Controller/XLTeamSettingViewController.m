//
//  XLTeamSettingViewController.m
//  NationalRedPacket
//
//  Created by bulangguo on 2018/7/27.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLTeamSettingViewController.h"
#import "XLTeamSettingCell.h"

@interface XLTeamSettingViewController ()

@property (strong, nonatomic) NSMutableArray *teamDataArray;

@end

@implementation XLTeamSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithString:COLORF7F7F7];
    self.title = @"群设置";
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    [self configTeamSettingData];
    
    [self.tableView xl_registerClass:XLTeamSettingCell.class];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = adaptHeight1334(20);
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, adaptHeight1334(20))];
    
    [self setupTableViewFooterView];
    
}

- (void)setupTableViewFooterView {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, adaptHeight1334(54*2))];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIButton *logoutTeamButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutTeamButton setTitle:@"退出该群" forState:UIControlStateNormal];
    [logoutTeamButton setTitleColor:[UIColor colorWithString:COLORFE6969] forState:UIControlStateNormal];
    [logoutTeamButton setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithString:COLORFE6969] colorWithAlphaComponent:0.1] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [logoutTeamButton setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithString:COLORFE6969] colorWithAlphaComponent:0.3] size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
    logoutTeamButton.layer.cornerRadius = 4;
    logoutTeamButton.layer.masksToBounds = YES;
    [logoutTeamButton addTarget:self action:@selector(logoutTeamAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:logoutTeamButton];
    [logoutTeamButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(adaptHeight1334(38*2));
        make.left.equalTo(footerView).offset(adaptWidth750(32));
        make.right.equalTo(footerView).offset(-adaptWidth750(32));
        make.centerY.equalTo(footerView);
    }];
    
    self.tableView.tableFooterView = footerView;
}

- (void)configTeamSettingData {
    
    self.teamDataArray = [NSMutableArray array];
    
    NSMutableArray *section1Array = [NSMutableArray array];
    NSMutableArray *section2Array = [NSMutableArray array];
    
    NSArray *titleArray = @[@"群名称", @"群聊成员", @"群公告", @"消息免打扰"];
    
    [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        XLTeamSettingModel *model = [XLTeamSettingModel new];
        model.title = obj;
        switch (idx) {
            case 0: {
                model.content = self.team.teamName;
                [section1Array addObject:model];
                break;
            }
            case 1: {
                model.content = [NSString stringWithFormat:@"共%ld人", (long)self.team.memberNumber];
                [section1Array addObject:model];
                break;
            }
            case 2: {
                model.content = self.team.intro;
                [section1Array addObject:model];
                break;
            }
            case 3: {
                model.noDisturb = (self.team.notifyStateForNewMsg == NIMTeamNotifyStateNone ? YES : NO);
                [section2Array addObject:model];
                break;
            }
        }
    }];
    
    [self.teamDataArray addObject:section1Array];
    [self.teamDataArray addObject:section2Array];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.teamDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.teamDataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XLTeamSettingCell *cell = [XLTeamSettingCell new];
    [cell configModelData:self.teamDataArray[indexPath.section][indexPath.row] indexPath:indexPath];
    [cell.switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    if (indexPath.row == [self.teamDataArray[indexPath.section] count] - 1) {
        cell.lineView.hidden = YES;
    } else {
        cell.lineView.hidden = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLTeamSettingModel *model = self.teamDataArray[indexPath.section][indexPath.row];
    if ([model.title isEqualToString:@"群公告"]) {
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass(XLTeamSettingCell.class) cacheByKey:model.title configuration:^(XLTeamSettingCell *cell) {
            [cell configModelData:model indexPath:indexPath];
        }];
    } else {
        return adaptHeight1334(54*2);
    }
}

#pragma mark - Action

- (void)switchAction:(UISwitch *)switchButton {
    
    [StatServiceApi statEvent:SHIELD_TEAM_CLICK model:self.session otherString:switchButton.isOn ? @"on" : @"off"];

    [NIMSDK.sharedSDK.teamManager updateNotifyState:switchButton.isOn inTeam:self.team.teamId completion:^(NSError * _Nullable error) {
        if (error) {
            [MBProgressHUD showError:@"修改失败"];
        }
    }];
}

- (void)logoutTeamAction {
    
    [self showAlertWithTitle:@"退出该群" message:@"\n是否确认退出该群" actionTitles:@[@"取消", @"确认"] actionHandler:^(NSInteger index) {
        if (index == 1) {
            
            [StatServiceApi statEvent:QUIT_TEAM_CLICK model:self.session];
            
            [[NIMSDK sharedSDK].teamManager quitTeam:self.team.teamId completion:^(NSError *error) {
                if (!error) {
                    //删除群组
                    NSArray *array = [NIMSDK.sharedSDK.conversationManager allRecentSessions];
                    for (NIMRecentSession *recentSession in array) {
                        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:recentSession.session.sessionId];
                        if ([self.team.teamId isEqualToString:team.teamId]) {
                            [[NIMSDK sharedSDK].conversationManager deleteRecentSession:recentSession];
                        }
                    }
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    [MBProgressHUD showError:@"退出失败"];
                }
                
            }];
        }
    }];
}

@end
