//
//  AppDelegate.h
//  NationalRedPacket
//
//  Created by 孙明悦 on 2017/5/31.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "TimeLineTableViewController.h"
#import "SDRefresh.h"
#import "TimeLineTableHeaderView.h"
#import "TimeLineRefreshHeader.h"
#import "TimeLineRefreshFooter.h"
#import "TimeLineCell.h"
#import "TimeLineModel.h"
//#import "UITableView+SDAutoTableViewCellHeight.h"
#import "InputView.h"
#import "ShootViewController.h"
#import "PublishViewController.h"
#import "BaseNavigationController.h"
#import "SelectAlertView.h"
#import "PublishViewController.h"
#import "CameraRollViewController.h"
#import "TimeLineApi.h"
#import "TimeLineModel.h"
#import "DatabaseManager.h"
#import "RobotModel.h"
#import "NSDictionary+JSON.h"
#import "NIMWebViewController.h"
#import "FullTextViewController.h"

#define kTimeLineTableViewCellId @"TimeLineCell"

@interface TimeLineTableViewController () <SDTimeLineCellDelegate, UITextFieldDelegate,InputViewDelegate>

@property (nonatomic, strong) InputView *inputView;
@property (nonatomic, strong) NSIndexPath *currentEditingIndexPath;
@property (nonatomic, copy  ) NSString *commentToUser;
@property (nonatomic, assign) BOOL isReplayingComment;
@property (nonatomic, assign) BOOL shoudFetchDataFromRemote;// 最后一条拉取的数据在本地是否存在
@property (nonatomic, strong) NSMutableArray<TimeLineModel *> *timeLineDataArray;
@property (nonatomic, strong) TimeLineTableHeaderView *headerView;
@property (nonatomic, strong) TimeLineRefreshFooter *refreshFooter;
@property (nonatomic, strong) TimeLineRefreshHeader *refreshHeader;
@property (nonatomic, assign) CGFloat lastScrollViewOffsetY;
@property (nonatomic, assign) CGFloat totalKeybordHeight;

@end

@implementation TimeLineTableViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    [self createPublishButton];
    
    // 初始化tableview数据
    [self initTableViewData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupTextField];
    
    // 拉取远端数据
    [self fetchRemoteCircleData];
    
    // 下拉刷新
    [self addRefreshHeader];
    
    // 刷新头像和昵称
    [self.headerView refreshHeaderData];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.inputView removeFromSuperview];
}

