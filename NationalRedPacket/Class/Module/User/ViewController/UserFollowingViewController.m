//
//  FollowingViewController.m
//  NationalRedPacket
//
//  Created by 王海玉 on 2018/1/25.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "UserFollowingViewController.h"
#import "PublisherViewController.h"
#import "FollowingCell.h"
#import "XLPublisherModel.h"
#import "UserApi.h"
#import "XLPublisherDataSource.h"

@interface UserFollowingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *headerLabel;
@property (strong, nonatomic) XLPublisherDataSource *dataSource;
@property (strong, nonatomic) XLPublisherModel *upDataModel;
@property (strong, nonatomic) NSMutableArray *freshImages;

@end

@implementation UserFollowingViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    if (XLPublisherDataSource.followingAuthorIds.count == 0) {
//        self.tableView.hidden = YES;
//        [XLEmptyDataView showEmptyDataInView:self.view withTitle:@"你还没有关注任何人" imageStr:@"my_attention_empty" offSet:NAVIGATION_BAR_HEIGHT];
//    } else {
//        self.headerLabel.text = [NSString stringWithFormat:@"你关注了%lu人", XLPublisherDataSource.followingAuthorIds.count];
//        [XLEmptyDataView hideEmptyDataInView:self.view];
//        [self.tableView reloadData];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的关注";
    
    self.view.backgroundColor = [UIColor colorWithString:COLORF2F2F2];
    
    [self.view addSubview:self.tableView];

    [XLLoadingView showLoadingInView:self.view];
    self.tableView.hidden = YES;
    
    self.dataSource = [[XLPublisherDataSource alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.upDataModel = nil;
    [self.tableView.mj_footer beginRefreshing];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return adaptHeight1334(130);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.elements.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FollowingCell *cell = [tableView dequeueReusableCellWithIdentifier:FollowingCellID forIndexPath:indexPath];
    cell.model = self.dataSource.elements[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [StatServiceApi statEvent:PERSONPAGE_CLICK model:self.dataSource.elements[indexPath.row]];
    PublisherViewController *personalHomePage = [PublisherViewController new];
    personalHomePage.model = self.dataSource.elements[indexPath.row];
    [self.navigationController pushViewController:personalHomePage animated:YES];
}

#pragma mark -
#pragma mark Fetch Data

/**
 * 上拉加载数据请求
 */
- (void)fetchUpNewData {
    
    [UserApi fetchFollowListAuthorId:self.upDataModel.authorId Success:^(id responseDict) {
        [XLLoadingView hideLoadingForView:self.view];
        NSMutableArray *array = [NSArray yy_modelArrayWithClass:XLPublisherModel.class json:responseDict[@"person"]].mutableCopy;
        //删除黑名单用户
        [XLUserManager.shared deletePublisherInBalcklist:array];
        if (self.upDataModel.authorId) {
            [self.dataSource addElementsFromArray:array];
        } else {
            [self.dataSource setElementsFromArray:array];
        }
        
        if (array.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            self.upDataModel = array[array.count - 1];
            [self.tableView.mj_footer endRefreshing];
        }
        
        if (self.dataSource.elements.count > 0) {
            self.tableView.hidden = NO;
        }
        
        if (self.dataSource.elements.count > 0) {
            self.headerLabel.text = [NSString stringWithFormat:@"你关注了%d人",[responseDict[@"attentionCount"] intValue]];
            [XLEmptyDataView hideEmptyDataInView:self.view];
        } else {
            self.tableView.hidden = YES;
            [XLEmptyDataView showEmptyDataInView:self.view withTitle:@"你还没有关注任何人" imageStr:@"my_attention_empty" offSet:NAVIGATION_BAR_HEIGHT];
        }
        [self.tableView reloadData];
    } failure:^(NSInteger errorCode) {
        [self.tableView.mj_footer endRefreshing];
        [XLLoadingView hideLoadingForView:self.view];
        
        if (self.dataSource.elements.count == 0) {
            self.tableView.hidden = YES;
            [self showLoadFailed];
        }
    }];
}

- (void)showLoadFailed {
    [XLReloadFailView showReloadFailInView:self.view offSet:NAVIGATION_BAR_HEIGHT reloadAction:^{
        [self.tableView.mj_footer beginRefreshing];
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerClass:[FollowingCell class] forCellReuseIdentifier:FollowingCellID];
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, adaptHeight1334(68))];
        UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(adaptWidth750(36), adaptHeight1334(66), SCREEN_WIDTH - adaptWidth750(36), 0.5)];
        bottomLabel.backgroundColor = [UIColor colorWithString:COLOREAEAEA];
        [header addSubview:bottomLabel];
        [header addSubview:self.headerLabel];
        self.tableView.tableHeaderView = header;
        _tableView.mj_footer = [self tableViewAutoFooter];
    }
    return _tableView;
}

- (XLRefreshAutoGifFooter *)tableViewAutoFooter {
    XLRefreshAutoGifFooter *autoFooter = [XLRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(fetchUpNewData)];
    [autoFooter setImages:self.freshImages.mutableCopy forState:MJRefreshStateRefreshing];
    autoFooter.triggerAutomaticallyRefreshPercent = 0.1;
    [autoFooter setTitle:@"加载更多" forState:MJRefreshStateIdle];
    [autoFooter setTitle:@"正在加载中..." forState:MJRefreshStateRefreshing];
    [autoFooter setTitle:@"没有更多啦～" forState:MJRefreshStateNoMoreData];
    return autoFooter;
}

- (UILabel *)headerLabel {
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(adaptWidth750(36), adaptHeight1334(13), SCREEN_WIDTH, adaptHeight1334(40))];
        _headerLabel.text = @"你关注了0人";
        _headerLabel.font = [UIFont boldSystemFontOfSize:adaptFontSize(28)];
        _headerLabel.textColor = [UIColor colorWithString:COLORB6B6B6];
    }
    return _headerLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
