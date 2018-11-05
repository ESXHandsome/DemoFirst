//
//  HomeFollowFeedListViewModel.m
//  NationalRedPacket
//
//  Created by fensi on 2018/5/10.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "HomeFollowFeedListViewModel.h"
#import "NewsApi.h"
#import "XLGDTAdManager.h"

@implementation HomeFollowFeedListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self startFollowingCheckCountdown];
    }
    return self;
}

- (void)refresh {
    [self fetchFollowFeedsDataWithAction:@"down"];
    [StatServiceApi statEvent:USER_DOWN_FETCH];
}

- (void)loadMore {
    [self fetchFollowFeedsDataWithAction:@"up"];
    [StatServiceApi statEvent:USER_UP_FETCH];
}

- (void)fetchFollowFeedsDataWithAction:(NSString *)action {
    
    NSString *oldestItemID = @"0";
    NSString *latestItemID = @"0";
    
    if ([action isEqualToString:@"down"] && self.dataSource.elements.count > 0) {
        XLFeedModel *feedModel = self.dataSource.elements.firstObject;
        latestItemID = feedModel.transmissionID;
    } else if ([action isEqualToString:@"up"] && [self.dataSource.elements lastObject]) {
        XLFeedModel *model =  [self.dataSource.elements lastObject];
        oldestItemID = model.transmissionID;
    }
    
    [NewsApi fetchFollowFeedsWithItemID:oldestItemID ?: @"0" withLatestItemID:latestItemID ?: @"0" success:^(NSDictionary *response) {
        
        NSMutableArray *itemArray = [self insertAdsWithResponseDict:response];
        
        // 移除黑名单用户发布内容
        [XLUserManager.shared deleteUserFeedInBlacklist:itemArray];
        
        if ([action isEqualToString:@"up"]) {
            [self loadMoreSuccess:itemArray];
        } else {
            [self refreshSuccess:itemArray tipCount:[response[@"updateCount"] integerValue]];
            
            if (itemArray.count > 0) {
                [self.delegate hideDiscoverGuidance];
            } else {
                [self.baseDelegate showEmpty];
                [self.delegate showDiscoverGuidance];
            }
        }
        
        [self.delegate didChangedFollowingFeedState:NO];
        
    } failure:^(NSInteger errorCode) {
        
        if ([action isEqualToString:@"down"]) {
            [self refreshFailure:errorCode];
        } else {
            [self loadMoreFailure:errorCode];
        }
    }];
}

- (NSMutableArray *)insertAdsWithResponseDict:(NSDictionary *)response {
    NSMutableArray *modelDataArray = [NSArray yy_modelArrayWithClass:XLFeedModel.class json:response[@"item"]].mutableCopy;

    NSArray *nativeExpressArray = response[@"otherAds"];
    
    
    // 插入广告信息流item
    if (nativeExpressArray && [nativeExpressArray isKindOfClass:[NSArray class]]) {
        NSInteger shouldInsertAdCount;
        if (XLGDTAdManager.shared.followNativeExpressMArray.count > nativeExpressArray.count) {
            shouldInsertAdCount = nativeExpressArray.count;
        } else {
            shouldInsertAdCount = XLGDTAdManager.shared.followNativeExpressMArray.count;
        }
        
        for (int i = 0; i < shouldInsertAdCount; i ++) {
            XLFeedAdNativeExpressModel *nativeExpressModel = [XLFeedAdNativeExpressModel yy_modelWithJSON:nativeExpressArray[i]];
            
            XLFeedAdNativeExpressModel *expressModel = [XLGDTAdManager.shared getExpressAdWithNativeExpressType:NativeExpressTypeFollow];
            
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

- (void)startFollowingCheckCountdown {
    
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        
        [self followingNewFeedsCheckTimerEvent];
        [self startFollowingCheckCountdown];
    });
}

- (void)followingNewFeedsCheckTimerEvent {
    
    NSString *latestItemID;
    
    if (self.dataSource.elements.count > 0) {
        XLFeedModel *feedModel = self.dataSource.elements.firstObject;
        latestItemID = feedModel.transmissionID;
    } else {
        latestItemID = @"0";
    }
    
    [NewsApi fetchFollowFeedsWithItemID:@"0" withLatestItemID:latestItemID ?: @"0" success:^(NSDictionary *response) {
        if ([response[@"updateCount"] integerValue] > 0) {
            [self.delegate didChangedFollowingFeedState:YES];
        }
    } failure:^(NSInteger errorCode) {
        
    }];
}

@end
