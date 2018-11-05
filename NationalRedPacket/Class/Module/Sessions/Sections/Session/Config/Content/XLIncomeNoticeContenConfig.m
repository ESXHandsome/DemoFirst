//
//  XLIncomeNoticeContenConfig.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLIncomeNoticeContenConfig.h"
#import "NIMKit.h"

@implementation XLIncomeNoticeContenConfig

- (CGSize)contentSize:(CGFloat)cellWidth message:(NIMMessage *)message {
    return CGSizeMake(SCREEN_WIDTH, adaptHeight1334(294*2));
}

- (NSString *)cellContent:(NIMMessage *)message {
    return @"XLSessionIncomeNoticeContentView";
}

- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message
{
    return [[NIMKit sharedKit].config setting:message].contentInsets;
}

@end
