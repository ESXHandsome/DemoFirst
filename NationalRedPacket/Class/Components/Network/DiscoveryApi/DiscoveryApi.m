
//
//  DiscoverApi.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/9.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "DiscoveryApi.h"
#import "DiscoveryRequestURL.h"

@implementation DiscoveryApi

+ (void)fetchPageCategoryListSuccess:(SuccessBlock)success
                             failure:(FailureBlock)failure
{
    [self httpRequestWithURL:URL_PAGECATEGORYLIST
                   withParam:nil
                     success:^(id response) {
                         success(response);
                     } failure:^(NSInteger errorCode) {
                         failure(errorCode);
                     }];
}

+ (void)fetchPageCategoryContentWithTitle:(NSString *)categoryTitle
                                     page:(NSString *)page
                                  Success:(SuccessBlock)success
                                  failure:(FailureBlock)failure
{
    [self httpRequestWithURL:URL_PAGECONTENT
                   withParam:@{@"name" : categoryTitle ?: @"",
                               @"p"    : page ?: @""
                               }
                     success:^(id response) {
                         success(response);
                     } failure:^(NSInteger errorCode) {
                         failure(errorCode);
                     }];
}

@end
