//
//  NSObject+XLDeallocBlockExecutor.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/4.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "NSObject+XLDeallocBlockExecutor.h"
#import <objc/runtime.h>
#import "XLDeallocBlockExecutor.h"

@implementation NSObject (XLDeallocBlockExecutor)

- (NSMutableArray *)gj_exutorPool {
    NSMutableArray *pool = objc_getAssociatedObject(self, _cmd);
    if (!pool) {
        pool = [NSMutableArray array];
        [self setGj_exutorPool:pool];;
    }
    return pool;
}

- (void)setGj_exutorPool:(NSMutableArray *)gj_exutorPool {
    objc_setAssociatedObject(self, @selector(gj_exutorPool), gj_exutorPool, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)gj_createExecutorWithHandlerBlock:(void (^)(void))block {
    XLDeallocBlockExecutor *executor = [[XLDeallocBlockExecutor alloc] initWithDeallocHandler:block];
    [self.gj_exutorPool addObject:executor];
}

@end
