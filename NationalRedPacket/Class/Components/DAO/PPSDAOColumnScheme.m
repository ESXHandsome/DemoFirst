//
//  PPSDAOColumnScheme.m
//  NationalRedPacket
//
//  Created by 张子琦 on 29/01/2018.
//  Copyright © 2018 孙明悦. All rights reserved.
//

#import "PPSDAOColumnScheme.h"

@interface PPSDAOColumnScheme ()
@property (strong, nonatomic, readwrite) NSString *name;
@property (assign, nonatomic, readwrite) PPSDAOColumnType type;
@property (assign, nonatomic, readwrite) PPSDAOColumnIndex index;
@property (assign, nonatomic, readwrite) PPSDAOColumnDefault defaults;
@end

@implementation PPSDAOColumnScheme

/**
 初始化列结构，类构造器
 
 @param name 列名
 @param type 类型
 @param index 索引
 @return 实例对象
 */
+ (instancetype)schemeWithName:(NSString *)name
                          type:(PPSDAOColumnType)type
                         index:(PPSDAOColumnIndex)index {
    return [[self alloc] initWithName:name
                                 type:type
                                index:index
                             defaults:PPSDAOColumnDefaultNone];
}

+ (instancetype)schemeWithName:(NSString *)name
                          type:(PPSDAOColumnType)type
                         index:(PPSDAOColumnIndex)index
                      defaults:(PPSDAOColumnDefault)defaults {
    return [[self alloc] initWithName:name
                                 type:type
                                index:index
                             defaults:defaults];
}

/**
 初始化列结构，构造器
 
 @param name 列名
 @param type 类型
 @param index 索引
 @return 实例对象
 */
- (instancetype)initWithName:(NSString *)name
                        type:(PPSDAOColumnType)type
                       index:(PPSDAOColumnIndex)index
                    defaults:(PPSDAOColumnDefault)defaults {
    if (self = [super init]) {
        self.name = name;
        self.type = type;
        self.index = index;
        self.defaults = defaults;
    }
    return self;
}

@end
