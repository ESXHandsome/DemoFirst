//
//  PPSBaseDAO.h
//  NationalRedPacket
//
//  Created by 张子琦 on 28/01/2018.
//  Copyright © 2018 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPSDAOColumnScheme.h"

@class FMDatabase;

@protocol PPSDAOProtocol <NSObject>
@required
/**
 获取表名

 @return 表名
 */
- (NSString *)tableName;

/**
 获取表的列结构

 @return 表的列结构
 */
- (NSArray<PPSDAOColumnScheme *> *)columnSchemes;
@end

@interface PPSBaseDAO : NSObject <PPSDAOProtocol>
/// 数据库对象
@property (strong, nonatomic) FMDatabase *db;

/**
 类构造器，如果这个数据库中不存在这个表，那么会创建表和对应的结构
 子类继承时，必须实现 PPSDataSourceProtocol 协议，用于正确创建表结构
 
 @param db 初始化用的数据库，数据来自这个数据库
 @return 实例对象
 */
+ (instancetype)dataSourceInDatabase:(FMDatabase *)db;

@end
