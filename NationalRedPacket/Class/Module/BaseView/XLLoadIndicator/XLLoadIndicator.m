//
//  XLLoadIndicator.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/7/3.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLLoadIndicator.h"

@interface XLLoadIndicator ()

@property (strong, nonatomic) CAShapeLayer *circleLayer;
@property (strong, nonatomic) UIBezierPath *path;

@end

@implementation XLLoadIndicator

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:adaptFontSize(30)];
    [self setTitle:@"动图" forState:UIControlStateNormal];
    [self setTitleColor:self.borderColor forState:UIControlStateNormal];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.width / 2.0;
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.borderWidth = self.borderWidth;

    self.circleLayer.frame = self.bounds;
    [self.layer insertSublayer:self.circleLayer atIndex:0];
    
}

- (void)reset {
    
    [self setTitle:@"动图" forState:UIControlStateNormal];
    self.circleLayer.strokeEnd = 0;
    
}

#pragma mark - Setter

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    
    self.layer.borderColor = self.borderColor.CGColor;
    [self setTitleColor:self.borderColor forState:UIControlStateNormal];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    
    self.layer.borderWidth = self.borderWidth;
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    
    self.circleLayer.strokeColor = self.strokeColor.CGColor;
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    
    self.circleLayer.fillColor = self.fillColor.CGColor;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    
    self.circleLayer.lineWidth = self.lineWidth;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    _progress = MIN(1, MAX(0, progress));
    self.circleLayer.strokeEnd = _progress;
    if (_progress > 0) {
        [self setTitle:@"" forState:UIControlStateNormal];
    }
}

#pragma mark - lazy loading

- (CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        self.circleLayer = [CAShapeLayer layer];
        self.circleLayer.strokeEnd = 0;
        self.circleLayer.lineWidth = self.lineWidth;
        self.circleLayer.strokeColor = self.strokeColor.CGColor;
        self.circleLayer.fillColor = self.fillColor.CGColor;
        self.circleLayer.path = self.path.CGPath;
    }
    return _circleLayer;
}

- (UIBezierPath *)path {
    if (!_path) {
        _path = [UIBezierPath bezierPathWithArcCenter:self.center radius:(self.width / 2.0) startAngle:-M_PI_2 endAngle:3*M_PI/2 clockwise:YES];
        _path.lineWidth = 2;
    }
    return _path;
}

@end
