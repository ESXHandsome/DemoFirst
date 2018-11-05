//
//  PPSHomeFeedDataSource.m
//  NationalRedPacket
//
//  Created by 张子琦 on 28/01/2018.
//  Copyright © 2018 孙明悦. All rights reserved.
//

#import "PPSHomeFeedDAO.h"
#import <FMDB/FMDB.h>

#define TABLE_NAME_FOR_HOME_FEED_DATA_SOURCE @"table_home_feed";

#define COLUMN_ID                   @"id"
#define COLUMN_FEED_ID              @"feed_id"
#define COLUMN_TEMPLATE_TYPE        @"template_type"
#define COLUMN_IS_LIKED             @"is_liked"
#define COLUMN_IS_READ              @"is_read"
#define COLUMN_COMMENT_COUNT        @"comment_count"
#define COLUMN_LIKED_COUNT          @"liked_count"
#define COLUMN_FORWARD_COUNT        @"forward_count"
#define COLUMN_FEED_JSON            @"feed_json"
#define COLUMN_PUBLISHER_ID         @"publisher_id"
#define COLUMN_PUBLISH_TIMESTAMP    @"publish_timestamp"
#define COLUMN_CREATED_TIMESTAMP    @"created_timestamp"
#define COLUMN_UPDATED_TIMESTAMP    @"updated_timestamp"


#define SQL_DELETE_ALL @"DELETE FROM %@"
#define SQL_DELETE_FROM_HEAD @"DELETE FROM %@ WHERE id IN (SELECT id FROM %@ ORDER BY id LIMIT %ld)"
#define SQL_INSERT_MODEL @"INSERT INTO %@ (feed_id, template_type, is_liked, is_read, comment_count, liked_count, forward_count, feed_json, publisher_id, publish_timestamp, created_timestamp) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
#define SQL_DETECT_ROW_EXIST @"SELECT COUNT(*) AS 'count' FROM %@ WHERE id = ?"
#define SQL_QUERY_MODELS_FROM_HEAD @"SELECT * FROM %@ ORDER BY id LIMIT %ld"
#define SQL_QUERY_MODELS_FROM_ROW @"SELECT * FROM %@ WHERE id > %ld ORDER BY id LIMIT %ld"
#define SQL_UPDATE_MODEL @"UPDATE %@ SET %@ WHERE %@"
#define SQL_COUNT_ROW @"SELECT count(id) AS 'count' FROM %@"

@implementation PPSHomeFeedDAO

#pragma mark -
#pragma mark PPSHomeFeedDAOProtocol Implementation

/**
 返回表内总条数

 @return 数据总条数
 */
- (NSInteger)totalCountForRow {

    [self openDatabase];
    
    NSString *SQL = [NSString stringWithFormat:SQL_COUNT_ROW, [self tableName]];
    FMResultSet *set = [self.db executeQuery:SQL];
    while ([set next]) {
        return [set longForColumn:@"count"];
    }
    return 0;
}

/**
 清空所有数据，小心使用
 */
- (BOOL)deleteAllModels {
    
    [self openDatabase];
    
    NSString *SQL = [NSString stringWithFormat:SQL_DELETE_ALL, [self tableName]];
    return [self.db executeUpdate:SQL];
}

/**
 删除最旧的多条
 
 @param count 条数
 */
- (BOOL)deleteModelsFromHead:(NSInteger)count {
    
    [self openDatabase];
    
    NSString *SQL = [NSString stringWithFormat:SQL_DELETE_FROM_HEAD, [self tableName], [self tableName], count];
    return [self.db executeUpdate:SQL];
}

/**
 批量插入数据
 
 @param models 待插入的数据
 */
- (BOOL)insertModels:(NSArray<PPSDAOHomeFeedModel *> *)models {
    
    [self openDatabase];
    
    for (PPSDAOHomeFeedModel *model in models) {
        [self insertModel:model];
    }
    
    return YES;
}

/**
 插入一条数据
 
 @param model 待插入的数据
 */
