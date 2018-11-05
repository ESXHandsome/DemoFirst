//
//  XLDataSource.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/13.
//  Copyright © 2018年 XLook. All rights reserved.
//
//  数据源对象，仅作为基类，由子类通过泛型声明具体对象类型
//
//  子类声明示例：@interface XLFeedDataSource : XLDataSource<__kindof FeedModel *>

#import <Foundation/Foundation.h>
#import "XLDataSourceChangingObservable.h"

@class XLDataSource;

@protocol XLDataSourceDelegate <NSObject>

/**
 同步某个索引的数据，调用者应在此方法中更新对应的单元格/视图

 @param dataSource 数据源
 @param index 索引
 */
- (void)dataSource:(XLDataSource *)dataSource didChangedForIndex:(NSInteger)index;

@end

@interface XLDataSource<__covariant ObjectType> : NSObject

/// 设置委托后，可以接收到数据同步的回调
@property (weak, nonatomic) id<XLDataSourceDelegate> delegate;

/// 集合对象，近提供查询用
@property (strong, nonatomic, readonly) NSArray<ObjectType> *elements;

/**
 类方法，从一个集合初始化并返回创建好的实例

 @param array 集合
 @return XLDataSource 实例
 */
+ (instancetype)dataSourceWithArray:(NSArray<ObjectType> *)array;

/**
 从一个集合初始化

 @param array 集合
 @return XLDataSource 实例
 */
- (instancetype)initWithArray:(NSArray<ObjectType> *)array;

@end

@interface XLDataSource<ObjectType> (Mutable)

/**
 向集合后面添加另一个集合

 @param otherArray 集合
 */
- (void)addElementsFromArray:(NSArray<ObjectType> *)otherArray;

/**
 传入另一个集合覆盖现有的

 @param otherArray 集合
 */
- (void)setElementsFromArray:(NSArray<ObjectType> *)otherArray;

/**
 删除一条指定索引的数据

 @param index 索引
 */
- (void)removeElementAtIndex:(NSUInteger)index;

@end

@interface XLDataSource<ObjectType> (Subclass)

/**
 枚举所有元素，并根据枚举中的返回值决定是否通知委托数据源改变，主要给子类使用

 @param block 若更新 obj，返回 YES
 */
- (void)enumerateElementsChangeUsingBlock:(BOOL(^)(ObjectType obj, NSUInteger idx, BOOL * stop))block;

@end

@interface XLDataSource (Changing) <XLDataSourceChangingObservable>
@end
