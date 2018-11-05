//
//  NewsBaseViewController.m
//  NationalRedPacket
//
//  Created by Ying on 2018/5/28.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLSessionBaseViewController.h"
#import "XLEmptyDataView.h"
#import "XLTableGifHeaderView.h"
#import "XLSessionBaseTableViewCell.h"
#import "PublisherViewController.h"
#import "XLPublisherModel.h"
#import "XLSessionNoPublisherViewController.h"
#import "XLCommentTableViewCell.h"


@interface XLSessionBaseViewController () <UITableViewDelegate, UITableViewDataSource, XLSessionBaseViewModelDelegate, XLRoutableProtocol>

@end

@implementation XLSessionBaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureViewModel];
    [self setUpUI];
    /**适配tableView*/
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self beginToRefresh];
    
    self.sessionListViewModel = [SessionListViewModel new];
}


- (void)configureViewModel {
    self.viewModel = [[XLSessionBaseViewModel alloc] init];
    self.viewModel.type = self.type;
}

- (void)beginToRefresh {
    self.viewModel.baseDelegate = self;
    [self.viewModel refresh];
    [XLLoadingView showLoadingInView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - private method
- (void)setUpUI {
    [self.view addSubview:self.tableView];
}

#pragma mark - XLSessionBaseViewModel delegate

-(void)removeLoadView {
    [XLLoadingView hideLoadingForView:self.view];
}

- (void)refreshFinish {
    /*刷新结束*/
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}

- (void)loadFinish {
    /*加载结束*/
    [self.tableView reloadData];
}

- (void)emptyDate {
    self.isEmpty = YES;
}

- (void)findAuthor:(NSString *)authorId {
    PublisherViewController *viewController = [[PublisherViewController alloc] init];
    viewController.publisherId = authorId;
    [self.navigationController pushViewController:viewController animated:YES];
    XLPublisherModel *model = [XLPublisherModel new];
    model.authorId = authorId;
    [StatServiceApi statEvent:PERSONPAGE_CLICK model:model];
}

- (void)defindAuthor {
    XLSessionNoPublisherViewController *controller = [XLSessionNoPublisherViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return adaptHeight1334(78*2);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XLSessionMessageModel *model = (XLSessionMessageModel *)self.viewModel.sessionMessageArray[indexPath.row];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewModel isHadAuthor:model.uid];
}

#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.sessionMessageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLSessionBaseTableViewCell *cell = [tableView xl_dequeueReusableCellWithClass:XLSessionBaseTableViewCell.class forIndexPath:indexPath];
    return cell;
}

#pragma mark - lazy load
- (void)setIsEmpty:(BOOL)isEmpty {
    if (isEmpty) {
        /*数据为空,展示空数据视图*/
        [XLEmptyDataView showEmptyDataInView:self.view withTitle:@"暂无内容" imageStr:@"my_collection_empty" offSet:0];
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
        [_tableView xl_registerClass:[XLCommentTableViewCell class]];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
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

- (XLTableGifHeaderView *)tableViewGifHeader {
    XLTableGifHeaderView *gifHeader = [XLTableGifHeaderView tableGifHeaderWithRefreshingTarget:self.viewModel refreshingAction:@selector(refresh)];
    return gifHeader;
}

#pragma mark -
#pragma mark - router delegate

+ (NSString * _Nonnull)xlr_AliasName {
    return NSStringFromClass(self.class);
}

+ (__kindof UIViewController<XLRoutableProtocol> * _Nonnull)xlr_Instance {
    return [XLSessionBaseViewController new];
}

+ (NSArray<XLRouterArgumentKey *> *_Nullable)xlr_RequiredArgumentKeys {
    return nil;
}

+ (NSDictionary<XLRouterArgumentKey *, id> *_Nullable)xlr_AcceptedArgumentType {
    return nil;
}
@synthesize xlr_InjectedArguments;

@end
