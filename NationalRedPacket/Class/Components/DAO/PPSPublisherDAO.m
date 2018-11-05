//
//  PPSPublisherDataSource.m
//  NationalRedPacket
//
//  Created by 张子琦 on 29/01/2018.
//  Copyright © 2018 孙明悦. All rights reserved.
//

#import "PPSPublisherDAO.h"
#import <FMDB/FMDB.h>

#define TABLE_NAME_FOR_PUBLISHER_DATA_SOURCE @"table_publisher";

#define COLUMN_ID                   @"id"
#define COLUMN_PUBLISHER_ID         @"publisher_id"
#define COLUMN_NICKNAME             @"nickname"
#define COLUMN_GENDER               @"gender"
#define COLUMN_AGE                  @"age"
#define COLUMN_LOCATION             @"location"
#define COLUMN_BIO                  @"bio"
#define COLUMN_CONSTELLATION        @"constellation"
#define COLUMN_FOLLOWER_COUNT       @"follower_count"
#define COLUMN_FOLLOWING_COUNT      @"following_count"
#define COLUMN_IS_FOLLOWING         @"is_following"
#define COLUMN_CREATED_TIMESTAMP    @"created_timestamp"
#define COLUMN_UPDATED_TIMESTAMP    @"updated_timestamp"

#define SQL_DELETE_ALL @"DELETE FROM %@"
#define SQL_DELETE_MODELS @"DELETE FROM %@ WHERE publisher_id IN (%@)"
#define SQL_INSERT_MODEL @"INSERT INTO %@ (publisher_id, nickname, gender, age, location, bio, constellation, follower_count, following_count, is_following) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
#define SQL_UPDATE_MODEL @"UPDATE %@ SET %@ WHERE %@"
#define SQL_SELECT_MODELS @"SELECT * FROM %@ WHERE publisher_id IN ('%@')"

@implementation PPSPublisherDAO

/**
 清空所有数据，小心使用
 */
- (BOOL)deleteAllModels {
    
    [self openDatabase];
    
    NSString *SQL = [NSString stringWithFormat:SQL_DELETE_ALL, [self tableName]];
    return [self.db executeUpdate:SQL];
}

/**
 删除指定的发布者，根据 PPSDAOPublisherModel 的 ID —— 发布者 ID

 @param models 发布者对象
 */
- (BOOL)deleteModels:(NSArray<PPSDAOPublisherModel *> *)models {
    
    [self openDatabase];
    
    NSArray<NSString *> *ids = [models valueForKeyPath:@"@distinctUnionOfObjects.identifier"];
    NSMutableArray<NSString *> *idsWithQuotation = [NSMutableArray arrayWithCapacity:models.count];
    
    
    [ids enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableString *idWithQuotation = [NSMutableString stringWithString:@"'"];
        [idWithQuotation appendString:obj];
        [idWithQuotation appendString:@"'"];
        [idsWithQuotation addObject:idWithQuotation];
    }];
    
    NSString *publisherIdList = [idsWithQuotation componentsJoinedByString:@","];
    NSString *SQL = [NSString stringWithFormat:SQL_DELETE_MODELS, [self tableName], publisherIdList];
    return [self.db executeUpdate:SQL];
}

/**
 批量插入数据
 
 @param models 待插入的数据
 */
- (BOOL)insertModels:(NSArray<PPSDAOPublisherModel *> *)models {
    
    [self openDatabase];
    
    for (PPSDAOPublisherModel *model in models) {
        [self insertModel:model];
    }
    return YES;
}

/**
 插入一条数据
 
 @param model 待插入的数据
 */
- (BOOL)insertModel:(PPSDAOPublisherModel *)model {
    
    [self openDatabase];
    
    NSString *SQL = [NSString stringWithFormat:SQL_INSERT_MODEL, [self tableName]];
    NSNumber *isFollowing = [NSNumber numberWithInteger:model.isFollowing ? 1 : 0];
    
    return [self.db executeUpdate:SQL, model.publisherId,
            model.nickname, @(model.gender),
            @(model.age), model.location,
            model.bio, model.constellation,
            @(model.followerCount),
            @(model.followingCount),
            isFollowing];
}

/**
 批量更新数据
 
 @param models 待更新的数据
 */
