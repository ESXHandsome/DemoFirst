//
//  DiscoverViewModel.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/9.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DiscoveryApi.h"
#import "DiscoveryModel.h"

@interface DiscoveryViewModel : NSObject

///数据源
@property (strong, nonatomic) NSMutableArray<NSString *> *categoryListArray;

/**
获取主题队列

 @param success 成功返回 （数组）
 @param failure 失败返回 （错误码）
 */
- (void)fetchCategoryListSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

@end
