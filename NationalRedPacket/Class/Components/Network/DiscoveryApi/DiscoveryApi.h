//
//  DiscoverApi.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/9.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNetApi.h"

@interface DiscoveryApi : BaseNetApi

+ (void)fetchPageCategoryListSuccess:(SuccessBlock)success
                             failure:(FailureBlock)failure;

+ (void)fetchPageCategoryContentWithTitle:(NSString *)categoryTitle
                                     page:(NSString *)page
                                  Success:(SuccessBlock)success
                                  failure:(FailureBlock)failure;

@end
