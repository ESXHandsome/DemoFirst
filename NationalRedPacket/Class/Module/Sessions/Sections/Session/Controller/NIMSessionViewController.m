//
//  NIMSessionViewController.m
//  NIMKit
//
//  Created by NetEase.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "NIMSessionConfigurateProtocol.h"
#import "NIMKit.h"
#import "NIMMessageCellProtocol.h"
#import "NIMMessageModel.h"
#import "NIMKitUtil.h"
#import "NIMCustomLeftBarView.h"
#import "NIMBadgeView.h"
#import "UITableView+NIMScrollToBottom.h"
#import "NIMMessageMaker.h"
#import "UIView+NIM.h"
#import "NIMSessionConfigurator.h"
#import "NIMKitInfoFetchOption.h"
#import "NIMKitTitleView.h"
#import "NIMKitKeyboardInfo.h"
#import "XLSessionRedPacketOpenView.h"
#import "XLSessionViewModel.h"
#import "XLSessionRedPacketDetailModel.h"
#import "XLSessionRedPacketWaitOpenModel.h"
#import "XLRedPacketDetailViewController.h"
#import "XLRedPacketAttachment.h"
#import "TotalAssetViewController.h"
#import "XLIncomeNoticeAttachment.h"
#import "NIMMessageCell.h"
#import "XLPhotoShowView.h"
#import "NIMSessionImageContentView.h"
#import "XLStartConfigManager.h"
#import "XLH5WebViewController.h"
#import "XLGroupInviteAttachment.h"
#import "XLTeamSettingViewController.h"

@interface NIMSessionViewController ()<NIMMediaManagerDelegate,NIMInputDelegate,XLOpenViewDelegate ,PPSPhotoShowViewDelegate>

@property (nonatomic,readwrite) NIMMessage *messageForMenu;

@property (nonatomic,strong)    UILabel *titleLabel;

@property (nonatomic,strong)    UILabel *subTitleLabel;

@property (nonatomic,strong)    NSIndexPath *lastVisibleIndexPathBeforeRotation;

@property (nonatomic,strong)  NIMSessionConfigurator *configurator;

@property (nonatomic,weak)    id<NIMSessionInteractor> interactor;

@property (strong, nonatomic)  XLSessionRedPacketOpenView *redPacketOpenView;
@property (strong, nonatomic)  XLSessionViewModel *viewModel;

@property (strong, nonatomic) NIMCustomLeftBarView *leftBarView;

@property (strong, nonatomic) NIMMessageCell *cell;

@property (assign, nonatomic) BOOL isFirstLogin;

@end

@implementation NIMSessionViewController

- (instancetype)initWithSession:(NIMSession *)session{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _session = session;
    }
    return self;
}

- (void)dealloc
{
    [self removeListener];
    [[NIMKit sharedKit].robotTemplateParser clean];
    
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.session = [self.xlr_InjectedArguments objectForKey:XLRouterArgumentSessionKey];
    
    //导航栏
    [self setupNav];
    //消息 tableView
    [self setupTableView];
    //输入框 inputView
    [self setupInputView];
    //会话相关逻辑配置器安装
    [self setupConfigurator];
    //添加监听
    [self addListener];
    //进入会话时，标记所有消息已读，并发送已读回执
    [self markRead];
    //更新已读位置
    [self uiCheckReceipts:nil];
    
    _viewModel = [XLSessionViewModel new];
    
}

- (void)setupNav
{
    self.title = self.sessionTitle;
    
    NIMCustomLeftBarView *leftBarView = [[NIMCustomLeftBarView alloc] init];
    [self.navigationController.navigationBar addSubview:leftBarView];
    self.leftBarView = leftBarView;
    
}

- (void)setupTableView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithString:COLORF2F2F2];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if ([self.sessionConfig respondsToSelector:@selector(sessionBackgroundImage)] && [self.sessionConfig sessionBackgroundImage]) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imgView.image = [self.sessionConfig sessionBackgroundImage];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        self.tableView.backgroundView = imgView;
    }
    [self.view addSubview:self.tableView];
}


- (void)setupInputView
{
    if ([self shouldShowInputView])
    {
        self.sessionInputView = [[NIMInputView alloc] initWithFrame:CGRectMake(0, 0, self.view.nim_width,0) config:self.sessionConfig];
        self.sessionInputView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.sessionInputView setSession:self.session];
        [self.sessionInputView setInputDelegate:self];
        [self.sessionInputView setInputActionDelegate:self];
        [self.sessionInputView refreshStatus:NIMInputStatusText];
        [self.view addSubview:_sessionInputView];
    }
}


