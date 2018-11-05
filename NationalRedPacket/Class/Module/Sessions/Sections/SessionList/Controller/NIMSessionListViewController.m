//
//  NIMSessionListViewController.m
//  NIMKit
//
//  Created by NetEase.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "NIMSessionListViewController.h"
#import "NIMSessionViewController.h"
#import "NIMSessionListCell.h"
#import "UIView+NIM.h"
#import "NIMAvatarImageView.h"
#import "NIMKitUtil.h"
#import "NIMKit.h"

#import "XLSessionButtonContentView.h"
#import "XLSessionLikedViewController.h"
#import "XLSessionFansViewController.h"
#import "XLSessionCommentViewController.h"
#import "XLSessionVisitorViewController.h"

#import "SessionListViewModel.h"

#import "XLBadgeRegister.h"
#import "NSObject+XLBadgeHandler.h"
#import "UIView+XLBadge.h"
#import "XLBadgeManager.h"
#import "NSString+XLBadgeCount.h"
#import "NSURL+Creation.h"
#import "XLRouter.h"

@interface NIMSessionListViewController ()<NewsButtonContentViewDelegate, SessionListViewModelDelegate>

@property (strong, nonatomic) SessionListViewModel *viewModel;

/// 会话列表tableView
@property (nonatomic,strong)   UITableView *tableView;

@property (nonatomic,strong) XLSessionButtonContentView *topItemView;

@end

@implementation NIMSessionListViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.viewModel = [SessionListViewModel new];
        self.viewModel.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addNotification];
    [self setUpUI];

    @weakify(self);
    [self setRedDotKey:XLBadgeSessionFansKey refreshBlock:^(NSInteger show) {
        @strongify(self);
        [self.topItemView getTabButton:ContentTypeFans].badgeValue = [NSString badgeCount:show];
    } handler:self];
    [self setRedDotKey:XLBadgeSessionVisitorKey refreshBlock:^(NSInteger show) {
        @strongify(self);
        [self.topItemView getTabButton:ContentTypeVisitor].badgeValue = [NSString badgeCount:show];
    } handler:self];
    [self setRedDotKey:XLBadgeSessionCommentKey refreshBlock:^(NSInteger show) {
        @strongify(self);
        [self.topItemView getTabButton:ContentTypeCommnet].badgeValue = [NSString badgeCount:show];
    } handler:self];
    [self setRedDotKey:XLBadgeSessionLikeKey refreshBlock:^(NSInteger show) {
        @strongify(self);
        [self.topItemView getTabButton:ContentTypeLike].badgeValue = [NSString badgeCount:show];
    } handler:self];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)setUpUI {
    self.view.backgroundColor = [UIColor colorWithString:COLORF2F2F2];
    self.topItemView = [[XLSessionButtonContentView alloc] init];
    self.topItemView.delegate = self;
    [self.view addSubview:self.topItemView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.topItemView.mas_bottom).mas_offset(adaptHeight1334(20));
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

#pragma mark - ViewModel Delegate

- (void)reloadData {
    if (self.viewModel.recentSessions.count == 0) {
        [XLEmptyDataView showEmptyDataInView:self.tableView withTitle:@"暂时没有对话" imageStr:@"my_collection_empty" offSet:adaptHeight1334(-85*2)] ;
    } else {
        [self refresh];
    }
}

#pragma mark - NewsContentViewDelegate

- (void)newsButtonContentViewButtonClicked:(NSInteger)tag {
    switch (tag) {
            case 0:
            /**界面路由跳转 粉丝界面*/
            [[UIApplication sharedApplication] openURL:[NSURL routerURLWithAliasName:NSStringFromClass([XLSessionFansViewController class]) optionsBlock:^(NSMutableDictionary *options) {
               [options setObject:@(XLRouterOptionControllerShowTypeNavigate) forKey:XLRouterOptionControllerShowTypeKey];
            }]];
            [StatServiceApi statEvent:FANS_BUTTON_CLICK];
            break;
            case 1:
            [self showViewController:[XLSessionLikedViewController new] sender:nil];
            [StatServiceApi statEvent:RECEIVE_LIKE_CLICK];
            break;
            case 2:
            [self showViewController:[XLSessionCommentViewController new] sender:nil];
            [StatServiceApi statEvent:RECEIVE_COMMENT_CLICK];
            break;
            case 3:
            /**界面路由跳转 访客界面*/
            [[UIApplication sharedApplication] openURL:[NSURL routerURLWithAliasName:NSStringFromClass([XLSessionVisitorViewController class]) optionsBlock:^(NSMutableDictionary *options) {
                [options setObject:@(XLRouterOptionControllerShowTypeNavigate) forKey:XLRouterOptionControllerShowTypeKey];
            }]];
            [StatServiceApi statEvent:VISITOR_BUTTON_CLICK];
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NIMRecentSession *recentSession = self.viewModel.recentSessions[indexPath.row];
    [self onSelectedRecent:recentSession atIndexPath:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.recentSessions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellId = @"NIMSessionListCell";
    NIMSessionListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NIMSessionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell.avatarImageView addTarget:self action:@selector(onTouchAvatar:) forControlEvents:UIControlEventTouchUpInside];
    }
    NIMRecentSession *recent = self.viewModel.recentSessions[indexPath.row];
    cell.hidden = [self.viewModel onlyShowSessionRedDotForRecentSession:recent];
    cell.nameLabel.text = [self nameForRecentSession:recent];
    [cell.avatarImageView setAvatarBySession:recent.session];
    cell.messageLabel.attributedText  = [self.viewModel contentForRecentSession:recent];
    cell.timeLabel.text = [self.viewModel timestampDescriptionForRecentSession:recent];
   
    [cell.messageLabel sizeToFit];
    [cell.nameLabel sizeToFit];
    [cell.timeLabel sizeToFit];
    
    [cell refresh:recent];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NIMRecentSession *recent = self.viewModel.recentSessions[indexPath.row];
    if ([self.viewModel onlyShowSessionRedDotForRecentSession:recent]) {
        return 0;
    }
    return adaptHeight1334(68 * 2);
}

#pragma mark - Override

- (void)onSelectedAvatar:(NSString *)userId
             atIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)onSelectedRecent:(NIMRecentSession *)recentSession atIndexPath:(NSIndexPath *)indexPath {
    [UIApplication.sharedApplication openURL:[NSURL routerURLWithAliasName:NSStringFromClass([NIMSessionViewController class]) optionsBlock:^(NSMutableDictionary *options) {
        options[XLRouterOptionControllerShowTypeKey] = @(XLRouterOptionControllerShowTypeNavigate);
        options[XLRouterOptionControllerArgumentkey] = @{XLRouterArgumentSessionKey : recentSession.session};
    }]];
    [StatServiceApi statEvent:SESSION_LIST_CLICK model:recentSession.session];
}

