//
//  XLBigPictureContentConfig.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/6/20.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLBigPictureContentConfig.h"
#import "NIMKit.h"
#import "XLSessionBigPictureContentView.h"
#import "NSString+Height.h"
#import "XLBigPictureAttachment.h"

@implementation XLBigPictureContentConfig

- (CGSize)contentSize:(CGFloat)cellWidth message:(NIMMessage *)message {
    
    CGFloat maxWidth = SCREEN_WIDTH - adaptWidth750(100) * 2;
    
    XLBigPictureAttachment *attachment = [(NIMCustomObject *)message.messageObject attachment];
    
    //标题高度
    CGFloat titleHeight = [NSString heightWithString:attachment.title fontSize:adaptFontSize(36) lineSpacing:adaptHeight1334(4) maxWidth:maxWidth];
    //描述高度
    CGFloat descriptionHeight = [NSString heightWithString:attachment.subtitle fontSize:adaptFontSize(28) lineSpacing:adaptHeight1334(6) maxWidth:maxWidth];
    
    return CGSizeMake(SCREEN_WIDTH, adaptHeight1334(236*2) + titleHeight + descriptionHeight - 5);
    
}

- (NSString *)cellContent:(NIMMessage *)message {
    return NSStringFromClass([XLSessionBigPictureContentView class]);
}

- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message {
    return [[NIMKit sharedKit].config setting:message].contentInsets;
}

@end
