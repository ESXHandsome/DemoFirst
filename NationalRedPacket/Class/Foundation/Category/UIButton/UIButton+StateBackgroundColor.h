//
//  UIButton+StateBackgroundColor.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/25.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (StateBackgroundColor)

@property (strong, nonatomic) IBInspectable UIColor *normalBackgroundColor;
@property (strong, nonatomic) IBInspectable UIColor *highlightedBackgroundColor;
@property (strong, nonatomic) IBInspectable UIColor *selectedBackgroundColor;
@property (strong, nonatomic) IBInspectable UIColor *disableBackgroundColor;

@end
