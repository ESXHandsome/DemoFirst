//
//  XLGroupInviteContentConfig.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLGroupInviteContentConfig.h"
#import "NIMKit.h"

@implementation XLGroupInviteContentConfig

- (CGSize)contentSize:(CGFloat)cellWidth message:(NIMMessage *)message {
    return CGSizeMake(adaptWidth750(256*2), adaptHeight1334(96*2));
}

- (NSString *)cellContent:(NIMMessage *)message {
    return @"XLSessionGroupInviteContentView";
}

- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message
{
    return [[NIMKit sharedKit].config setting:message].contentInsets;
}

@end
