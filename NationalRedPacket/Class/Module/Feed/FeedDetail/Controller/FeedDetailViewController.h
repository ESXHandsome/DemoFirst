//
//  ArticleDetailViewController.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/1/10.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedCommentSectionHeaderView.h"
#import "AllRecognizeTableView.h"
#import "FollowButton.h"
#import "FeedDetailViewModel.h"
#import "NavigationBarFollowView.h"
#import "BottomToolbarView.h"
#import "FeedCommentContentCell.h"

@protocol FeedDetailViewControllerDelegate <NSObject>

- (void)didClickDeleteButton;

@end


@interface FeedDetailViewController : UIViewController

@property (weak, nonatomic) id<FeedDetailViewControllerDelegate> delegate;

///是否直接滚动到评论处
@property (assign, nonatomic) BOOL shouldScrollToCommentView;
///进入的模型数据
@property (strong, nonatomic) FeedDetailViewModel *viewModel;
///进入个人主页
@property (assign, nonatomic) BOOL                 isEnterPersonal;

@property (strong, nonatomic) AllRecognizeTableView *tableView;

@property (strong, nonatomic) NavigationBarFollowView *navigationBarfollowView;

@property (strong, nonatomic) BottomToolbarView       *bottomToolbarView;
@property (strong, nonatomic) FeedCommentContentCell  *commentContentCell;

@property (assign, nonatomic) CGFloat               showFollowHeight;

@property (assign, nonatomic) CGFloat               videoOffsetHeight;

@property (assign, nonatomic) CGFloat               commentAreaHeight;

@property (assign, nonatomic) CGFloat               statSeparateHeight;


/**
 子类重载
 */
- (void)configHeaderView;

/**
 设置当前TableView是否可滚动

 @param isScroll 是否可滚动
 */
- (void)setTableViewScroll:(BOOL)isScroll;

/**
 正在滚动

 @param scrollView scrollView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

/**
 关注

 @param button 点击的按钮
 */
- (void)followButtonClick:(FollowButton *)button;

/**
 跳转发布者主页
 */
- (void)pushPublisherHomepage;

/**
 模型更新回调处理

 @param feed 模型
 */
- (void)feedModelDidUpdate:(XLFeedModel *)feed;

/**
 view 在屏幕范围
 
 @param view view
 @param number 范围值
 @return bool
 */
- (BOOL)screenAreaWithView:(UIView *)view number:(CGFloat)number;

- (void)updateNavigationBarFollowButton;

@end
