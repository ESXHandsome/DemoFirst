//
//  NewsListViewController.m
//  NationalRedPacket
//
//  Created by sunmingyue on 17/11/14.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "BaseFeedListViewController.h"
#import "FeedImageDetailViewController.h"
#import "FeedVideoDetailViewController.h"
#import "FeedAdCell.h"
#import "FeedVideoHorizonalCell.h"
#import "FeedVideoVerticalCell.h"
#import "FeedsHeaderView.h"
#import "GifPlayManager.h"
#import "PublisherViewController.h"
#import "ShareAlertView.h"
#import "ShowDataView.h"
#import "UITableView+VideoPlay.h"
#import <KVOController/KVOController.h>
#import "XLPlayerManager.h"
#import "XLH5WebViewController.h"
#import "XLFeedNativeExpressCell.h"
#import "XLShareAlertViewController.h"
#import "XLFloatRefreshView.h"
#import "XLReportSheetAlertViewController.h"
#import "XLTableGifHeaderView.h"
#import "XLFeedMyPostRejectCell.h"
#import "UserProtocolURL.h"

@interface BaseFeedListViewController () <UITableViewDelegate, UITableViewDataSource, FeedCellDelegate, ShareAlertViewDelegate, BaseFeedListViewModelDelegate ,XLShareAlertControllerShareDelegate, FeedDetailViewControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) CGFloat tableViewLastOffsetY;
@property (assign, nonatomic) BOOL isEnterImageDetail;
@property (assign, nonatomic) BOOL isViewWillAppear;
@property (assign, nonatomic) BOOL isViewWillDisappear;
@property (strong, nonatomic) XLFeedModel *shareFeedModel;
@property (assign, nonatomic) BOOL isReturnFromDetailVideo;

@property (strong, nonatomic) FBKVOController *KVOController;
@property (strong, nonatomic) XLFloatRefreshView *floatRefreshView;
@property (strong, nonatomic) NSIndexPath *didClickIndex;

@end

@implementation BaseFeedListViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureViewModel];
    [self configureUI];
    
    self.viewModel.baseDelegate = self;

    [self autoRefreshForFirstTime];
    
    [self observeOfFeedMuteState];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didNetworkChangedNotification) name:XLNetworkChangedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isViewWillAppear = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [GifPlayManager sharedManager].currentTableView = self.tableView;
    [[GifPlayManager sharedManager] statImagesCell];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![UIView isDisplayedInScreenForView:self.view]) {
        return;
    }
    if (self.isViewWillDisappear) {
        self.isViewWillDisappear = NO;
        if (self.isReturnFromDetailVideo) {
            self.isReturnFromDetailVideo = NO;
        } else {
            [self autoPlayVideoWithVisibleCheck:NO];
        }
    }
    
    if ([StatServiceApi.sharedService.viewControllerDictionary.allKeys containsObject:NSStringFromClass([self class])]) {
        [StatServiceApi sharedService].currentVCStr = NSStringFromClass([self class]);
    }
    
    [GifPlayManager sharedManager].currentTableView = self.tableView;
    
    if (!self.isEnterImageDetail) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([GifPlayManager sharedManager].playingGifCell == nil) {
                [[GifPlayManager sharedManager] playGifCell];
            }
        });
    } else {
        self.isEnterImageDetail = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isViewWillAppear = NO;
    self.isViewWillDisappear = YES;
    
    if ([UIView isDisplayedInScreenForView:self.view]) {
        [[GifPlayManager sharedManager] statEndImageCell];
        [self.tableView statVideoPreview];
    }
    [self.tableView pause];
    if (!animated) {
        return;
    }
    [[GifPlayManager sharedManager] pauseGifCell];
    [GifPlayManager sharedManager].playingGifCell = nil;
    [GifPlayManager sharedManager].playingGifCell.containerView.isPlaying = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.tableView = nil;
}

#pragma mark - Configure

- (void)configureViewModel {
    NSAssert(NO, @"需要在子类中实现");
}

- (void)configureUI {
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:self.tableView];
    [GifPlayManager sharedManager].currentTableView = self.tableView;
    
    [self showLoading];
    
    if (self.isNeedRefreshFloat) {
        [self.view addSubview:self.floatRefreshView];
        [self.floatRefreshView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-adaptWidth750(30));
            make.bottom.equalTo(self.view).offset(-(adaptHeight1334(24)+ (IS_IPHONE_X ? (TAB_BAR_HEIGHT + 44) : TAB_BAR_HEIGHT)));
        }];
    }
}

