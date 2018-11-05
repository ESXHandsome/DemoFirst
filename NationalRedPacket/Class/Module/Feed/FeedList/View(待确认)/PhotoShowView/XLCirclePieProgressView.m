//
//  PPSCirclePieProgressView.m
//  NationalRedPacket
//
//  Created by Ying on 2018/2/26.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "XLCirclePieProgressView.h"

static CGFloat radiusFromAngle(CGFloat angle) {
    return (angle * M_PI)/180;
}

@implementation XLCirclePieProgressView

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
        self.frame = CGRectMake(0, 0, adaptWidth750(80), adaptHeight1334(80));
        self.center = [UIApplication sharedApplication].keyWindow.rootViewController.view.center;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit {
    _progressColor = [UIColor whiteColor];
    _lineColor = [UIColor whiteColor];
    _beginAngle = radiusFromAngle(-90);
    _lineWidth = 1.f;
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGFloat slideLength = self.bounds.size.width;
    CGFloat centerX = slideLength/2;
    CGFloat centerY = slideLength/2;
    
    if (_lineWidth > 0) {
        CGContextAddArc(currentContext, centerX, centerY, (slideLength-_lineWidth-1)/2, 0, 2*M_PI, 0);
        CGContextSetLineWidth(currentContext, _lineWidth);
        [self.lineColor setStroke];
        CGContextStrokePath(currentContext);
        
    }
    CGFloat deltaAngle = _progress*2*M_PI;
    CGContextMoveToPoint(currentContext, centerX, centerY);
    CGContextAddArc(currentContext, centerX, centerY, (slideLength-_lineWidth-2)/2-_lineWidth, self.beginAngle, self.beginAngle+deltaAngle, 0);
    [self.progressColor setFill];
    CGContextFillPath(currentContext);
    
}


- (void)setProgress:(CGFloat)progress {
    
    if (progress >= 1 || progress < 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
    }else{
        _progress = progress;
        // 标记为需要重新绘制, 将会在下一个绘制循环中, 调用drawRect:方法重新绘制
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setNeedsDisplay];
        });
    }
}

@end

