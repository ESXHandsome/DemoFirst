//
//  FeedCommentListViewController.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/23.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedCommentListViewModel.h"
#import "FeedCommentKeyboardViewController.h"

@interface FeedCommentListViewController : UIViewController

@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) BOOL         canScroll;
@property (assign, nonatomic, getter=isFeedListSuperComment) BOOL feedListSuperComment;
@property (assign, nonatomic, getter=isRefreshAnimation)     BOOL refreshAnimation;
@property (assign, nonatomic, getter=isAppointCommentScroll) BOOL appointCommentScroll;
@property (copy, nonatomic) NSString *appointCommentId;
@property (copy, nonatomic) NSString *appointSecondCommentId;

@property (assign, nonatomic) NSMutableArray<XLFeedCommentModel *> *superCommentArray;
@property (strong, nonatomic) XLFeedModel                          *feed;
@property (weak, nonatomic)    id superCommentTarget;
@property (assign, nonatomic) SEL superCommentAction;

@property (copy, nonatomic) void(^commentRequestBlock)(void);
@property (copy, nonatomic) void(^commentSuccessBlock)(void);

/**
 初始化控制器实例

 @param feed 信息流实例
 @return 类型实例
 */
- (instancetype)initWithFeed:(XLFeedModel *)feed;
- (instancetype)init __attribute__((unavailable("请使用 initWithFeed")));
+ (instancetype)new __attribute__((unavailable("请使用 initWithFeed")));

/**
 显示评论键盘，发布一级评论
 */
- (void)showCommentKeyboardShortcutShowPhotos:(BOOL)shortcutShowPhotos;

//计算comment高度
- (CGFloat)feedListSuperCommentTotalHeight;

@end
