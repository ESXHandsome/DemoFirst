//
//  NewsTableViewController.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/1/24.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLFeedModel.h"
#import "XLPublisherModel.h"
#import "BaseFeedListViewModel.h"
#import "NegativeFeedbackView.h"

@interface BaseFeedListViewController : UIViewController <NegativeFeedbackDelegate>

/// 视图模型，在子类 configureViewModel 方法中设置
@property (strong, nonatomic) __kindof BaseFeedListViewModel *viewModel;

/// 表视图
@property (strong, nonatomic, readonly) UITableView *tableView;

/// 是否进入时自动刷新，子类重载，默认为 YES
@property (assign, nonatomic, readonly) BOOL isAutoRefreshForFirstTime;

/// 是否需要刷新时需要顶部提示，子类重载，默认为 NO
@property (assign, nonatomic, readonly) BOOL isNeedTopTip;

/// 是否需要顶部下拉刷新控件，子类重载，默认为 NO
@property (assign, nonatomic, readonly) BOOL isNeedRefreshHeader;

/// 是否需要右下角刷新悬浮控件，子类重载，默认为 NO
@property (assign, nonatomic, readonly) BOOL isNeedRefreshFloat;

/// 加载视图偏移量，子类重载，默认为 0
@property (assign, nonatomic, readonly) CGFloat loadingViewOffset;

/// 加载失败视图偏移量，子类重载，默认为 0
@property (assign, nonatomic, readonly) CGFloat loadFailViewOffset;

/// 空数据视图偏移量，子类重载，默认为 0
@property (assign, nonatomic, readonly) CGFloat emptyViewOffset;

/// 表视图原点 y，子类重载，默认为 导航栏高度
@property (assign, nonatomic, readonly) CGFloat tableViewOriginY;

/// 表视图高度，子类重载，默认为 控制器高度减导航栏高度
@property (assign, nonatomic, readonly) CGFloat tableViewHeight;

/// 表头视图高度，子类重载，默认为 0
@property (assign, nonatomic, readonly) CGFloat tableHeaderViewHeight;

/// 空数据视图标题，子类重载，默认为 @""
@property (strong, nonatomic, readonly) NSString *emptyTitle;

/// 空数据视图图片，子类重载，默认为 nil
@property (strong, nonatomic, readonly) NSString *emptyImageName;

/**
 子类必须重载，并设置 ViewModel
 */
- (void)configureViewModel;

/**
 视频自动播放

 @param isCheckVisible 是否跳过检查可见
 */
- (void)autoPlayVideoWithVisibleCheck:(BOOL)isCheckVisible;

/**
 点击 Cell 点赞按钮事件，供子类重写自定义行为

 @param model 对应的信息流模型
 */
- (void)didClickCellPraiseButtonEvent:(XLFeedModel *)model;

/**
 显示空视图，供子类调用
 */
- (void)showEmpty;

/**
 视图滚动，供子类重写自定义行为

 @param scrollView UIScrollView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

/**
 刷新某个索引的模型

 @param model 模型
 @param indexPath 索引
 */
- (void)reloadModel:(XLFeedModel *)model atIndexPath:(NSIndexPath *)indexPath;

/**
 配置 Cell，供子类重写自定义行为

 @param tableView 表视图
 @param indexPath 索引
 @return UITableViewCell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 手动吊起刷新视图,并正常播放视频和gif
 */
- (void)reloadData;

/**
 刷新失败处理重载
 */
- (void)showLoadFailed;

@end
