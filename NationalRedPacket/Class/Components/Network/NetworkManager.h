//
//  HttpRequest.h
//  YouHaveClass
//
//  Created by sunmingyue on 15/12/21.
//  Copyright © 2015年 sunmingyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define HTTP_RESPONSE_NIL 1

@interface NetworkManager : NSObject

@property (copy, nonatomic) NSString *netWorkTypeString;

/** 单例 */
+ (instancetype)shared;

- (NSURLSessionDataTask *)sendGETRequest: (NSString *)url
                          withParameters: (NSDictionary *)parameters
                                 success: (SuccessBlock)success
                                 failure: (FailureBlock)failure;

- (NSURLSessionDataTask *)sendPostRequest: (NSString *)url
                            withParamDict: (NSDictionary *)parameters
                                  success: (SuccessBlock)success
                                  failure: (FailureBlock)failure;

- (NSURLSessionDataTask *)sendPostRequest: (NSString *)url
                         withParameString: (NSString *)parameters
                                  success: (SuccessBlock)success
                                  failure: (FailureBlock)failure;

- (void)configNetworkMonitor;

@end
