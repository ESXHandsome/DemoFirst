//
//  BaseNetApi.h
//  NationalRedPacket
//
//  Created by 孙明悦 on 2017/6/2.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AES256.h"
#import "TokenNetApi.h"

@interface BaseNetApi : NSObject

/**
 *  发送数据请求
 *
 *  @param url 数据请求URL
 *  @param param 数据请求参数
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)httpRequestWithURL:(NSString *)url
                 withParam:(NSDictionary *)param
                   success:(SuccessBlock)success
                   failure:(FailureBlock)failure;
@end
