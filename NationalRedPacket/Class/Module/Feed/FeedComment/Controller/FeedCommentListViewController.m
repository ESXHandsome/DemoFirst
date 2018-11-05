//
//  FeedCommentListViewController.m
//  NationalRedPacket
//
//  Created by fensi on 2018/4/23.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "FeedCommentListViewController.h"
#import "FeedCommentKeyboardViewController.h"
#import "FeedCommentCell.h"
#import "FeedSecondaryCommentCell.h"
#import "FeedSecondaryCommentUnfoldTipCell.h"
#import "FeedSecondaryCommentTopCell.h"
#import "FeedSecondaryCommentBottomCell.h"
#import "FeedCommentSectionHeaderView.h"
#import "PublisherViewController.h"
#import "XLDimmingPresentationController.h"
#import "XLReportSheetAlertViewController.h"
#import "XLPhotoShowView.h"
#import "XLFeedListSuperCommentCell.h"

@interface FeedCommentListViewController () <FeedCommentListViewModelDelegate, FeedCommentCellDelegate, FeedSecondaryCommentCellDelegate, FeedSecondaryCommentUnfoldTipCellDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) FeedCommentListViewModel *viewModel;

@end

@interface FeedCommentListViewController () <FeedCommentCellDelegate>
@end

@interface FeedCommentListViewController () <FeedCommentListViewModelDelegate>
@end

@implementation FeedCommentListViewController

#pragma mark - Lifecycle

- (instancetype)initWithFeed:(XLFeedModel *)feed {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _viewModel = [[FeedCommentListViewModel alloc] initWithFeed:feed];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel.specialCommentId = self.appointCommentId;
    self.viewModel.specialSecondCommentId = self.appointSecondCommentId;
    
    self.viewModel.delegate = self;
    [self.view addSubview:self.tableView];
    
    if (self.isFeedListSuperComment) { //如果是信息流列表神评，不添加刷新控件
        return;
    }
    [self setFreshControl];
    [self pretreatmentFeedAllowComment];
    
}

- (void)setFreshControl {
    self.tableView.mj_footer = [XLRefreshAutoGifFooter footerWithRefreshingTarget:self.viewModel refreshingAction:@selector(loadMore)];
}

- (void)pretreatmentFeedAllowComment{
    
    if (self.viewModel.feed.allowComment) { //是否允许评论
        if (self.isRefreshAnimation) {
            [self.tableView.mj_footer beginRefreshing];
        } else {
            [self.viewModel loadMore];
        }
    } else {
        [self showCloseCommentView];
    }
}

#pragma mark - Public Methods

- (CGFloat)feedListSuperCommentTotalHeight {
    
    CGFloat sum = 0;
    for (FeedCommentListSectionModel *sectionModel in self.viewModel.sections) {
        
        FeedCommentListRowModel *rowModel = sectionModel.rows.firstObject;
        sum += [self.tableView fd_heightForCellWithIdentifier:NSStringFromClass(XLFeedListSuperCommentCell.class) cacheByKey:[rowModel.comment.commentId stringByAppendingString:[NSString stringWithFormat:@"%d", rowModel.isAllContent?1:0]] configuration:^(FeedCommentCell *cell) {
            [cell configModelData:rowModel indexPath:nil];
        }]+1;
    }
    return sum;
}

- (void)setSuperCommentArray:(NSMutableArray<XLFeedCommentModel *> *)superCommentArray {
    _superCommentArray = superCommentArray;
    
    [self.viewModel addFeedCommentWithModelArray:superCommentArray];
    [self.tableView reloadData];
}

