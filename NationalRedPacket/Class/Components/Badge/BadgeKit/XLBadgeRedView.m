//
//  XLBadgeView.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/4.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLBadgeRedView.h"

BOOL hasSetXLDefault;

static CGFloat __XLDefaultRadius = 3;
static CGFloat XLDefaultRadius = 3;
static UIColor *XLDefaultColor;

// create cornerRatius red dot
static UIImage* xl_createCircleImage(UIColor *color,
                                     CGFloat radius,
                                     CGFloat borderWidth,
                                     UIColor *boarderColor) {
    
    CGRect rect = CGRectMake(0, 0, radius * 2, radius * 2);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    if (borderWidth > 0 && boarderColor) {
        rect = CGRectMake(borderWidth/2, borderWidth/2, rect.size.width - borderWidth, rect.size.width - borderWidth);
    }
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    [color setFill];
    [roundedRectanglePath fill];
    
    if (borderWidth > 0 && boarderColor) {
        [boarderColor setStroke];
        roundedRectanglePath.lineWidth = borderWidth;
        [roundedRectanglePath stroke];
    }

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@interface XLBadgeRedView ()

@property (nonatomic, weak) NSLayoutConstraint *layoutCenterX;
@property (nonatomic, weak) NSLayoutConstraint *layoutCenterY;

@end

static BOOL _initFinished;
static NSHashTable *_needSetDefaultViews;

@implementation XLBadgeRedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.borderColor = [UIColor whiteColor];
        self.radius = XLDefaultRadius;
        self.color = XLDefaultColor ? [UIColor greenColor] :[UIColor colorWithString:COLORFF3E3D];
        self.offset = CGPointZero;
        self.contentMode = UIViewContentModeCenter;
    
        if (!_initFinished) {
            [[self.class needSetDefaultViews] addObject:self];
        }
    }
    return self;
}

+ (NSHashTable *)needSetDefaultViews {
    if (!_needSetDefaultViews) {
        _needSetDefaultViews = [NSHashTable weakObjectsHashTable];
    }
    return _needSetDefaultViews;
}

// this method only be called once
+ (void)initFinished {
    _initFinished = YES;
    
    BOOL needSetRedius = XLDefaultRadius != __XLDefaultRadius;
    BOOL needSetColor  = XLDefaultColor ? YES : NO;

    if (!needSetColor && !needSetRedius) {
        [[self needSetDefaultViews] removeAllObjects];
        return;
    }
    for (XLBadgeRedView *view in [self needSetDefaultViews]) {
        
        if (needSetRedius) [view setRadius:XLDefaultRadius];
        
        if (needSetColor) [view setColor:XLDefaultColor];
    }
    
    [[self needSetDefaultViews] removeAllObjects];
}

#pragma mark - Custom Accessor

+ (void)setDefaultRadius:(CGFloat)radius {
    XLDefaultRadius = radius;
}

+ (void)setDefaultColor:(UIColor *)color {
    XLDefaultColor = color;
}

- (void)setOffset:(CGPoint)offset {
    if (CGPointEqualToPoint(offset, _offset)) return;
    _offset = offset;
    [self _refreshFrame];
}

- (void)setRadius:(CGFloat)radius {
    if (_radius == radius) return;
    _radius = radius;
    [self _refreshView];
}

- (void)setColor:(UIColor *)color {
    if (CGColorEqualToColor(color.CGColor, _color.CGColor)) return;
    _color = color;
    [self _refreImage];
}

- (void)setBorderColor:(UIColor *)borderColor {
    if (CGColorEqualToColor(borderColor.CGColor, _borderColor.CGColor)) return;
    _borderColor = borderColor;
    [self _refreImage];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    if (_borderWidth == borderWidth) return;
    _borderWidth = borderWidth;
    [self _refreImage];
}

- (void)_refreImage {
    self.image = xl_createCircleImage(self.color, self.radius, self.borderWidth, self.borderColor);
}

- (void)_refreshFrame {
    self.bounds = CGRectMake(0, 0, self.radius * 2, self.radius * 2);
    !self.refreshBlock ?: self.refreshBlock(self);
}

- (void)_refreshView {
    [self _refreImage];
    [self _refreshFrame];
}

@end

@interface XLBadgeView ()

@property (nonatomic, strong) UILabel *badgeLabel;

@end

@implementation XLBadgeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [xl_createCircleImage([UIColor colorWithString:COLORFF3E3D], 9, 0, nil) resizableImageWithCapInsets:UIEdgeInsetsMake(0, 9, 0, 9)];
        [self addSubview:self.badgeLabel];
        self.contentMode = UIViewContentModeScaleToFill;
        
        [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).mas_offset(5.5);
            make.right.equalTo(self.mas_right).mas_offset(-5.5);
            make.top.equalTo(self.mas_top).mas_offset(1);
            make.bottom.equalTo(self.mas_bottom).mas_offset(-1);
            make.width.mas_lessThanOrEqualTo(80);
        }];
    }
    return self;
}

#pragma mark - Custom Accessor

- (void)setColor:(UIColor *)color {
    _color = color;
    self.image = [xl_createCircleImage(_color, 9, 0, nil) resizableImageWithCapInsets:UIEdgeInsetsMake(0, 9, 0, 9)];
}

- (void)setBadgeValue:(NSString *)badgeValue {
    if ([_badgeValue isEqualToString:badgeValue]) return;
    _badgeValue = [badgeValue copy];
    
    self.badgeLabel.text = _badgeValue;
}

- (void)setOffset:(CGPoint)offset {
    if (CGPointEqualToPoint(offset, _offset)) return;
    _offset = offset;
}

- (UILabel *)badgeLabel {
    if (!_badgeLabel) {
        _badgeLabel = [UILabel new];
        _badgeLabel.font = [UIFont systemFontOfSize:12];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _badgeLabel;
}

@end
