//
//  NSObject+GJRedDotHandler.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/4.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (XLBadgeHandler)

/**
 *  set red dot refresh action by refreshBlock with red dot key,
 *  different from above method, you can specify a handler to manage the action block.
 *  you must us weak self to break retain circle!
 *
 *  @param key          red dot key
 *  @param refreshBlock refresh action block
 *  @param handler      red dot view handler
 */
- (void)setRedDotKey:(NSString *)key
        refreshBlock:(void (^)(NSInteger show))refreshBlock
             handler:(id)handler;

/**
 设置红点显示个数
 */
- (void)resetBadgeCount:(NSInteger)count
                  forKey:(NSString *)key;

@end
