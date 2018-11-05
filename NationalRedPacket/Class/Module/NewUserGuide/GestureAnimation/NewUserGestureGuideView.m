//
//  NewUserGestureAnimation.m
//  NationalRedPacket
//
//  Created by Ying on 2018/6/20.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "NewUserGestureGuideView.h"

@implementation NewUserGestureGuideView

- (instancetype)init {
    self = [super init];
    if (self) {
        /**加入上滑手势*/
        UISwipeGestureRecognizer  *upSwipeGestureRecognizer=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureRecognizer)];
        upSwipeGestureRecognizer.direction=UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:upSwipeGestureRecognizer];
        
        UITapGestureRecognizer *tapGestureRecongnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognizer)];
        [self addGestureRecognizer:tapGestureRecongnizer];
    }
    return self;
}

- (void)showGestureAnimation {
    self.backgroundColor = [UIColor colorWithRed:26/255.0f green:26.0/255.0f blue:26.0/255.0f alpha:0.85];
    self.userInteractionEnabled = YES;
    
    UIImageView *animatedImageViewHand = [[UIImageView alloc]
                                          initWithFrame:CGRectMake(adaptWidth750(347),
                                                                   adaptHeight1334(732),
                                                                   adaptWidth750(178),
                                                                   adaptHeight1334(143))];
    animatedImageViewHand.image = [UIImage imageNamed:@"hand"];
    [self addSubview:animatedImageViewHand];
    
    
    UIImageView *animatedImageViewLine = [[UIImageView alloc]init];
    animatedImageViewLine.image = [UIImage imageNamed:@"line"];
    [self addSubview:animatedImageViewLine];
    
    UIImageView *declarLabel = [[UIImageView alloc]init];
    declarLabel.image = [UIImage imageNamed:@"guide_word"];
    [self addSubview:declarLabel];
    
    [animatedImageViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(animatedImageViewHand);
        make.bottom.mas_equalTo(animatedImageViewHand).offset(adaptHeight1334(180));
    }];
    
    [declarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-adaptHeight1334(411));
    }];
    
    CABasicAnimation *animaA = [CABasicAnimation animationWithKeyPath:@"position"];
    animaA.fromValue = [NSValue valueWithCGPoint:CGPointMake(adaptWidth750(435),adaptHeight1334(800))];
    animaA.toValue = [NSValue valueWithCGPoint:CGPointMake(adaptWidth750(435),adaptHeight1334(380))];
    animaA.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animaA.duration = 1.4f;
    
    CABasicAnimation *animaB = [CABasicAnimation animationWithKeyPath:@"position"];
    animaB.fromValue = [NSValue valueWithCGPoint:CGPointMake(adaptWidth750(435),adaptHeight1334(380))];
    animaB.toValue = [NSValue valueWithCGPoint:CGPointMake(adaptWidth750(435),adaptHeight1334(800))];
    animaB.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animaB.beginTime = 1.4f;
    animaB.duration = 1.4f;
    
    CABasicAnimation *animaC = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animaC.fromValue = [NSNumber numberWithFloat:1.0];
    animaC.toValue = [NSNumber numberWithFloat:0.0];
    animaC.beginTime = 1.2;
    animaC.duration = 0.5;
    animaC.removedOnCompletion = NO;
    animaC.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *groupAnimation0 = [CAAnimationGroup animation];
    groupAnimation0.animations = [NSArray arrayWithObjects:animaA,animaB,animaC, nil];
    groupAnimation0.duration = 2.1f;
    groupAnimation0.repeatCount = HUGE_VAL;
    
    [animatedImageViewHand.layer addAnimation:groupAnimation0 forKey:@"groupAnimation"];
    
    
    CABasicAnimation *anima1 = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
    anima1.fromValue = [NSValue valueWithCGSize:CGSizeMake(adaptWidth750(10), adaptHeight1334(1))];
    anima1.toValue = [NSValue valueWithCGSize:CGSizeMake(adaptWidth750(10),adaptHeight1334(432))];
    anima1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    anima1.duration = 1.4f;
    
    //anima.fillMode = kCAFillModeForwards;
    //anima.removedOnCompletion = NO;
    
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"position"];
    anima2.fromValue = [NSValue valueWithCGPoint:CGPointMake(adaptWidth750(370),
                                                             adaptHeight1334(748))];
    anima2.toValue = [NSValue valueWithCGPoint:CGPointMake(adaptWidth750(370),
                                                           adaptHeight1334(542))];
    anima2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    anima2.duration = 1.4f;
    
    CABasicAnimation *anima3 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anima3.fromValue = [NSNumber numberWithFloat:1.0];
    anima3.toValue = [NSNumber numberWithFloat:0.0];
    anima3.beginTime = 0.9;
    anima3.duration = 0.5;
    anima3.removedOnCompletion = NO;
    anima3.fillMode = kCAFillModeForwards;
    
    //组动画
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = [NSArray arrayWithObjects:anima1,anima2,anima3, nil];
    groupAnimation.duration = 2.1f;
    groupAnimation.repeatCount = HUGE_VAL;
    [animatedImageViewLine.layer addAnimation:groupAnimation forKey:@"groupAnimation"];
    
    [StatServiceApi statEvent:HOT_PAGE_LEAD_LOOK];
}

/**上滑手势触发事件*/
- (void)swipeGestureRecognizer {
    [self removeFromSuperview];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"old" forKey:XLUserDefaultNewUserGestureGuide];
    if (self.delegate && [self.delegate respondsToSelector:@selector(gestureGuideViewWillDisappear)]) {
        [self.delegate gestureGuideViewWillDisappear];
    }

    [StatServiceApi statEvent:HOT_PAGE_LEAD_CLICK];
    
}

@end
