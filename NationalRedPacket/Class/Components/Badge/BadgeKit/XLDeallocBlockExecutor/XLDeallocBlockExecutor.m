//
//  XLDeallocBlockExecutor.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/4.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLDeallocBlockExecutor.h"

@interface XLDeallocBlockExecutor ()
@property (nonatomic, copy) void (^deallocHandler)(void);
@end

@implementation XLDeallocBlockExecutor

- (instancetype)initWithDeallocHandler:(void (^)(void))handler {
    self = [super init];
    if (self) {
        self.deallocHandler = handler;
    }
    return self;
}

- (void)dealloc {
    !self.deallocHandler ?: self.deallocHandler();
    self.deallocHandler = nil;
}

@end
