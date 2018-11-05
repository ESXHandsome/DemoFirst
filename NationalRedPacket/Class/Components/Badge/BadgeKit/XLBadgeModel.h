//
//  XLBadgeModel.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/4.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLBadgeModelProtocol.h"

@interface XLBadgeModel : NSObject <XLBadgeModelProtocol>

@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) NSNumber *show;
@property (nonatomic, strong) NSMutableArray<id<XLBadgeModelProtocol>> *subDots;
@property (nonatomic, strong) id<XLBadgeModelProtocol> parent;

@end
