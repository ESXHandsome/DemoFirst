//
//  XLBadgeInfo.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/4.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLBadgeInfo : NSObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) void (^refreshBlock)(NSInteger);

@end
