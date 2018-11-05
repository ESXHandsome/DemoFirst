//
//  FloatViewApi.h
//  NationalRedPacket
//
//  Created by Ying on 2018/3/27.
//  Copyright © 2018年 孙明悦. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BaseNetApi.h"

@interface FloatViewApi : BaseNetApi
+ (void)fetchFloatViewConfigSuccess:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)fetchFloatViewClickSuccess:(SuccessBlock)success failure:(FailureBlock)failure;
@end
