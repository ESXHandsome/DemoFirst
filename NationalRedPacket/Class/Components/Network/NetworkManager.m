
//
//  HttpRequest.h
//  YouHaveClass
//
//  Created by sunmingyue on 15/12/21.
//  Copyright © 2015年 sunmingyue. All rights reserved.
//

#import "AFNetworking.h"

@interface NetworkManager ()

@property (strong, nonatomic) AFHTTPSessionManager *manager;

@end

@implementation NetworkManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{ sharedInstance = [self new]; });
    return sharedInstance;
}

- (AFHTTPSessionManager *)manager:(NSString *)url {
    
    AFHTTPSessionManager *manager = self.manager;
    
    manager.requestSerializer.timeoutInterval = 10;
    
    NSMutableSet *acceptContentTypes = [NSMutableSet set];
    // 添加需要的类型
    acceptContentTypes.set = manager.responseSerializer.acceptableContentTypes;
    [acceptContentTypes addObject:@"text/html"];
    
    // 给acceptableContentTypes赋值
    manager.responseSerializer.acceptableContentTypes = acceptContentTypes;
    
    // 声明获取到的数据格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    return manager;
}

- (NSURLSessionDataTask *)sendGETRequest: (NSString *)url
                          withParameters: (NSDictionary *)parameters
                                 success: (SuccessBlock)success
                                 failure: (FailureBlock)failure {
    
    AFHTTPSessionManager  *manager = [self manager:url];
    
    NSURLSessionDataTask *task1 = [manager GET:url
                                    parameters:parameters
                                      progress:^(NSProgress * _Nonnull downloadProgress) {
                                          
                                      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                          
                                          if (responseObject) {
                                              success(responseObject);
                                              return;
                                          }
                                          failure(HTTP_RESPONSE_NIL);
                                          
                                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                                          failure(error.code);
                                      }];
    
    return task1;
}

- (NSURLSessionDataTask *)sendPostRequest: (NSString *)url
                            withParamDict: (NSDictionary *)parameters
                                  success: (SuccessBlock)success
                                  failure: (FailureBlock)failure {
    
    AFHTTPSessionManager  *manager = [self manager:url];
    
    NSURLSessionDataTask *task = [manager POST:url
                                    parameters:parameters
                                      progress:^(NSProgress * _Nonnull uploadProgress) { }
                                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                           
                                           NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                                        
                                           if (responseObject) {
                                               success(dict);
                                               return;
                                           }
                                           failure(HTTP_RESPONSE_NIL);
                                          
                                       }
                                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                           
                                           XLLog(@"[Server Error]: %@", error);
                                           failure(error.code);
                                       }];
    return task;
}

- (NSURLSessionDataTask *)sendPostRequest: (NSString *)url
                         withParameString: (NSString *)parameters
                                  success: (SuccessBlock)success
                                  failure: (FailureBlock)failure {
    
    AFHTTPSessionManager  *manager = [self manager:url];
    
    NSURLSessionDataTask *task = [manager POST:url
                                    parameters:parameters
                                      progress:^(NSProgress * _Nonnull uploadProgress) {

                                      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                          
                                          if (responseObject) {
                                              success(responseObject);
                                              return;
                                          }
                                          failure(HTTP_RESPONSE_NIL);
                                          
                                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                                          failure(error.code);
                                      }];
    return task;
}

- (void)configNetworkMonitor {
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                // 未知网络
                self.netWorkTypeString = XLAlertNetworkNotReachable;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                // 没有网络(断网)
                self.netWorkTypeString = XLAlertNetworkNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                // 手机自带网络
                self.netWorkTypeString = XLAlertNetworkWWAN;
                [[NSNotificationCenter defaultCenter] postNotificationName:XLNetworkChangedNotification
                                                                    object:self
                                                                  userInfo:nil];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                // WIFI
                self.netWorkTypeString = XLAlertNetworkWIFI;
                [[NSNotificationCenter defaultCenter] postNotificationName:XLNetworkChangedNotification
                                                                    object:self
                                                                  userInfo:nil];
                break;
        }
    }];
    
    [manager startMonitoring];
}

-(AFHTTPSessionManager *)manager{
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

@end