- (void)setupConfigurator
{
    _configurator = [[NIMSessionConfigurator alloc] init];
    [_configurator setup:self];
    
    BOOL needProximityMonitor = [self needProximityMonitor];
    [[NIMSDK sharedSDK].mediaManager setNeedProximityMonitor:needProximityMonitor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.interactor onViewWillAppear];
    [self addListener];
    
    [StatServiceApi statEventBegin:SESSION_DETAIL_LONG model:self.session];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.sessionInputView endEditing:YES];
    
    [StatServiceApi statEventEnd:SESSION_DETAIL_LONG model:self.session];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.interactor onViewDidDisappear];
    [self removeListener];
}


- (void)viewDidLayoutSubviews
{
    [self changeLeftBarBadge:self.conversationManager.allUnreadCount];
//    [self.interactor resetLayout];
}



#pragma mark - 消息收发接口
- (void)sendMessage:(NIMMessage *)message
{
    [self.interactor sendMessage:message];
}


#pragma mark - Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [_sessionInputView endEditing:YES];
}


#pragma mark - NIMSessionConfiguratorDelegate

- (void)didFetchMessageData
{
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"firstEnter"];
    [self uiCheckReceipts:nil];
    [self.tableView reloadData];
    [self.tableView nim_scrollToBottom:NO];
}

- (void)didRefreshMessageData
{
    [self refreshSessionTitle:self.sessionTitle];
    [self refreshSessionSubTitle:self.sessionSubTitle];
    [self.tableView reloadData];
}

- (void)didPullUpMessageData {}

#pragma mark - 会话title
- (NSString *)sessionTitle
{
    NSString *title = @"";
    NIMSessionType type = self.session.sessionType;
    switch (type) {
        case NIMSessionTypeTeam:{
            NIMTeam *team = [[[NIMSDK sharedSDK] teamManager] teamById:self.session.sessionId];
            title = [NSString stringWithFormat:@"%@(%zd)",[team teamName],[team memberNumber]];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(teamSettingAction)];
        }
            break;
        case NIMSessionTypeP2P:{
            title = [NIMKitUtil showNick:self.session.sessionId inSession:self.session];
        }
            break;
        default:
            break;
    }
    return title;
}

- (NSString *)sessionSubTitle{return @"";};

#pragma mark - NIMChatManagerDelegate

- (void)willSendMessage:(NIMMessage *)message
{
    id<NIMSessionInteractor> interactor = self.interactor;
    
    if ([message.session isEqual:self.session]) {
        if ([interactor findMessageModel:message]) {
            [interactor updateMessage:message];
        }else{
            [interactor addMessages:@[message]];
        }
    }
}

//发送结果
- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(NSError *)error
{
    if ([message.session isEqual:_session])
    {
        [self.interactor updateMessage:message];
        if (message.session.sessionType == NIMSessionTypeTeam)
        {
            //如果是群的话需要检查一下回执显示情况
            NIMMessageReceipt *receipt = [[NIMMessageReceipt alloc] initWithMessage:message];
            [self.interactor checkReceipts:@[receipt]];
        }
    }    
}

//发送进度
-(void)sendMessage:(NIMMessage *)message progress:(float)progress
{
    if ([message.session isEqual:_session]) {
        [self.interactor updateMessage:message];
    }
}

//接收消息
- (void)onRecvMessages:(NSArray *)messages
{
    if ([self shouldAddListenerForNewMsg])
    {
        NIMMessage *message = messages.firstObject;
        NIMSession *session = message.session;
        if (![session isEqual:self.session] || !messages.count)
        {
            return;
        }
        
        [self uiAddMessages:messages];
        [self.interactor markRead];
    }
    
    
}


- (void)fetchMessageAttachment:(NIMMessage *)message progress:(float)progress
{
    if ([message.session isEqual:_session])
    {
        [self.interactor updateMessage:message];
    }
}

- (void)fetchMessageAttachment:(NIMMessage *)message didCompleteWithError:(NSError *)error
{
    if ([message.session isEqual:_session])
    {
        NIMMessageModel *model = [self.interactor findMessageModel:message];
        //下完缩略图之后，因为比例有变化，重新刷下宽高。
        [model cleanCache];
        [self.interactor updateMessage:message];
    }
}

- (void)onRecvMessageReceipts:(NSArray<NIMMessageReceipt *> *)receipts
{
    if ([self shouldAddListenerForNewMsg])
    {
        NSMutableArray *handledReceipts = [[NSMutableArray alloc] init];
        for (NIMMessageReceipt *receipt in receipts) {
            if ([receipt.session isEqual:self.session])
            {
                [handledReceipts addObject:receipt];
            }
        }
        if (handledReceipts.count)
        {
            [self uiCheckReceipts:handledReceipts];
        }
    }
}

#pragma mark - NIMConversationManagerDelegate
- (void)messagesDeletedInSession:(NIMSession *)session{
    [self.interactor resetMessages:nil];
    [self.tableView reloadData];
}

- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount{
    [self changeUnreadCount:recentSession totalUnreadCount:totalUnreadCount];
}

- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount{
    [self changeUnreadCount:recentSession totalUnreadCount:totalUnreadCount];
}

- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount{
    [self changeUnreadCount:recentSession totalUnreadCount:totalUnreadCount];
}


- (void)changeUnreadCount:(NIMRecentSession *)recentSession
         totalUnreadCount:(NSInteger)totalUnreadCount{
    if ([recentSession.session isEqual:self.session]) {
        return;
    }
    [self changeLeftBarBadge:totalUnreadCount];
}

#pragma mark - NIMMediaManagerDelegate
- (void)recordAudio:(NSString *)filePath didBeganWithError:(NSError *)error {
    if (!filePath || error) {
        _sessionInputView.recording = NO;
        [self onRecordFailed:error];
    }
}

- (void)recordAudio:(NSString *)filePath didCompletedWithError:(NSError *)error {
    if(!error) {
        if ([self recordFileCanBeSend:filePath]) {
            [self sendMessage:[NIMMessageMaker msgWithAudio:filePath]];
        }else{
            [self showRecordFileNotSendReason];
        }
    } else {
        [self onRecordFailed:error];
    }
    _sessionInputView.recording = NO;
}

- (void)recordAudioDidCancelled {
    _sessionInputView.recording = NO;
}

- (void)recordAudioProgress:(NSTimeInterval)currentTime {
    [_sessionInputView updateAudioRecordTime:currentTime];
}

- (void)recordAudioInterruptionBegin {
    [[NIMSDK sharedSDK].mediaManager cancelRecord];
}

#pragma mark - 录音相关接口

- (void)onRecordFailed:(NSError *)error {}

- (BOOL)recordFileCanBeSend:(NSString *)filepath
{
    return YES;
}

- (void)showRecordFileNotSendReason{}

#pragma mark - NIMInputDelegate

- (void)didChangeInputHeight:(CGFloat)inputHeight
{
    [self.interactor changeLayout:inputHeight];
}

#pragma mark - NIMInputActionDelegate
- (BOOL)onTapMediaItem:(NIMMediaItem *)item{
    SEL sel = item.selctor;
    BOOL handled = sel && [self respondsToSelector:sel];
    if (handled) {
        NIMKit_SuppressPerformSelectorLeakWarning([self performSelector:sel withObject:item]);
        handled = YES;
    }
    return handled;
}

- (void)onTextChanged:(id)sender{}

- (void)onSendText:(NSString *)text atUsers:(NSArray *)atUsers
{
    NSMutableArray *users = [NSMutableArray arrayWithArray:atUsers];
    if (self.session.sessionType == NIMSessionTypeP2P)
    {
        [users addObject:self.session.sessionId];
    }
    NSString *robotsToSend = [self robotsToSend:users];

    NIMMessage *message = nil;
    if (robotsToSend.length)
    {
        message = [NIMMessageMaker msgWithRobotQuery:text toRobot:robotsToSend];
    }
    else
    {
        message = [NIMMessageMaker msgWithText:text];
    }
    
    if (atUsers.count)
    {
        NIMMessageApnsMemberOption *apnsOption = [[NIMMessageApnsMemberOption alloc] init];
        apnsOption.userIds = atUsers;
        apnsOption.forcePush = YES;
        
        NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
        option.session = self.session;
        
        NSString *me = [[NIMKit sharedKit].provider infoByUser:[NIMSDK sharedSDK].loginManager.currentAccount option:option].showName;
        apnsOption.apnsContent = [NSString stringWithFormat:@"%@在群里@了你",me];
        message.apnsMemberOption = apnsOption;
    }
    [self sendMessage:message];
}

- (NSString *)robotsToSend:(NSArray *)atUsers
{
    for (NSString *userId in atUsers)
    {
        if ([[NIMSDK sharedSDK].robotManager isValidRobot:userId])
        {
            return userId;
        }
    }
    return nil;
}


- (void)onSelectChartlet:(NSString *)chartletId
                 catalog:(NSString *)catalogId{}

- (void)onCancelRecording
{
    [[NIMSDK sharedSDK].mediaManager cancelRecord];
}

- (void)onStopRecording
{
    [[NIMSDK sharedSDK].mediaManager stopRecord];
}

- (void)onStartRecording
{
    _sessionInputView.recording = YES;
    
    NIMAudioType type = [self recordAudioType];
    NSTimeInterval duration = [NIMKit sharedKit].config.recordMaxDuration;
    
    [[NIMSDK sharedSDK].mediaManager addDelegate:self];
    
    [[NIMSDK sharedSDK].mediaManager record:type
                                     duration:duration];
}

