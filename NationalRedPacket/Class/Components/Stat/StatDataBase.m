//
//  NewsDataBase.m
//  StatProject
//
//  Created by 刘永杰 on 2018/1/2.
//  Copyright © 2018年 刘永杰. All rights reserved.
//

#import "StatDataBase.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

#define STATTABLE_CREATE         @"create table if not exists tb_stat(stat_id integer PRIMARY KEY autoincrement not null, stat_data text, is_upload text, create_time text);"
#define STATTABLE_INSERT         @"insert into tb_stat (stat_data, is_upload, create_time) values ('%@', '%@', '%@')"
#define STATTABLE_QUERY_NOUPLOAD @"select * from tb_stat where is_upload = '0'"
#define STATTABLE_UPDATE_UPLOAD  @"update tb_stat set is_upload = '%@' where stat_id = '%@'"


#pragma mark - 存储展示过的数据

#define NEWSTABLE_CREATE         @"create table if not exists tb_shownews(id integer PRIMARY KEY autoincrement not null, news_id text, news_type text, news_page text, create_time text);"
#define NEWSTABLE_INSERT         @"insert into tb_shownews (news_id, news_type, news_page, create_time) values ('%@', '%@', '%@', '%@')"
#define NEWSTABLE_ISHAVE         @"select * from tb_shownews where news_id = '%@' and news_type = '%@' and news_page = '%@'"

@interface StatDataBase ()

@property (strong, nonatomic) FMDatabaseQueue *databaseQueue;

@end

@implementation StatDataBase

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static StatDataBase *db = nil;
    dispatch_once(&onceToken,^{
        db = [[self alloc] init];
    });
    return db;
}

- (instancetype)init{
    if (self = [super init]) {
        [self initDatabase];
    }
    return self;
}

- (FMDatabaseQueue *)databaseQueue {
    if (_databaseQueue == nil) {
        NSURL *docURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
        NSString *dir = [docURL path];
        NSString *pathString = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"newsStat.sqlite"]];
        _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:pathString];
    }
    return _databaseQueue;
}

// 数据库初始化
- (void)initDatabase{
    
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:STATTABLE_CREATE];
        [db executeUpdate:NEWSTABLE_CREATE];
        
    }];
}

/*****************************  增  ****************************/

/**
 插入news
 
 @param model news模型
 */
- (BOOL)insertShowNewsModel:(XLFeedModel *)model
{
    BOOL __block result;
    NSMutableArray *vcArray = [[StatServiceApi sharedService] screenDisplayViewController];
    NSString *pageStr = NSStringFromClass([vcArray.lastObject class]);
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:NEWSTABLE_INSERT, model.itemId, model.type, pageStr, [NSString stringWithFormat:@"%ld",time(0)]];
        result = [db executeUpdate:sql];
    }];
    return result;
}

/**
 插入stat
 
 @param model stat模型
 */
- (BOOL)insertStatModel:(StatModel *)model
{
    BOOL __block result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:STATTABLE_INSERT, [model yy_modelToJSONString], @"0", [NSString stringWithFormat:@"%ld",time(0)]];
        result = [db executeUpdate:sql];
    }];
    return result;
}

/*****************************  删  ****************************/

/**
 删除7天前的所有数据
 */
- (void)deleteOverdueNews
{
    
}

/*****************************  改  ****************************/

/**
 更新stat_id已上传
 
 @param statIds 上传过的id数组
 */
- (void)updateStatDidUpload:(NSArray *)statIds
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSString *statId in statIds) {
            [self.databaseQueue inDatabase:^(FMDatabase *db) {
                NSString *sql = [NSString stringWithFormat:STATTABLE_UPDATE_UPLOAD, @"1", statId];
                [db executeUpdate:sql];
            }];
        }
        XLLog(@"更新上传状态");
    });
}

/*****************************  查  **************************/

/**
 查询是否已插入

 @param model news
 @return 是否
 */
- (BOOL)queryIsHaveModel:(XLFeedModel *)model
{
    BOOL __block exist = FALSE;
    NSMutableArray *vcArray = [[StatServiceApi sharedService] screenDisplayViewController];
    NSString *pageStr = NSStringFromClass([vcArray.lastObject class]);
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:NEWSTABLE_ISHAVE, model.itemId, model.type, pageStr];
        FMResultSet *result = [db executeQuery:sql];
        if (result) {
            while ([result next]) {
                exist = TRUE;
            }
        }
    }];
    return exist;
}

/**
 查询未上传的所有统计数据
 
 @return 返回数据
 */
- (NSArray *)queryNoUploadStat
{
    NSMutableArray *array = [NSMutableArray array];
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = [NSString stringWithFormat:STATTABLE_QUERY_NOUPLOAD];
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            NSString *stat_id = [result stringForColumn:@"stat_id"];
            NSString *stat_data = [result stringForColumn:@"stat_data"];
            NSDictionary *dataDic = [self dictionaryWithJsonString:stat_data];
            NSDictionary *dic = @{@"stat_data" : dataDic,
                                  @"stat_id" : stat_id};
            [array addObject:dic];
        }
    }];
    return array;
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments
                         error:&err];
    if(err) {
        XLLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
