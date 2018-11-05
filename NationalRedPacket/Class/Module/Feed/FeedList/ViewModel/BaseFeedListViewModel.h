//
//  BaseFeedListViewModel.h
//  NationalRedPacket
//
//  Created by fensi on 2018/5/10.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLFeedDataSource.h"

@protocol BaseFeedListViewModelDelegate <NSObject>

- (void)refreshFinish:(BOOL)hasMore;
- (void)loadMoreFinish:(BOOL)hasMore;

- (void)reloadData;
- (void)reloadModel:(XLFeedModel *)model atIndexPath:(NSIndexPath *)indexPath;
- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (void)showLoading;
- (void)hideLoading;
- (void)showLoadFailed;
- (void)hideLoadFailed;
- (void)showEmpty;
- (void)hideEmpty;
- (void)showTipCount:(NSInteger)tipCount;
- (void)showErrorWithCode:(NSInteger)errorCode;

@end

@interface BaseFeedListViewModel : NSObject

/// 基类的委托
@property (weak, nonatomic) id<BaseFeedListViewModelDelegate> baseDelegate;

/// 数据源
@property (strong, nonatomic, readonly) XLFeedDataSource *dataSource;

/// 是否第一次刷新数据
@property (assign, nonatomic, readonly) BOOL isFirstRefresh;

/**
 重置并执行下拉刷新
 */
- (void)resetAndRefresh;

/**
 执行下拉刷新，子类重载
 */
- (void)refresh;

/**
 下拉刷新成功时调用
 
 @param feeds 信息流集合
 @param tipCount 提示数目
 */
- (void)refreshSuccess:(NSArray<XLFeedModel *> *)feeds
              tipCount:(NSInteger)tipCount;

/**
 下拉刷新失败时调用
 
 @param errorCode 错误码
 */
- (void)refreshFailure:(NSInteger)errorCode;

/**
 执行加载更多，子类重载
 */
- (void)loadMore;

/**
 加载更多成功时调用
 
 @param feeds 信息流集合，添加到当前集合末尾
 */
- (void)loadMoreSuccess:(NSArray<XLFeedModel *> *)feeds;

/**
 加载更多失败时调用
 
 @param errorCode 错误码
 */
- (void)loadMoreFailure:(NSInteger)errorCode;

/**
 点赞

 @param feed 信息流模型
 */
- (void)praise:(XLFeedModel *)feed;

/**
 踩
 
 @param feed 信息流模型
 */
- (void)tread:(XLFeedModel *)feed;

/**
 关注

 @param feed 信息流模型
 @param success 成功回调
 @param failure 失败回调
 */
- (void)follow:(XLFeedModel *)feed
       success:(void(^)(BOOL isToFollow))success
       failure:(FailureBlock)failure;

/**
 准备分享，分享弹窗前调用

 @param feed 信息流模型
 */
- (void)prepareShare:(XLFeedModel *)feed;

- (void)uploadNegativeFeedBackItemID:(XLFeedModel *)model content:(NSString *)content success:(void(^)(id obj, NSInteger index)) successBlock;

- (NSInteger)removeFeedModel:(XLFeedModel *)model;

- (void)deleteMyUploadFeed:(XLFeedModel *)model success:(void(^)(void))success;

@end
