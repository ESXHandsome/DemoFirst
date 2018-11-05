//
//  FirstLunchApi.h
//  NationalRedPacket
//
//  Created by Ying on 2018/4/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNetApi.h"

#define URL_FETCHSTARTPAGE URL_BASE@"/Item/fetchStartPage"
#define URL_STARTPAGEATTENTION   URL_BASE@"/Item/startPageAttention"

@interface FirstLaunchApi : BaseNetApi
+ (void)fetchStartPageSex:(NSInteger)sex
                  Success:(SuccessBlock)success
                  failure:(FailureBlock)failure;

+(void)startPageAttentionList:(NSArray *)array
                        count:(NSInteger)count
                      Success:(SuccessBlock)success
                      failure:(FailureBlock)failure;
@end
