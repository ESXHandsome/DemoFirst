//
//  NSArray+Map.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/24.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray <ObjectType> (Map)

- (NSArray *)mapObjectsUsingBlock:(id (^)(ObjectType obj, NSUInteger idx))block;

@end