- (BOOL)insertModel:(PPSDAOHomeFeedModel *)model {
    
    [self openDatabase];
    
    NSString *SQL = [NSString stringWithFormat:SQL_INSERT_MODEL, [self tableName]];
    NSNumber *isLiked = [NSNumber numberWithInteger:model.isLiked ? 1 : 0];
    NSNumber *isRead = [NSNumber numberWithInteger:model.isRead ? 1 : 0];
    
    return [self.db executeUpdate:SQL,
            model.feedId, @(model.templateType), isLiked, isRead,
            @(model.commentCount), @(model.likedCount), @(model.forwardCount),
            model.JSON, model.publisherId, @(model.publishTimestamp), @(model.createdTimestamp)];
}

/**
 批量更新数据
 
 @param models 待更新的数据
 */
- (BOOL)updateModels:(NSArray<PPSDAOHomeFeedModel *> *)models {
    [self openDatabase];
    
    for (PPSDAOHomeFeedModel *model in models) {
        [self updateModel:model];
    }
    return YES;
}

/**
 更新一条数据
 
 @param model 待更新的数据
 */
- (BOOL)updateModel:(PPSDAOHomeFeedModel *)model {
    
    [self openDatabase];
    
    NSMutableArray *fragments = [NSMutableArray arrayWithCapacity:11];
    
    if (model.feedId) {
        [fragments addObject:[NSString stringWithFormat:@"%@ = '%@'", COLUMN_FEED_ID, model.feedId]];
    }
    if (model.templateType != -1) {
        [fragments addObject:[NSString stringWithFormat:@"%@ = %ld", COLUMN_TEMPLATE_TYPE, model.templateType]];
    }
    if (model.shouldUpdateLikedStatus) {
        [fragments addObject:[NSString stringWithFormat:@"%@ = %d", COLUMN_IS_LIKED, model.isLiked ? 1 : 0]];
    }
    if (model.shouldUpdateReadStatus) {
        [fragments addObject:[NSString stringWithFormat:@"%@ = %d", COLUMN_IS_READ, model.isRead ? 1 : 0]];
    }
    if (model.commentCount != -1) {
        [fragments addObject:[NSString stringWithFormat:@"%@ = %ld", COLUMN_COMMENT_COUNT, model.commentCount]];
    }
    if (model.likedCount != -1) {
        [fragments addObject:[NSString stringWithFormat:@"%@ = %ld", COLUMN_LIKED_COUNT, model.likedCount]];
    }
    if (model.forwardCount != -1) {
        [fragments addObject:[NSString stringWithFormat:@"%@ = %ld", COLUMN_FORWARD_COUNT, model.forwardCount]];
    }
    if (model.JSON) {
        [fragments addObject:[NSString stringWithFormat:@"%@ = '%@'", COLUMN_FEED_JSON, model.JSON]];
    }
    if (model.publisherId) {
        [fragments addObject:[NSString stringWithFormat:@"%@ = '%@'", COLUMN_PUBLISHER_ID, model.publisherId]];
    }
    if (model.publishTimestamp != -1) {
        [fragments addObject:[NSString stringWithFormat:@"%@ = %ld", COLUMN_PUBLISH_TIMESTAMP, model.publishTimestamp]];
    }
    
    return [self.db executeUpdate:[NSString stringWithFormat:SQL_UPDATE_MODEL, [self tableName], [fragments componentsJoinedByString:@","], [NSString stringWithFormat:@"id = %lu", model.modelId]]];
}

/**
 从一个指定的位置（不包含这个位置），向后取数据指定偏移量的数据，如果指定的位置不存在，从头开始取
 
 @param rowId 开始位置，是 DAOModel 中的 modelId
 @param offset 偏移量
 */