- (void)dealloc
{
    [_refreshHeader removeFromSuperview];
    [_refreshFooter removeFromSuperview];
    [_inputView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Data handle

// 查询朋友圈本地数据
- (NSMutableArray<TimeLineModel *> *)loadDataFromDBWithTimestamp:(NSString *)timestamp
{
    return  [[DatabaseManager sharedInstance] queryTimeLineArrayByTimestamp:timestamp];
}

// 存储朋友圈到本地
- (void)saveTimeLineToLocalDB:(NSArray<TimeLineModel *> *)insertDataArray
{
    for (int i =0 ; i < insertDataArray.count; i++) {
        TimeLineModel *timelineModel = insertDataArray[i];
        NSDictionary *timelineDict = timelineModel.mj_keyValues;
        
        [[DatabaseManager sharedInstance] insertTimeLine:timelineModel.feedId
                                             feedContent:[timelineDict json]
                                               timestamp:timelineModel.timestamp];
    }
}

// 存储评论到本地
- (void)saveCommentToLocalDB:(NSArray<TimeLineModel *> *)insertDataArray
{
    for (int i =0 ; i < insertDataArray.count; i++) {
        TimeLineModel *timelineModel = insertDataArray[i];
        NSDictionary *timelineDict = timelineModel.mj_keyValues;
        if (![[DatabaseManager sharedInstance] queryCommentWithID:timelineModel.feedId]) {
            [[DatabaseManager sharedInstance] insertCommentWithFeedID:timelineModel.feedId
                                                          withContent:[timelineDict json]];
            return;
        }
        [[DatabaseManager sharedInstance] updataCommentWithFeedID:timelineModel.feedId withContent:[timelineDict json]];
    }
}

// 朋友圈在本地DB中是否存在
- (BOOL)checkLocalExistTimeLine:(TimeLineModel *)timelineModel
{
    return [[DatabaseManager sharedInstance] checkLocalExistFeedID:timelineModel.feedId];;
}

// 下拉刷新
- (void)fetchRemoteCircleData
{
    NSString *requestFeedID;
    
    if ([self.timeLineDataArray count] > 0) {
        TimeLineModel *model = self.timeLineDataArray[0];
        requestFeedID = model.feedId;
        [self updateLocalTimeLineTheLastTimestamp];
    } else {
        requestFeedID = @"0";
    }

    __weak typeof(self) weakSelf = self;
    __weak typeof(_refreshHeader) weakHeader = _refreshHeader;
    
    [TimeLineApi fetchNewCircleWithFeedId:requestFeedID
                                         success:^(NSArray<TimeLineModel *> *dataArray) {

                                             UITabBar *tabBar = [(UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController tabBar];
                                             [tabBar hideBadgeOnItemIndex:1]; //隐藏
                                             
                                             [weakHeader endRefreshing];
                                             
                                             if (dataArray.count > 0) {

                                                 // 存储朋友圈到本地
                                                 [weakSelf saveTimeLineToLocalDB:dataArray];
                                                 
                                                 NSMutableArray *tempMutableArray = [[NSMutableArray alloc] init];
                                                 [tempMutableArray addObjectsFromArray:dataArray];
                                                 [tempMutableArray addObjectsFromArray:weakSelf.timeLineDataArray];
                                                 weakSelf.timeLineDataArray = tempMutableArray;

                                                 [weakSelf updateLocalTimeLineTheLastTimestamp];

                                                 [weakSelf.tableView reloadData];

                                                 weakSelf.shoudFetchDataFromRemote = [self checkLocalExistTimeLine:dataArray[dataArray.count - 1]];
                                             }

                                         } failure:^(NSInteger errorCode) {
                                             
                                             [weakHeader endRefreshing];

                                         }];
}

// 刷新评论
- (void)fetchRemoteCommentData
{
    __weak typeof(self) weakSelf = self;
    
    NSMutableArray *feedIDArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.timeLineDataArray.count; i++) {
        TimeLineModel *model = self.timeLineDataArray[i];
        [feedIDArray addObject:model.feedId];
    }
    if (feedIDArray.count > 0) {
        [TimeLineApi fetchCommentWithFeedIds:feedIDArray
                                            success:^(NSArray<TimeLineModel *> *dataArray) {
                                                
                                                if (dataArray.count > 0) {
                                                    // 存储评论到本地
                                                    [weakSelf saveCommentToLocalDB:dataArray];
                                                    
                                                    // 将数据源中的评论替换
                                                    [weakSelf replaceLocalCommentData:dataArray];
                                                    
                                                    [weakSelf.tableView reloadData];
                                                }
                                                
                                            } failure:^(NSInteger errorCode) {
                                                
                                            }];
    }
}

// 用评论表中的数据替换朋友圈中的评论数据
- (void)replaceLocalCommentData:(NSArray *)commentArray
{
    __weak typeof(self) weakSelf = self;

    NSMutableArray *tempTimeLineModelMarry = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < weakSelf.timeLineDataArray.count; i ++) {
        
        TimeLineModel *model = weakSelf.timeLineDataArray[i];
        TimeLineModel *commentModelInDB = [[DatabaseManager sharedInstance] queryCommentWithID:model.feedId];;
        model.likeItemsArray = commentModelInDB.likeItemsArray;
        model.commentItemsArray = commentModelInDB.commentItemsArray;
        [tempTimeLineModelMarry addObject:model];
    }
    weakSelf.timeLineDataArray = tempTimeLineModelMarry;
}

// 上拉加载远端数据
- (void)fetchDownCircle
{
    NSString *requestFeedID;
    
    if ([self.timeLineDataArray count] > 0) {
        TimeLineModel *model = self.timeLineDataArray[self.timeLineDataArray.count - 1];
        requestFeedID = model.feedId;
    } else {
        requestFeedID = @"0";
    }
    __weak typeof(self) weakSelf = self;
    __weak typeof(_refreshFooter) weakRefreshFooter = _refreshFooter;
    
    [TimeLineApi fetchDownCircleWithFeedId:requestFeedID
                                          success:^(NSArray<TimeLineModel *> *dataArray) {
                                              
                                              [weakRefreshFooter endRefreshing];

                                              if (dataArray.count < 20) {
                                                  [_refreshFooter removeFromSuperview];;
                                              }
                                              [weakSelf saveTimeLineToLocalDB:dataArray];
                                              
                                              [weakSelf.timeLineDataArray addObjectsFromArray:dataArray];
                                              
                                              if (dataArray.count > 0) {
                                                  [weakSelf.tableView reloadData];
                                              }
                                              
                                          } failure:^(NSInteger errorCode) {
                                              [weakRefreshFooter endRefreshing];
                                          }];
}

// 提交评论数据
- (void)commentWithCircleModel:(TimeLineCommentItemModel *)commentItemModel
{
    [TimeLineApi commentWithCircleModel:commentItemModel
                                       success:^(NSDictionary *responseDict) {
                                           if ([responseDict[@"result"] integerValue] == 1) {
                                               //[MBProgressHUD showError:@"已经赞过啦"];
                                           }
                                       } failure:^(NSInteger errorCode) {
                                           
                                       }];
}

// 下拉刷新
- (void)addRefreshHeader
{
    if (!_refreshHeader.superview) {
        
        _refreshHeader = [TimeLineRefreshHeader refreshHeaderWithCenter:CGPointMake(40, 45)];
        _refreshHeader.scrollView = self.tableView;
        __weak typeof(self) weakSelf = self;
        [_refreshHeader setRefreshingBlock:^{
            [weakSelf fetchRemoteCircleData];
        }];
        [self.tableView.superview addSubview:_refreshHeader];
    } else {
        [self.tableView.superview bringSubviewToFront:_refreshHeader];
    }
}

// 上拉加载更多
- (void)addRefreshFooter
{
    // 上拉加载
    _refreshFooter = [TimeLineRefreshFooter refreshFooterWithRefreshingText:@"正在加载数据"];
    
    __weak typeof(self) weakSelf = self;
    
    __weak typeof(_refreshFooter) weakRefreshFooter = _refreshFooter;
    
    [_refreshFooter addToScrollView:self.tableView refreshOpration:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (weakSelf.timeLineDataArray.count == 0) {
                [weakRefreshFooter endRefreshing];
                weakRefreshFooter.hidden = YES;
                return;
            }
            // 需要拉取远端数据
            if (weakSelf.shoudFetchDataFromRemote) {
                [weakSelf fetchDownCircle];
                return;
            }
            // 最后一条朋友圈模型
            TimeLineModel *model = weakSelf.timeLineDataArray[weakSelf.timeLineDataArray.count - 1];
            
            // 拉取本地数据
            NSArray *moreTimelineDataArray = [weakSelf loadDataFromDBWithTimestamp:model.timestamp];

            // 用评论表中的数据替换朋友圈中的评论数据
            [weakSelf replaceLocalCommentData:moreTimelineDataArray];
            
            // 拉取远端评论
            [weakSelf fetchRemoteCommentData];
            
            // 本地数据不足20条，拉取远端数据
            if (moreTimelineDataArray.count < TIME_LINE_ONCE_LOAD_COUNT) {
                [weakSelf fetchDownCircle];
            } else {
                [weakSelf.timeLineDataArray addObjectsFromArray:moreTimelineDataArray];
                [weakSelf.tableView reloadData];
                [weakRefreshFooter endRefreshing];
            }
        });
    }];
}

