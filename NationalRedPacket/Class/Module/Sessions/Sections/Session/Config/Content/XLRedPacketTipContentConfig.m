//
//  XLRedPacketTipContentConfig.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/31.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLRedPacketTipContentConfig.h"
#import "NIMKit.h"

@implementation XLRedPacketTipContentConfig

- (CGSize)contentSize:(CGFloat)cellWidth message:(NIMMessage *)message {
    return CGSizeMake(SCREEN_WIDTH, adaptHeight1334(46));
}

- (NSString *)cellContent:(NIMMessage *)message {
    return @"XLSessionRedPacketTipContentView";
}

- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message
{
    return [[NIMKit sharedKit].config setting:message].contentInsets;
}

@end