- (NSArray<PPSDAOHomeFeedModel *> *)queryModelsFrom:(NSInteger)rowId offset:(NSInteger)offset {
    
    [self openDatabase];
    
    NSString *SQL;
    
    if (![self isSpecificRowExisting:rowId]) {
        SQL = [NSString stringWithFormat:SQL_QUERY_MODELS_FROM_HEAD, [self tableName], offset];
    } else {
        SQL = [NSString stringWithFormat:SQL_QUERY_MODELS_FROM_ROW, [self tableName], rowId, offset];
    }
    
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:offset];
    
    FMResultSet *set = [self.db executeQuery:SQL];
    
    while ([set next]) {
        PPSDAOHomeFeedModel *model = [PPSDAOHomeFeedModel new];
        model.modelId = [set intForColumn:COLUMN_ID];
        model.feedId = [set stringForColumn:COLUMN_FEED_ID];
        model.templateType = [set intForColumn:COLUMN_TEMPLATE_TYPE];
        model.isLiked = [set boolForColumn:COLUMN_IS_LIKED];
        model.isRead = [set boolForColumn:COLUMN_IS_READ];
        model.commentCount = [set longForColumn:COLUMN_COMMENT_COUNT];
        model.likedCount = [set longForColumn:COLUMN_LIKED_COUNT];
        model.forwardCount = [set longForColumn:COLUMN_FORWARD_COUNT];
        model.JSON = [set stringForColumn:COLUMN_FEED_JSON];
        model.publisherId = [set stringForColumn:COLUMN_PUBLISHER_ID];
        model.publishTimestamp = [set longForColumn:COLUMN_PUBLISH_TIMESTAMP];
        model.createdTimestamp = [set longForColumn:COLUMN_CREATED_TIMESTAMP];
        [models addObject:model];
    }
    return models;
}

/**
 检查指定的行是否存在

 @param rowId 行 ID
 @return 是否存在
 */
- (BOOL)isSpecificRowExisting:(NSInteger)rowId {
    
    NSString *SQL = [NSString stringWithFormat:SQL_DETECT_ROW_EXIST, [self tableName]];
    
    FMResultSet *set = [self.db executeQuery:SQL, @(rowId)];
    
    while ([set next]) {
        if ([set intForColumn:@"count"] == 0) {
            return NO;
        } else {
            return YES;
        }
    }
    return NO;
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
    return TABLE_NAME_FOR_HOME_FEED_DATA_SOURCE;
}

- (NSArray<PPSDAOColumnScheme *> *)columnSchemes {
    return @[
             [PPSDAOColumnScheme schemeWithName:COLUMN_ID
                                           type:PPSDAOColumnTypeInteger
                                          index:PPSDAOColumnIndexPrimaryKey],
             [PPSDAOColumnScheme schemeWithName:COLUMN_FEED_ID
                                           type:PPSDAOColumnTypeText
                                          index:PPSDAOColumnIndexNone],
             [PPSDAOColumnScheme schemeWithName:COLUMN_TEMPLATE_TYPE
                                           type:PPSDAOColumnTypeInteger
                                          index:PPSDAOColumnIndexNone],
             [PPSDAOColumnScheme schemeWithName:COLUMN_IS_LIKED
                                           type:PPSDAOColumnTypeInteger
                                          index:PPSDAOColumnIndexNone],
             [PPSDAOColumnScheme schemeWithName:COLUMN_IS_READ
                                           type:PPSDAOColumnTypeInteger
                                          index:PPSDAOColumnIndexNone],
             [PPSDAOColumnScheme schemeWithName:COLUMN_COMMENT_COUNT
                                           type:PPSDAOColumnTypeInteger
                                          index:PPSDAOColumnIndexNone],
             [PPSDAOColumnScheme schemeWithName:COLUMN_LIKED_COUNT
                                           type:PPSDAOColumnTypeInteger
                                          index:PPSDAOColumnIndexNone],
             [PPSDAOColumnScheme schemeWithName:COLUMN_FORWARD_COUNT
                                           type:PPSDAOColumnTypeInteger
                                          index:PPSDAOColumnIndexNone],
             [PPSDAOColumnScheme schemeWithName:COLUMN_FEED_JSON
                                           type:PPSDAOColumnTypeText
                                          index:PPSDAOColumnIndexNone],
             [PPSDAOColumnScheme schemeWithName:COLUMN_PUBLISHER_ID
                                           type:PPSDAOColumnTypeText
                                          index:PPSDAOColumnIndexNone],
             [PPSDAOColumnScheme schemeWithName:COLUMN_PUBLISH_TIMESTAMP
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