#pragma mark - NIMMessageCellDelegate
- (BOOL)onTapCell:(NIMMessageCell *)cell event:(NIMKitEvent *)event{
    BOOL handle = NO;
    NSString *eventName = event.eventName;
    if ([eventName isEqualToString:NIMKitEventNameTapAudio])
    {
        [self.interactor mediaAudioPressed:event.messageModel];
        handle = YES;
    }
    if ([eventName isEqualToString:NIMKitEventNameTapRobotBlock]) {
        NSDictionary *param = event.data;
        NIMMessage *message = [NIMMessageMaker msgWithRobotSelect:param[@"text"] target:param[@"target"] params:param[@"param"] toRobot:param[@"robotId"]];
        [self sendMessage:message];
        handle = YES;
    }
    if ([eventName isEqualToString:NIMKitEventNameTapRobotContinueSession]) {
        NIMRobotObject *robotObject = (NIMRobotObject *)event.messageModel.message.messageObject;
        NIMRobot *robot = [[NIMSDK sharedSDK].robotManager robotInfo:robotObject.robotId];
        NSString *text = [NSString stringWithFormat:@"%@%@%@",NIMInputAtStartChar,robot.nickname,NIMInputAtEndChar];
        
        NIMInputAtItem *item = [[NIMInputAtItem alloc] init];
        item.uid  = robot.userId;
        item.name = robot.nickname;
        [self.sessionInputView.atCache addAtItem:item];
        
        [self.sessionInputView.toolBar insertText:text];
        
        handle = YES;
    }
    if ([eventName isEqualToString:NIMKitEventNameTapContent]) {
        
        self.cell = cell;
        ImageModel *model = [ImageModel new];
        NIMImageObject * imageObject = event.messageModel.message.messageObject;
        model.isOnLocal = YES;
        model.preview = imageObject.thumbPath;
        model.imagePath = imageObject.path;
        model.originalImage = imageObject.url;
        model.height = [NSString stringWithFormat:@"%f",imageObject.size.height];
        model.width = [NSString stringWithFormat:@"%f",imageObject.size.width];
        NSArray<ImageModel *> *array  = [NSArray arrayWithObjects:model, nil];
        XLPhotoShowView *photoShowView = [[XLPhotoShowView alloc] initWithGroupItems:array];
        photoShowView.delegate = self;
        photoShowView.isHaveAlertView = NO;
        NIMSessionImageContentView *content = (NIMSessionImageContentView *)self.cell.bubbleView;
        [photoShowView presentFromImageView:content.imageView toContainer:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
        handle = YES;
    }
    if ([eventName isEqualToString:NIMKitEventNameTapRedPacket]) {
        
        [self onTapRedPacketWithMessage:event.messageModel.message];
        
        handle = YES;
    }
    if ([eventName isEqualToString:NIMKitEventNameTapRedPacketTip]) {
        
        [self detailButtonDidClickWithMessage:event.messageModel.message];
        
        XLRedPacketAttachment *attachment = (XLRedPacketAttachment *)[(NIMCustomObject *)event.messageModel.message.messageObject attachment];
        [StatServiceApi statEvent:LUCKYMONEY_DETAIL model:self.session otherString:[NSString stringWithFormat:@"%@,%@", attachment.luckyid, @"tip"]];
        
        handle = YES;
    }
    if ([eventName isEqualToString:NIMKitEventNameTapGroupInvite]) {
        
        [self didTeamJump:event];
        
        [StatServiceApi statEvent:GROUP_LINK_CLICK model:self.session];
        
        handle = YES;
    }
    if ([eventName isEqualToString:NIMKitEventNameTapIncomeNotice]) {
        
        XLIncomeNoticeAttachment *attachment = [(NIMCustomObject *)event.messageModel.message.messageObject attachment];
        BOOL result = ![attachment.moneyType isEqualToString:@"coin"];
        
        [UIApplication.sharedApplication openURL:[NSURL routerURLWithAliasName:NSStringFromClass([TotalAssetViewController class]) optionsBlock:^(NSMutableDictionary *options) {
            options[XLRouterOptionControllerShowTypeKey] = @(XLRouterOptionControllerShowTypeNavigate);
            options[XLRouterOptionControllerArgumentkey] = @{XLRouterArgumentIncomeKey : @(result)};
        }]];
        
        [StatServiceApi statEvent:MY_WALLET_CLICK model:nil otherString:attachment.moneyType];

        handle = YES;
    }
    
    if ([eventName isEqualToString:NIMKitEventNameTapActivityLink]) {
        
        XLH5WebViewController *webVC = [XLH5WebViewController new];
        webVC.urlString = ((XLActivityLinkModel *)event.data).url;
        [self showViewController:webVC sender:nil];
        XLBaseCustomAttachment *attachment = (XLBaseCustomAttachment *)[(NIMCustomObject *)event.messageModel.message.messageObject attachment];
        [StatServiceApi statEvent:MSG_CLICK model:nil otherString:[NSString stringWithFormat:@"%ld,%@", attachment.customMessageType, attachment.attachmentId]];
        
        handle = YES;
    }
    
    if ([eventName isEqualToString:NIMKitEventNameTapLabelLink]) {
        XLH5WebViewController *webVC = [XLH5WebViewController new];
        webVC.urlString = event.data;
        [self showViewController:webVC sender:nil];
    }
    
    return handle;
}

- (void)onRetryMessage:(NIMMessage *)message
{
    if (message.isReceivedMsg) {
        [[[NIMSDK sharedSDK] chatManager] fetchMessageAttachment:message
                                                           error:nil];
    }else{
        [[[NIMSDK sharedSDK] chatManager] resendMessage:message
                                                  error:nil];
    }
}

- (BOOL)onLongPressCell:(NIMMessage *)message
                 inView:(UIView *)view
{
    BOOL handle = NO;
    NSArray *items = [self menusItems:message];
    if ([items count] && [self becomeFirstResponder]) {
        UIMenuController *controller = [UIMenuController sharedMenuController];
        controller.menuItems = items;
        _messageForMenu = message;
        [controller setTargetRect:view.bounds inView:view];
        [controller setMenuVisible:YES animated:YES];
        handle = YES;
    }
    return handle;
}

- (BOOL)disableAudioPlayedStatusIcon:(NIMMessage *)message
{
    BOOL disable = NO;
    if ([self.sessionConfig respondsToSelector:@selector(disableAudioPlayedStatusIcon)])
    {
        disable = [self.sessionConfig disableAudioPlayedStatusIcon];
    }
    return disable;
}

- (void)didTeamJump:(NIMKitEvent *)event {
    [MBProgressHUD hideHUD];
    [MBProgressHUD showChrysanthemum:@"加载中..."];
    
    XLGroupInviteAttachment *attachment = [(NIMCustomObject *)event.messageModel.message.messageObject attachment];
    
    [self.viewModel fetchJumpTeamIDWithType:attachment.type Success:^(id responseDict) {
        
        [self.navigationController popViewControllerAnimated:YES];
        if (responseDict[@"tid"]) {
            NIMSession *session = [NIMSession session:responseDict[@"tid"] type:NIMSessionTypeTeam];
            [UIApplication.sharedApplication openURL:[NSURL routerURLWithAliasName:NSStringFromClass([NIMSessionViewController class]) optionsBlock:^(NSMutableDictionary *options) {
                options[XLRouterOptionControllerShowTypeKey] = @(XLRouterOptionControllerShowTypeNavigate);
                options[XLRouterOptionControllerArgumentkey] = @{XLRouterArgumentSessionKey : session};
            }]];
        }
        [MBProgressHUD hideHUD];

    } failure:^(NSInteger errorCode) {
        [MBProgressHUD hideHUD];

    }];
}

- (void)teamSettingAction {
    
    XLTeamSettingViewController *teamSettingVC = [[XLTeamSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    teamSettingVC.team = [[[NIMSDK sharedSDK] teamManager] teamById:self.session.sessionId];
    teamSettingVC.session = self.session;
    [self showViewController:teamSettingVC sender:nil];
}

#pragma mark -
#pragma mark - photo show delegate
- (UIView *)dismissAction:(NSInteger)currentPage {
    NIMSessionImageContentView *content = (NIMSessionImageContentView *)self.cell.bubbleView;
    return content.imageView;
}
- (void)dismissAtCurrentPage:(NSInteger)currentPage {
    
}

#pragma mark -  Cell Delegate

/**
 点击红包
 */
- (void)onTapRedPacketWithMessage:(NIMMessage *)message {
    XLRedPacketAttachment *attachment = (XLRedPacketAttachment *)[(NIMCustomObject *)message.messageObject attachment];

    if (attachment.status == RedPacketStatusOpened) {
        [self detailButtonDidClickWithMessage:message];
        [StatServiceApi statEvent:LUCKYMONEY_CLICK model:self.session otherString:[NSString stringWithFormat:@"%@,%ld", attachment.luckyid, (long)attachment.status]];
        [StatServiceApi statEvent:LUCKYMONEY_DETAIL model:self.session otherString:[NSString stringWithFormat:@"%@,%@", attachment.luckyid, @"luckymoney"]];

    } else {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showChrysanthemum:@"加载中..."];
        
        [self.viewModel fetchRedPacketStateWithMessage:message success:^(XLSessionRedPacketWaitOpenModel *waitOpenModel) {
            [MBProgressHUD hideHUD];
            
            [StatServiceApi statEvent:LUCKYMONEY_CLICK model:self.session otherString:[NSString stringWithFormat:@"%@,,%ld", attachment.luckyid, (long)waitOpenModel.status]];
            
            [self.redPacketOpenView showRedPacketOpenViewWithMessage:message openViewInfo:waitOpenModel];
            
            [self updateRedPacketMessage:message status:waitOpenModel.status];
            
        } failure:^(NSInteger errorCode) {
            [MBProgressHUD showError:@"红包打开失败"];
            [self.redPacketOpenView stopOpenButtonAnimation];
        }];
    }
}

#pragma mark - RedPacketOpenView Delegate

/**
 “開”按钮点击事件
 */
- (void)openButtonDidClickWithMessage:(NIMMessage *)message openViewInfo:(XLSessionRedPacketWaitOpenModel *)waitOpenModel {

    [StatServiceApi statEvent:LUCKYMONEY_OPEN model:self.session otherString:[(XLRedPacketAttachment *)[(NIMCustomObject *)message.messageObject attachment] luckyid]];
    
    if (!XLLoginManager.shared.isAccountLogined) {
        [self.redPacketOpenView removeFromSuperview];

        [LoginViewController showLoginVCFromSource:LoginSourceTypeRedPacketClick].loginSuccess = ^(BOOL success) {
            if (success) {
                self.isFirstLogin = YES;
                [NSThread sleepForTimeInterval:0.5]; //睡眠 0.5s等待真消息发过来
                //修改真正的红包id及session会话id
                [(XLRedPacketAttachment *)[(NIMCustomObject *)message.messageObject attachment] setLuckyid:XLLoginManager.shared.luckyId];
                NSString *accId = XLStartConfigManager.shared.startConfigModel.vImAccid ?: @"m_1";
                message.from = accId;
                NIMSession *session = [NIMSession session:accId type:NIMSessionTypeP2P];
                [message setValue:session forKey:@"_session"];
                [self openButtonDidClickWithMessage:message openViewInfo:waitOpenModel];
            }
        };
        return;
    }

    [self.viewModel grabRedPacketWithMessage:message success:^(NSDictionary *responseDict) {
       
        XLSessionRedPacketDetailModel *detailModel = [XLSessionRedPacketDetailModel yy_modelWithJSON:responseDict];
        
        //抢新手红包时，特殊处理，已领过也需要跳到详情页，这里通过新手红包id判断
        if (detailModel.status == XLRedPacketStateNormal ||
            [[(XLRedPacketAttachment *)[(NIMCustomObject *)message.messageObject attachment] luckyid] isEqualToString:XLLoginManager.shared.luckyId]) {
            [self.redPacketOpenView removeFromSuperview];

            if (detailModel.status == RedPacketStatusNormal) {
                [self sendRedPacketTipMessage:message];
            }
            [self updateRedPacketMessage:message status:RedPacketStatusOpened];
            [self pushRedPacketDetailViewController:detailModel message:message shouldPacketDetailAnimation:YES];
        } else {
            XLSessionRedPacketWaitOpenModel *waitModel = [XLSessionRedPacketWaitOpenModel yy_modelWithJSON:responseDict];
            [self.redPacketOpenView updateRedPacketOpenViewWithMessage:message openViewInfo:waitModel];
            [self updateRedPacketMessage:message status:waitModel.status];
        }
        
    } failure:^(NSInteger errorCode) {
        
        [MBProgressHUD showError:@"红包打开失败"];
        [self.redPacketOpenView stopOpenButtonAnimation];

    }];
}

/**
 查看红包详情
 */
- (void)detailButtonDidClickWithMessage:(NIMMessage *)message {
    [self.redPacketOpenView removeFromSuperview];

    if (!XLLoginManager.shared.isAccountLogined) {
        [LoginViewController showLoginVCFromSource:LoginSourceTypeRedPacketClick].loginSuccess = ^(BOOL success) {
            if (success) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        };
        return;
    }
    
    [MBProgressHUD hideHUD];
    [MBProgressHUD showChrysanthemum:@"加载中..."];
    
    [self.viewModel fetchRedPacketDetailWithMessage:message success:^(XLSessionRedPacketDetailModel *detailModel) {
       
        [MBProgressHUD hideHUD];

        [self pushRedPacketDetailViewController:detailModel message:message shouldPacketDetailAnimation:NO];

    } failure:^(NSInteger errorCode) {
        [MBProgressHUD hideHUD];
    }];
}

- (void)pushRedPacketDetailViewController:(XLSessionRedPacketDetailModel *)detailModel
                                  message:(NIMMessage *)message
              shouldPacketDetailAnimation:(BOOL)animated {

    [UIApplication.sharedApplication openURL:[NSURL routerURLWithAliasName:NSStringFromClass([XLRedPacketDetailViewController class]) optionsBlock:^(NSMutableDictionary *options) {
        options[XLRouterOptionControllerShowTypeKey] = @(XLRouterOptionControllerShowTypeNavigate);
        options[XLRouterOptionControllerArgumentkey] = @{XLRouterArgumentRedPacketDetailModelKey : detailModel,
                                                         XLRouterArgumentRedPacketDetailMessageKey : message,
                                                         XLRouterArgumentRedPacketDetailAnimationKey : @(animated)
                                                         };
    }]];
    
    if (self.isFirstLogin) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableArray *array = self.navigationController.viewControllers.mutableCopy;
            for (UIViewController *vc in array) {
                if ([vc isKindOfClass:[self class] ]) {
                    [array removeObject:vc];
                    [self.navigationController setViewControllers:array animated:NO];
                    break;
                }
            }
        });
    }
}

