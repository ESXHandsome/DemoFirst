//
//  XLPublishApi.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/12.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLPublishApi.h"

@implementation XLPublishApi

+ (void)uploadPersonItem:(NSDictionary *)info success:(SuccessBlock)success failure:(FailureBlock)failure {
    [self httpRequestWithURL:URL_UPLOAD_PERSON_ITEM
                   withParam:info
                     success:^(id response) {
                         success(response);
                     } failure:^(NSInteger errorCode) {
                         failure(errorCode);
                     }];
}

+ (void)deletePersionItem:(NSDictionary *)info success:(SuccessBlock)success failure:(FailureBlock)failure {
    [self httpRequestWithURL:URL_DELETE_PERSON_ITEN withParam:info success:^(id responseDict) {
        
        success(responseDict);
    } failure:^(NSInteger errorCode) {
        failure(errorCode);
    }];
}
@end