#pragma mark -
#pragma mark - Share Alert Delegate
/**TODO: 分享弹窗*/

- (id<XLShareModelDelegate>)configShareModel {
    XLShareFeedModel *model = [[XLShareFeedModel alloc] init];
    /**信息流分享*/
    self.shareFeedModel.shareCompleteURL = [XLFeedModel completeShareURL:self.shareFeedModel withRefrence:@"*FEED*"];
    model.title = self.shareFeedModel.title;
    model.imageUrl = self.shareFeedModel.picture.firstObject;
    model.feedUrl = self.shareFeedModel.shareCompleteURL;
    model.feedType = self.shareFeedModel.type;
    model.originModel = self.shareFeedModel;
    model.position = @"0";
    return model;
}

- (XLShareCollectionModel *)configUploadCollection {
    XLShareCollectionModel *model = [[XLShareCollectionModel alloc] init];
    model.itemID = self.shareFeedModel.itemId;
    model.type = self.shareFeedModel.type;
    model.isCollection = self.shareFeedModel.isCollection;
    model.originModel = self.shareFeedModel;
    return model;
}

- (XLShareReportModel *)configUploadReport {
    XLShareReportModel *model = [[XLShareReportModel alloc] init];
    model.itemID = self.shareFeedModel.itemId;
    model.type = self.shareFeedModel.type;
    return model;
}

- (XLShareBackListModel *)configUpLoadBackList {
    XLShareBackListModel *model = [[XLShareBackListModel alloc] init];
    model.authorID = self.shareFeedModel.authorId;
    return model;
}

- (XLDeleteFeedModel *)configDeleteModel {
    XLDeleteFeedModel *model = [[XLDeleteFeedModel alloc] init];
    model.index = [self.shareFeedModel.index integerValue];
    model.itemId = self.shareFeedModel.itemId;
    model.type = [self.shareFeedModel.type integerValue];
    return model;
}

- (XLSaveVideoModel *)configSaveVideo {
    XLSaveVideoModel *model = [[XLSaveVideoModel alloc] init];
    model.videoURLString = self.shareFeedModel.downloadUrl ? self.shareFeedModel.downloadUrl : self.shareFeedModel.url ;
    model.originModel = self.shareFeedModel;
    return model;
}

