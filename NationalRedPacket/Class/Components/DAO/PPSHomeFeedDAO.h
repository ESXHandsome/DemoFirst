//
//  PPSHomeFeedDataSource.h
//  NationalRedPacket
//
//  Created by 张子琦 on 28/01/2018.
//  Copyright © 2018 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPSBaseDAO.h"
#import "PPSDAOHomeFeedModel.h"

// 不支持多线程！！！！！！
@protocol PPSHomeFeedDAOProtocol <NSObject>
@required
/**
 返回表内总条数
 
 @return 数据总条数
 */
- (NSInteger)totalCountForRow;

/**
 清空所有数据，小心使用
 */
- (BOOL)deleteAllModels;

/**
 删除最旧的多条

 @param count 条数
 */
- (BOOL)deleteModelsFromHead:(NSInteger)count;

/**
 批量插入数据

 @param models 待插入的数据
 */
- (BOOL)insertModels:(NSArray<PPSDAOHomeFeedModel *> *)models;

/**
 插入一条数据

 @param model 待插入的数据
 */
- (BOOL)insertModel:(PPSDAOHomeFeedModel *)model;

/**
 批量更新数据

 @param models 待更新的数据
 */
- (BOOL)updateModels:(NSArray<PPSDAOHomeFeedModel *> *)models;

/**
 更新一条数据

 @param model 待更新的数据
 */
- (BOOL)updateModel:(PPSDAOHomeFeedModel *)model;

/**
 从一个指定的位置（不包含这个位置），向后取数据指定偏移量的数据，如果指定的位置不存在，从头开始取
 
 @param rowId 开始位置，是 DAOModel 中的 modelId
 @param offset 偏移量
 */
- (NSArray<PPSDAOHomeFeedModel *> *)queryModelsFrom:(NSInteger)rowId offset:(NSInteger)offset;

@end

@interface PPSHomeFeedDAO : PPSBaseDAO <PPSDAOProtocol, PPSHomeFeedDAOProtocol>

@end
