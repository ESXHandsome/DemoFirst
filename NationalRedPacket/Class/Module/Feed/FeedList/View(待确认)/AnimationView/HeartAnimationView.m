//
//  HeartAnimationView.m
//  NationalRedPacket
//
//  Created by 王海玉 on 2018/1/10.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "HeartAnimationView.h"
#import "NSNumber+RandomNumber.h"

@implementation HeartAnimationView

- (void)showWithPoint:(CGPoint)point isRule:(BOOL)rule{
    if (rule) {
        self.frame = CGRectMake(point.x - adaptWidth750(460)/2,point.y - adaptWidth750(400)/2, adaptWidth750(460), adaptHeight1334(418));
        CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI*0.105);
        self.transform = transform;//旋转 ;
    } else if (point.x != 0 && point.y != 0 ) {
        self.frame = CGRectMake(point.x - adaptWidth750(460)/2,point.y - adaptWidth750(400)/2, adaptWidth750(460), adaptHeight1334(418));
        CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI*0.105*[NSNumber randomNumberFrom:0 to:2]);
        self.transform = transform;//旋转 ;
    } else {
        self.frame = CGRectMake((SCREEN_WIDTH - adaptWidth750(460))/2,(SCREEN_HEIGHT - adaptWidth750(400))/2, adaptWidth750(460), adaptHeight1334(418));
    }
    
    self.image = [UIImage imageNamed:@"lad22"];
    
    CAKeyframeAnimation *anima1 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    NSValue *value1 = [NSNumber numberWithFloat:1.2f];
    NSValue *value2 = [NSNumber numberWithFloat:0.8f];
    NSValue *value3 = [NSNumber numberWithFloat:0.8f];
    NSValue *value4 = [NSNumber numberWithFloat:2.0f];
    anima1.values = [NSArray arrayWithObjects:value1,value2,value3,value4, nil];
    anima1.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.02],[NSNumber numberWithFloat:0.08],[NSNumber numberWithFloat:0.6],[NSNumber numberWithFloat:1.0], nil];
    
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anima2.fromValue = [NSNumber numberWithFloat:1.0];
    anima2.toValue = [NSNumber numberWithFloat:0.0];
    anima2.beginTime = 0.7;
    anima2.duration = 0.3;
    anima2.removedOnCompletion = NO;
    anima2.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
    groupAnima.animations = [NSArray arrayWithObjects:anima1,anima2, nil];
    groupAnima.duration = 1.0f;
    groupAnima.repeatCount = 1;
    groupAnima.removedOnCompletion = NO;
    groupAnima.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:groupAnima forKey:@"groupAnimation"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

- (void)showWithPoint:(CGPoint)point{
    [self showWithPoint:point isRule:NO];
}

@end