- (void)updateRedPacketMessage:(NIMMessage *)message status:(XLRedPacketStatus)status {
    
    //更新界面显示
    XLRedPacketAttachment *attachment = [(NIMCustomObject *)message.messageObject attachment];
    if (attachment.status == status) {
        return;
    }
    attachment.status = status;
    [self.interactor updateMessage:message];
    //更新本地数据库
    [self.conversationManager updateMessage:message forSession:self.session completion:nil];
    
}

- (void)sendRedPacketTipMessage:(NIMMessage *)message {
    
    XLRedPacketAttachment *redAttachment = [(NIMCustomObject *)message.messageObject attachment];
    if (redAttachment.status == RedPacketStatusOpened) {
        return;
    }
    
    XLRedPacketTipAttachment *attachment = [XLRedPacketTipAttachment new];
    attachment.senderId = message.from;
    attachment.openerId = NIMSDK.sharedSDK.loginManager.currentAccount;
    attachment.luckyid = redAttachment.luckyid;
    attachment.customMessageType = CustomMessageTypeRedPacketTip;
    NIMMessage *sendMessage = [NIMMessageMaker msgWithRedPacketTip:attachment];
    
    //目前的需求不需要把红包提示消息发送给对方，所以只保存在本地数据库
    //[self sendMessage:sendMessage];
    [self.conversationManager saveMessage:sendMessage forSession:message.session completion:^(NSError * _Nullable error) {
        XLLog(@"插入红包提示消息：%@", error);
        if ([attachment.luckyid isEqualToString:XLLoginManager.shared.luckyId]) {
            XLLoginManager.shared.newUserRedPacketStatus = 3;
        }
    }];

}

