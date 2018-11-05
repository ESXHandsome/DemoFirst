//
//  XLRedPacketDetailViewController.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLRedPacketDetailViewController.h"
#import "DetailHeaderView.h"
#import "UIImage+Tool.h"
#import "PacketDetailCell.h"
#import "TotalAssetViewController.h"
#import "XLSessionViewModel.h"
#import "NSDate+Timestamp.h"

@interface XLRedPacketDetailViewController ()<UITableViewDataSource, UITableViewDelegate, DetailHeaderDelegate, XLRoutableProtocol>

@property (strong, nonatomic) DetailHeaderView *detailHeaderView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView  *packetCountTipContainerView;
@property (strong, nonatomic) UILabel *packetCountTipLabel;

@property (strong, nonatomic) XLSessionRedPacketDetailModel *detailModel;
@property (strong, nonatomic) NIMMessage *message;
@property (assign, nonatomic) BOOL shouldAnimation;

@end

@implementation XLRedPacketDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailModel = [self.xlr_InjectedArguments objectForKey:XLRouterArgumentRedPacketDetailModelKey];
    self.message = [self.xlr_InjectedArguments objectForKey:XLRouterArgumentRedPacketDetailMessageKey];
    self.shouldAnimation = [[self.xlr_InjectedArguments objectForKey:XLRouterArgumentRedPacketDetailAnimationKey] boolValue];

    [self configUI];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, adaptWidth750(28), 22)];
    [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -adaptWidth750(10), 0, adaptWidth750(10))];
    [backButton setImage:[UIImage imageNamed:@"redpacket_back_icon"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(didClickBackeButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:nil
                                                                 action:nil];
    self.navigationItem.backBarButtonItem = barButton;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:17.5];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithString:COLORFDD6A8];
    titleLabel.text =[NSString stringWithFormat:@"%@的红包",self.detailModel.name];
    self.navigationItem.titleView = titleLabel;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIImage *img = [UIImage createImageWithColor:[UIColor colorWithString:COLORD85940] size:CGSizeMake(1, 1)];
    [self.navigationController.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

#pragma mark - Event Response

- (void)didClickBackeButtonEvent {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private Method

- (void)configUI {
    self.view.backgroundColor = [UIColor colorWithString:COLORF6F6F6];
    [self.view addSubview:self.tableView];
    
    if (self.detailModel.detail.count == self.detailModel.total_num) {
        self.packetCountTipLabel.text = [NSString stringWithFormat:@"%ld个红包，%@被抢光",(long)self.detailModel.total_num,[NSDate timeStringWithSecond:self.detailModel.time]];
    } else {
        self.packetCountTipLabel.text = [NSString stringWithFormat:@"已领取%ld/%ld个",(long)self.detailModel.fetch_num,(long)self.detailModel.total_num];
    }
    
    [self configDetailHeaderView];
    
    if (self.shouldAnimation) {
        [self.view addSubview:self.detailHeaderView];
        [self startViewAnimation];
    } else {
        self.tableView.tableHeaderView = self.detailHeaderView;
        self.tableView.y = 0;
    }
}

- (void)configDetailHeaderView {
    NSInteger detailHeaderHeight = 0;
    DetailHeaderType headerType;
    
    // detail==0时，为私信红包
    if (self.message.session.sessionType == NIMSessionTypeTeam) {
        // 已领取的群红包
        if (self.detailModel.money.length > 0) {
            headerType = DetailHeaderTypeTeamDetailReceived;
            detailHeaderHeight = 292 -64;
        } else {
            headerType = DetailHeaderTypeTeamDetailUnReceived;
            detailHeaderHeight = 228 -64;
        }
    } else {
        // 已领取的私信红包
        BOOL showDetail = [[NSUserDefaults.standardUserDefaults objectForKey:XLUserDefaultsFollowRedPacketShowDetail] boolValue];
        
        if (self.detailModel.status == XLRedPacketStateReceived && !showDetail) {
            headerType = DetailHeaderTypeFocusDetailOpened;
            detailHeaderHeight = 312 - 64;
        } else {
            headerType = DetailHeaderTypeFocusDetailFirstOpen;
            detailHeaderHeight = 325 - 64;
            
            [NSUserDefaults.standardUserDefaults setBool:YES forKey:XLUserDefaultsFollowRedPacketShowDetail];
            [NSUserDefaults.standardUserDefaults synchronize];
        }
    }
    self.detailHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, adaptHeight1334(detailHeaderHeight * 2));
    [self.detailHeaderView configUIWithHeaderType:headerType detailModel:self.detailModel];
}

// 进入页面的动画
- (void)startViewAnimation {
    self.detailHeaderView.packetTopBgImageView.transform = CGAffineTransformMakeScale(5.0, 5.0);

    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        self.detailHeaderView.packetTopBgImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);

    } completion:^(BOOL finished) {

    }];

    [UIView animateWithDuration:0.6 animations:^{
        self.detailHeaderView.height = self.detailHeaderView.frame.size.height;
        self.tableView.y = + self.detailHeaderView.frame.size.height;
    }completion:^(BOOL finished) {
        [self.detailHeaderView removeFromSuperview];
        self.tableView.tableHeaderView = self.detailHeaderView;
        self.tableView.y = 0;
    }];
}

