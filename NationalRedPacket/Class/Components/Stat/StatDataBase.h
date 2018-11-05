//
//  NewsDataBase.h
//  StatProject
//
//  Created by 刘永杰 on 2018/1/2.
//  Copyright © 2018年 刘永杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLFeedModel.h"
#import "StatModel.h"

@interface StatDataBase : NSObject

+ (instancetype)sharedManager;

/*****************************  增  ****************************/

/**
 插入文章/视频
 
 @param model 文章模型
 */
- (BOOL)insertShowNewsModel:(XLFeedModel *)model;

/**
 插入stat
 
 @param model stat模型
 */
- (BOOL)insertStatModel:(StatModel *)model;

/*****************************  删  ****************************/

/**
 删除7天前的所有数据
 */
- (void)deleteOverdueNews;

/*****************************  改  ****************************/

/**
 更新stat_id已上传
 
 @param statIds 上传过的id数组
 */
- (void)updateStatDidUpload:(NSArray *)statIds;

/*****************************  查  **************************/

/**
 查询是否已插入
 
 @param model news
 @return 是否
 */
- (BOOL)queryIsHaveModel:(XLFeedModel *)model;

/**
 查询未上传的所有统计数据
 
 @return 返回数据
 */
- (NSArray *)queryNoUploadStat;


@end
