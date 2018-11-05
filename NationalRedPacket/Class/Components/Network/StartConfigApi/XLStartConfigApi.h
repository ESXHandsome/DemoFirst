//
//  XLStartConfigApi.h
//  NationalRedPacket
//
//  Created by Ying on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNetApi.h"

#define URL_FETCH_START_CONFIG  URL_BASE@"/User/fetchStartConfig"

@interface XLStartConfigApi : BaseNetApi

+ (void)fetchStartConfig:(SuccessBlock)success
                  failure:(FailureBlock)failure;

@end
