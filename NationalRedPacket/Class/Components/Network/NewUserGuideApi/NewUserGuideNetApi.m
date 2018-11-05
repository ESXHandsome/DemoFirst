//
//  NewUserFuideNetApi.m
//  NationalRedPacket
//
//  Created by Ying on 2018/4/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "NewUserGuideNetApi.h"

@implementation NewUserGuideNetApi

+ (void)fetchStartPageSex:(NSInteger)sex
                  success:(SuccessBlock)success
                  failure:(FailureBlock)failure {
    [self httpRequestWithURL:URL_FETCH_START_PAGE
                   withParam:@{@"sex":[NSNumber numberWithInteger:sex]}
                     success:success
                     failure:failure];
}

+ (void)startPageFollowingList:(NSArray *)array
                         count:(NSInteger)count
                       success:(SuccessBlock)success
                       failure:(FailureBlock)failure {
    [self httpRequestWithURL:URL_START_PAGE_FOLLOWING
                   withParam:@{
                               @"authorList": [array yy_modelToJSONString],
                               @"authorCount":[NSNumber numberWithInteger:count]
                               }
                     success:success
                     failure:failure];
}
@end
