//
//  XLStartConfigApi.m
//  NationalRedPacket
//
//  Created by Ying on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLStartConfigApi.h"

@implementation XLStartConfigApi

#pragma mark -
#pragma mark - class method
+ (void)fetchStartConfig:(SuccessBlock)success failure:(FailureBlock)failure {
    [self httpRequestWithURL:URL_FETCH_START_CONFIG withParam:@{} success:success failure:failure];
}

@end
