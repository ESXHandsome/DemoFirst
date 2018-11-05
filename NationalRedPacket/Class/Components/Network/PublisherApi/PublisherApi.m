//
//  PublisherApi.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/27.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "PublisherApi.h"
#import "PublisherRequestURL.h"

@implementation PublisherApi

+ (void)fetchPublisherInfoWithPublisherId:(NSString *)publisherId
                                  Success:(SuccessBlock)success
                                  failure:(FailureBlock)failure
{
    [self httpRequestWithURL:URL_PUBLISHER_INFO
                   withParam:@{@"authorId" : publisherId}
                     success:^(id response) {
                         success(response);
                     } failure:^(NSInteger errorCode) {
                         failure(errorCode);
                     }];
}

@end