- (void)deleteFeedCell {
    NSInteger row = [self.viewModel.dataSource.elements indexOfObject:self.shareFeedModel];
    //第一,删除数据源,
    [self.viewModel.dataSource removeElementAtIndex:row];
    //第二,删除表格cell
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XLFeedModel *model = self.viewModel.dataSource.elements[indexPath.row];
    model.indexPath = indexPath;
    
    @weakify(self);
    void(^backResult)(NSInteger) = ^(NSInteger index) {
        @strongify(self);
        model.isAllContent = !model.isAllContent;

        [UIView performWithoutAnimation:^{
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView layoutIfNeeded];
        
            if (model.type.integerValue == XLFeedCellVideoHorizonalWithAuthorType ||
                model.type.integerValue == XLFeedCellVideoVerticalWithAuthorType) {
          
                BaseVideoCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                [cell.videoDisPlayView resetVideoShow];

                model.currentTime = [self.tableView currentTime];
                XLPlayerManager.shared.currentPlayingCell = cell;
                [self.tableView handleScrollAutoPlayWithCompareCurrentCell:YES];
            } else {
                [[GifPlayManager sharedManager] rebootGifCell];
            }
        }];
    };
    
    if (model.type.integerValue == XLFeedCellVideoHorizonalWithAuthorType) {
        FeedVideoHorizonalCell *cell = [tableView xl_dequeueReusableCellWithClass:FeedVideoHorizonalCell.class forIndexPath:indexPath];
        model.indexPath = indexPath;
        cell.cellDelegate = self;
        cell.backResult = backResult;
        [cell configModelData:model indexPath:indexPath];
        [self addChildViewController:cell.commentListVC];
        if ([UIView isDisplayedInScreenForView:self.view]) {
            // 首页浏览打点
            [StatServiceApi statEvent:VIDEO_BROWSE model:model];
        }

        return cell;

    } else if (model.type.integerValue == XLFeedCellVideoVerticalWithAuthorType) {
        
        FeedVideoVerticalCell *cell = [tableView xl_dequeueReusableCellWithClass:FeedVideoVerticalCell.class forIndexPath:indexPath];
        model.indexPath = indexPath;
        cell.cellDelegate = self;
        cell.backResult = backResult;

        [cell configModelData:model indexPath:indexPath];
        [self addChildViewController:cell.commentListVC];
        
        if ([UIView isDisplayedInScreenForView:self.view]) {
            // 首页浏览打点
            [StatServiceApi statEvent:VIDEO_BROWSE model:model];
        }
        
        return cell;

    } else if (model.type.integerValue == XLFeedCellMultiPictureType) {
        
        FeedImagesCell *cell = [tableView xl_dequeueReusableCellWithClass:FeedImagesCell.class forIndexPath:indexPath];
        cell.cellDelegate = self;
        cell.backResult = backResult;
        [cell configModelData:model indexPath:indexPath];
        [self addChildViewController:cell.commentListVC];
        if ([UIView isDisplayedInScreenForView:self.view]) {
            // 首页浏览打点
            [StatServiceApi statEvent:IMAGE_BROWSE model:model];
        }
        return cell;
        
    } else if (model.type.integerValue == XLFeedCellADSimplePictureType) {
        
        FeedAdCell *cell = [tableView xl_dequeueReusableCellWithClass:FeedAdCell.class forIndexPath:indexPath];
        [cell configModelData:model indexPath:indexPath];
        [StatServiceApi statEvent:FEED_AD_LOOK model:nil otherString:[NSString stringWithFormat:@"%@,%@", YOUKAN_CHANNEL, model.adModel.adId]];
        return cell;
    } else if (model.type.integerValue == XLFeedCellAdNativeExpressType) {
        
        XLFeedNativeExpressCell *cell = [tableView xl_dequeueReusableCellWithClass:XLFeedNativeExpressCell.class forIndexPath:indexPath];
      
        [cell configModelData:model indexPath:indexPath];
        model.nativeExpressModel.expressAdView.controller = self;

        cell.deleteBlock = ^{
            
            //第一,删除数据源,
            [self.viewModel.dataSource removeElementAtIndex:indexPath.row];
            //第二,删除表格cell
            [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation: UITableViewRowAnimationAutomatic];
            
        };
        

        return cell;
    } else if (model.type.integerValue == XLFeedCellPostViolationType) {
        XLFeedMyPostRejectCell *cell = [tableView xl_dequeueReusableCellWithClass:XLFeedMyPostRejectCell.class forIndexPath:indexPath];
        [cell configModelData:model indexPath:indexPath];
        cell.cellDelegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return [UITableViewCell new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.elements.count;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLFeedModel *model = self.viewModel.dataSource.elements[indexPath.row];
    
    if (model.type.integerValue == XLFeedCellVideoHorizonalWithAuthorType) {
        return [self.tableView fd_heightForCellWithIdentifier:NSStringFromClass(FeedVideoHorizonalCell.class) cacheByKey:[model.itemId stringByAppendingString:[NSString stringWithFormat:@"%d", model.isAllContent?1:0]] configuration:^(FeedVideoHorizonalCell *cell) {
            [cell configModelData:model indexPath:indexPath];
        }]+0.5;
    } else if (model.type.integerValue == XLFeedCellVideoVerticalWithAuthorType) {
        return [self.tableView fd_heightForCellWithIdentifier:NSStringFromClass(FeedVideoVerticalCell.class) cacheByKey:[model.itemId stringByAppendingString:[NSString stringWithFormat:@"%d", model.isAllContent?1:0]] configuration:^(FeedVideoVerticalCell *cell) {
            [cell configModelData:model indexPath:indexPath];
        }]+0.5;
    } else if (model.type.integerValue == XLFeedCellMultiPictureType) {
        return [self.tableView fd_heightForCellWithIdentifier:NSStringFromClass(FeedImagesCell.class) cacheByKey:[model.itemId stringByAppendingString:[NSString stringWithFormat:@"%d", model.isAllContent?1:0]] configuration:^(FeedImagesCell *cell) {
            [cell configModelData:model indexPath:indexPath];
        }];
    } else if (model.type.integerValue == XLFeedCellADSimplePictureType) {
        return [self.tableView fd_heightForCellWithIdentifier:NSStringFromClass(FeedAdCell.class) cacheByKey:model.adModel.title configuration:^(FeedAdCell *cell) {
            [cell configModelData:model indexPath:indexPath];
        }];
    } else if (model.type.integerValue == XLFeedCellAdNativeExpressType) {
        return adaptHeight1334(317*2);
    } else if (model.type.integerValue == XLFeedCellPostViolationType) {
        return [self.tableView fd_heightForCellWithIdentifier:NSStringFromClass(XLFeedMyPostRejectCell.class) cacheByKey:@"XLFeedMyPostRejectCell" configuration:^(XLFeedMyPostRejectCell *cell) {
            [cell configModelData:model indexPath:indexPath];
        }]+0.5;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XLFeedModel *model = self.viewModel.dataSource.elements[indexPath.row];
    model.isRead = YES;
    
    // BaseFeedCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    // [cell setContentDidRead:YES];
    
    if (model.type.integerValue == XLFeedCellVideoHorizonalType ||
        model.type.integerValue == XLFeedCellVideoVerticalType ||
        model.type.integerValue == XLFeedCellVideoVerticalWithAuthorType ||
        model.type.integerValue == XLFeedCellVideoHorizonalWithAuthorType) {
        [self pushVideoDetailViewController:indexPath shouldShowCommentView:NO isSuperComment:NO];
        
    } else if (model.type.integerValue == XLFeedCellMultiPictureType ||
               model.type.integerValue == XLFeedCellArticleQQCircleType) {
        [self pushArticalDetailViewController:indexPath shouldScrollToCommentView:NO isSuperComment:NO];
    } else if (model.type.integerValue == XLFeedCellADSimplePictureType) {
        [StatServiceApi statEvent:FEED_AD_CLICK model:nil otherString:[NSString stringWithFormat:@"%@,%@", YOUKAN_CHANNEL, model.adModel.adId]];

        XLH5WebViewController *viewController = [XLH5WebViewController new];
        viewController.urlString = model.adModel.url;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - NegativeFeedbackDelegate

- (void)negativeFeedBackButtonDidClicked:(XLFeedModel *)model content:(NSString *)content {
    if ([content isEqualToString:@"举报"]) {
        XLReportSheetAlertViewController *alertView = [[XLReportSheetAlertViewController alloc] init];
        @weakify(self);
        [alertView presentReportAlertViewController:self itemID:model.itemId type:[model.type integerValue] complete:^{
            @strongify(self);
            NSInteger index = [self.viewModel removeFeedModel:model];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                                  withRowAnimation:UITableViewRowAnimationLeft];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self reloadData];
            });
        }];
        return;
    }
    [self.viewModel uploadNegativeFeedBackItemID:model content:content success:^(id obj, NSInteger index) {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                              withRowAnimation:UITableViewRowAnimationLeft];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reloadData];
        });
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.tableViewLastOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [[GifPlayManager sharedManager] currentTableViewDidScroll];
    
    if (self.viewModel.dataSource.elements.count > 0 && fabs(scrollView.contentOffset.y - self.tableViewLastOffsetY) < 12) {
        [self autoPlayVideoAndGif];
    }
    
    self.tableViewLastOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (decelerate == NO) { // scrollView已经完全静止
        
        [self autoPlayVideoAndGif];
        
        // 预加载
        if (self.tableView.contentOffset.y + self.tableView.height > self.tableView.contentSize.height - self.tableView.height) {
            [self.tableView.mj_footer beginRefreshing];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.tableView.visibleCells.count <= 0) {
        return;
    }
    [self autoPlayVideoAndGif];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [self autoPlayVideoAndGif];
}