- (void)setFeed:(XLFeedModel *)feed {
    _feed = feed;
    _viewModel = [[FeedCommentListViewModel alloc] initWithFeed:feed];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.sections[section].rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FeedCommentListSectionModel *sectionModel = self.viewModel.sections[indexPath.section];
    FeedCommentListRowModel *rowModel = sectionModel.rows[indexPath.row];
    
    if (self.viewModel.sections.count - 6 == indexPath.section && !self.viewModel.isAllData) {
        [self.tableView.mj_footer beginRefreshing];
    }
    
    switch (rowModel.type) {
        case FeedCommentListFirstlyRowType: {
            
            FeedCommentCell *cell = [tableView xl_dequeueReusableCellWithClass:self.isFeedListSuperComment ? XLFeedListSuperCommentCell.class : FeedCommentCell.class forIndexPath:indexPath];
            cell.delegate = self;
            [cell configModelData:rowModel indexPath:indexPath];
            
            return cell;
        }
        case FeedCommentListSecondaryRowType: {

            FeedSecondaryCommentCell *cell = [tableView xl_dequeueReusableCellWithClass:FeedSecondaryCommentCell.class forIndexPath:indexPath];
            [cell configModelData:rowModel indexPath:indexPath];
            cell.delegate = self;
            
            return cell;
        }
        case FeedCommentListSecondaryUnfoldTipRowType: {
            
            FeedSecondaryCommentUnfoldTipCell *cell = [tableView xl_dequeueReusableCellWithClass:FeedSecondaryCommentUnfoldTipCell.class forIndexPath:indexPath];
            cell.delegate = self;

            cell.secondaryCommentTotalCount = sectionModel.secondaryCommentTotalCount;
            cell.isLoadMoreButtonShowDetail = sectionModel.secondaryCommentCount == 3;
            
            [cell configModelData:rowModel indexPath:indexPath];

            return cell;
        }
        case FeedCommentListSecondaryTopRowType: {
            
            return [tableView xl_dequeueReusableCellWithClass:FeedSecondaryCommentTopCell.class forIndexPath:indexPath];
            
        }
        case FeedCommentListSecondaryBottomRowType: {
            
            return [tableView xl_dequeueReusableCellWithClass:FeedSecondaryCommentBottomCell.class forIndexPath:indexPath];
        }
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FeedCommentListSectionModel *sectionModel = self.viewModel.sections[indexPath.section];
    FeedCommentListRowModel *rowModel = sectionModel.rows[indexPath.row];

    switch (rowModel.type) {
        case FeedCommentListFirstlyRowType: {
            
            if (self.isFeedListSuperComment) {
                if (self.feed.type.integerValue == XLFeedCellMultiPictureType) {
                    [StatServiceApi statEvent:IMAGE_BEST_COMMENT_CLICK model:self.feed otherString:rowModel.comment.commentId];
                } else {
                    [StatServiceApi statEvent:VIDEO_BEST_COMMENT_CLICK model:self.feed otherString:rowModel.comment.commentId];
                }
                if ([self.superCommentTarget respondsToSelector:self.superCommentAction]) {
                    MJRefreshMsgSend(MJRefreshMsgTarget(self.superCommentTarget), self.superCommentAction, self.view);
                }
                return;
            }
            [self feedCommentCell:[tableView cellForRowAtIndexPath:indexPath] replyRow:rowModel];
            
            break;
        }
        case FeedCommentListSecondaryRowType: {
            
            break;
        }
        case FeedCommentListSecondaryUnfoldTipRowType: {

            // do something ...

            break;
        }
        default: break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FeedCommentListRowModel *rowModel = self.viewModel.sections[indexPath.section].rows[indexPath.row];
    
    switch (rowModel.type) {
        case FeedCommentListFirstlyRowType: {
            return [tableView fd_heightForCellWithIdentifier:NSStringFromClass(self.isFeedListSuperComment ? XLFeedListSuperCommentCell.class : FeedCommentCell.class) cacheByKey:[rowModel.comment.commentId stringByAppendingString:[NSString stringWithFormat:@"%d", rowModel.isAllContent?1:0]] configuration:^(FeedCommentCell *cell) {
                [cell configModelData:rowModel indexPath:indexPath];
            }]+1;
        }
        case FeedCommentListSecondaryRowType: {
            return [tableView fd_heightForCellWithIdentifier:NSStringFromClass(FeedSecondaryCommentCell.class) cacheByKey:rowModel.comment.content configuration:^(FeedSecondaryCommentCell *cell) {
                [cell configModelData:rowModel indexPath:indexPath];
            }];
        }
        case FeedCommentListSecondaryUnfoldTipRowType: {
            return 34;
        }
        case FeedCommentListSecondaryTopRowType: {
            return 8;
        }
        case FeedCommentListSecondaryBottomRowType: {
            return 8 + 18;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.isFeedListSuperComment ? 0.01f : 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(adaptWidth750(64*2), 0, SCREEN_WIDTH - adaptWidth750(64*2) - adaptWidth750(40) , 0.5)];
    line.backgroundColor = [UIColor colorWithString:COLORE3E3E3];
    [view addSubview:line];
    
    if (self.isFeedListSuperComment) {
        if (self.viewModel.sections.count - 1 == section) {
            return nil;
        } else {
            line.x = 0;
            line.width = SCREEN_WIDTH;
        }
    }
    return view;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    XLLog(@"点击状态栏");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kdScrollToTopNotification" object:@1];
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

#pragma mark - FeedCommentListViewModelDelegate

- (void)viewModel:(FeedCommentListViewModel *)viewModel didAppendSections:(NSArray<FeedCommentListSectionModel *> *)sections {
    
    if (self.viewModel.isFirstFetch) {
        if (self.isAppointCommentScroll) {
            if (self.viewModel.isSpecialComment) {
                [self scrollAppointCommentWithCommentSections:sections];
                if (self.viewModel.specialSecondCommentId != nil && self.viewModel.specialSecondCommentId.length != 0 && !self.viewModel.isSpecialSecondComment) {
                    [MBProgressHUD showError:@"该回复已被删除"];
                }
            } else {
                [MBProgressHUD showError:@"该评论已被删除"];
            }
        }
    }
    
    if (sections == nil) {  //请求失败的逻辑
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    
    if (sections.count < 10) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        self.viewModel.isAllData = YES;
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
    
    [self.tableView reloadData];
    
    if (viewModel.sections.count == 0) {
        [self showEmptyDataView];
    }
}

#pragma mark - FeedCommentCellDelegate

- (void)feedCommentCell:(FeedCommentCell *)cell didSelectAvatarAndNicknameForRow:(FeedCommentListRowModel *)rowModel {
    
    [self showPublisherWithAuthorId:rowModel.comment.fromAuthorId];
}

- (void)feedCommentCell:(FeedCommentCell *)cell replyRow:(FeedCommentListRowModel *)rowModel {

    @weakify(self);
    [self showCommentKeyboardWithToAuthorName:rowModel.comment.fromName shortcutShowPhotos:NO completion:^(NSString *content, UIImage *picture, NSURL *pictureFileURL, BOOL isForward, void (^sendFinish)(BOOL isSuccess)) {
        @strongify(self);
        
        [self.viewModel replyCommentRow:rowModel content:content isForward:isForward success:^(NSArray<NSNumber *> *inserts, NSArray<NSNumber *> *deletes, NSArray<NSNumber *> *reloads) {
            @strongify(self);

            [self reloadSectionFromCell:cell inserts:inserts deletes:deletes reloads:reloads];
            
            sendFinish(YES);
            
            [MBProgressHUD showError:@"发送成功"];

        } failure:^(NSInteger errorCode) {
            
            sendFinish(NO);
            
            [MBProgressHUD showError:@"发送失败"];
            
        }];
    }];
}

- (void)feedCommentCell:(FeedCommentCell *)cell reportRow:(FeedCommentListRowModel *)rowModel {
    
    [self showReportWithRow:rowModel];
}

- (void)feedCommentCell:(FeedCommentCell *)cell deleteRow:(FeedCommentListRowModel *)rowModel {
    
    @weakify(self);
    [self showAlertWithTitle:nil message:@"是否确认删除？" actionTitles:@[@"取消", @"确认删除"] actionHandler:^(NSInteger index) {
        @strongify(self);
        
        if (index == 1) {
            [self.viewModel deleteFeedCommentWithModel:rowModel success:^(id responseDict) {
                
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:[self.tableView indexPathForCell:cell].section] withRowAnimation:UITableViewRowAnimationNone];
                [MBProgressHUD showError:@"删除成功"];
                
                if (self.viewModel.sections.count == 0) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        @strongify(self);
                        [self showEmptyDataView];
                    });
                }
                
            } failure:^(NSInteger errorCode) {
                
                [MBProgressHUD showError:@"删除评论失败"];
                
            }];
        }
    }];
    
}

