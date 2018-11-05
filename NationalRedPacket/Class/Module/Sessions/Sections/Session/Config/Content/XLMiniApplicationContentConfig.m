//
//  XLMiniApplicationContentConfig.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/6/20.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLMiniApplicationContentConfig.h"
#import "NIMKit.h"
#import "XLSessionMiniApplicationContentView.h"
#import "NSString+Height.h"
#import "XLMiniApplicationAttachment.h"

@implementation XLMiniApplicationContentConfig

- (CGSize)contentSize:(CGFloat)cellWidth message:(NIMMessage *)message {
    
    XLMiniApplicationAttachment *attachment = [(NIMCustomObject *)message.messageObject attachment];
    
    //标题高度
    CGFloat titleHeight = [NSString heightWithString:attachment.title fontSize:adaptFontSize(32) lineSpacing:adaptHeight1334(4) maxWidth:adaptWidth750(420)];
    titleHeight = titleHeight < adaptHeight1334(80) ? titleHeight : adaptHeight1334(80);
    
    return CGSizeMake(adaptWidth750(235*2), adaptHeight1334(242*2) + titleHeight - 5);
}

- (NSString *)cellContent:(NIMMessage *)message {
    return NSStringFromClass([XLSessionMiniApplicationContentView class]);
}

- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message {
    return [[NIMKit sharedKit].config setting:message].contentInsets;
}

@end
