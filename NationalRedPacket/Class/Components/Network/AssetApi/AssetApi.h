//
//  AssetApi.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "BaseNetApi.h"

@interface AssetApi : BaseNetApi

+ (void)fetchIncomeListSuccess:(SuccessBlock)success
                       failure:(FailureBlock)failure;

+ (void)fetchIncomeBalanceSuccess:(SuccessBlock)success
                          failure:(FailureBlock)failure;

+ (void)fetchExchangeListSuccess:(SuccessBlock)success
                         failure:(FailureBlock)failure;

+ (void)fetchExchangeOptionSuccess:(SuccessBlock)success
                           failure:(FailureBlock)failure;

+ (void)doExchangeWithExchangeDicInfo:(NSMutableDictionary *)dicInfo
                              Success:(SuccessBlock)success
                              failure:(FailureBlock)failure;


@end