#pragma mark - DetailHeaderView Delegate

- (void)detailHeaderViewDidClickWalletJump {
    [UIApplication.sharedApplication openURL:[NSURL routerURLWithAliasName:NSStringFromClass([TotalAssetViewController class]) optionsBlock:^(NSMutableDictionary *options) {
        options[XLRouterOptionControllerShowTypeKey] = @(XLRouterOptionControllerShowTypeNavigate);
        options[XLRouterOptionControllerArgumentkey] = @{XLRouterArgumentIncomeKey : @(NO)};
    }]];
    [StatServiceApi statEvent:MY_WALLET_CLICK model:nil otherString:@"coin"];
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.detailModel.detail.count > 0) {
        return adaptHeight1334(78);
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.detailModel.detail.count > 0) {
        return self.packetCountTipContainerView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return adaptHeight1334(68*2);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.detailModel.detail.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PacketDetailCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"PacketDetailCell"];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"PacketDetailCell" owner:nil options:nil];
        cell = [nibs objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    };
    XLRedPacketDetailUserModel *userDetailModel = [self.detailModel.detail objectAtIndex:indexPath.row];
    [cell configModelData:userDetailModel indexPath:indexPath];

    if ([userDetailModel.uid isEqualToString:self.detailModel.lucky_uid]) {
        [cell configBestOfLuckShow];
    }
    
    return cell;
}

#pragma mark - XLRoutableProtocol

+ (UIViewController<XLRoutableProtocol> *)xlr_Instance {
    return [XLRedPacketDetailViewController new];
}

+ (NSString *)xlr_AliasName {
    return NSStringFromClass([XLRedPacketDetailViewController class]);
}

+ (NSDictionary<XLRouterArgumentKey *,id> *)xlr_AcceptedArgumentType {
    return @{XLRouterArgumentRedPacketDetailModelKey : [XLSessionRedPacketDetailModel new],
             XLRouterArgumentRedPacketDetailMessageKey : [NIMMessage new],
             XLRouterArgumentRedPacketDetailAnimationKey : @(NO)
             };
}

+ (NSArray<XLRouterArgumentKey *> *)xlr_RequiredArgumentKeys {
    return @[XLRouterArgumentRedPacketDetailModelKey, XLRouterArgumentRedPacketDetailMessageKey, XLRouterArgumentRedPacketDetailAnimationKey];
}

#pragma mark - Custom Accessor

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -NAVIGATION_BAR_HEIGHT + SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorColor = [UIColor colorWithString:COLORE6E6E6];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        backView.backgroundColor = [UIColor colorWithString:COLORD85940];
        [_tableView addSubview:backView];
    }
    return _tableView;
}

- (UIView *)packetCountTipContainerView {
    if (!_packetCountTipContainerView) {
        _packetCountTipContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, adaptHeight1334(38*2))];
        _packetCountTipContainerView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *bottomLine = [UIImageView new];
        bottomLine.backgroundColor = [UIColor colorWithString:COLORE6E6E6];
        [_packetCountTipContainerView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self->_packetCountTipContainerView);
            make.height.mas_equalTo(adaptHeight1334(1));
        }];
        
        [_packetCountTipContainerView addSubview:self.packetCountTipLabel];
        [self.packetCountTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(adaptWidth750(26));
            make.top.equalTo(self->_packetCountTipContainerView.mas_top).mas_offset(adaptHeight1334(4));
            make.bottom.equalTo(self->_packetCountTipContainerView.mas_bottom).mas_offset(-adaptHeight1334(4));
        }];
    }
    return _packetCountTipContainerView;
}

- (UILabel *)packetCountTipLabel {
    if (!_packetCountTipLabel) {
        _packetCountTipLabel = [UILabel new];
        _packetCountTipLabel.font = [UIFont systemFontOfSize:adaptFontSize(28)];
        _packetCountTipLabel.textColor = [UIColor colorWithString:COLOR999999];
    }
    return _packetCountTipLabel;
}

- (DetailHeaderView *)detailHeaderView {
    if (!_detailHeaderView) {
        _detailHeaderView = [DetailHeaderView new];
        _detailHeaderView.delegate = self;
    }
    return _detailHeaderView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@synthesize xlr_InjectedArguments;

@end
