//
//  ExchangeViewController.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "ExchangeViewController.h"
#import "BalanceHeaderView.h"
#import "ExchangeTypeCell.h"
#import "RecordViewController.h"
#import "ExchangeEditController.h"
#import "AssetApi.h"
#import "OptionModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "IncomeInfoModel.h"
#import "ExchangeNotesViewController.h"
#import "XLUserManager.h"

@interface ExchangeViewController () <UITableViewDelegate, UITableViewDataSource, ExchangeProtocol>

@property (strong, nonatomic) UITableView       *tableView;
@property (strong, nonatomic) UIButton          *notesButton;
@property (strong, nonatomic) BalanceHeaderView *balanceView;
@property (strong, nonatomic) UIButton          *exchangeRecordButton;
@property (strong, nonatomic) UIView            *redView;
@property (strong, nonatomic) NSArray           *dataArray;

@property (strong, nonatomic) IncomeInfoModel   *infoModel;
@property (assign, nonatomic) BOOL              isExchangeChecking;

@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.notesButton];
    
    self.tableView.tableHeaderView = self.balanceView;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.exchangeRecordButton];
    [XLLoadingView showLoadingInView:self.view];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.balanceView updateBalance:XLUserManager.shared.incomeInfoModel.balance];
    [self requestBalance];
    [self requestExchangeOptionList];
}

- (void)requestExchangeOptionList
{
    [AssetApi fetchExchangeOptionSuccess:^(id responseDict) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if ([responseDict[@"exchangeChange"] integerValue] > [[userDefault objectForKey:@"exchangeChange"] integerValue]) {
            self.redView.hidden = NO;
            [userDefault setObject:responseDict[@"exchangeChange"] forKey:@"exchangeChange"];
            [userDefault synchronize];
        }
        self.isExchangeChecking = [responseDict[@"exchangeStatus"] boolValue];
        self.dataArray = [NSArray yy_modelArrayWithClass:OptionModel.class json:responseDict[@"list"]];
        [self.tableView reloadData];
        [XLLoadingView hideLoadingForView:self.view];

    } failure:^(NSInteger errorCode) {
        [XLLoadingView hideLoadingForView:self.view];
    }];
}

- (void)requestBalance
{
    [AssetApi fetchIncomeBalanceSuccess:^(id responseDict) {
        self.infoModel = [IncomeInfoModel yy_modelWithJSON:responseDict];
        [self.balanceView updateBalance:self.infoModel.balance];
        XLUserManager.shared.incomeInfoModel = self.infoModel;
    } failure:^(NSInteger errorCode) {
        
    }];
}

#pragma mark - NotesAction
- (void)notesButtonAction
{
    [self showViewController:[[ExchangeNotesViewController alloc] initWithStyle:UITableViewStyleGrouped] sender:nil];
}

#pragma mark - RecordAction
- (void)recordAction
{
    self.redView.hidden = YES;
    [self showViewController:[RecordViewController new] sender:nil];
}

#pragma mark - ExchangeTypeCellDelegate
- (void)didSelectExchangeOptionWithModel:(OptionListModel *)model
{
    if (model.money.floatValue > self.infoModel.balance.floatValue) {
        [MBProgressHUD showError:@"您还未到达提现额度哦~"];
        return;
    }
    if (self.isExchangeChecking) {
        [MBProgressHUD showError:@"您还有在审核中的提现申请，\n暂时不能再提现"];
        return;
    }

    ExchangeEditController *editVC = [ExchangeEditController new];
    if ([model.exchangeMode isEqualToString:@"ALIPAY_NATIVE"]) {
        editVC.exchangeType = ExchangeTypeAlipay;
    } else if ([model.exchangeMode isEqualToString:@"TELEPHONE"]) {
        editVC.exchangeType = ExchangeTypeTelephone;
    }
    editVC.model = model;
    [self showViewController:editVC sender:nil];
}

#pragma mark - TableViewDelegateAndDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExchangeTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:ExchangeTypeCellID forIndexPath:indexPath];
    cell.delegate = self;
    [cell configModelData:self.dataArray[indexPath.row] indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:ExchangeTypeCellID configuration:^(id cell) {
        [cell configModelData:self.dataArray[indexPath.row] indexPath:indexPath];
    }];
}

#pragma mark - Lazy Loading
- (UITableView *)tableView
{
    if (!_tableView) {
        self.tableView = [UITableView new];
        self.tableView.frame = self.view.bounds;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [UIView new];
        [self.tableView registerClass:[ExchangeTypeCell class] forCellReuseIdentifier:ExchangeTypeCellID];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIButton *)notesButton
{
    if (!_notesButton) {
        self.notesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.notesButton setTitle:@"注意事项" forState:UIControlStateNormal];
        self.notesButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(28)];
        [self.notesButton setTitleColor:[UIColor colorWithString:COLOR576C96] forState:UIControlStateNormal];
        self.notesButton.frame = CGRectMake(0, SCREEN_HEIGHT - adaptHeight1334(100), adaptWidth750(120), adaptHeight1334(100));
        self.notesButton.centerX = self.view.centerX;
        [self.notesButton addTarget:self action:@selector(notesButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _notesButton;
}

- (BalanceHeaderView *)balanceView
{
    if (!_balanceView) {
        self.balanceView = [BalanceHeaderView new];
    }
    return _balanceView;
}

- (UIButton *)exchangeRecordButton
{
    if (!_exchangeRecordButton) {
        self.exchangeRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.exchangeRecordButton setTitle:@"提现记录" forState:UIControlStateNormal];
        [self.exchangeRecordButton setTitleColor:[UIColor colorWithString:COLOR333333] forState:UIControlStateNormal];
        self.exchangeRecordButton.titleLabel.font = [UIFont systemFontOfSize:16];
        self.exchangeRecordButton.frame = CGRectMake(0, 0, self.exchangeRecordButton.titleLabel.mj_textWith + adaptWidth750(10), 44);
        [self.exchangeRecordButton addTarget:self action:@selector(recordAction) forControlEvents:UIControlEventTouchUpInside];
        UIView *redView = [UIView new];
        redView.backgroundColor = [UIColor colorWithString:COLORFF3E3D];
        redView.layer.cornerRadius = 3.5;
        redView.layer.masksToBounds = YES;
        self.redView = redView;
        [self.exchangeRecordButton.titleLabel addSubview:redView];
        self.redView.hidden = YES;
        self.redView.y = self.exchangeRecordButton.titleLabel.y - 1.5;
        self.redView.x = self.exchangeRecordButton.titleLabel.x + adaptWidth750(115) - 5.5;
        self.redView.width = 7;
        self.redView.height = 7;
    }
    return _exchangeRecordButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
