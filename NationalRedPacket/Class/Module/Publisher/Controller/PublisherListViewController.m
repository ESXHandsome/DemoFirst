//
//  PublisherListViewController.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "PublisherListViewController.h"
#import "PublisherInfoCell.h"
#import "ChoicenessInfoHeaderView.h"
#import "NewsApi.h"
#import "PublisherTopicsViewController.h"
#import "PublisherViewController.h"
#import "XLH5WebViewController.h"

@interface PublisherListViewController () <CycleBannerViewDelegate,PublisherCellDelegate,PublisherViewModelDelegate>

@end

@implementation PublisherListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PublisherInfoCell class]) bundle:nil] forCellReuseIdentifier:@"PublisherInfoCellID"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = adaptHeight1334(76*2);
    
    self.viewModel.delegate = self;
    
    [XLLoadingView showLoadingInView:self.view offSet:-NAVIGATION_BAR_HEIGHT];
    [self requestPageContent];
    
    self.tableView.mj_footer = [XLRefreshAutoGifFooter footerWithRefreshingBlock:^{
        [self requestPageContent];
    }];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.viewModel.isChoiceness) {
        [((ChoicenessInfoHeaderView *)self.tableView.tableHeaderView) setBannerTimerStart:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.viewModel.isChoiceness) {
        [((ChoicenessInfoHeaderView *)self.tableView.tableHeaderView) setBannerTimerStart:NO];
    }
}

- (void)requestPageContent
{
    [self.viewModel fetchCategoryContentSuccess:^(NSArray *listArray) {
        
        [XLLoadingView hideLoadingForView:self.view];
        [self updateSubViewsWithListArray:listArray];
        
    } failure:^(NSInteger pageNumber) {
        [self.tableView.mj_footer endRefreshing];
        [XLLoadingView hideLoadingForView:self.view];
        if (pageNumber == 0) {  //当page=0时，拉取失败显示失败页
            [XLReloadFailView showReloadFailInView:self.view reloadAction:^{
                [XLLoadingView showLoadingInView:self.view offSet:-NAVIGATION_BAR_HEIGHT];
                [self requestPageContent];
            }];
        }
    }];
}

- (void)updateSubViewsWithListArray:(NSArray *)listArray
{
    if (listArray.count == 0 || self.viewModel.publisherListDataSource.elements.count < 10) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
    
    if (self.viewModel.isFirstFetch) {
        if (self.viewModel.isChoiceness) {
            ChoicenessInfoHeaderView *choicenessView = [ChoicenessInfoHeaderView new];
            [choicenessView configDelegate:self];
            choicenessView.bannerDataArray = self.viewModel.bannerArray;
            choicenessView.publisherCardArray = self.viewModel.publisherCardDataSource.elements.mutableCopy;
            self.tableView.tableHeaderView = choicenessView;
        } else {
            self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, adaptHeight1334(10))];
        }
    }
    
    if (self.viewModel.publisherListDataSource.elements.count == 0 && self.viewModel.isChoiceness == NO) {
        [XLEmptyDataView showEmptyDataInView:self.view withTitle:@"你已经都关注了\n快去关注页面看看吧～" imageStr:@"personal_nodynamic" offSet:-NAVIGATION_BAR_HEIGHT];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.tableView reloadData];
}

#pragma mark - PublisherViewModelDelegate

- (void)dataSource:(XLDataSource *)dataSource reloadCardForIndex:(NSInteger)index {
    ChoicenessInfoHeaderView *headerView = (ChoicenessInfoHeaderView *)self.tableView.tableHeaderView;
    
    if (headerView) {
        [headerView.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    }
}

- (void)dataSource:(XLDataSource *)dataSource reloadListForIndex:(NSInteger)index {
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - CycleBannerViewDelegate

- (void)didSelectBannerView:(CycleBannerView *)bannerView bannerModel:(BannerModel *)model
{
    [StatServiceApi statEvent:DISCOVERY_BANNER_CLICK model:nil otherString:model.title];
    BannerType bannerType = [self.viewModel getBannerTypeWithModel:model];
    switch (bannerType) {
        case BannerTypeH5: {
            XLH5WebViewController *webVC = [XLH5WebViewController new];
            webVC.urlString = model.h5Url;
            [self showViewController:webVC sender:nil];
            break;
        }
        case BannerTypePublisherListRecommend: {
            PublisherTopicsViewController *topicsVC = [PublisherTopicsViewController new];
            topicsVC.model = model;
            [self showViewController:topicsVC sender:nil];
            break;
        }
        case BannerTypePublisherOwnRecommend: {
            [self enterPublisherViewControllerWithPublisherCell:nil model:model.authorInfo];
            break;
        }
    }
    XLLog(@"%@", model.type);
}

- (void)enterPublisherViewControllerWithPublisherCell:(PublisherCardCell *)publisherCell model:(XLPublisherModel *)model
{
    XLLog(@"进入<%@>的个人主页", model.nickname);
    PublisherViewController *publisherVC = [PublisherViewController new];
    publisherVC.model = model;
    [StatServiceApi statEvent:PERSONPAGE_CLICK model:model];
    if (publisherCell) {
        [publisherVC setPersonalHomepageControllerWillDisplayBlock:^{
            [publisherCell updateFollowInfo];
        }];
    }
    [self.navigationController pushViewController:publisherVC animated:YES];
}

#pragma mark - PublisherCellDelegate

- (void)didSelectPublisherCell:(PublisherCardCell *)publisherCell publisherModel:(XLPublisherModel *)model
{
    [self enterPublisherViewControllerWithPublisherCell:publisherCell model:model];
}

- (void)didSelectPublisherCellFollowButton:(PublisherCardCell *)publisherCell publisherModel:(XLPublisherModel *)model
{
    [self.viewModel followPublisherWithModel:model success:^(BOOL isToFollow) {
        if (isToFollow) {
            if ([publisherCell isKindOfClass:[PublisherCardCell class]]) {
                [StatServiceApi statEvent:FOLLOW_CLICK model:model otherString:@"card"];
            } else if ([publisherCell isKindOfClass:[PublisherInfoCell class]]) {
                [StatServiceApi statEvent:FOLLOW_CLICK model:model otherString:self.viewModel.categoryTitle];
            }
            [MBProgressHUD showSuccess:@"关注成功"];
        } else {
            [MBProgressHUD showSuccess:@"取消关注"];
        }
        [publisherCell updateFollowInfo];
    } failure:^(NSInteger errorCode) {
        [MBProgressHUD showSuccess:@"关注失败"];
        [publisherCell updateFollowInfo];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.publisherListDataSource.elements.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PublisherInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PublisherInfoCellID" forIndexPath:indexPath];
    cell.delegate = self;
    [cell configModelData:self.viewModel.publisherListDataSource.elements[indexPath.row] indexPath:indexPath];
    if (self.viewModel.publisherListDataSource.elements.count - 6 == indexPath.row && !self.viewModel.isAllPublisherList) {
        [self.tableView.mj_footer beginRefreshing];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self didSelectPublisherCell:(PublisherCardCell *)[tableView cellForRowAtIndexPath:indexPath] publisherModel:self.viewModel.publisherListDataSource.elements[indexPath.row]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