#pragma mark - BaseFeedListViewModelDelegate

- (void)reloadData {
    [self.tableView reloadData];
    [self autoPlayVideoAndGif];
}

- (void)reloadModel:(XLFeedModel *)model atIndexPath:(NSIndexPath *)indexPath {
    
    BaseFeedCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (model.type.integerValue == XLFeedCellVideoVerticalWithAuthorType ||
        model.type.integerValue == XLFeedCellVideoHorizonalWithAuthorType) {
        [((FeedVideoHorizonalCell *)cell).commentContainerView setModel:model];
    }
    
    // 更新关注按钮
    if (cell.isContainFollowButton) {
        [(FeedVideoHorizonalCell *)cell updateDataWithModel:model];
    }
    
    // 更新神评
    [[(BaseFeedAuthorCell *)cell commentTableView] reloadData];
}

- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)refreshFinish:(BOOL)hasMore {
    [self.tableView.mj_header endRefreshing];
    [self.floatRefreshView endRefreshing];
    
    if (hasMore) {
        [self.tableView.mj_footer resetNoMoreData];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)loadMoreFinish:(BOOL)hasMore {
    if (hasMore) {
        [self.tableView.mj_footer endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)showEmpty {
    
    [XLEmptyDataView showEmptyDataInView:self.tableView withTitle:self.emptyTitle imageStr:self.emptyImageName offSet:self.emptyViewOffset];
    
    self.tableView.mj_footer.hidden = YES;
}

- (void)hideEmpty {
    
    [XLEmptyDataView hideEmptyDataInView:self.tableView];
}

- (void)showLoading {
    
    [XLLoadingView showLoadingInView:self.tableView offSet:self.loadingViewOffset];
}

- (void)hideLoading {
    
    [XLLoadingView hideLoadingForView:self.tableView];
}

- (void)showLoadFailed {
    
    CGFloat offset = adaptHeight1334(self.loadFailViewOffset);
    
    @weakify(self);
    [XLReloadFailView showReloadFailInView:self.tableView offSet:offset reloadAction:^{
        @strongify(self);
        [self.viewModel resetAndRefresh];
    }];
}

- (void)hideLoadFailed {
    
    [XLReloadFailView hideReloadFailInView:self.tableView];
}

- (void)showTipCount:(NSInteger)tipCount {
    
    if (!self.isNeedTopTip) {
        [self.tableView.mj_header endRefreshing];
        return;
    }
    ShowDataView *dataView = [ShowDataView new];
    
    dataView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT + adaptHeight1334(23*2), SCREEN_WIDTH, adaptHeight1334(32*2));
    
    [dataView setDataNumber:tipCount];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.tableView.mj_header endRefreshing];
        self.tableView.mj_insetT = 0;
        self.tableView.mj_header.alpha = 0;
    } completion:^(BOOL finished) {
        self.tableView.mj_insetT = 0;
        self.tableView.mj_header.alpha = 1;
        [self.view addSubview:dataView];
        CGFloat dataViewY = dataView.y;
        dataView.y = 0;
        [UIView animateWithDuration:0.2 animations:^{
            dataView.y = dataViewY;
        }];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dataView.frame = CGRectMake(0, 22, SCREEN_WIDTH, 42);
        [UIView animateWithDuration:0.4 animations:^{
            [dataView removeFromSuperview];
        }];
    });
}

