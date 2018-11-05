//
//  XLTextAndPictureContentConfig.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/6/20.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLTextAndPictureContentConfig.h"
#import "NIMKit.h"
#import "XLSessionTextAndPictureContentView.h"
#import "NSString+Height.h"
#import "XLTextAndPictureAttachment.h"

@implementation XLTextAndPictureContentConfig

- (CGSize)contentSize:(CGFloat)cellWidth message:(NIMMessage *)message {
    
    XLTextAndPictureAttachment *attachment = [(NIMCustomObject *)message.messageObject attachment];
    
    //标题高度
    CGFloat titleHeight = [NSString heightWithString:attachment.title fontSize:adaptFontSize(32) lineSpacing:adaptHeight1334(4) maxWidth:adaptWidth750(420)];
    titleHeight = titleHeight < adaptHeight1334(80) ? titleHeight : adaptHeight1334(80);
    
    return CGSizeMake(adaptWidth750(234*2), adaptHeight1334(72*2) + titleHeight);
}

- (NSString *)cellContent:(NIMMessage *)message {
    return NSStringFromClass([XLSessionTextAndPictureContentView class]);
}

- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message {
    return [[NIMKit sharedKit].config setting:message].contentInsets;
}

@end
