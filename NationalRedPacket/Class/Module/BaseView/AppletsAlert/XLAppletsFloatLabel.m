//
//  XLAppletsFloatLabel.m
//  NationalRedPacket
//
//  Created by Ying on 2018/6/21.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLAppletsFloatLabel.h"

@implementation XLAppletsFloatLabel
- (instancetype)init {
    if (self = [super init]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}

@end