- (void)feedCommentCell:(FeedCommentCell *)cell didSelectPraiseButton:(UIButton *)praiseButton forRow:(FeedCommentListRowModel *)rowModel {
    
    BOOL isPraise = praiseButton.selected;
    
    rowModel.comment.isPraise = isPraise;
    rowModel.comment.upNum = [NSString stringWithFormat:@"%ld", rowModel.comment.upNum.integerValue + (isPraise ? 1 : -1)];
    
    if (isPraise) {
        NSString *imageCommentStr;
        NSString *videoCommnetStr;
        if (rowModel.comment.bestComment) {
            imageCommentStr = IMAGE_BEST_COMMENT_LIKE;
            videoCommnetStr = VIDEO_BEST_COMMENT_LIKE;
        } else {
            imageCommentStr = IMAGE_COMMENT_LIKE;
            videoCommnetStr = VIDEO_COMMENT_LIKE;
        }
        [StatServiceApi statEvent:self.feed.type.integerValue == XLFeedCellMultiPictureType ? imageCommentStr : videoCommnetStr model:self.viewModel.feed otherString:rowModel.comment.commentId];
    }
    
    [self.viewModel praiseFeedCommentWithCommentId:rowModel.comment.commentId isPraise:praiseButton.isSelected success:^(id responseDict) {
        
    } failure:^(NSInteger errorCode) {
        
        [MBProgressHUD showError:@"点赞失败"];
        
    }];
}

