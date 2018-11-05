//
//  XLBadgeModelProtocol.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/4.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XLBadgeModelProtocol <NSObject>

/**
 *  just key
 */
@property (nonatomic, copy) NSString *key;

/**
 *  show or hide the dot, only used by leaf node, if model have subDots it's unused.
 */
@property (nonatomic, strong) NSNumber *show;

/**
 *  leaf nodes of current node
 */
@property (nonatomic, strong) NSMutableArray<id<XLBadgeModelProtocol>> *subDots;

/**
 *  parent node of current node
 */
@property (nonatomic, strong) id<XLBadgeModelProtocol> parent;

@end
