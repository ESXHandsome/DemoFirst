//
//  XLBadgeView.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/4.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLBadgeRedView : UIImageView

@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign) CGFloat borderWidth;

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, assign) CGPoint offset;

@property (nonatomic, copy) void (^refreshBlock)(XLBadgeRedView *view);

+ (void)setDefaultRadius:(CGFloat)radius;

+ (void)setDefaultColor:(UIColor *)color;

+ (void)initFinished;

@end


@interface XLBadgeView : UIImageView

@property (nonatomic, copy) NSString *badgeValue;

@property (nonatomic, assign) CGPoint offset;

@property (nonatomic, strong) UIColor *color;

@end
