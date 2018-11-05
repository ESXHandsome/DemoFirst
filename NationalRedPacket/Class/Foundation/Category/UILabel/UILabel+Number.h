//
//  UILabel+Number.h
//  NationalRedPacket
//
//  Created by Ying on 2018/4/24.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Number)
/**
 *  获取Label文字内容的行数
 *
 *  @return 返回行数
 */
- (CGFloat)numberOfText:(NSString *)string;
@end
