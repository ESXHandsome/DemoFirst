//
//  NSObject+GJRedDotHandler.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/4.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "NSObject+XLBadgeHandler.h"
#import "XLBadgeInfo.h"
#import "XLBadgeManager.h"
#import "NSObject+XLDeallocBlockExecutor.h"
#import "XLBadgeRedView.h"

@implementation NSObject (GJRedDotHandler)

- (void)setRedDotKey:(NSString *)key refreshBlock:(void (^)(NSInteger))refreshBlock handler:(id)handler {
    [handler setRedDotKey:key refreshBlock:refreshBlock];
}

- (void)setRedDotKey:(NSString *)key refreshBlock:(void (^)(NSInteger))refreshBlock {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [XLBadgeRedView initFinished];
    });
    
    if (key.length == 0 || refreshBlock == nil) return;
    
    XLBadgeInfo *info = [XLBadgeInfo new];
    info.key = key;
    info.refreshBlock = refreshBlock;
    
    [[XLBadgeManager sharedManager] addRedDotItem:info forKey:key];

    [self gj_createExecutorWithHandlerBlock:^{
        [[XLBadgeManager sharedManager] removeRedDotItemForKey:key];
    }];
}

- (void)resetBadgeCount:(NSInteger)count forKey:(NSString *)key {
    [[XLBadgeManager sharedManager] resetBadgeCount:[NSString stringWithFormat:@"%ld",(long)count] forKey:key];
}

@end
