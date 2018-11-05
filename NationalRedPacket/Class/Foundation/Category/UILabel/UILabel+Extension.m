//
//  UILabel+Extension.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2017/6/22.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

+ (UILabel *)labWithText:(NSString *)text fontSize:(CGFloat)fontSize textColorString:(NSString *)textColorString
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = [UIColor colorWithString:textColorString];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    return label;
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    
    if (self.text == nil) {
        return;
    }
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:self.text attributes:nil];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];//行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.text.length)];
    self.attributedText = attributedString;
}

@end
