//
//  NSString+Height.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/26.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Height)

+ (CGFloat)heightWithString:(NSString *)string fontSize:(CGFloat)fontSize lineSpacing:(CGFloat)lineSpacing maxWidth:(CGFloat)maxWidth;

@end
