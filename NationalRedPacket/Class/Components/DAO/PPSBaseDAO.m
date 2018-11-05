//
//  PPSBaseDAO.m
//  NationalRedPacket
//
//  Created by 张子琦 on 28/01/2018.
//  Copyright © 2018 孙明悦. All rights reserved.
//

#import "PPSBaseDAO.h"
#import <FMDB/FMDB.h>

@implementation PPSBaseDAO

#pragma mark -
#pragma mark Initialization

/**
 类构造器，调用 - (instancetype)initWithDatabase:(FMDatabase *)db
 
 @param db 初始化用的数据库，数据来自这个数据库
 @return 实例对象
 */
+ (instancetype)dataSourceInDatabase:(FMDatabase *)db {
    return [[self alloc] initWithDatabase:db];
}

/**
 构造器
 
 @param db 初始化用的数据库，数据来自这个数据库
 @return 实例对象
 */
- (instancetype)initWithDatabase:(FMDatabase *)db {
    if (self = [super init]) {
        self.db = db;
        if (![self checkIfTableIsExist]) {
            [self createTable];
        }
    }
    return self;
}

#pragma mark -
#pragma mark About Tables

/**
 检查表是否存在，表名从 PPSDataSourceProtocol 中的 tableName 获得
 
 @return 表是否存在
 */
- (BOOL)checkIfTableIsExist {
    
    if ([self.db open]) {
        
        FMResultSet *set = [self.db executeQuery:[self SQLForCheckIfTableIsExist:[self tableName]]];
        
        while ([set next]) {
            return [[set stringForColumn:@"name"] isEqualToString:[self tableName]];
        }
    }
    return NO;
}

/**
 创建表，表的结构从 PPSDataSourceProtocol 中的 columnSchemes 获得
 
 @return 是否创建成功
 */
- (BOOL)createTable {
    if ([self.db open]) {
        return [self.db executeUpdate:[self SQLForCreateTableWithSchemes:[self columnSchemes]]];
    }
    return NO;
}

#pragma mark -
#pragma mark SQL with params

/**
 获得创建表的 SQL 语句

 @param schemes 表结构数据
 @return SQL 语句
 */
- (NSString *)SQLForCreateTableWithSchemes:(NSArray<PPSDAOColumnScheme *> *)schemes {
    
    NSMutableArray *SQLColumns = [NSMutableArray array];
    
    for (PPSDAOColumnScheme *scheme in schemes) {

        NSString *type;
        if (scheme.type == PPSDAOColumnTypeInteger) {
            type = @"INTEGER";
        } else if (scheme.type == PPSDAOColumnTypeText) {
            type = @"TEXT";
        } else if (scheme.type == PPSDAOColumnTypeReal) {
            type = @"READ";
        } else if (scheme.type == PPSDAOColumnTypeBLOB) {
            type = @"BLOB";
        } else if (scheme.type == PPSDAOColumnTypeNull) {
            type = @"NULL";
        } else if (scheme.type == PPSDAOColumnTypeDatetime) {
            type = @"DATETIME";
        }
        
        NSString *index;
        if (scheme.index == PPSDAOColumnIndexNone) {
            index = @"";
        } else if (scheme.index == PPSDAOColumnIndexPrimaryKey) {
            index = @"PRIMARY KEY";
        } else if (scheme.index == PPSDAOColumnIndexUnique) {
            index = @"UNIQUE";
        }
        
        NSString *defaults;
        if (scheme.defaults == PPSDAOColumnDefaultNone) {
            defaults = @"";
        } else if (scheme.defaults == PPSDAOColumnDefaultLocalTime) {
            defaults = @"DEFAULT (datetime('now','localtime'))";
        } else if (scheme.defaults == PPSDAOColumnDefaultCustomize) {
            defaults = [NSString stringWithFormat:@"default %@", [self exactDefaultValue:scheme.defaultValue]];
        }
        
        [SQLColumns addObject:[NSString stringWithFormat:@"%@ %@ %@ %@",
                               scheme.name,
                               type,
                               index,
                               defaults]];
    }
    return [NSString stringWithFormat:@"CREATE TABLE %@ (%@)",
            [self tableName],
            [SQLColumns componentsJoinedByString:@","]];
}

/**
 获得检查表是否存在的 SQL 语句

 @param tableName 表名
 @return SQL 语句
 */
- (NSString *)SQLForCheckIfTableIsExist:(NSString *)tableName {
    return [NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type = 'table' and name = '%@'", tableName];
}

#pragma mark -
#pragma mark Exact default value from Scheme

/**
 获取默认值

 @param raw 原始值
 @return 默认值
 */
- (NSString *)exactDefaultValue:(id)raw {
    if ([raw isKindOfClass:[NSString class]]) {
        return [self exactStringDefaultValue:(NSString *)raw];
    } else if ([raw isKindOfClass:[NSNumber class]]) {
        return [self exactNumberDefaultValue:(NSNumber *)raw];
    }
    return @"";
}

/**
 获取 String 类型默认值

 @param raw 原始值
 @return 默认值
 */
- (NSString *)exactStringDefaultValue:(NSString *)raw {
    return [NSString stringWithFormat:@"'%@'", raw];
}

/**
 获取 Number 类型默认值

 @param raw 原始值
 @return 默认值
 */
- (NSString *)exactNumberDefaultValue:(NSNumber *)raw {
    const char * pObjCType = [raw objCType];
    if (strcmp(@encode(int),                pObjCType) == 0 ||
        strcmp(@encode(short),              pObjCType) == 0 ||
        strcmp(@encode(long),               pObjCType) == 0 ||
        strcmp(@encode(long long),          pObjCType) == 0 ||
        strcmp(@encode(unsigned int),       pObjCType) == 0 ||
        strcmp(@encode(unsigned short),     pObjCType) == 0 ||
        strcmp(@encode(unsigned long),      pObjCType) == 0 ||
        strcmp(@encode(unsigned short),     pObjCType) == 0 ||
        strcmp(@encode(unsigned long long), pObjCType) == 0 ||
        strcmp(@encode(float),              pObjCType) == 0 ||
        strcmp(@encode(double),             pObjCType) == 0) {
        return [raw stringValue];
    } else if (strcmp(@encode(BOOL), pObjCType) == 0) {
        return [raw boolValue] ? @"1" : @"0";
    }
    return @"0";
}

- (NSArray<PPSDAOColumnScheme *> *)columnSchemes {
    NSAssert(NO, @"Subclass must override this method, without call [super columnSchemes]");
    return nil;
}

- (NSString *)tableName {
    NSAssert(NO, @"Subclass must override this method, without call [super tableName]");
    return nil;
}

@end
