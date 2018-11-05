//
//  PPSPublisherDataSource.h
//  NationalRedPacket
//
//  Created by 张子琦 on 29/01/2018.
//  Copyright © 2018 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPSBaseDAO.h"
#import "PPSDAOPublisherModel.h"

// 不支持多线程！！！！！！
@protocol PPSPublisherDAOProtocol <NSObject>
@required
/**
 清空所有数据，小心使用
 */
- (BOOL)deleteAllModels;

/**
 删除指定的发布者，根据 PPSDAOPublisherModel 的 ID —— 发布者 ID
 
 @param models 发布者对象
 */
- (BOOL)deleteModels:(NSArray<PPSDAOPublisherModel *> *)models;

/**
 批量插入数据
 
 @param models 待插入的数据
 */
- (BOOL)insertModels:(NSArray<PPSDAOPublisherModel *> *)models;

/**
 插入一条数据
 
 @param model 待插入的数据
 */
- (BOOL)insertModel:(PPSDAOPublisherModel *)model;

/**
 批量更新数据
 
 @param models 待更新的数据
 */
- (BOOL)updateModels:(NSArray<PPSDAOPublisherModel *> *)models;

/**
 更新一条数据
 
 @param model 待更新的数据
 */
- (BOOL)updateModel:(PPSDAOPublisherModel *)model;

/**
 取发布者信息
 
 @param publisherIds 发布者 ID 数组
 */
- (NSArray<PPSDAOPublisherModel *> *)queryModelsWithIds:(NSArray<NSString *> *)publisherIds;

/**
 取发布者信息
 
 @param publisherId 发布者 ID
 */
- (PPSDAOPublisherModel *)queryModelWithId:(NSString *)publisherId;

@end

@interface PPSPublisherDAO : PPSBaseDAO <PPSDAOProtocol, PPSPublisherDAOProtocol>

@end
