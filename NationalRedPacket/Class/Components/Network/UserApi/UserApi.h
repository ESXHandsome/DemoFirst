//
//  UserApi.h
//  NationalRedPacket
//
//  Created by 王海玉 on 2018/1/25.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNetApi.h"
#import "XLPublisherModel.h"

@interface UserApi : BaseNetApi

+ (void)fetchFollowListAuthorId:(NSString *)authorId
                      Success:(SuccessBlock)success
                      failure:(FailureBlock)failure;

+ (void)fetchUserListAuthorId:(NSString *)authorId
                        Success:(SuccessBlock)success
                        failure:(FailureBlock)failure;

+ (void)getSignLuckyMoney:(SuccessBlock)success
                  failure:(FailureBlock)failure;

+ (void)getShareLuckyMoney:(SuccessBlock)success
                  failure:(FailureBlock)failure;

+ (void)uploadPersonInfo:(NSDictionary *)info
                 success:(SuccessBlock)success
                 failure:(FailureBlock)failure;
@end
