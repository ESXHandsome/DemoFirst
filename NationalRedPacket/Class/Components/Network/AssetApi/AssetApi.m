//
//  AssetApi.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "AssetApi.h"
#import "AssetRequestURL.h"

@implementation AssetApi

+ (void)fetchIncomeListSuccess:(SuccessBlock)success
                       failure:(FailureBlock)failure
{
    [self httpRequestWithURL:URL_INCOMELIST
                   withParam:nil
                     success:^(id response) {
                         success(response);
                     } failure:^(NSInteger errorCode) {
                         failure(errorCode);
                     }];
}

+ (void)fetchIncomeBalanceSuccess:(SuccessBlock)success
                          failure:(FailureBlock)failure
{
    [self httpRequestWithURL:URL_INCOMEBALANCE
                   withParam:nil
                     success:^(id response) {
                         success(response);
                     } failure:^(NSInteger errorCode) {
                         failure(errorCode);
                     }];
}

+ (void)fetchExchangeListSuccess:(SuccessBlock)success
                         failure:(FailureBlock)failure
{
    [self httpRequestWithURL:URL_EXCHANGELIST
                   withParam:nil
                     success:^(id response) {
                         success(response);
                     } failure:^(NSInteger errorCode) {
                         failure(errorCode);
                     }];
}

+ (void)fetchExchangeOptionSuccess:(SuccessBlock)success
                           failure:(FailureBlock)failure
{
    [self httpRequestWithURL:URL_EXCHANGEOPTION
                   withParam:nil
                     success:^(id response) {
                         success(response);
                     } failure:^(NSInteger errorCode) {
                         failure(errorCode);
                     }];
}

+ (void)doExchangeWithExchangeDicInfo:(NSMutableDictionary *)dicInfo
                              Success:(SuccessBlock)success
                              failure:(FailureBlock)failure
{
    [self httpRequestWithURL:URL_DOEXCHANGE
                   withParam:dicInfo
                     success:^(id response) {
                         success(response);
                     } failure:^(NSInteger errorCode) {
                         failure(errorCode);
                     }];
}

@end