- (void)feedCommentCell:(FeedCommentCell *)cell fullTextRow:(FeedCommentListRowModel *)rowModel {
    
    rowModel.isAllContent = YES;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)feedCommentCell:(FeedCommentCell *)cell didSelectContentImageView:(FLAnimatedImageView *)imageView forRow:(FeedCommentListRowModel *)rowModel {
    [StatServiceApi statEvent:COMMENT_IMAGE_CLICK model:self.viewModel.feed otherString:rowModel.comment.commentId];
    XLPhotoShowView *photoShowView = [[XLPhotoShowView alloc] initWithGroupItems:rowModel.comment.images];
    photoShowView.delegate = cell;
    photoShowView.isDetail = NO;
    photoShowView.newsModel = self.viewModel.feed;
    [photoShowView presentFromImageView:imageView toContainer:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
    
    if (self.viewModel.feed.type.integerValue == XLFeedCellMultiPictureType) {
        [StatServiceApi statEventBegin:IMAGE_COMMENT_BROWSER_DURATION model:self.viewModel.feed];
    } else {
        [StatServiceApi statEventBegin:VIDEO_COMMENT_BROWSER_DURATION model:self.viewModel.feed];
    }
}

- (void)feedCommentCell:(FeedCommentCell *)cell didDismissImageBrowserForRow:(FeedCommentListRowModel *)rowModel {
    self.viewModel.feed.isBottom = rowModel.comment.commentId;
    if (self.viewModel.feed.type.integerValue == XLFeedCellMultiPictureType) {
        [StatServiceApi statEventEnd:IMAGE_COMMENT_BROWSER_DURATION model:self.viewModel.feed];
    } else {
        [StatServiceApi statEventEnd:VIDEO_COMMENT_BROWSER_DURATION model:self.viewModel.feed];
    }
}

#pragma mark - FeedSecondaryCellDelegate

-(void)feedSecondaryCommenCell:(FeedSecondaryCommentCell *)cell nickNameDidClickWithAuthorID:(NSString *)authorID {
    [self showPublisherWithAuthorId:authorID];
}

- (void)feedSecondaryCommentCell:(FeedSecondaryCommentCell *)cell deletedWithRowModel:(FeedCommentListRowModel *)rowModel {
    
    @weakify(self);
    [self showAlertWithTitle:nil message:@"是否确认删除" actionTitles:@[@"取消",@"确认删除"] actionHandler:^(NSInteger index) {
        @strongify(self);
        
        if (index == 1) {
            
            [self.viewModel deleteSecondaryCommentWithModel:rowModel success:^(id responseDict) {
              
                [self reloadSectionFromCell:(UITableViewCell *)cell];
              
            } failure:^(NSInteger errorCode) {
                
                [MBProgressHUD showError:@"删除失败"];
                
            }];
        }
    }];
}

- (void)feedSecondaryCommentCell:(FeedSecondaryCommentCell *)cell reportedWithRowModel:(FeedCommentListRowModel *)rowModel {
    
    [self showReportWithRow:rowModel];
}

- (void)feedSecondaryCommentCell:(FeedSecondaryCommentCell *)cell replyWithRowModel:(FeedCommentListRowModel *)rowModel {
    
    @weakify(self);
    [self showCommentKeyboardWithToAuthorName:rowModel.comment.fromName shortcutShowPhotos:NO completion:^(NSString *content, UIImage *picture, NSURL *pictureFileURL, BOOL isForward, void (^sendFinish)(BOOL isSuccess)) {
        @strongify(self);
        
        [self.viewModel replyCommentRow:rowModel content:content isForward:isForward success:^(NSArray<NSNumber *> *inserts, NSArray<NSNumber *> *deletes, NSArray<NSNumber *> *reloads) {
            @strongify(self);
            
            [self reloadSectionFromCell:cell inserts:inserts deletes:deletes reloads:reloads];

            sendFinish(YES);
            
            [MBProgressHUD showError:@"发送成功"];

        } failure:^(NSInteger errorCode) {
            
            sendFinish(NO);
            
            [MBProgressHUD showError:@"发送失败"];

        }];
    }];
}

#pragma mark - FeedSecondaryUnFoldTipCellDelegate

- (void)feedSecondaryCommentCell:(FeedSecondaryCommentUnfoldTipCell *)cell loadMoreButtonDidClickWithRowModel:(FeedCommentListRowModel *)feedCommentListRowModel {

    [StatServiceApi statEvent:SECOND_COMMENT_LOAD_MORE model:nil otherString:feedCommentListRowModel.section.firstlyCommentRow.comment.commentId];
    
    @weakify(self);
    [self.viewModel loadMoreSecondaryMomentWithRowModel:feedCommentListRowModel success:^(NSArray<NSNumber *> *inserts, NSArray<NSNumber *> *deletes, NSArray<NSNumber *> *reloads) {
        @strongify(self);
        
        [self reloadSectionFromCell:cell inserts:inserts deletes:deletes reloads:reloads];
        [cell stopLoading];
        
    } failure:^(NSInteger errorCode) {
        
        [cell stopLoading];
        [MBProgressHUD showError:@"数据加载失败"];

    }];
}

#pragma mark - Public

- (void)showCommentKeyboardShortcutShowPhotos:(BOOL)shortcutShowPhotos {
    
    @weakify(self);
    [self showCommentKeyboardWithToAuthorName:nil shortcutShowPhotos:shortcutShowPhotos completion:^(NSString *content, UIImage *picture, NSURL *pictureFileURL, BOOL isForward, void (^sendFinish)(BOOL isSuccess)) {
        @strongify(self);
        
        [self.viewModel commentFeedWithContent:content picture:picture pictureFileURL:pictureFileURL isForward:isForward success:^(id responseDict) {
            @strongify(self);
            
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            
            sendFinish(YES);
            
            [MBProgressHUD showError:@"发送成功"];
            
            if (self.commentSuccessBlock) {
                self.commentSuccessBlock();
            }
            
            [XLEmptyDataView hideEmptyDataInView:self.tableView];
            self.tableView.tableFooterView = [UIView new];
            [self setFreshControl];
            if (self.viewModel.sections.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        } failure:^(NSInteger errorCode) {
            
            sendFinish(NO);
            
            [MBProgressHUD showError:@"发送失败"];

        }];
    }];
}

#pragma mark - Private

- (void)reloadSectionFromCell:(UITableViewCell *)cell inserts:(NSArray<NSNumber *> *)inserts deletes:(NSArray<NSNumber *> *)deletes reloads:(NSArray<NSNumber *> *)reloads {
    
    NSInteger section = [self.tableView indexPathForCell:cell].section;
    
    NSArray<NSIndexPath *> *insertRows = [inserts mapObjectsUsingBlock:^id(NSNumber *obj, NSUInteger idx) {
        return [NSIndexPath indexPathForRow:obj.integerValue inSection:section];
    }];
    
    NSArray<NSIndexPath *> *deleteRows = [deletes mapObjectsUsingBlock:^id(NSNumber *obj, NSUInteger idx) {
        return [NSIndexPath indexPathForRow:obj.integerValue inSection:section];
    }];
    
    NSArray<NSIndexPath *> *reloadRows = [reloads mapObjectsUsingBlock:^id(NSNumber *obj, NSUInteger idx) {
        return [NSIndexPath indexPathForRow:obj.integerValue inSection:section];
    }];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:insertRows withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView deleteRowsAtIndexPaths:deleteRows withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:reloadRows withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)reloadSectionFromCell:(UITableViewCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                  withRowAnimation:UITableViewRowAnimationNone];
}

- (void)showCommentKeyboardWithToAuthorName:(NSString *)toAuthorName shortcutShowPhotos:(BOOL)shortcutShowPhotos completion:(FeedCommentKeyboardCompletion)completion {
    
    if (!self.viewModel.feed.allowComment) {
        [MBProgressHUD showError:@"抱歉，该内容的评论功\n能已关闭"];
        return;
    }
    
    [StatServiceApi statEvent:COMMENT_KEYBOARD_SHOW];
    
    FeedCommentKeyboardViewController *vc = [FeedCommentKeyboardViewController xibViewController];
    
    vc.completion = completion;
    vc.toAuthorName = toAuthorName;
    vc.shortcutShowPhotos = shortcutShowPhotos;
    
    XLDimmingPresentationController *pc = [[XLDimmingPresentationController alloc] initWithPresentedViewController:vc presentingViewController:self];
    
    vc.transitioningDelegate = pc;
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)showPublisherWithAuthorId:(NSString *)authorId {
    
    PublisherViewController *publishVC = [PublisherViewController new];
    publishVC.publisherId = authorId;
    [self.navigationController pushViewController:publishVC animated:YES];
    XLPublisherModel *model = [XLPublisherModel new];
    model.authorId = authorId;
    [StatServiceApi statEvent:PERSONPAGE_CLICK model:model otherString:@"1"];
}

- (void)showEmptyDataView {
    
    @weakify(self);
    [self showEmpty:^(UIView *inView, CGFloat offset, CGFloat titleOffset) {
        [XLEmptyDataView showEmptyDataInView:inView withTitle:@"暂无评论，点击抢沙发" imageStr:@"detailpage_comment_sofa" offSet:offset titleOffSet:titleOffset tapAction:^{
            @strongify(self);
            [self showCommentKeyboardShortcutShowPhotos:NO];
        }];
    }];
}

- (void)showCloseCommentView {
    
    @weakify(self);
    [self showEmpty:^(UIView *inView, CGFloat offset, CGFloat titleOffset) {
        [XLEmptyDataView showEmptyDataInView:inView withTitle:@"该内容的评论功能已关闭" imageStr:@"detailpage_comment_close" offSet:offset titleOffSet:titleOffset tapAction:^{
            @strongify(self);
            [self showCommentKeyboardShortcutShowPhotos:NO];
        }];
    }];
    self.tableView.mj_footer = nil;
}

- (void)showEmpty:(void (^)(UIView *inView, CGFloat offset, CGFloat titleOffset))parameter {
    
    UIView *inView = self.tableView;
    CGFloat offset = -adaptHeight1334(340);
    CGFloat titleOffset = -adaptHeight1334(40);
    
    if (parameter) {
        parameter(inView, offset, titleOffset);
    }
}

- (void)showReportWithRow:(FeedCommentListRowModel *)row {
    XLReportSheetAlertViewController *vc = [[XLReportSheetAlertViewController alloc] init];
    [vc presentSheetAlertViewController:self itemID:row.comment.commentId type:row.type complete:^{
        
    }];
}

- (void)scrollAppointCommentWithCommentSections:(NSArray *)sections {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //通过神评数量判断滚动位置
        NSInteger superCommentCount = self.viewModel.feed.bestComment.count;
        if (sections.count > superCommentCount) {
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:superCommentCount];
            
            if (path.section == 0) {
                [self animateWithFeedCommentCell:[self.tableView cellForRowAtIndexPath:path] delay:0];
                return;
            }
            
            if (self.commentRequestBlock) self.commentRequestBlock();
            
            [self.tableView scrollToRowAtIndexPath:path atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self animateWithFeedCommentCell:[self.tableView cellForRowAtIndexPath:path] delay:0];
            });
        }
    });
}

- (void)animateWithFeedCommentCell:(FeedCommentCell *)cell delay:(NSTimeInterval)delay {
    //从收到评论点击评论进入时，对应评论展示动画，用于提示用户
    [UIView animateWithDuration:1 delay:delay options:0 animations:^{
        cell.backgroundColor = [UIColor colorWithString:COLORE3E3E3];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            cell.backgroundColor = [UIColor whiteColor];
        }];
    }];
}

#pragma mark - Custom Accessors

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;

        [_tableView xl_registerClass:FeedCommentCell.class];
        [_tableView xl_registerClass:FeedSecondaryCommentCell.class];
        [_tableView xl_registerClass:FeedSecondaryCommentUnfoldTipCell.class];
        [_tableView xl_registerClass:FeedSecondaryCommentTopCell.class];
        [_tableView xl_registerClass:FeedSecondaryCommentBottomCell.class];
        [_tableView xl_registerClass:XLFeedListSuperCommentCell.class];
        
    }
    return _tableView;
}

- (FeedCommentListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [FeedCommentListViewModel new];
        _viewModel.delegate = self;
    }
    return _viewModel;
}

@end