- (void)showErrorWithCode:(NSInteger)errorCode {
    
    if (errorCode == -1009 || errorCode == -1005) {
        [MBProgressHUD showError:XLAlertNetworkNotReachable];
    } else if (errorCode == -1001) {
        [MBProgressHUD showError:XLAlertRequestTimeout];
    }
}

#pragma mark - IBActions/Event Response

- (void)didClickAvatarButtonEvent:(XLFeedModel *)model {
    
    PublisherViewController *personalHomepageViewController = [PublisherViewController new];
    personalHomepageViewController.model = [model copy];
    [StatServiceApi statEvent:PERSONPAGE_CLICK model:model];
    [[UIViewController currentViewController].navigationController pushViewController:personalHomepageViewController animated:YES];
    
    model.currentTime = self.tableView.currentTime;
    
    @weakify(self);
    [personalHomepageViewController setPersonalHomepageControllerWillDisplayBlock:^{
        @strongify(self);
        if (!self.isViewWillAppear) return;
        id cell = [self.tableView cellForRowAtIndexPath:model.indexPath];
        if ([cell isKindOfClass:[FeedVideoHorizonalCell class]] && self.isViewWillAppear) {
            [self.tableView handleScrollWithCell:cell withShouldCompareCurrentCell:NO];
        }
    }];
}

- (void)didClickCellPraiseButtonEvent:(XLFeedModel *)model {
    
    [self.viewModel praise:model];
}

- (void)didClickCellTreadButtonEvent:(XLFeedModel *)model {
    
    [self.viewModel tread:model];
}

- (void)didClickCellCommentButtonEvent:(XLFeedModel *)model {
    
    if (model.type.integerValue == XLFeedCellVideoHorizonalType ||
        model.type.integerValue == XLFeedCellVideoVerticalType ||
        model.type.integerValue == XLFeedCellVideoVerticalWithAuthorType ||
        model.type.integerValue == XLFeedCellVideoHorizonalWithAuthorType) {
        
        [self pushVideoDetailViewController:model.indexPath shouldShowCommentView:YES isSuperComment:NO];
    } else {
        [self pushArticalDetailViewController:model.indexPath shouldScrollToCommentView:YES isSuperComment:NO];
    }
}

