//
//  TotalAssetViewController.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/20.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "TotalAssetViewController.h"
#import "TotalAssetHeaderView.h"
#import "BottomExchangeView.h"
#import "SegmentControlView.h"
#import "IncomeContentCell.h"
#import "ExchangeViewController.h"
#import "AllRecognizeTableView.h"
#import "AssetApi.h"
#import "IncomeInfoModel.h"
#import "IncomeListModel.h"
#import "XLUserManager.h"
#import "XLH5WebViewController.h"

@interface TotalAssetViewController () <UITableViewDelegate, UITableViewDataSource, TotalAssetProtocol>

@property (strong, nonatomic) AllRecognizeTableView  *tableView;
@property (strong, nonatomic) TotalAssetHeaderView *headerView;
@property (strong, nonatomic) SegmentControlView   *segmentView;
@property (strong, nonatomic) BottomExchangeView   *exchangeView;
@property (strong, nonatomic) IncomeContentCell    *contentCell;

//YES代表能滑动
@property (assign, nonatomic) BOOL canScroll;

@property (strong, nonatomic) IncomeInfoModel *infoModel;
@property (strong, nonatomic) NSArray         *goldListArray;
@property (strong, nonatomic) NSArray         *moneyListArray;

@end

@implementation TotalAssetViewController

@synthesize xlr_InjectedArguments;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isIncome = [[self.xlr_InjectedArguments objectForKey:XLRouterArgumentIncomeKey] boolValue];
    
    self.title = @"我的钱包";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.exchangeView];
    self.tableView.tableHeaderView = self.headerView;
    self.canScroll = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(segmentLeaveTopAction:) name:@"kLeaveTopNotification" object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isIncome) {
            [self.segmentView selectSegmentControlIndex:1 animated:NO];
            [self.contentCell switchChildViewControllerIndex:1 animated:NO];
        } else {
            [self.segmentView selectSegmentControlIndex:0 animated:NO];
            [self.contentCell switchChildViewControllerIndex:0 animated:NO];
        }
    });
    
    [XLLoadingView showLoadingInView:self.view];
    [self requestNetWork];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.headerView updateGoldNumber:XLUserManager.shared.incomeInfoModel.myCoin];
}

//请求网络数据
- (void)requestNetWork
{
    [AssetApi fetchIncomeListSuccess:^(id responseDict) {
        self.infoModel = [IncomeInfoModel yy_modelWithJSON:responseDict[@"incomeInfo"]];
        self.goldListArray = [NSArray yy_modelArrayWithClass:IncomeListModel.class json:responseDict[@"listCoin"]];
        self.moneyListArray = [NSArray yy_modelArrayWithClass:IncomeListModel.class json:responseDict[@"listMoney"]];
        
        XLUserManager.shared.incomeInfoModel = self.infoModel;
        
        //更新金币与昨日收入
        [self.headerView updateGoldNumber:self.infoModel.myCoin];
        [self.headerView updateYesterdayIncome:self.infoModel.yesterdayIncome];
        [self.headerView updateBalance:self.infoModel.balance];
        
        //更新列表
        [self.contentCell updateGoldListView:self.goldListArray];
        [self.contentCell updateMoneyListView:self.moneyListArray];
        
        [XLLoadingView hideLoadingForView:self.view];
        
    } failure:^(NSInteger errorCode) {
        
        [XLLoadingView hideLoadingForView:self.view];
        [XLReloadFailView showReloadFailInView:self.view reloadAction:^{
            [self requestNetWork];
        }];
        
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kLeaveTopNotification" object:nil];
}

- (void)setTableViewScroll:(BOOL)isScroll
{
    self.tableView.scrollEnabled = isScroll;
}

#pragma mark - TableViewDelegateAndDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSegmentControlHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.segmentView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.contentCell) {
        self.contentCell = [tableView dequeueReusableCellWithIdentifier:IncomeContentCellID];
        self.contentCell.delegate = self;
    }
    return self.contentCell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //金币与零钱列表 和 主控制器之间的滑动状态切换
    CGFloat segmentOffsetY = [_tableView rectForSection:0].origin.y - NAVIGATION_BAR_HEIGHT;
    if (scrollView.mj_offsetY >= segmentOffsetY) {
        scrollView.contentOffset = CGPointMake(0, segmentOffsetY);
        if (_canScroll) {
            _canScroll = NO;
            self.contentCell.canScroll = YES;
        }
    } else {
        if (!_canScroll) {
            scrollView.contentOffset = CGPointMake(0, segmentOffsetY);
        }
    }
}

//金币与零钱列表 离开顶部了 主控制器可以滑动
- (void)segmentLeaveTopAction:(NSNotification *)ntf {
    self.canScroll = YES;
    self.contentCell.canScroll = NO;
}

#pragma mark - TotalAssetProtocol
/**
 切换金币/零钱 List

 @param index 0/1 => 金币/零钱
 */
- (void)didSelectSegmentControlIndex:(NSInteger)index
{
    [self.contentCell switchChildViewControllerIndex:index animated:YES];
    [self.segmentView selectSegmentControlIndex:index animated:YES];
}

- (void)scrollAnimationWithOffSet:(CGFloat)offSet
{
    [self.segmentView doScrollAnimationWithOffSet:offSet];
}

/**
 跳转兑换规则
 */
- (void)didClickExchangeRuleButton
{
    XLH5WebViewController *webVC = [XLH5WebViewController new];
    webVC.urlString = @"http://neptune.jipi-nobug.cn/rateExplain.html";
    [self showViewController:webVC sender:nil];
    
}

/**
 跳转提现界面
 */
- (void)didClickExchangeButton
{
    [self showViewController:[ExchangeViewController new] sender:nil];
}

#pragma mark - XLRoutableProtocol

+ (UIViewController<XLRoutableProtocol> *)xlr_Instance {
    return [TotalAssetViewController new];
}

+ (NSString *)xlr_AliasName {
    return NSStringFromClass([TotalAssetViewController class]);
}

+ (NSDictionary<XLRouterArgumentKey *,id> *)xlr_AcceptedArgumentType {
    return @{XLRouterArgumentIncomeKey : @(NO)};
}

+ (NSArray<XLRouterArgumentKey *> *)xlr_RequiredArgumentKeys {
    return @[XLRouterArgumentIncomeKey];
}

#pragma mark - Lazy Loading
- (UITableView *)tableView
{
    if (!_tableView) {
        self.tableView = [[AllRecognizeTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - adaptHeight1334(160)) style:UITableViewStylePlain];
        [self.tableView registerClass:[IncomeContentCell class] forCellReuseIdentifier:IncomeContentCellID];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = kContentCellHeight;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.showsHorizontalScrollIndicator = NO;
    }
    return _tableView;
}

- (TotalAssetHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [TotalAssetHeaderView new];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (BottomExchangeView *)exchangeView
{
    if (!_exchangeView) {
        _exchangeView = [BottomExchangeView new];
        _exchangeView.delegate = self;
    }
    return _exchangeView;
}

- (SegmentControlView *)segmentView
{
    if (!_segmentView) {
        _segmentView = [SegmentControlView new];
        _segmentView.delegate = self;
    }
    return _segmentView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