// 初始化tableview数据
- (void)initTableViewData
{
    self.timeLineDataArray = [self loadDataFromDBWithTimestamp:[Device timestamp]];
  
    // 用评论表中的数据替换朋友圈表中的评论数据
    [self replaceLocalCommentData:self.timeLineDataArray];

    // 第一次进入页面，拉取远端评论
    [self fetchRemoteCommentData];
    
    // tableview头视图
    _headerView = [TimeLineTableHeaderView new];
    _headerView.frame = CGRectMake(0, 0, 0, 260);
    self.tableView.tableHeaderView = _headerView;
    
    //上拉加载更多
    [self addRefreshFooter];
    
    // tableview注册cell
    [self.tableView registerClass:[TimeLineCell class] forCellReuseIdentifier:kTimeLineTableViewCellId];
}

// 更新本地存储的最新朋友圈的时间戳
- (void)updateLocalTimeLineTheLastTimestamp
{
    __weak typeof(self) weakSelf = self;
    
    if ([weakSelf.timeLineDataArray count] > 0) {
        TimeLineModel *model = weakSelf.timeLineDataArray[0];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:model.timestamp forKey:@"TimeLineTheLastTimestamp"];
    }
}

#pragma mark - UI handle

- (void)setupTextField
{
    _inputView = [InputView new];
    _inputView.delegate = self;
    _inputView.backgroundColor = [UIColor colorWithString:COLORF5F5F6];
    [[UIApplication sharedApplication].keyWindow addSubview:_inputView];
}

#pragma mark - 发布
- (void)createPublishButton
{
    UIButton *pulishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pulishButton setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [pulishButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    pulishButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    pulishButton.frame = CGRectMake(0, 0, 44, 44);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:pulishButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerAction:)];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerAction:)];
    longPress.delaysTouchesEnded = NO;
    [pulishButton addGestureRecognizer:tap];
    [pulishButton addGestureRecognizer:longPress];
}