#pragma mark - 配置项
- (id<NIMSessionConfig>)sessionConfig
{
    return nil; //使用默认配置
}

#pragma mark - 配置项列表
//是否需要监听新消息通知 : 某些场景不需要监听新消息，如浏览服务器消息历史界面
- (BOOL)shouldAddListenerForNewMsg
{
    BOOL should = YES;
    if ([self.sessionConfig respondsToSelector:@selector(disableReceiveNewMessages)]) {
        should = ![self.sessionConfig disableReceiveNewMessages];
    }
    return should;
}



//是否需要显示输入框 : 某些场景不需要显示输入框，如使用 3D touch 的场景预览会话界面内容
- (BOOL)shouldShowInputView
{
    BOOL should = YES;
    if ([self.sessionConfig respondsToSelector:@selector(disableInputView)]) {
        should = ![self.sessionConfig disableInputView];
    }
    return should;
}


//当前录音格式 : NIMSDK 支持 aac 和 amr 两种格式
- (NIMAudioType)recordAudioType
{
    NIMAudioType type = NIMAudioTypeAAC;
    if ([self.sessionConfig respondsToSelector:@selector(recordType)]) {
        type = [self.sessionConfig recordType];
    }
    return type;
}

//是否需要监听感应器事件
- (BOOL)needProximityMonitor
{
    BOOL needProximityMonitor = YES;
    if ([self.sessionConfig respondsToSelector:@selector(disableProximityMonitor)]) {
        needProximityMonitor = !self.sessionConfig.disableProximityMonitor;
    }
    return needProximityMonitor;
}


