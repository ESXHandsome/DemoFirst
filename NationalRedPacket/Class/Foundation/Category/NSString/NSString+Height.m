//
//  NSString+Height.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/26.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "NSString+Height.h"

@implementation NSString (Height)

+ (CGFloat)heightWithString:(NSString *)string fontSize:(CGFloat)fontSize lineSpacing:(CGFloat)lineSpacing maxWidth:(CGFloat)maxWidth
{
    if (string == nil || [string isKindOfClass:[NSNull class]]) {
        return 0;
    }
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpacing;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, maxWidth, 1)];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.numberOfLines = 0;
    label.attributedText = attributeString;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize size = [label sizeThatFits:CGSizeMake(label.frame.size.width, CGFLOAT_MAX)];
    return size.height;
}

@end