- (void)gestureRecognizerAction:(id)recognizer
{
    if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        
        SelectAlertView *selectView = [SelectAlertView new];
        [selectView showAlertResult:^(NSInteger index) {
            
            if (index == 0) {
                
                NSLog(@"相机");
                ShootViewController *shootVC = [ShootViewController new];
                BaseNavigationController *navc = [[BaseNavigationController alloc] initWithRootViewController:shootVC];
                shootVC.blcokImage = ^(UIImage *image) {
                    
                    [self pushPublishViewControllerOnlyText:NO imageArray:@[image].mutableCopy];
                    
                };
                [self presentViewController:navc animated:YES completion:nil];
            } else {
                
                NSLog(@"相册");
                CameraRollViewController *rollVC = [CameraRollViewController new];
                rollVC.currentNumber = 0;
                BaseNavigationController *navc = [[BaseNavigationController alloc] initWithRootViewController:rollVC];
                rollVC.blcokResult = ^(NSMutableArray *array) {
                    [self pushPublishViewControllerOnlyText:NO imageArray:array];
                };
                [self presentViewController:navc animated:YES completion:nil];
            }
        }];
        
    } else {
        
        if ([(UILongPressGestureRecognizer *)recognizer state] == UIGestureRecognizerStateBegan){
            // do something
            NSLog(@"长按");
            [self pushPublishViewControllerOnlyText:YES imageArray:nil];
        }
    }
    
}

/**
 跳转发布界面
 
 @param isOnlyText 是否只是文本
 @param imageArray 图片数组
 */
- (void)pushPublishViewControllerOnlyText:(BOOL)isOnlyText imageArray:(NSMutableArray *)imageArray
{
    PublishViewController *publishVC = [[PublishViewController alloc] init];
    if (!isOnlyText) {
        publishVC.imageArray = imageArray;
    }
    publishVC.isOnlyText = isOnlyText;
    BaseNavigationController *navc = [[BaseNavigationController alloc] initWithRootViewController:publishVC];
    [self presentViewController:navc animated:YES completion:nil];
}

#pragma mark - TableViewDelegateAndDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.timeLineDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeLineTableViewCellId];
    
    cell.indexPath = indexPath;
    
    __weak typeof(self) weakSelf = self;
    
    if (!cell.moreButtonClickedBlock) {
        // 全文点击
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
            TimeLineModel *model = weakSelf.timeLineDataArray[indexPath.row];
            model.isOpening = !model.isOpening;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        // 评论按钮点击
        [cell setDidClickCommentLabelBlock:^(NSString *commentToUser, CGRect rectInWindow, NSIndexPath *indexPath) {
            RobotModel *robot = [[DatabaseManager sharedInstance] queryRobotWithID:commentToUser];
            weakSelf.inputView.placeHolder.text = [NSString stringWithFormat:@"回复%@:", robot.nickname];
            weakSelf.currentEditingIndexPath = indexPath;
            [weakSelf.inputView.textField becomeFirstResponder];
            weakSelf.isReplayingComment = YES;
            weakSelf.commentToUser = commentToUser;
            [weakSelf adjustTableViewToFitKeyboardWithRect:rectInWindow];
        }];
        // 文本全文（1行文本）
        [cell setFullTextClickedBlock:^(NSString *content) {
            FullTextViewController *fullTextViewController = [[FullTextViewController alloc] init];
            fullTextViewController.content = content;
            [weakSelf.navigationController pushViewController:fullTextViewController animated:YES];
        }];
        cell.delegate = self;
    }
    
    TimeLineModel *model = self.timeLineDataArray[indexPath.row];
    RobotModel *robotModel = [[DatabaseManager sharedInstance] queryRobotWithID:model.accid];
    model.avatar = robotModel.avatar;
    model.name = robotModel.nickname;
    
    cell.model = model;
    
    //设置用于实现cell的frame缓存
//    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // cell自适应
    id model = self.timeLineDataArray[indexPath.row];
    return 0;
//    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[TimeLineCell class] contentViewWidth:kScreenWidth];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_inputView.textField resignFirstResponder];
    if (_inputView.frame.origin.y < kScreenHeight) {
        [_inputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view);
            make.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view);
            make.height.mas_equalTo(0);
        }];
        _inputView.hidden = YES;
    }
}

#pragma mark - SDTimeLineCellDelegate

