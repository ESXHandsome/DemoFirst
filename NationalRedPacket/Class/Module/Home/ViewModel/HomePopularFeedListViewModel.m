//
//  HomePopularFeedListViewModel.m
//  NationalRedPacket
//
//  Created by fensi on 2018/5/10.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "HomePopularFeedListViewModel.h"
#import "PPSDAOService.h"
#import "PPSHomeFeedDAO.h"
#import "NewsApi.h"
#import "GifPlayManager.h"
#import "XLGDTAdManager.h"

@interface HomePopularFeedListViewModel ()

@property (strong, nonatomic) id<PPSHomeFeedDAOProtocol> feedDAO;

@end

@implementation HomePopularFeedListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _feedDAO = [[PPSDAOService serviceForUser:XLLoginManager.shared.userId] homeFeedDAO];
    }
    return self;
}

- (void)refresh {
    
    [[SDImageCache sharedImageCache] clearMemory];
    [[GifPlayManager sharedManager] pauseGifCell];
    
    if (!self.isFirstRefresh) {
        [StatServiceApi statEvent:USER_DOWN_FETCH];
    }
    
    NSString *fetchAction = self.isFirstRefresh ? @"new" : @"down";
    @weakify(self);
    [NewsApi fetchNewItem:fetchAction
                  success:^(NSDictionary *response) {
                      
                      NSMutableArray *feeds = [self insertAdsWithResponseDict:response];
                      // 移除黑名单用户发布内容
                      [XLUserManager.shared deleteUserFeedInBlacklist:feeds];
                      
                      [self refreshSuccess:feeds tipCount:feeds.count];
                      
                      @strongify(self);
                      //插入到本地数据库
                      [self.feedDAO insertModels:[XLFeedModel transformXLFeedModelArray:feeds.mutableCopy]];
                      if ([self.feedDAO totalCountForRow] > 60) {
                          //删除旧数据
                          [self.feedDAO deleteModelsFromHead: [self.feedDAO totalCountForRow] - 60];
                      }
                      
                  } failure:^(NSInteger errorCode) {
                      
                      if (!XLLoginManager.shared.isVisitorLogined || self.isFirstRefresh) {
                          //查询数据库
                          NSArray *array = [self.feedDAO queryModelsFrom:0 offset:60];
                          
                          [self refreshSuccess:[XLFeedModel transformPPSDAOHomeFeedModelArray:array.mutableCopy] tipCount:errorCode];
                          
                          if (!XLLoginManager.shared.isVisitorLogined) {
                              [XLLoginManager.shared relogin:nil failure:nil]; //尝试一次登录
                          }
                          if (array.count == 0) {
                              [self.baseDelegate showLoadFailed];
                          }
                      } else {
                          [self refreshFailure:errorCode];
                      }
                  }];
}

- (NSMutableArray<XLFeedModel *> *)insertAdsWithResponseDict:(NSDictionary *)response {
    NSMutableArray *modelDataArray = [NSArray yy_modelArrayWithClass:XLFeedModel.class json:response[@"item"]].mutableCopy;

    // 插入广告信息流item
    if (response[@"ads"] &&
        [response[@"ads"] isKindOfClass:[NSArray class]]) {
        NSArray *adArray = response[@"ads"];
        for (int i = 0; i < adArray.count; i ++) {
            AdModel *adModel = [AdModel yy_modelWithJSON:adArray[i]];
            if (adModel.position > 0 && adModel.position < modelDataArray.count) {
                XLFeedModel *model = [XLFeedModel new];
                model.type = [NSString stringWithFormat:@"%li",(long)XLFeedCellADSimplePictureType];
                model.adModel =  adModel;
                [modelDataArray insertObject:model atIndex:adModel.position];
            }
        }
    }
    NSArray *nativeExpressArray = response[@"otherAds"];
    
    // 插入广告信息流item
    if (nativeExpressArray && [nativeExpressArray isKindOfClass:[NSArray class]]) {
        NSInteger shouldInsertAdCount;
        if (XLGDTAdManager.shared.hotNativeExpressMArray.count > nativeExpressArray.count) {
            shouldInsertAdCount = nativeExpressArray.count;
        } else {
            [XLGDTAdManager.shared fetchNativeExpressAd:NativeExpressTypeHot];
            shouldInsertAdCount = XLGDTAdManager.shared.hotNativeExpressMArray.count;
        }
        
        for (int i = 0; i < shouldInsertAdCount; i ++) {
            XLFeedAdNativeExpressModel *nativeExpressModel = [XLFeedAdNativeExpressModel yy_modelWithJSON:nativeExpressArray[i]];
            
            XLFeedAdNativeExpressModel *expressModel = [XLGDTAdManager.shared getExpressAdWithNativeExpressType:NativeExpressTypeHot];
            
            if (expressModel) {
                nativeExpressModel.expressAdView = expressModel.expressAdView;
                nativeExpressModel.fetchTimestamp = expressModel.fetchTimestamp;
                
                if (nativeExpressModel.position > 0 && nativeExpressModel.position < modelDataArray.count) {
                    XLFeedModel *model = [XLFeedModel new];
                    model.type = [NSString stringWithFormat:@"%li",(long)XLFeedCellAdNativeExpressType];
                    model.nativeExpressModel =  nativeExpressModel;
                    [modelDataArray insertObject:model atIndex:nativeExpressModel.position];
                }
            }
        }
    }
    return modelDataArray;
}

- (void)loadMore {
    [StatServiceApi statEvent:USER_UP_FETCH];
    [NewsApi fetchNewItem:@"up"
                  success:^(NSDictionary *response) {
                      NSMutableArray *feeds = [self insertAdsWithResponseDict:response];
                      // 移除黑名单用户发布内容
                      [XLUserManager.shared deleteUserFeedInBlacklist:feeds];
                      
                      [self loadMoreSuccess:feeds];
                  } failure:^(NSInteger errorCode) {
                      [self loadMoreFailure:errorCode];
                  }];
}

@end
