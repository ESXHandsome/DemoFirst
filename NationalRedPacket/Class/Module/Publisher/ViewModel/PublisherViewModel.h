//
//  PublisherViewModel.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/11.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DiscoveryModel.h"
#import "XLPublisherDataSource.h"

typedef NS_ENUM(NSInteger, BannerType) {
    BannerTypeH5 = 0,
    BannerTypePublisherListRecommend = 1,
    BannerTypePublisherOwnRecommend  = 2
};

@protocol PublisherViewModelDelegate <NSObject>

- (void)dataSource:(XLDataSource *)dataSource reloadListForIndex:(NSInteger)index;
- (void)dataSource:(XLDataSource *)dataSource reloadCardForIndex:(NSInteger)index;

@end

@interface PublisherViewModel : NSObject

@property (copy, nonatomic) NSString *categoryTitle;

@property (weak, nonatomic) id <PublisherViewModelDelegate> delegate;

///顶部banner数据源
@property (strong, nonatomic) NSMutableArray<BannerModel *>    *bannerArray;
///卡片式发布者数据源
@property (strong, nonatomic) XLPublisherDataSource *publisherCardDataSource;
///发布者数据源
@property (strong, nonatomic) XLPublisherDataSource *publisherListDataSource;

///是否为精选内容（含banner及卡片式推荐）
@property (assign, nonatomic) BOOL           isChoiceness;
///是否是首次拉取
@property (assign, nonatomic) BOOL           isFirstFetch;
///是否已拉取完成发布者列表的所有数据
@property (assign, nonatomic) BOOL           isAllPublisherList;

/**
 初始化viewModel

 @param categoryTitle 分类标题
 @return viewModel
 */
- (instancetype)initWithCategoryTitle:(NSString *)categoryTitle;

/**
 获取banner点击跳转类型
 
 @param model bannerModel
 @return      bannerType
 */
- (BannerType)getBannerTypeWithModel:(BannerModel *)model;

/**
 获取分类内容
 
 @param success 成功返回（网络模型）
 @param failure 失败返回（错误码）
 */
- (void)fetchCategoryContentSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 关注某个人
 
 @param model 发布者model
 @param success 成功
 @param failure 失败
 */
- (void)followPublisherWithModel:(XLPublisherModel *)model success:(void (^)(BOOL))success failure:(FailureBlock)failure;

@end
