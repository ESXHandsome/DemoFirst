//
//  ArticleDetailViewController.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/1/10.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "FeedDetailViewController.h"
#import "NewsApi.h"
#import "PublisherViewController.h"
#import "XLUserManager.h"
#import "XLDataSourceManager.h"
#import "FeedCommentListViewController.h"
#import "XLReportSheetAlertViewController.h"
#import "XLShareAlertViewController.h"

@interface FeedDetailViewController ()<UITableViewDelegate, UITableViewDataSource, BottomToolbarViewDelegate, FollowButtonDelegate, FeedDetailViewModelDelegate, XLShareAlertControllerShareDelegate>

@property (strong, nonatomic) FeedCommentSectionHeaderView  *sectionHeaderView;

@property (assign, nonatomic) BOOL                          canScroll;
@property (assign, nonatomic) BOOL                          shortcutPictureComment;

@end

@implementation FeedDetailViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self configHeaderView];
    
    [self setNavigationBar];
    [self.view addSubview:self.bottomToolbarView];
    
    [self configFeedPageData];
    
    if (!self.shouldScrollToCommentView) {
        [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    
    self.bottomToolbarView.shortcutPictureComment = self.shortcutPictureComment;
}

- (void)configHeaderView {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBarfollowView.followButton.followed = self.viewModel.feed.isFollowed;
    
    if (self.viewModel.feed.isMyUpload) {
        self.navigationBarfollowView.followButton.hidden = self.viewModel.feed.isMyUpload;
    } else {
        self.navigationBarfollowView.followButton.hidden = self.viewModel.feed.isFollowed;
    }
    
    [self.viewModel statBeginPage];
    if (self.tableView.mj_offsetY > self.statSeparateHeight) {
        [self.viewModel statBeginComment];
    } else {
        if (!self.shouldScrollToCommentView) {
            [self.viewModel statBeginContent];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.viewModel statEndPage];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kLeaveTopNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kdScrollToTopNotification" object:nil];
}

- (void)setNavigationBar {
    
    [self.navigationController.navigationBar addSubview:self.navigationBarfollowView];
    self.navigationBarfollowView.model = self.viewModel.feed;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(toolbarView:forwardAction:)];
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_text_icon"]];
    self.navigationItem.titleView = titleView;
    
    @weakify(self);
    self.navigationBarfollowView.backResult = ^(NSInteger index) {
        @strongify(self);
        [self pushPublisherHomepage];
    };
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

#pragma mark - ConfigFeedPageData
- (void)configFeedPageData {
    
    self.viewModel.delegate = self;
    self.canScroll = YES;
    self.bottomToolbarView.model = self.viewModel.feed;
    
    if (self.shouldScrollToCommentView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scrollToCommentListAreaAnimated:NO];
        });
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sectionLeaveTopAction:) name:@"kLeaveTopNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToTopAction:) name:@"kdScrollToTopNotification" object:nil];

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
    return kSectionHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.sectionHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.commentContentCell) {
        self.viewModel.isShowCommentRefreshAnination = self.tableView.tableHeaderView.height > self.tableView.height ? NO : YES;
        if (self.shouldScrollToCommentView) {
            self.viewModel.isShowCommentRefreshAnination = YES;
        }
        self.commentContentCell = [[FeedCommentContentCell alloc] initWithFeedModel:self.viewModel];
        [self addChildViewController:self.commentContentCell.commentListVC];
        
        @weakify(self)
        self.commentContentCell.commentListVC.commentSuccessBlock = ^{
            @strongify(self)
            [self scrollToCommentListAreaAnimated:YES];
            [self.commentContentCell.commentListVC.tableView setContentOffset:CGPointZero animated:YES];
        };
        self.commentContentCell.commentListVC.commentRequestBlock = ^{
            @strongify(self)
            CGFloat segmentOffsetY = self.commentAreaHeight + self.sectionHeaderView.height;
            CGPoint bottomOffset = CGPointMake(0, segmentOffsetY);
            [self.tableView setContentOffset:bottomOffset animated:YES];
        };
        if (self.shouldScrollToCommentView) { //如果是直接到的评论处，允许CommentList滚动
            self.commentContentCell.canScroll = YES;
        }
    }
    return self.commentContentCell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //评论列表 和 主控制器之间的滑动状态切换
    CGFloat segmentOffsetY = [_tableView rectForSection:0].origin.y + kSectionHeight - self.videoOffsetHeight;
    if (scrollView.mj_offsetY >= segmentOffsetY) {
        scrollView.contentOffset = CGPointMake(0, segmentOffsetY);
        if (_canScroll) {
            _canScroll = NO;
            self.commentContentCell.canScroll = YES;
        }
        if (scrollView.mj_offsetY >= segmentOffsetY + 1) {
            self.tableView.scrollsToTop = NO;
        } else {
            self.tableView.scrollsToTop = YES;
        }
    } else {
        if (!_canScroll) {
            scrollView.contentOffset = CGPointMake(0, segmentOffsetY);
        }
        self.tableView.scrollsToTop = YES;
    }
    [self updateNavigationBarFollowButton];
    
    if (scrollView.mj_offsetY > self.statSeparateHeight && !self.viewModel.isStatingComment) {
        [self.viewModel statBeginComment];
        [self.viewModel statEndContent];
    }
    
    if (scrollView.mj_offsetY <= self.statSeparateHeight && !self.viewModel.isStatingContent) {
        [self.viewModel statBeginContent];
        [self.viewModel statEndComment];
    }
    
    self.bottomToolbarView.shortcutPictureComment = self.shortcutPictureComment;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    XLLog(@"点击状态栏");
    [self scrollToTopAction:nil];
}

