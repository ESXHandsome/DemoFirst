//
//  IncomeListController.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/21.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "IncomeListController.h"
#import "IncomeListModel.h"

@implementation IncomeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[IncomeDetailCell class] forCellReuseIdentifier:IncomeDetailCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = kIncomeDetailCellHeight;

}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    if (dataArray.count == 0) {
        self.tableView.mj_footer = nil;
        [XLEmptyDataView showEmptyDataInView:self.tableView withTitle:@"暂无记录\n系统只保留最近3天的收入明细" imageStr:@"nodata_default_icon" offSet:-adaptHeight1334(280) titleOffSet:-adaptHeight1334(50) tapAction:nil];
        _dataArray = nil;
    } else {
        self.tableView.tableHeaderView = nil;
        self.tableView.mj_footer = [self tableViewAutoFooter];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IncomeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:IncomeDetailCellID forIndexPath:indexPath];
    cell.incomeType = self.incomeType;
    IncomeListModel *model = self.dataArray[indexPath.row];
    [cell configModelData:model indexPath:indexPath];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY<0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kLeaveTopNotification" object:@1];
        self.canScroll = NO;
        scrollView.contentOffset = CGPointZero;
    }
}

- (MJRefreshAutoGifFooter *)tableViewAutoFooter {
    MJRefreshAutoGifFooter *autoFooter = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(fetchUpNewData)];
    autoFooter.triggerAutomaticallyRefreshPercent = 0.1;
    [autoFooter setTitle:@"加载更多" forState:MJRefreshStateIdle];
    [autoFooter setTitle:@"正在加载中..." forState:MJRefreshStateRefreshing];
    [autoFooter setTitle:@"系统只保留最近3天的收入明细" forState:MJRefreshStateNoMoreData];
    autoFooter.stateLabel.textColor = [UIColor colorWithString:COLOR999999];
    autoFooter.stateLabel.font = [UIFont systemFontOfSize:adaptFontSize(30)];
    autoFooter.stateLabel.width = SCREEN_WIDTH;
    autoFooter.stateLabel.height = adaptHeight1334(54*2);
    autoFooter.stateLabel.y = adaptHeight1334(30);
    return autoFooter;
}

- (void)fetchUpNewData
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
