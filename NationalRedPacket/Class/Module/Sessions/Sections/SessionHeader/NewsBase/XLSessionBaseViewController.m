//
//  NewsBaseViewController.m
//  NationalRedPacket
//
//  Created by Ying on 2018/5/28.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLSessionBaseViewController.h"
#import "XLEmptyDataView.h"
#import "FeedsHeaderView.h"
#import "XLSessionBaseTableViewCell.h"

@interface XLSessionBaseViewController () <UITableViewDelegate, UITableViewDataSource, XLSessionBaseViewModelDelegate>

@end

@implementation XLSessionBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - private method
- (void)setUpUI {
    [self.view addSubview:self.tableView];
}

#pragma mark - XLSessionBaseViewModel delegate
- (void)refreshFinish {
    /*刷新结束*/
    [self.tableView.mj_header endRefreshing];
}

- (void)loadFinish {
    /*加载结束*/
    [self.tableView reloadData];
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return adaptHeight1334(78*2);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"111");
}

#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLSessionBaseTableViewCell *cell = [tableView xl_dequeueReusableCellWithClass:XLSessionBaseTableViewCell.class forIndexPath:indexPath];
    [cell cellSetImage:[UIImage imageNamed:@"my_slick"] authorName:@"路肯不代表本不懂不懂定发" tailString:@"关注了你" buttonTitle:@""];
    return cell;
}

#pragma mark - lazy load
- (void)setIsEmpty:(BOOL)isEmpty {
    if (isEmpty) {
        /*数据为空,展示空数据视图*/
        [XLEmptyDataView showEmptyDataInView:self.view withTitle:@"暂无数据" imageStr:@"my_collection_empty" offSet:NAVIGATION_BAR_HEIGHT];
        self.view.backgroundColor = [UIColor colorWithString:COLORF2F2F2];
        self.tableView.hidden = YES;
    } else {
        /*数据不为空,视图给丫删了*/
        if ([XLEmptyDataView emptyDataForView:self.view]) {
            [XLEmptyDataView hideEmptyDataInView:self.view];
        }
        self.tableView.hidden = NO;
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, self.view.width, self.view.height - NAVIGATION_BAR_HEIGHT);
        _tableView.backgroundColor = [UIColor colorWithString:COLORF2F2F2];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.mj_header = [self tableViewGifHeader];
        [_tableView xl_registerClass:[XLSessionBaseTableViewCell class]];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (XLRefreshAutoGifFooter *)tableViewAutoFooter {
    
    XLRefreshAutoGifFooter *autoFooter = [XLRefreshAutoGifFooter footerWithRefreshingTarget:self.viewModel refreshingAction:@selector(loadMore)];
    
    autoFooter.backgroundColor = [UIColor colorWithString:COLORF2F2F2];
    
    autoFooter.ignoredScrollViewContentInsetBottom = -5;
    autoFooter.triggerAutomaticallyRefreshPercent = 0.1;
    
    return autoFooter;
}

- (FeedsHeaderView *)tableViewGifHeader {
    
    FeedsHeaderView *gifHeader = [FeedsHeaderView headerWithRefreshingTarget:self.viewModel refreshingAction:@selector(refresh)];
    
    gifHeader.backgroundColor = [UIColor colorWithString:COLORF2F2F2];
    gifHeader.frame = CGRectMake(0, 0, SCREEN_WIDTH, adaptHeight1334(56 * 2));
    
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    
    NSMutableArray *headerRefreshImages = [NSMutableArray array];
    for (int i = 1; i < 5; i++) {
        [headerRefreshImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"header_Loading_%d", i]]];
    }
    
    [gifHeader setImages:headerRefreshImages forState:MJRefreshStateRefreshing];
    [gifHeader setImages:headerRefreshImages forState:MJRefreshStateIdle];
    [gifHeader setTitle:@"加载中" forState:MJRefreshStateRefreshing];
    [gifHeader setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [gifHeader setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    
    return gifHeader;
}

- (XLSessionBaseViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[XLSessionBaseViewModel alloc] init];
        _viewModel.baseDelegate = self;
    }
    return _viewModel;
}
@end
