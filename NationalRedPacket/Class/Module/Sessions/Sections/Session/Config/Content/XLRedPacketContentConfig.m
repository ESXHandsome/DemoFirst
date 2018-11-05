//
//  XLRedPacketContentConfig.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLRedPacketContentConfig.h"
#import "NIMKit.h"

@implementation XLRedPacketContentConfig

- (CGSize)contentSize:(CGFloat)cellWidth message:(NIMMessage *)message {
    return CGSizeMake(adaptWidth750(235*2), adaptHeight1334(82*2));
}

- (NSString *)cellContent:(NIMMessage *)message {
    return @"XLSessionRedPacketContentView";
}

- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message
{
    return [[NIMKit sharedKit].config setting:message].contentInsets;
}

@end
