
//
//  PPSDataSourceManager.m
//  NationalRedPacket
//
//  Created by 张子琦 on 28/01/2018.
//  Copyright © 2018 孙明悦. All rights reserved.
//

#import "PPSDAOService.h"
#import "PPSHomeFeedDAO.h"
#import "PPSPublisherDAO.h"

#import <FMDB/FMDB.h>

@interface PPSDAOService ()
/// 当前的用户 ID
@property (strong, nonatomic) NSString *userId;
/// 用户的数据库
@property (strong, nonatomic) FMDatabase *userDb;
/// 用户的 home feed 表
@property (strong, nonatomic) PPSHomeFeedDAO *homeFeedDAO;
/// 用户的 publisher 表
@property (strong, nonatomic) PPSPublisherDAO *publisherDAO;

@end

@implementation PPSDAOService

#pragma mark -
#pragma mark Initialization

/**
 获取对应用户的 Manager

 @param userId 用户 ID
 @return 实例对象
 */
+ (instancetype)serviceForUser:(NSString *)userId {
    return [[self alloc] initWithUserId:userId];
}

/**
 初始化

 @param userId 用户 ID
 @return 实例对象
 */
- (instancetype)initWithUserId:(NSString *)userId {
    if (self = [super init]) {
        self.userId = userId;
        self.userDb = [self databaseForUser:userId];
    }
    return self;
}

/**
 对象被销毁时，关闭数据库链接
 */
- (void)dealloc {
    [self.userDb close];
}

#pragma mark -
#pragma mark Data source for User

/**
 获取用户的 Home Feed 数据源，Lazy load

 @return 数据源
 */
- (id<PPSHomeFeedDAOProtocol>)homeFeedDAO {
    if (!_homeFeedDAO) {
        _homeFeedDAO = [PPSHomeFeedDAO dataSourceInDatabase:self.userDb];
    }
    return _homeFeedDAO;
}

/**
 获取用户的 Publisher 数据源，Lazy load

 @return 数据源
 */
- (id<PPSPublisherDAOProtocol>)publisherDAO {
    if (!_publisherDAO) {
        _publisherDAO = [PPSPublisherDAO dataSourceInDatabase:self.userDb];
    }
    return _publisherDAO;
}

#pragma mark -
#pragma mark Create database for user

/**
 获取指定用户的数据库
 
 @param userId 用户 ID
 @return FMDatebase 对象
 */
- (FMDatabase *)databaseForUser:(NSString *)userId {
    if (![self isUserDatabaseExisting]) {
        return [self createUserDatabase];
    }
    return [self openUserDatabase];
}

/**
 检查指定的用户数据库是否存在

 @return 用户数据库是否存在
 */
- (BOOL)isUserDatabaseExisting {
    BOOL isDir = NO;
    NSString *pathToUserDatabase = [self pathToUserDatabase];
    BOOL isExisting =  [[NSFileManager defaultManager] fileExistsAtPath:pathToUserDatabase isDirectory:&isDir];
    return isExisting && !isDir;
}

/**
 获取用户文件夹路径

 @return 用户文件夹路径
 */
- (NSString *)pathToUserDirectory  {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths lastObject] stringByAppendingPathComponent:self.userId];

}

/**
 获取用户数据库路径

 @return 用户数据库路径
 */
- (NSString *)pathToUserDatabase {
    return [[self pathToUserDirectory] stringByAppendingString:@"/data.db"];
}

/**
 创建用户文件夹

 @return 是否创建成功
 */
- (BOOL)createUserDirectory {
    return [[NSFileManager defaultManager] createDirectoryAtPath:[self pathToUserDirectory]
                                     withIntermediateDirectories:YES
                                                      attributes:nil
                                                           error:nil];
}

/**
 创建用户数据库

 @return 数据库对象
 */
- (FMDatabase *)createUserDatabase {
    [self createUserDirectory];
    return [self openUserDatabase];
}

/**
 打开用户数据库

 @return 数据库对象
 */
- (FMDatabase *)openUserDatabase {
    return [FMDatabase databaseWithPath:[self pathToUserDatabase]];
}
@end
