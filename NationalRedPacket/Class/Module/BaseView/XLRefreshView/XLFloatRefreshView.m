//
//  XLFloatRefreshView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/7/5.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLFloatRefreshView.h"

@interface XLFloatRefreshView ()

/** 回调对象 */
@property (weak, nonatomic)    id refreshingTarget;
/** 回调方法 */
@property (assign, nonatomic) SEL refreshingAction;

@property (strong, nonatomic) CABasicAnimation *freshAnimation;

@end

@implementation XLFloatRefreshView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:@"home_refresh"] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

+ (instancetype)floatWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    
    XLFloatRefreshView *refreshView = [XLFloatRefreshView new];
    refreshView.refreshingTarget = target;
    refreshView.refreshingAction = action;
    return refreshView;
}

- (void)refreshAction {
    
    [self beginRefreshing];
    if ([self.refreshingTarget respondsToSelector:self.refreshingAction]) {
        MJRefreshMsgSend(MJRefreshMsgTarget(self.refreshingTarget), self.refreshingAction, self);
    }
    
    [StatServiceApi statEvent:FLOAT_REFRESH_CLICK];
}

- (void)beginRefreshing {
    
    [self.layer addAnimation:[self freshAnimation] forKey:@"animation"];
}

- (void)endRefreshing {
    
    [self.layer removeAllAnimations];
}

- (CABasicAnimation *)freshAnimation {
    if (!_freshAnimation) {
        _freshAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _freshAnimation.fromValue = @(0);
        _freshAnimation.toValue = @(M_PI*4);
        _freshAnimation.duration = 1;
        _freshAnimation.repeatCount = HUGE_VALF;
        _freshAnimation.fillMode = kCAFillModeForwards;
        _freshAnimation.removedOnCompletion = NO;
    }
    return _freshAnimation;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
