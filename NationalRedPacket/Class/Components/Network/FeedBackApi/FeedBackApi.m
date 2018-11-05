//
//  FeedBackApi.m
//  NationalRedPacket
//
//  Created by 王海玉 on 2017/9/21.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "FeedBackApi.h"
#import "FeedBackRequestURL.h"

@implementation FeedBackApi


/**
 投诉反馈

 @param opinion 反馈的意见
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)feedBackWithOpinion:(NSString *)opinion
                    Number:(NSString *)number
                    success:(SuccessBlock)success
                    failure:(FailureBlock)failure {
    NSDictionary *queryDict = @{@"content":[NSString replaceNil:opinion],
                                @"number":[NSString replaceNil:number],
                                @"source":@"4"};
    [self httpRequestWithURL:URL_FEEDBACK
                   withParam:queryDict
                     success:^(id responseDict) {
                         success(responseDict);
                     } failure:^(NSInteger errorCode) {
                         XLLog(@"返回的errorCode %ld",(long)errorCode);
                         failure(errorCode);
                     }];
}

+ (void)feedBackWithOpinion:(NSString *)opinion
                    success:(SuccessBlock)success
                    failure:(FailureBlock)failure {
    [self feedBackWithOpinion:opinion
                       Number:NULL
                      success:^(id responseDict) {
        
    } failure:^(NSInteger errorCode) {
        
    }];
}


@end