- (void)didClickCellSuperCommentButtonEvent:(XLFeedModel *)model {
    
    if (model.type.integerValue == XLFeedCellVideoHorizonalType ||
        model.type.integerValue == XLFeedCellVideoVerticalType ||
        model.type.integerValue == XLFeedCellVideoVerticalWithAuthorType ||
        model.type.integerValue == XLFeedCellVideoHorizonalWithAuthorType) {
        
        [self pushVideoDetailViewController:model.indexPath shouldShowCommentView:YES isSuperComment:YES];
    } else {
        [self pushArticalDetailViewController:model.indexPath shouldScrollToCommentView:YES isSuperComment:YES];
    }
}

- (void)didClickCellForwardButtonEvent:(XLFeedModel *)model {
    
    [self.viewModel prepareShare:model];
    
    self.shareFeedModel = model;
    XLShareAlertViewController *alert = [[XLShareAlertViewController alloc] init];
    if (model.isMyUpload) {
        [alert resetTool:@[@"收藏",@"删除"] icon:@[@"detail_comment_collection_n",@"post_delete"]];
    } else {
        [alert resetTool:@[@"收藏",@"举报"] icon:@[@"detail_comment_collection_n",@"detail_comment_report"]];
    }
    
    if (model.type.integerValue == XLFeedCellVideoHorizonalType ||
        model.type.integerValue == XLFeedCellVideoVerticalType ||
        model.type.integerValue == XLFeedCellVideoVerticalWithAuthorType ||
        model.type.integerValue == XLFeedCellVideoHorizonalWithAuthorType) {
        [alert addObjectToTool:@"下载视频" icon:@"share_download_video"];
    }
    
    alert.shareDelegate = self;
    [alert presentSheetAlertViewController:self];
}

- (void)didClickFollowButtonEvent:(XLFeedModel *)model withFollowButton:(FollowButton *)followButton {
    
    [self.viewModel follow:model success:^(BOOL isToFollow) {
        
        if (isToFollow) {
            [MBProgressHUD showSuccess:@"关注成功"];
        }

    } failure:^(NSInteger errorCode) { [followButton stopAnimation]; }];
}

/**
 我的帖子删除按钮点击回调
 */
- (void)tableCell:(UITableViewCell *)cell deleteModel:(XLFeedModel *)model {
    [self.viewModel deleteMyUploadFeed:model success:^{
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        //第一,删除数据源,
        [self.viewModel.dataSource removeElementAtIndex:indexPath.row];
        //第二,删除表格cell
        [self.tableView reloadData];
    }];
}

/**
 管理规范点击事件
 */
- (void)didClickManagementSpecificationButtonEvent:(XLFeedModel *)model {
    XLH5WebViewController *webViewController = [XLH5WebViewController new];
    webViewController.urlString = model.url;
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark - Private

- (void)autoPlayVideoAndGif {
    if ([self.tableView videoShouldAutoPlay]) {
        if ([UIView isDisplayedInScreenForView:self.view]) {
            [self.tableView handleScrollAutoPlayWithCompareCurrentCell:YES];
            [GifPlayManager sharedManager].currentTableView = self.tableView;
            [[GifPlayManager sharedManager] playGifCell];
        }
    } else {
        [self.tableView handleNonAutoPlay];
    }
    [[GifPlayManager sharedManager] statImagesCell];
}

- (void)autoPlayVideoWithVisibleCheck:(BOOL)isCheckVisible {
    if ([self.tableView videoShouldAutoPlay]) {
        if (!isCheckVisible || [UIView isDisplayedInScreenForView:self.view]) {
            [self.tableView handleScrollAutoPlayWithCompareCurrentCell:NO];
        }
    } else {
        [self.tableView handleNonAutoPlay];
    }
}

- (void)autoRefreshForFirstTime {
    if (!self.isAutoRefreshForFirstTime) {
        return;
    }
    
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self.viewModel refresh];
    });
}

