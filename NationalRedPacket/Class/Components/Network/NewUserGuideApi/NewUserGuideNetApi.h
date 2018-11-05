//
//  NewUserFuideNetApi.h
//  NationalRedPacket
//
//  Created by Ying on 2018/4/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNetApi.h"

#define URL_FETCH_START_PAGE       URL_BASE@"/Item/fetchStartPage"
#define URL_START_PAGE_FOLLOWING   URL_BASE@"/Item/startPageAttention"

@interface NewUserGuideNetApi : BaseNetApi

+ (void)fetchStartPageSex:(NSInteger)sex
                  success:(SuccessBlock)success
                  failure:(FailureBlock)failure;

+ (void)startPageFollowingList:(NSArray *)array
                         count:(NSInteger)count
                       success:(SuccessBlock)success
                       failure:(FailureBlock)failure;
@end