#pragma mark - 菜单
- (NSArray *)menusItems:(NIMMessage *)message
{
    NSMutableArray *items = [NSMutableArray array];
    
    BOOL copyText = NO;
    if (message.messageType == NIMMessageTypeText)
    {
        copyText = YES;
    }
    if (message.messageType == NIMMessageTypeRobot)
    {
        NIMRobotObject *robotObject = (NIMRobotObject *)message.messageObject;
        copyText = !robotObject.isFromRobot;
    }
    if (copyText) {
        [items addObject:[[UIMenuItem alloc] initWithTitle:@"复制"
                                                    action:@selector(copyText:)]];
    }
    [items addObject:[[UIMenuItem alloc] initWithTitle:@"删除"
                                                action:@selector(deleteMsg:)]];
    return items;
    
}

- (NIMMessage *)messageForMenu
{
    return _messageForMenu;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    NSArray *items = [[UIMenuController sharedMenuController] menuItems];
    for (UIMenuItem *item in items) {
        if (action == [item action]){
            return YES;
        }
    }
    return NO;
}


- (void)copyText:(id)sender
{
    NIMMessage *message = [self messageForMenu];
    if (message.text.length) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:message.text];
    }
}

- (void)deleteMsg:(id)sender
{
    NIMMessage *message    = [self messageForMenu];
    [self uiDeleteMessage:message];
    [self.conversationManager deleteMessage:message];
}

- (void)menuDidHide:(NSNotification *)notification
{
    [UIMenuController sharedMenuController].menuItems = nil;
}


#pragma mark - 操作接口
- (void)uiAddMessages:(NSArray *)messages
{
    [self.interactor addMessages:messages];
}

