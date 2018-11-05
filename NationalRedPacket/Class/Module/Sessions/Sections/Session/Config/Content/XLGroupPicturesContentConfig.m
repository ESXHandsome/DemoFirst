//
//  XLGroupPicturesContentConfig.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/6/20.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLGroupPicturesContentConfig.h"
#import "NIMKit.h"
#import "XLSessionGroupPicturesContentView.h"
#import "XLGroupPicturesAttachment.h"

@implementation XLGroupPicturesContentConfig

- (CGSize)contentSize:(CGFloat)cellWidth message:(NIMMessage *)message {
    
    XLGroupPicturesAttachment *attachment = [(NIMCustomObject *)message.messageObject attachment];
    return CGSizeMake(SCREEN_WIDTH, kBigPictureHeight + kSmallPictureHeight * (attachment.list.count - 1) - 5);
}

- (NSString *)cellContent:(NIMMessage *)message {
    return NSStringFromClass([XLSessionGroupPicturesContentView class]);
}

- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message {
    return [[NIMKit sharedKit].config setting:message].contentInsets;
}

@end
