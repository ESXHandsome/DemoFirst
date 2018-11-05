//
//  PublisherViewModel.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/11.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "PublisherViewModel.h"
#import "DiscoveryApi.h"
#import "NewsApi.h"

@interface PublisherViewModel () <XLDataSourceDelegate>

@property (copy, nonatomic) NSString *pageNum;

@end

@implementation PublisherViewModel

- (instancetype)initWithCategoryTitle:(NSString *)categoryTitle
{
    self = [super init];
    if (self) {
        _publisherListDataSource = [[XLPublisherDataSource alloc] init];
        _publisherListDataSource.delegate = self;
        _publisherCardDataSource = [[XLPublisherDataSource alloc] init];
        _publisherCardDataSource.delegate = self;
        _categoryTitle = categoryTitle;
        _pageNum = @"0";
    }
    return self;
}

- (void)dataSource:(XLDataSource *)dataSource didChangedForIndex:(NSInteger)index {
    if (self.delegate == nil) {
        return;
    }
    
    if (dataSource == self.publisherListDataSource) {
        if ([self.delegate respondsToSelector:@selector(dataSource:reloadListForIndex:)]) {
            [self.delegate dataSource:dataSource reloadListForIndex:index];
        }
    } else if (dataSource == self.publisherCardDataSource) {
        if ([self.delegate respondsToSelector:@selector(dataSource:reloadCardForIndex:)]) {
            [self.delegate dataSource:dataSource reloadCardForIndex:index];
        }
    }
}

/**
 获取banner点击跳转类型
 
 @param model bannerModel
 @return      bannerType
 */
- (BannerType)getBannerTypeWithModel:(BannerModel *)model
{
    if ([model.type isEqualToString:@"h5"]) {
        return BannerTypeH5;
    } else if ([model.type isEqualToString:@"author_list"]) {
        return BannerTypePublisherListRecommend;
    } else if ([model.type isEqualToString:@"author"]) {
        return BannerTypePublisherOwnRecommend;
    }
    return BannerTypeH5;
}

/**
 获取分类内容
 
 @param success 成功返回（网络模型）
 @param failure 失败返回（错误码）
 */
- (void)fetchCategoryContentSuccess:(SuccessBlock)success failure:(FailureBlock)failure
{
    [DiscoveryApi fetchPageCategoryContentWithTitle:self.categoryTitle page:self.pageNum Success:^(id responseDict) {
        XLLog(@"%@", responseDict);
        DiscoveryModel *model = [DiscoveryModel yy_modelWithJSON:responseDict];
        self.pageNum = model.p;
        [self.publisherListDataSource addElementsFromArray:model.list];
        if (model.p.integerValue == 1) { // 第一次拉取的时候确定Header(只走一次)
            if (model.banner.count != 0) {
                self.isChoiceness = YES;
                self.bannerArray = model.banner.mutableCopy;
            }
            if (model.card.count != 0) {
                [self.publisherCardDataSource setElementsFromArray:model.card];
            }
            self.isFirstFetch = YES;
        } else {
            self.isFirstFetch = NO;
        }
        if (model.list.count == 0) {
            self.isAllPublisherList = YES;
        }
        if (success) {
            success(model.list);
        }
    } failure:^(NSInteger errorCode) {
        if (failure) {
            failure(self.pageNum.integerValue);
        }
    }];
}

/**
 关注某个人
 
 @param model 发布者model
 @param success 成功
 @param failure 失败
 */
- (void)followPublisherWithModel:(XLPublisherModel *)model success:(void (^)(BOOL))success failure:(FailureBlock)failure
{
    BOOL isToFollow = !model.isFollowed;

    [NewsApi followWithAuthorId:model.authorId action:!model.isFollowed success:^(id responseDict) {
        success(isToFollow);
    } failure:^(NSInteger errorCode) {
        failure(errorCode);
    }];
}

@end
