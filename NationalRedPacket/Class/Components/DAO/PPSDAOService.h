//
//  PPSDataSourceManager.h
//  NationalRedPacket
//
//  Created by 张子琦 on 28/01/2018.
//  Copyright © 2018 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPSHomeFeedDAO.h"
#import "PPSPublisherDAO.h"
#import "PPSHomeFeedDAO.h"

@interface PPSDAOService : NSObject

/**
 获取对应用户的 Manager
 
 @param userId 用户 ID
 @return 实例对象
 */
+ (instancetype)serviceForUser:(NSString *)userId;

/**
 获取用户的 Home Feed 数据源，Lazy load
 
 @return 数据源
 */
- (id<PPSHomeFeedDAOProtocol>)homeFeedDAO;

/**
 获取用户的 Publisher 数据源，Lazy load
 
 @return 数据源
 */
- (id<PPSPublisherDAOProtocol>)publisherDAO;

@end
