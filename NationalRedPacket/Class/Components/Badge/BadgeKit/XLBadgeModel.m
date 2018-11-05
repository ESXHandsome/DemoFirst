//
//  XLBadgeModel.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/4.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLBadgeModel.h"

@implementation XLBadgeModel

- (NSMutableArray<id<XLBadgeModelProtocol>> *)subDots {
    if (!_subDots) {
        _subDots = [NSMutableArray arrayWithCapacity:0];
    }
    return _subDots;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"key:%@ show:%@ parentKey:%@ subCount:%@",self.key,self.show,self.parent.key,@(self.subDots.count)];
}
@end
