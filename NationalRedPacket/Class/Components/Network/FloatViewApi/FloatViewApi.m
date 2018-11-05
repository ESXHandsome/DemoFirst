//
//  FloatViewApi.m
//  NationalRedPacket
//
//  Created by Ying on 2018/3/27.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "FloatViewApi.h"
#import "FloatViewRequestURL.h"

@implementation FloatViewApi
+ (void)fetchFloatViewConfigSuccess:(SuccessBlock)success failure:(FailureBlock)failure{
    [self httpRequestWithURL:URL_FETCH_FLOATVIEW_CONFIG
                   withParam:nil
                     success:^(id response) {
                         success(response);
                     } failure:^(NSInteger errorCode) {
                         failure(errorCode);
                     }];
}
+ (void)fetchFloatViewClickSuccess:(SuccessBlock)success failure:(FailureBlock)failure{
    [self httpRequestWithURL:URL_FETCH_FLOATVIEW_CLICK
                   withParam:nil
                     success:^(id response) {
                         success(response);
                     } failure:^(NSInteger errorCode) {
                         failure(errorCode);
                     }];
}
@end
