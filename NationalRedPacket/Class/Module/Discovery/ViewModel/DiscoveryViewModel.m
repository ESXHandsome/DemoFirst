//
//  DiscoverViewModel.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/9.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "DiscoveryViewModel.h"
#import "DiscoveryModel.h"
#import "NewsApi.h"

@implementation DiscoveryViewModel

- (void)fetchCategoryListSuccess:(SuccessBlock)success failure:(FailureBlock)failure
{
    [DiscoveryApi fetchPageCategoryListSuccess:^(id responseDict) {
        if (success) {
            self.categoryListArray = responseDict[@"list"];
            success(responseDict[@"list"]);
        }
    } failure:^(NSInteger errorCode) {
        if (failure) {
            failure(errorCode);
        }
    }];
}

@end
