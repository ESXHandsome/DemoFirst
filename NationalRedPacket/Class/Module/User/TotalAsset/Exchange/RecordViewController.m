//
//  ExchangeRecordViewController.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/23.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "RecordViewController.h"
#import "ExchangeRecordCell.h"
#import "RecordDetailViewController.h"
#import "ExchangeModel.h"
#import "AssetApi.h"
#import "XLLoadingView.h"
#import "XLEmptyDataView.h"

@interface RecordViewController ()

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提现记录";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ExchangeRecordCell class] forCellReuseIdentifier:ExchangeRecordCellID];
    self.tableView.rowHeight = kRecordCellHeight;
    self.tableView.y = 0;
    [self requestExchangeRecord];
}

- (void)requestExchangeRecord
{
    [XLLoadingView showLoadingInView:self.tableView];
    [XLLoadingView loadingForView:self.tableView].y = 0;
    
    [AssetApi fetchExchangeListSuccess:^(id responseDict) {
        self.dataArray = [NSArray yy_modelArrayWithClass:ExchangeModel.class json:responseDict[@"list"]];
        [self.tableView reloadData];
        [XLLoadingView hideLoadingForView:self.tableView];
        if (self.dataArray.count == 0) {
            [XLEmptyDataView showEmptyDataInView:self.tableView withTitle:@"暂无提现记录" imageStr:@"nodata_default_icon"];
        }
    } failure:^(NSInteger errorCode) {
        [XLLoadingView hideLoadingForView:self.tableView];
        [XLEmptyDataView hideEmptyDataInView:self.tableView];
        [XLReloadFailView showReloadFailInView:self.tableView reloadAction:^{
            [self requestExchangeRecord];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExchangeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ExchangeRecordCellID forIndexPath:indexPath];
    [cell configModelData:self.dataArray[indexPath.row] indexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RecordDetailViewController *detailVC = [RecordDetailViewController new];
    detailVC.model = self.dataArray[indexPath.row];
    [self showViewController:detailVC sender:nil];
}

@end
