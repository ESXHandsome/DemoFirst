
//
//  FeedBackApi.h
//  NationalRedPacket
//
//  Created by 王海玉 on 2017/9/21.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNetApi.h"

@interface FeedBackApi : BaseNetApi

+ (void)feedBackWithOpinion:(NSString *)opinion
                    success:(SuccessBlock)success
                    failure:(FailureBlock)failure;

+ (void)feedBackWithOpinion:(NSString *)opinion
                     Number:(NSString *)number
                    success:(SuccessBlock)success
                    failure:(FailureBlock)failure;

@end