//热门评论 离开顶部了 主控制器可以滑动
- (void)sectionLeaveTopAction:(NSNotification *)ntf {
    self.canScroll = YES;
    self.commentContentCell.canScroll = NO;
}

//点击状态栏滚动到了顶部
- (void)scrollToTopAction:(NSNotification *)ntf {
    [self sectionLeaveTopAction:ntf];
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

- (void)setTableViewScroll:(BOOL)isScroll
{
    self.tableView.scrollEnabled = isScroll;
}

#pragma mark - IBActions/Event Response

/**
 滚动到评论
 */
- (void)scrollToCommentListAreaAnimated:(BOOL)animated {
    
    CGFloat segmentOffsetY = self.commentAreaHeight;
    CGPoint bottomOffset = CGPointMake(0, segmentOffsetY);
    [self.tableView setContentOffset:bottomOffset animated:animated];
}

//跳转个人中心
- (void)pushPublisherHomepage {
    
    PublisherViewController *personalHomePage = [PublisherViewController new];
    personalHomePage.model = [self.viewModel.feed copy];
    [StatServiceApi statEvent:PERSONPAGE_CLICK model:self.viewModel.feed];
    self.isEnterPersonal = YES;
    [self.navigationController pushViewController:personalHomePage animated:YES];
}

- (void)updateNavigationBarFollowButton {
    if (self.tableView.mj_offsetY > self.showFollowHeight) {
        if (self.navigationBarfollowView.hidden == YES && self.navigationItem.titleView.hidden == NO) {
            [UIView animateWithDuration:0.2 animations:^{
                self.navigationBarfollowView.hidden = NO;
                self.navigationItem.titleView.hidden = YES;
            }];
        }
    } else {
        if (self.navigationBarfollowView.hidden == NO && self.navigationItem.titleView.hidden == YES) {
            [UIView animateWithDuration:0.2 animations:^{
                self.navigationBarfollowView.hidden = YES;
                self.navigationItem.titleView.hidden = NO;
            }];
        }
    }
}

#pragma mark - FeedCellDelegate

- (void)didClickCellPraiseButtonEvent:(XLFeedModel *)model {
    self.viewModel.feed.praiseNum += self.viewModel.feed.isPraise ? -1 : 1;
    self.viewModel.feed.isPraise = !self.viewModel.feed.isPraise;
    [self.viewModel repeatUpload:YES];
}

- (void)didClickCellTreadButtonEvent:(XLFeedModel *)model {
    self.viewModel.feed.treadNum += self.viewModel.feed.isTread ? -1 : 1;
    self.viewModel.feed.isTread = !self.viewModel.feed.isTread;
    [self.viewModel treadRepeatUpload:YES];
}

- (void)didClickCellCommentButtonEvent:(XLFeedModel *)model {
    [self.commentContentCell.commentListVC showCommentKeyboardShortcutShowPhotos:NO];
}

- (void)didClickCellForwardButtonEvent:(XLFeedModel *)model {
    [self toolbarView:nil forwardAction:nil];
}

#pragma mark - FeedDetailViewModelDelegate
- (void)feedModelDidUpdate:(XLFeedModel *)feed {
    
    self.bottomToolbarView.model = feed;
}

#pragma mark - FollowButtonDelegate
- (void)followButtonClick:(FollowButton *)sender {
    
    [NewsApi followWithAuthorId:self.viewModel.feed.authorId action:!self.navigationBarfollowView.followButton.followed success:^(id responseDict) {
        
        if (self.navigationBarfollowView.followButton.followed) {
            self.navigationBarfollowView.followButton.followed = NO;
            if (self.viewModel.feed.type.integerValue == XLFeedCellArticleQQCircleType) {
            }
            ((FollowButton *)sender).followed = NO;
        } else {
            self.navigationBarfollowView.followButton.followed = YES;
            [StatServiceApi statEvent:FOLLOW_CLICK model:self.viewModel.feed];
            ((FollowButton *)sender).followed = YES;
        }
        
    } failure:^(NSInteger errorCode) {
        [self.navigationBarfollowView.followButton stopAnimation];
        [sender stopAnimation];
        if (self.viewModel.feed.type.integerValue == XLFeedCellArticleQQCircleType) {
        }
    }];
}

#pragma mark - BottomCommentViewDelegate

- (void)toolbarView:(BottomToolbarView *)toolbar commentAction:(UIButton *)commentButton {
    [self.commentContentCell.commentListVC showCommentKeyboardShortcutShowPhotos:NO];
}

- (void)toolbarView:(BottomToolbarView *)toolbar pictureCommentAction:(UIButton *)pictureCommentButton {
    [self.commentContentCell.commentListVC showCommentKeyboardShortcutShowPhotos:YES];
}

- (void)toolbarView:(BottomToolbarView *)toolbar praiseAction:(UIButton *)praiseButton {
    
    self.viewModel.feed.praiseNum += self.viewModel.feed.isPraise ? -1 : 1;
    self.viewModel.feed.isPraise = !self.viewModel.feed.isPraise;
    
    [self feedModelDidUpdate:self.viewModel.feed];
    [self.viewModel repeatUpload:YES];
}

- (void)toolbarView:(BottomToolbarView *)toolbar forwardAction:(UIButton *)forwardButton {
    
    NSString *event;
    if (forwardButton != nil && ![forwardButton isKindOfClass:[UIButton class]]) {
        event = self.viewModel.feed.type.integerValue == XLFeedCellMultiPictureType ? IMAGE_MENU_CLICK : VIDEO_MENU_CLICK;
    } else {
        event = self.viewModel.feed.type.integerValue == XLFeedCellMultiPictureType ? IMAGE_FORWARD : VIDEO_FORWARD;
    }
    
    [StatServiceApi statEvent:event model:self.viewModel.feed];
    
    XLShareAlertViewController *alert = [[XLShareAlertViewController alloc] init];
    
    if (self.viewModel.feed.isMyUpload) {
        [alert resetTool:@[@"收藏",@"删除"] icon:@[@"detail_comment_collection_n",@"post_delete"]];
    } else {
        [alert resetTool:@[@"收藏",@"举报"] icon:@[@"detail_comment_collection_n",@"detail_comment_report"]];
    }
    
    if (self.viewModel.feed.type.integerValue == XLFeedCellVideoHorizonalType ||
        self.viewModel.feed.type.integerValue == XLFeedCellVideoVerticalType ||
        self.viewModel.feed.type.integerValue == XLFeedCellVideoVerticalWithAuthorType ||
        self.viewModel.feed.type.integerValue == XLFeedCellVideoHorizonalWithAuthorType) {
        [alert addObjectToTool:@"下载视频" icon:@"share_download_video"];
    }
    
    alert.shareDelegate = self;
    [alert presentSheetAlertViewController:self];
}

#pragma mark - ShareAlertViewControllerDelegate

- (XLSaveVideoModel *)configSaveVideo {
    XLSaveVideoModel *model = [[XLSaveVideoModel alloc] init];
    model.videoURLString = self.viewModel.feed.downloadUrl ? self.viewModel.feed.downloadUrl : self.viewModel.feed.url;
    model.originModel = self.viewModel.feed;
    return model;
}

- (id<XLShareModelDelegate>)configShareModel {
    
    XLShareFeedModel *model = [[XLShareFeedModel alloc] init];
    /**信息流分享*/
    self.viewModel.feed.shareCompleteURL = [XLFeedModel completeShareURL:self.viewModel.feed withRefrence:@"*FEED*"];
    model.title = self.viewModel.feed.title;
    model.imageUrl = self.viewModel.feed.picture.firstObject;
    model.feedUrl = self.viewModel.feed.shareCompleteURL;
    model.feedType = self.viewModel.feed.type;
    model.originModel = self.viewModel.feed;
    model.position = @"0";
    return model;
}

- (XLShareCollectionModel *)configUploadCollection {
    XLShareCollectionModel *model = [[XLShareCollectionModel alloc] init];
    model.itemID = self.viewModel.feed.itemId;
    model.type = self.viewModel.feed.type;
    model.isCollection = self.viewModel.feed.isCollection;
    model.originModel = self.viewModel.feed;
    return model;
}

- (XLShareReportModel *)configUploadReport {
    XLShareReportModel *model = [[XLShareReportModel alloc] init];
    model.itemID = self.viewModel.feed.itemId;
    model.type = self.viewModel.feed.type;
    return model;
}

- (XLDeleteFeedModel *)configDeleteModel {
    XLDeleteFeedModel *model = [[XLDeleteFeedModel alloc] init];
    model.index = [self.viewModel.feed.index integerValue];
    model.itemId = self.viewModel.feed.itemId;
    model.type = [self.viewModel.feed.type integerValue];
    return model;
}

- (void)deleteFeedCell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickDeleteButton)]) {
        [self.delegate didClickDeleteButton];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 view 在屏幕范围

 @param view view
 @param number 范围值
 @return bool
 */
- (BOOL)screenAreaWithView:(UIView *)view number:(CGFloat)number {
    //frame 转换
    CGRect rect = [view.superview convertRect:view.frame toView:[UIApplication sharedApplication].keyWindow];
    if (rect.origin.y + rect.size.height < number) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - Lazy loading

- (UITableView *)tableView
{
    if (!_tableView) {
        self.tableView = [[AllRecognizeTableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT) style:UITableViewStyleGrouped];
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = self.tableView.height;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.showsHorizontalScrollIndicator = NO;
    }
    return _tableView;
}

- (BottomToolbarView *)bottomToolbarView {
    if (!_bottomToolbarView) {
        self.bottomToolbarView = [BottomToolbarView new];
        self.bottomToolbarView.frame = CGRectMake(0, self.view.height - TAB_BAR_HEIGHT, SCREEN_WIDTH, TAB_BAR_HEIGHT);
        _bottomToolbarView.delegate = self;
    }
    return _bottomToolbarView;
}

- (NavigationBarFollowView *)navigationBarfollowView {
    if (!_navigationBarfollowView) {
        _navigationBarfollowView = [NavigationBarFollowView new];
        _navigationBarfollowView.hidden = YES;
        _navigationBarfollowView.followButton.delegate = self;

    }
    return _navigationBarfollowView;
}

- (FeedCommentSectionHeaderView *)sectionHeaderView {
    if (!_sectionHeaderView) {
        _sectionHeaderView = [FeedCommentSectionHeaderView new];
        [_sectionHeaderView setSectionTitle:@"热门评论"];
    }
    return _sectionHeaderView;
}

- (BOOL)shortcutPictureComment {
    return ![self screenAreaWithView:self.tableView.tableHeaderView number:SCREEN_HEIGHT - TAB_BAR_HEIGHT];
}

@end
