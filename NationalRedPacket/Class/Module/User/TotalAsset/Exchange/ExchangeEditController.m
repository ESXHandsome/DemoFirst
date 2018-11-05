//
//  ExchangeEditViewController.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/23.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "ExchangeEditController.h"
#import "ExchangeAlertView.h"
#import "RecordDetailViewController.h"
#import "AssetApi.h"
#import "ExchangeModel.h"
#import "XLUserManager.h"

@interface ExchangeEditController () <ExchangeProtocol>

@property (strong, nonatomic) ExchangeView *exchangeView;

@end

@implementation ExchangeEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.exchangeType == ExchangeTypeAlipay ? @"支付宝提现" : @"话费提现";
    
    self.tableView.tableHeaderView = self.exchangeView;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = self.exchangeView.backgroundColor;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.scrollEnabled = NO;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.exchangeView becomeCanEditState];
}

/**
 确认按钮，弹出信息确认页面
 */
- (void)didClickExchangeSureButton
{
    NSMutableDictionary *dicInfo = [self.exchangeView exchangeRequestDictionary];
    [dicInfo setObject:self.model.money forKey:@"money"];
    @weakify(self);
    [ExchangeAlertView showExchangeSureViewWithType:self.exchangeType sureInfo:dicInfo sureInfoCallBack:^{
        [AssetApi doExchangeWithExchangeDicInfo:dicInfo Success:^(id responseDict) {
            ExchangeModel *model = [ExchangeModel yy_modelWithJSON:responseDict];
            @strongify(self);
            if (model.result.integerValue == 0) {
                RecordDetailViewController *detailVC = [RecordDetailViewController new];
                detailVC.model = model;
                detailVC.isFromExchange = YES;
                [XLUserManager.shared subBalanceIncomeMoney:dicInfo[@"money"]];
                [self showViewController:detailVC sender:nil];
            } else {
                switch (model.result.integerValue) {
                    case 1: [MBProgressHUD showError:@"兑换类型错误"];    break;
                    case 2: [MBProgressHUD showError:@"兑换金额错误"];    break;
                    case 3: [MBProgressHUD showError:@"您还未到达提现额度哦~"];       break;
                    case 4: [MBProgressHUD showError:@"您还有在审核中的提现申请，\n暂时不能再提现"]; break;
                }
            }
        } failure:^(NSInteger errorCode) {
            
        }];
    }];
}

- (ExchangeView *)exchangeView
{
    if (!_exchangeView) {
        self.exchangeView = [[ExchangeView alloc] initWithExchangeType:self.exchangeType delegate:self];
    }
    return _exchangeView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
