//
//  NSObject+XLDeallocBlockExecutor.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/4.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XLDeallocBlockExecutor;
@interface NSObject (XLDeallocBlockExecutor)

//@property (nonatomic, strong) XLDeallocBlockExecutor *gj_exutor;
@property (nonatomic, readonly) NSMutableArray *gj_exutorPool;

- (void)gj_createExecutorWithHandlerBlock:(void (^)(void))block;

@end