- (void)pushArticalDetailViewController:(NSIndexPath *)indexPath
              shouldScrollToCommentView:(BOOL)shouldScrollToCommentView
                         isSuperComment:(BOOL)isSuperComment{
    
    self.didClickIndex = indexPath;
    
    XLFeedModel *model = self.viewModel.dataSource.elements[indexPath.row];
    
    FeedImageDetailViewController *detailVC = [FeedImageDetailViewController new];
    detailVC.delegate = self;
    detailVC.viewModel = [[FeedDetailViewModel alloc] initWithFeed:model];
    detailVC.shouldScrollToCommentView = shouldScrollToCommentView;
    
    if (shouldScrollToCommentView) {
        if (!isSuperComment) {
            [StatServiceApi statEvent:IMAGE_JUMP_COMMENT_CLCK model:model];
        }
    } else {
        [StatServiceApi statEvent:IMAGE_DETAIL_CLICK model:model];
    }
    
    if (model.type.integerValue == XLFeedCellMultiPictureType) {
        FeedImagesCell *imageCell = [self.tableView cellForRowAtIndexPath:indexPath];
        detailVC.palyPlace = imageCell.containerView.playingPlace;
        
        @weakify(self);
        detailVC.ContinueGifPlayPlace = ^(NSInteger place) {
            @strongify(self);
            if (![imageCell.containerView isAllCellCanNotPlay]) {
                [GifPlayManager sharedManager].currentTableView = self.tableView;
                [imageCell.containerView playGifImageViewWithNumber:place];
                imageCell.containerView.isPlaying = YES;
                [GifPlayManager sharedManager].playingGifCell = imageCell;
            } else {
                [[GifPlayManager sharedManager] playGifCell];
            }
        };
        self.isEnterImageDetail = YES;
        [imageCell.containerView stopPlayGifImageView];
    }
    
    [[UIViewController currentViewController].navigationController pushViewController:detailVC animated:YES];
}

- (void)pushVideoDetailViewController:(NSIndexPath *)indexPath shouldShowCommentView:(BOOL)showCommentView isSuperComment:(BOOL)isSuperComment {
    
    self.didClickIndex = indexPath;
    
    XLFeedModel *model = self.viewModel.dataSource.elements[indexPath.row];
    model.currentTime = self.tableView.currentTime;
    model.videoHasPlayed = YES;
    
    //首页点击
    if (showCommentView) {
        if (!isSuperComment) {
            [StatServiceApi statEvent:VIDEO_JUMP_COMMENT_CLCK model:model];
        }
    } else {
        [StatServiceApi statEvent:VIDEO_CLICK model:model];
    }
    
    FeedVideoDetailViewController *detailViewController = [FeedVideoDetailViewController new];
    detailViewController.delegate = self;
    detailViewController.viewModel = [[FeedDetailViewModel alloc] initWithFeed:model];
    detailViewController.shouldScrollToCommentView = showCommentView;
    
    if (self.tableView.isPlaying && [self.tableView.currentVideoPlayURLString isEqual:model.url]) {
        detailViewController.isVideoPlaying = YES;
    } else {
        detailViewController.isVideoPlaying = NO;
    }
    
    @weakify(self);
    // 视频继续播放
    [detailViewController setVideoDetailEndPlay_block:^(BOOL isVideoPlaying, BOOL isVideoPlayToEnd) {
        @strongify(self);
      
        if (!self.isViewWillAppear) return;
        self.isReturnFromDetailVideo = YES;
     
        [XLPlayerManager.shared.currentPlayingCell.videoDisPlayView setShareViewHidden:!isVideoPlayToEnd];
        BaseVideoCell *videoCell = [self.tableView cellForRowAtIndexPath:indexPath];
        videoCell.model.isVideoPlayToEndTime = isVideoPlayToEnd;
        
        if (isVideoPlayToEnd) {
            XLPlayerManager.shared.currentPlayingCell.model.isVideoPlayToEndTime = isVideoPlayToEnd;
        } else {
            if (isVideoPlaying && [UIView isDisplayedInScreenForView:self.view]) {
                [self.tableView handleScrollAutoPlayWithCompareCurrentCell:NO];
            }
        }
    }];
    
    [[UIViewController currentViewController].navigationController pushViewController:detailViewController animated:YES];
}

- (void)observeOfFeedMuteState {
    // 静音按钮点击，列表的静音按钮需要同步
    self.KVOController = [[FBKVOController alloc] initWithObserver:self];
    [self.KVOController observe:XLPlayerManager.shared keyPath:@"feedVideoMute" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        [self updateVisibleCellMuteButtonDisplay];
    }];
}

