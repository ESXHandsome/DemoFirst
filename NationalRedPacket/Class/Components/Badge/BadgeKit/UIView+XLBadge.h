//
//  UIView+GJRedDot.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/4.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XLBadge)

/**
 是否显示小红点
 */
@property (nonatomic, assign) BOOL showRedDot;

/**
 badge个数, badge优先于小红点
 */
@property (nonatomic, copy) NSString *badgeValue;

@end