- (void)didClickShareContent:(TimeLineModel *)model
{
    switch (model.timeLineType) {
        case article:[TalkingData trackEvent:CLICK_MOMENTS_ARTICLE]; break;
        case music:[TalkingData trackEvent:CLICK_MOMENTS_MUSIC]; break;
        case h5video:[TalkingData trackEvent:CLICK_MOMENTS_LINK]; break;
            
    }
    NIMWebViewController *webVC = [NIMWebViewController new];
    webVC.webUrl = model.picNamesArray.firstObject;
    [self showViewController:webVC sender:nil];
}

- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell
{
    [TalkingData trackEvent:CLICK_MOMENTS_COMMENT];
    self.inputView.placeHolder.text = @"评论";

    [_inputView.textField becomeFirstResponder];
    _currentEditingIndexPath = [self.tableView indexPathForCell:cell];
    [self adjustTableViewToFitKeyboard];
}

- (void)didClickLikeButtonInCell:(UITableViewCell *)cell
{
    [TalkingData trackEvent:CLICK_MOMENTS_LIKE];
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    TimeLineModel *model = self.timeLineDataArray[index.row];
    
    if (!model.isLiked) {
        
        // 构建评论模型
        NSDictionary *nimAccountDict = [ConstantManager sharedManager].nimAccount;
        NSString *myAccid = nimAccountDict[@"accid"];
       
        NSMutableArray *temp = [NSMutableArray arrayWithArray:model.likeItemsArray];
        [temp addObject:myAccid];
      
        model.isLiked = YES;
        model.likeItemsArray = [temp copy];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        });
        
        TimeLineCommentItemModel *commentItemModel = [[TimeLineCommentItemModel alloc] init];
        commentItemModel.feedId = model.feedId;
        commentItemModel.type = TimeLine_Type_Praise;
        commentItemModel.from = myAccid;
        commentItemModel.to = @"0";
        commentItemModel.content = @"";
        
        // 提交评论数据
        [self commentWithCircleModel:commentItemModel];
        
    } else {
        [MBProgressHUD showError:@"您已经赞过啦"];
    }
}

- (void)adjustTableViewToFitKeyboard
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_currentEditingIndexPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    [self adjustTableViewToFitKeyboardWithRect:rect];
}

- (void)adjustTableViewToFitKeyboardWithRect:(CGRect)rect
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - _totalKeybordHeight);
    
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    
    [self.tableView setContentOffset:offset animated:YES];
}

#pragma mark - UITextFieldDelegate

// 键盘return点击事件
- (void)inputViewShouldReturn:(NSString *)content {
    
    TimeLineModel *model = self.timeLineDataArray[_currentEditingIndexPath.row];
    NSMutableArray *temp = [NSMutableArray new];
    [temp addObjectsFromArray:model.commentItemsArray];
    
    TimeLineCommentItemModel *commentItemModel = [TimeLineCommentItemModel new];
    commentItemModel.type = TimeLine_Type_Comment;
    commentItemModel.feedId = model.feedId;
    
    NSDictionary *nimAccountDict = [ConstantManager sharedManager].nimAccount;
    NSString *myAccid = nimAccountDict[@"accid"];
    
    if (self.isReplayingComment) {
        commentItemModel.from = myAccid;
        commentItemModel.to = self.commentToUser;
        commentItemModel.content = content;
        
        self.isReplayingComment = NO;
    } else {
        commentItemModel.from = myAccid;
        commentItemModel.to = @"0";
        commentItemModel.content = content;
    }
    [temp addObject:commentItemModel];
    model.commentItemsArray = [temp copy];
    [self.tableView reloadRowsAtIndexPaths:@[_currentEditingIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    // 提交评论数据
    [self commentWithCircleModel:commentItemModel];
}

// 适配输入框
- (void)keyboardSizeToRect:(CGRect)rect adjustTableViewToFitKeyboard:(BOOL)adjustTableView
{
    UIView *view = [UIApplication sharedApplication].keyWindow;

    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        self.inputView.hidden = YES;
    } else {
        self.inputView.hidden = NO;
    }

    [_inputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(view.mas_bottom);
        make.height.mas_equalTo(rect.size.height + 44);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self.inputView layoutIfNeeded];
    }];
    
    if (adjustTableView) {
        CGFloat h = rect.size.height + 45;
        if (_totalKeybordHeight != h) {
            _totalKeybordHeight = h;
            [self adjustTableViewToFitKeyboard];
        }
    }
}

- (NSMutableArray<TimeLineModel *> *)timeLineDataArray
{
    if (!_timeLineDataArray) {
        _timeLineDataArray = [NSMutableArray new];
    }
    return _timeLineDataArray;
}

@end