- (BOOL)updateModels:(NSArray<PPSDAOPublisherModel *> *)models {
    
    [self openDatabase];
    
    for (PPSDAOPublisherModel *model in models) {
        [self updateModel:model];
    }
    return YES;
}

/**
 更新一条数据
 
 @param model 待更新的数据
 */
- (BOOL)updateModel:(PPSDAOPublisherModel *)model {
    
    [self openDatabase];
    
    NSMutableArray *fragments = [NSMutableArray arrayWithCapacity:9];
    
    if (model.nickname) {
        [fragments addObject:[NSString stringWithFormat:@"%@ = '%@'", COLUMN_NICKNAME, model.nickname]];
    }
    if (model.gender) {
        [fragments addObject:[NSString stringWithFormat:@"%@ = %lu", COLUMN_GENDER, model.gender]];
    }
    if (model.age != -1) {
        [fragments addObject:[NSString stringWithFormat:@"%@ = %lu", COLUMN_AGE, model.age]];
    }
    if (model.location) {
        [fragments addObject:[NSString stringWithFormat:@"%@ = '%@'", COLUMN_LOCATION, model.location]];
    }
    if (model.bio) {
        [fragments addObject:[NSString stringWithFormat:@"%@ = '%@'", COLUMN_BIO, model.bio]];
    }
    if (model.constellation) {
        [fragments addObject:[NSString stringWithFormat:@"%@ = '%@'", COLUMN_CONSTELLATION, model.constellation]];
    }
    if (model.followerCount != -1) {
        [fragments addObject:[NSString stringWithFormat:@"%@ = %ld", COLUMN_FOLLOWER_COUNT, model.followerCount]];
    }
    if (model.followingCount != -1) {
        [fragments addObject:[NSString stringWithFormat:@"%@ = %ld", COLUMN_FOLLOWING_COUNT, model.followingCount]];
    }
    if (model.shouldUpdateFollowingStatus) {
        [fragments addObject:[NSString stringWithFormat:@"%@ = %d", COLUMN_IS_FOLLOWING, model.isFollowing ? 1 : 0]];
    }
    
    return [self.db executeUpdate:[NSString stringWithFormat:SQL_UPDATE_MODEL, [self tableName], [fragments componentsJoinedByString:@","], [NSString stringWithFormat:@"%@ = '%@'", COLUMN_PUBLISHER_ID, model.publisherId]]];
}

/**
 取发布者信息
 
 @param publisherIds 发布者 ID 数组
 */
- (NSArray<PPSDAOPublisherModel *> *)queryModelsWithIds:(NSArray<NSString *> *)publisherIds {
    
    [self openDatabase];
    
    NSString *publisherIdList = [publisherIds componentsJoinedByString:@"','"];
    NSString *SQL = [NSString stringWithFormat:SQL_SELECT_MODELS, [self tableName], publisherIdList];
    
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:publisherIds.count];
    
    FMResultSet *set = [self.db executeQuery:SQL];
    while ([set next]) {
        PPSDAOPublisherModel *model = [PPSDAOPublisherModel new];
        model.modelId = [set intForColumn:COLUMN_ID];
        model.publisherId = [set stringForColumn:COLUMN_PUBLISHER_ID];
        model.nickname = [set stringForColumn:COLUMN_NICKNAME];
        model.gender = [set intForColumn:COLUMN_GENDER];
        model.age = [set intForColumn:COLUMN_AGE];
        model.location = [set stringForColumn:COLUMN_LOCATION];
        model.bio = [set stringForColumn:COLUMN_BIO];
        model.constellation = [set stringForColumn:COLUMN_CONSTELLATION];
        model.followerCount = [set longForColumn:COLUMN_FOLLOWER_COUNT];
        model.followingCount = [set longForColumn:COLUMN_FOLLOWING_COUNT];
        model.isFollowing = [set boolForColumn:COLUMN_IS_FOLLOWING];
        
        [models addObject:model];
    }
    
    return models;
}

/**
 取发布者信息
 
 @param publisherId 发布者 ID
 */