- (void)uiInsertMessages:(NSArray *)messages
{
    [self.interactor insertMessages:messages];
}

- (NIMMessageModel *)uiDeleteMessage:(NIMMessage *)message{
    NIMMessageModel *model = [self.interactor deleteMessage:message];
    if (model.shouldShowReadLabel && model.message.session.sessionType == NIMSessionTypeP2P)
    {
        [self uiCheckReceipts:nil];
    }
    return model;
}

- (void)uiUpdateMessage:(NIMMessage *)message{
    [self.interactor updateMessage:message];
}

- (void)uiCheckReceipts:(NSArray<NIMMessageReceipt *> *)receipts
{
    [self.interactor checkReceipts:receipts];
}

#pragma mark - NIMMeidaButton
- (void)onTapMediaItemPicture:(NIMMediaItem *)item
{
    [self.interactor mediaPicturePressed];
}

- (void)onTapMediaItemShoot:(NIMMediaItem *)item
{
    [self.interactor mediaShootPressed];
}

- (void)onTapMediaItemLocation:(NIMMediaItem *)item
{
    [self.interactor mediaLocationPressed];
}

#pragma mark - 旋转处理 (iOS8 or above)
- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    self.lastVisibleIndexPathBeforeRotation = [self.tableView indexPathsForVisibleRows].lastObject;
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    if (self.view.window) {
        __weak typeof(self) wself = self;
        [coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context)
         {
             [[NIMSDK sharedSDK].mediaManager cancelRecord];
             [wself.interactor cleanCache];
             [wself.sessionInputView reset];
             [wself.tableView reloadData];
             [wself.tableView scrollToRowAtIndexPath:wself.lastVisibleIndexPathBeforeRotation atScrollPosition:UITableViewScrollPositionBottom animated:NO];
         } completion:nil];
    }
}


#pragma mark - 标记已读
- (void)markRead
{
    [self.interactor markRead];
}


#pragma mark - Private

- (void)addListener
{
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
}

- (void)removeListener
{
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
}

- (void)changeLeftBarBadge:(NSInteger)unreadCount
{
    NSArray *array = [NIMSDK.sharedSDK.conversationManager allRecentSessions];
    for (NIMRecentSession *recentSession in array) {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:recentSession.session.sessionId];
        if (team.notifyStateForNewMsg == NIMTeamNotifyStateNone) {
            unreadCount -= recentSession.unreadCount; //总数需减去免打扰群消息的未读数量
        }
    }
    self.leftBarView.badgeView.badgeValue = @(unreadCount).stringValue;
    self.leftBarView.badgeView.hidden = !unreadCount;
}


- (id<NIMConversationManager>)conversationManager{
    switch (self.session.sessionType) {
        case NIMSessionTypeChatroom:
            return nil;
            break;
        case NIMSessionTypeP2P:
        case NIMSessionTypeTeam:
        default:
            return [NIMSDK sharedSDK].conversationManager;
    }
}


- (void)setUpTitleView
{
    NIMKitTitleView *titleView = (NIMKitTitleView *)self.navigationItem.titleView;
    if (!titleView || ![titleView isKindOfClass:[NIMKitTitleView class]])
    {
        titleView = [[NIMKitTitleView alloc] initWithFrame:CGRectZero];
        self.navigationItem.titleView = titleView;
        
        titleView.titleLabel.text = self.sessionTitle;
        titleView.subtitleLabel.text = self.sessionSubTitle;
        
        self.titleLabel    = titleView.titleLabel;
        self.subTitleLabel = titleView.subtitleLabel;
    }

    [titleView sizeToFit];
}

- (void)refreshSessionTitle:(NSString *)title
{
    self.titleLabel.text = title;
    [self setUpTitleView];
}


- (void)refreshSessionSubTitle:(NSString *)title
{
    self.subTitleLabel.text = title;
    [self setUpTitleView];
}

#pragma mark - XLRoutableProtocol

+ (UIViewController<XLRoutableProtocol> *)xlr_Instance {
    return [NIMSessionViewController new];
}

+ (NSString *)xlr_AliasName {
    return NSStringFromClass([NIMSessionViewController class]);
}

+ (NSDictionary<XLRouterArgumentKey *,id> *)xlr_AcceptedArgumentType {
    return @{XLRouterArgumentSessionKey : [NIMSession new]};
}

+ (NSArray<XLRouterArgumentKey *> *)xlr_RequiredArgumentKeys {
    return @[XLRouterArgumentSessionKey];
}

#pragma mark - Custom Accessor

- (XLSessionRedPacketOpenView *)redPacketOpenView {
    if (!_redPacketOpenView) {
        _redPacketOpenView = [XLSessionRedPacketOpenView new];
        _redPacketOpenView.delegate = self;
    }
    return _redPacketOpenView;
}

@synthesize xlr_InjectedArguments;

@end