- (NSString *)nameForRecentSession:(NIMRecentSession *)recent {
    if (recent.session.sessionType == NIMSessionTypeP2P) {
        return [NIMKitUtil showNick:recent.session.sessionId inSession:recent.session];
    } else {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:recent.session.sessionId];
        return team.teamName;
    }
}

#pragma mark - Event Response

- (void)onTouchAvatar:(id)sender{
    UIView *view = [sender superview];
    while (![view isKindOfClass:[UITableViewCell class]]) {
        view = view.superview;
    }
    UITableViewCell *cell  = (UITableViewCell *)view;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
   
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - Notification

- (void)addNotification {
    extern NSString *const NIMKitTeamInfoHasUpdatedNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTeamInfoHasUpdatedNotification:) name:NIMKitTeamInfoHasUpdatedNotification object:nil];
    
    extern NSString *const NIMKitTeamMembersHasUpdatedNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTeamMembersHasUpdatedNotification:) name:NIMKitTeamMembersHasUpdatedNotification object:nil];
    
    extern NSString *const NIMKitUserInfoHasUpdatedNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserInfoHasUpdatedNotification:) name:NIMKitUserInfoHasUpdatedNotification object:nil];
}

- (void)onUserInfoHasUpdatedNotification:(NSNotification *)notification {
    [self refresh];
}

- (void)onTeamInfoHasUpdatedNotification:(NSNotification *)notification {
    [self refresh];
}

- (void)onTeamMembersHasUpdatedNotification:(NSNotification *)notification {
    [self refresh];
}

#pragma mark - Private

- (void)refresh {
    [self.tableView reloadData];
    [self.viewModel refreshTopViewMessage];
}

#pragma mark - Custom Accessor

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.rowHeight = adaptHeight1334(68 * 2);
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

@end
