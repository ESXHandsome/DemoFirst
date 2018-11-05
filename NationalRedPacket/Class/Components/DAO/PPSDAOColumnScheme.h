//
//  PPSDAOColumnScheme.h
//  NationalRedPacket
//
//  Created by 张子琦 on 29/01/2018.
//  Copyright © 2018 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>

// 列数据类型
typedef enum : NSUInteger {
    PPSDAOColumnTypeText = 0,   // 文本
    PPSDAOColumnTypeInteger,    // 数字，整形、浮点
    PPSDAOColumnTypeBLOB,       // 二进制
    PPSDAOColumnTypeReal,       // Real
    PPSDAOColumnTypeNull,       // 空值
    PPSDAOColumnTypeDatetime    // 时间戳
} PPSDAOColumnType;

// 列索引类型
typedef enum : NSUInteger {
    PPSDAOColumnIndexNone = 0,      // 无索引
    PPSDAOColumnIndexPrimaryKey,    // 主键
    PPSDAOColumnIndexUnique,        // 唯一键
} PPSDAOColumnIndex;

// 列默认值
typedef enum : NSUInteger {
    PPSDAOColumnDefaultNone = 0,     // 无默认值
    PPSDAOColumnDefaultLocalTime ,   // 本地时间戳
    PPSDAOColumnDefaultCustomize     // 自定义默认值
} PPSDAOColumnDefault;

@interface PPSDAOColumnScheme : NSObject
/// 列名
@property (strong, nonatomic, readonly) NSString *name;
/// 列类型
@property (assign, nonatomic, readonly) PPSDAOColumnType type;
/// 索引
@property (assign, nonatomic, readonly) PPSDAOColumnIndex index;
/// 默认值
@property (assign, nonatomic, readonly) PPSDAOColumnDefault defaults;
/// 默认值数据，使用 NSNumber 储存 int、float 等基本类型，NSString 储存字符串
@property (strong, nonatomic) id defaultValue;

/**
 初始化列结构 Model
 
 @param name 列名
 @param type 类型
 @param index 索引
 @return 列结构 Model
 */
+ (instancetype)schemeWithName:(NSString *)name
                          type:(PPSDAOColumnType)type
                         index:(PPSDAOColumnIndex)index;

/**
 初始化列结构 Model，列有默认值时使用
 
 @param name 列名
 @param type 类型
 @param index 索引
 @param defaults 默认值
            如果设置为 PPSDAOColumnDefaultCustomize
            那么必须设置 defaultValue
 @return 列结构 Model
 */
+ (instancetype)schemeWithName:(NSString *)name
                          type:(PPSDAOColumnType)type
                         index:(PPSDAOColumnIndex)index
                      defaults:(PPSDAOColumnDefault)defaults;

@end