- (PPSDAOPublisherModel *)queryModelWithId:(NSString *)publisherId {
    
    [self openDatabase];
    
    NSString *SQL = [NSString stringWithFormat:SQL_SELECT_MODELS, [self tableName], publisherId];
    
    FMResultSet *set = [self.db executeQuery:SQL];
    PPSDAOPublisherModel *model = [PPSDAOPublisherModel new];
    
    while ([set next]) {
        model.modelId = [set intForColumn:COLUMN_ID];
        model.publisherId = [set stringForColumn:COLUMN_PUBLISHER_ID];
        model.nickname = [set stringForColumn:COLUMN_NICKNAME];
        model.gender = [set longForColumn:COLUMN_GENDER];
        model.age = [set longForColumn:COLUMN_AGE];
        model.location = [set stringForColumn:COLUMN_LOCATION];
        model.bio = [set stringForColumn:COLUMN_BIO];
        model.constellation = [set stringForColumn:COLUMN_CONSTELLATION];
        model.followerCount = [set longForColumn:COLUMN_FOLLOWER_COUNT];
        model.followingCount = [set longForColumn:COLUMN_FOLLOWING_COUNT];
        model.isFollowing = [set boolForColumn:COLUMN_IS_FOLLOWING];
        
    }
    
    return model;
}

/**
 打开数据库
 
 @return 是否打开成功
 */
- (BOOL)openDatabase {
    return [self.db open];
}

#pragma mark -
#pragma mark PPSDataSourceProtocol Implementation

- (NSString *)tableName {
    return TABLE_NAME_FOR_PUBLISHER_DATA_SOURCE;
}

- (NSArray<PPSDAOColumnScheme *> *)columnSchemes {
    return @[
             [PPSDAOColumnScheme schemeWithName:COLUMN_ID
                                           type:PPSDAOColumnTypeInteger
                                          index:PPSDAOColumnIndexPrimaryKey],
             [PPSDAOColumnScheme schemeWithName:COLUMN_PUBLISHER_ID
                                           type:PPSDAOColumnTypeText
                                          index:PPSDAOColumnIndexNone],
             [PPSDAOColumnScheme schemeWithName:COLUMN_NICKNAME
                                           type:PPSDAOColumnTypeText
                                          index:PPSDAOColumnIndexNone],
             [PPSDAOColumnScheme schemeWithName:COLUMN_GENDER
                                           type:PPSDAOColumnTypeInteger
                                          index:PPSDAOColumnIndexNone],
             [PPSDAOColumnScheme schemeWithName:COLUMN_AGE
                                           type:PPSDAOColumnTypeInteger
                                          index:PPSDAOColumnIndexNone],
             [PPSDAOColumnScheme schemeWithName:COLUMN_LOCATION
                                           type:PPSDAOColumnTypeText
                                          index:PPSDAOColumnIndexNone],
             [PPSDAOColumnScheme schemeWithName:COLUMN_BIO
                                           type:PPSDAOColumnTypeText
                                          index:PPSDAOColumnIndexNone],
             [PPSDAOColumnScheme schemeWithName:COLUMN_CONSTELLATION
                                           type:PPSDAOColumnTypeText
                                          index:PPSDAOColumnIndexNone],
             [PPSDAOColumnScheme schemeWithName:COLUMN_FOLLOWER_COUNT
                                           type:PPSDAOColumnTypeInteger
                                          index:PPSDAOColumnIndexNone],
             [PPSDAOColumnScheme schemeWithName:COLUMN_FOLLOWING_COUNT
                                           type:PPSDAOColumnTypeInteger
                                          index:PPSDAOColumnIndexNone],
             [PPSDAOColumnScheme schemeWithName:COLUMN_IS_FOLLOWING
                                           type:PPSDAOColumnTypeInteger
                                          index:PPSDAOColumnIndexNone],
             [PPSDAOColumnScheme schemeWithName:COLUMN_CREATED_TIMESTAMP
                                           type:PPSDAOColumnTypeDatetime
                                          index:PPSDAOColumnIndexNone
                                       defaults:PPSDAOColumnDefaultLocalTime],
             [PPSDAOColumnScheme schemeWithName:COLUMN_UPDATED_TIMESTAMP
                                           type:PPSDAOColumnTypeDatetime
                                          index:PPSDAOColumnIndexNone
                                       defaults:PPSDAOColumnDefaultLocalTime]
             ];
}

@end
