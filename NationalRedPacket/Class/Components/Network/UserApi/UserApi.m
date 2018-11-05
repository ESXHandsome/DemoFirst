//
//  UserApi.m
//  NationalRedPacket
//
//  Created by 王海玉 on 2018/1/25.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "UserApi.h"
#import "UserRequestURL.h"

@implementation UserApi

+ (void)fetchFollowListAuthorId:(NSString *)authorId
                        Success:(SuccessBlock)success
                        failure:(FailureBlock)failure {
    if (!authorId) {
        [self httpRequestWithURL:URL_FOLLOWING
                       withParam:@{@"action":@"new"}
                         success:^(id response) {
                             success(response);
                         } failure:^(NSInteger errorCode) {
                             failure(errorCode);
                         }];
    } else {
        [self httpRequestWithURL:URL_FOLLOWING
                       withParam:@{@"action":@"old",
                                   @"authorId":authorId
                                   }
                         success:^(id response) {
                             success(response);
                         } failure:^(NSInteger errorCode) {
                             failure(errorCode);
                         }];
    }
}

+ (void)fetchUserListAuthorId:(NSString *)authorId
                      Success:(SuccessBlock)success
                      failure:(FailureBlock)failure{
    [self httpRequestWithURL:URL_USER withParam:@{} success:^(id responseDict) {
         success(responseDict);
    } failure:^(NSInteger errorCode) {
        failure(errorCode);
    }];
}

+ (void)getSignLuckyMoney:(SuccessBlock)success
                   failure:(FailureBlock)failure{
    [self httpRequestWithURL:URL_SIGNLUCKMONEY withParam:@{} success:^(id responseDict) {
        success(responseDict);
    } failure:^(NSInteger errorCode) {
        failure(errorCode);
    }];
}

+ (void)getShareLuckyMoney:(SuccessBlock)success
                   failure:(FailureBlock)failure{
    [self httpRequestWithURL:URL_SHARELICKMONEY withParam:@{} success:^(id responseDict) {
        success(responseDict);
    } failure:^(NSInteger errorCode) {
        failure(errorCode);
    }];
}


+ (void)uploadPersonInfo:(NSDictionary *)info
                 success:(SuccessBlock)success
                 failure:(FailureBlock)failure {
    [self httpRequestWithURL:URL_UPLOAD_PERSON_INFO withParam:info success:^(id responseDict) {
        success(responseDict);
    } failure:^(NSInteger errorCode) {
        failure(errorCode);
    }];
}

@end