- (void)updateVisibleCellMuteButtonDisplay {
    NSArray *visitableCell = self.tableView.visibleCells;
    [visitableCell enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BaseVideoCell class]]) {
            [((BaseVideoCell *)obj).videoDisPlayView configMuteButtonDisplay];
        }
    }];
}

#pragma mark - Notification Event

- (void)applicationWillResignActiveNotification {
    if (self.tableView.isPlaying) {
        self.tableView.isVideoInterrupt = YES;
        [self.tableView pause];
    }
}

- (void)applicationDidBecomeActiveNotification {
    if (![UIView isDisplayedInScreenForView:self.view]) { //如果当前页面不显示，就不需要播放
        return;
    }
    if (self.tableView.isVideoInterrupt) {
        [self.tableView play];
        self.tableView.isVideoInterrupt = NO;
    } else {
        [self autoPlayVideoWithVisibleCheck:YES];
    }
}

- (void)didNetworkChangedNotification {
    if ([NetworkManager.shared.netWorkTypeString isEqualToString:XLAlertNetworkWWAN]) {
        [MBProgressHUD showError:XLAlertNetworkChanged];
    }
}

#pragma mark -
#pragma mark - detail delegate

- (void)didClickDeleteButton {
    //第一,删除数据源,
    [self.viewModel.dataSource removeElementAtIndex:self.didClickIndex.row];
    //第二,删除表格cell
    [self.tableView reloadData];
}

#pragma mark - Custom Accessors

- (NSString *)emptyImageName {
    return @"no_dz";
}

- (NSString *)emptyTitle {
    return @"";
}

- (CGFloat)emptyViewOffset {
    return 0;
}

- (BOOL)isNeedRefreshHeader {
    return NO;
}

- (BOOL)isNeedRefreshFloat {
    return NO;
}

- (BOOL)isNeedTopTip {
    return NO;
}

- (BOOL)isAutoRefreshForFirstTime {
    return YES;
}

- (CGFloat)loadingViewOffset {
    return 0;
}

- (CGFloat)loadFailViewOffset {
    return 0;
}

- (CGFloat)tableViewOriginY {
    return NAVIGATION_BAR_HEIGHT;
}

- (CGFloat)tableViewHeight {
    return self.view.bounds.size.height - self.tableViewOriginY;
}

- (CGFloat)tableHeaderViewHeight {
    return 0;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        CGRect frame = CGRectMake(0, self.tableViewOriginY, self.view.bounds.size.width, self.tableViewHeight);
        
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithString:COLORF2F2F2];
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.tableHeaderViewHeight, 0, 0, 0);
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView xl_registerClass:FeedVideoVerticalCell.class];
        [_tableView xl_registerClass:FeedVideoHorizonalCell.class];
        [_tableView xl_registerClass:FeedImagesCell.class];
        [_tableView xl_registerClass:FeedAdCell.class];
        [_tableView xl_registerClass:XLFeedNativeExpressCell.class];
        [_tableView xl_registerClass:XLFeedMyPostRejectCell.class];

        if (self.tableHeaderViewHeight > 0) {
            UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableHeaderViewHeight)];
            _tableView.tableHeaderView = tableHeaderView;
        }
        
        if (self.isNeedRefreshHeader) {
            _tableView.mj_header = [self tableViewGifHeader];
        }
        
        _tableView.mj_footer = [self tableViewAutoFooter];
    }
    return _tableView;
}

- (FeedsHeaderView *)tableViewGifHeader {
    
    FeedsHeaderView *gifHeader = [XLTableGifHeaderView tableGifHeaderWithRefreshingTarget:self.viewModel refreshingAction:@selector(refresh)];
    return gifHeader;
}

- (XLRefreshAutoGifFooter *)tableViewAutoFooter {
    
    XLRefreshAutoGifFooter *autoFooter = [XLRefreshAutoGifFooter footerWithRefreshingTarget:self.viewModel refreshingAction:@selector(loadMore)];
    
    autoFooter.backgroundColor = [UIColor colorWithString:COLORF2F2F2];
    
    autoFooter.ignoredScrollViewContentInsetBottom = -5;
    autoFooter.triggerAutomaticallyRefreshPercent = 0.1;
    
    return autoFooter;
}

- (XLFloatRefreshView *)floatRefreshView {
    if (!_floatRefreshView) {
        _floatRefreshView = [XLFloatRefreshView floatWithRefreshingTarget:self.tableView.mj_header refreshingAction:@selector(beginRefreshing)];
    }
    return _floatRefreshView;
}

@end
