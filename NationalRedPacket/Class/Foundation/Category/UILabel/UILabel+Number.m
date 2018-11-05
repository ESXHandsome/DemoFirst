//
//  UILabel+Number.m
//  NationalRedPacket
//
//  Created by Ying on 2018/4/24.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "UILabel+Number.h"

@implementation UILabel (Number)
- (CGFloat)numberOfText:(NSString *)string{
    // 获取单行时候的内容的size
    CGSize singleSize = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    // 获取多行时候,文字的size
    CGSize textSize = [string boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
    // 返回计算的行数
    return ceil( textSize.height / singleSize.height);
}
@end
