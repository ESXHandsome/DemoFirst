//
//  SideBarView.m
//  SidebarView
//
//  Created by 王海玉 on 2017/11/15.
//  Copyright © 2017年 王海玉. All rights reserved.
//

#import "SideBarView.h"
#import <Masonry.h>
#import "UIImage+ChangeColor.h"
#import "UIViewController+Utils.h"

@interface SideBarView ()<CAAnimationDelegate>

@property (nonatomic ,strong) UIButton *enjoyButton;
@property (nonatomic ,strong) UIButton *commentButton;
@property (nonatomic ,strong) UIButton *shareButton;
@property (nonatomic ,strong) UILabel *enjoyLabel;
@property (nonatomic ,strong) UILabel *commentLabel;
@property (nonatomic ,strong) UILabel *shareLabel;

@end

@implementation SideBarView {
    CGFloat alpha;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    alpha = 1;
    _enjoyButton = [[UIButton alloc]init];
    [_enjoyButton setImage:[UIImage imageNamed:@"video_like"] forState:UIControlStateNormal];
    [_enjoyButton setImage:[UIImage imageNamed:@"video_like_slick"] forState:UIControlStateSelected];
    [_enjoyButton addTarget:self action:@selector(enjoyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_enjoyButton];
    
    _commentButton = [[UIButton alloc]init];
    [_commentButton setImage:[UIImage imageNamed:@"video_comment"] forState:UIControlStateNormal];
    [_commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commentButton];

    _shareButton = [[UIButton alloc]init];
    [_shareButton setImage:[UIImage imageNamed:@"video_share"] forState:UIControlStateNormal];
    [_shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shareButton];
    
    _enjoyLabel = [[UILabel alloc]init];
    _enjoyLabel.backgroundColor = [UIColor orangeColor];
    _enjoyLabel.text = @"21.2";
    [self addSubview:_enjoyLabel];
    
    _commentLabel = [[UILabel alloc]init];
    _commentLabel.backgroundColor = [UIColor orangeColor];
    _commentLabel.text = @"222";
    [self addSubview:_commentLabel];
    
    _shareLabel = [[UILabel alloc]init];
    _shareLabel.backgroundColor = [UIColor orangeColor];
    _shareLabel.text = @"分享";
    [self addSubview:_shareLabel];
    
    [_enjoyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(10);
        make.width.mas_equalTo(@40);
        make.height.mas_equalTo(@40);
    }];
    [_enjoyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(_enjoyButton.mas_bottom).offset(10);
        make.width.mas_equalTo(@40);
        make.height.mas_equalTo(@20);
    }];
    [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(_enjoyLabel.mas_bottom).offset(20);
        make.width.mas_equalTo(@40);
        make.height.mas_equalTo(@40);
    }];
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(_commentButton.mas_bottom).offset(10);
        make.width.mas_equalTo(@40);
        make.height.mas_equalTo(@20);
    }];
    [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(_commentLabel.mas_bottom).offset(20);
        make.width.mas_equalTo(@40);
        make.height.mas_equalTo(@40);
    }];
    [_shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(_shareButton.mas_bottom).offset(10);
        make.width.mas_equalTo(@40);
        make.height.mas_equalTo(@20);
    }];
    
    [self shareButtonBecomeWeiXin];
    //[self SideBarViewAlphaWithFloat:0.5];
}

- (void)enjoyButtonClick:(UIButton *)btn {
    if (!_enjoyButton.selected) {
        self.userInteractionEnabled = NO;
        [_enjoyButton setImage:[[UIImage imageNamed:@"video_like"]
                                imageChangeColor:0] forState:UIControlStateNormal];
        [self enjoyAnimation:btn];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
    } else {
        [_enjoyButton setImage:[[UIImage imageNamed:@"video_like"]
                                imageChangeColor:alpha] forState:UIControlStateNormal];
        _enjoyButton.selected = !_enjoyButton.selected;
    }
    if ([self.delegate respondsToSelector:@selector(onTapEnjoyButton)]) {
        [self.delegate onTapEnjoyButton];
    }
}

- (void)delayMethod {
    self.userInteractionEnabled = YES;
    _enjoyButton.selected = !_enjoyButton.selected;
}

- (void)commentButtonClick:(UIButton *)btn {
    self.userInteractionEnabled = NO;
    [self beatAnimation:btn isEndlessLoop:NO];
    if ([self.delegate respondsToSelector:@selector(onTapcommentButton)]) {
        [self.delegate onTapEnjoyButton];
    }
}

- (void)shareButtonClick:(UIButton *)btn {
    [_shareButton setImage:[[UIImage imageNamed:@"video_share"]
                            imageChangeColor:alpha] forState:UIControlStateNormal];
    [_shareButton.layer removeAllAnimations];
    self.userInteractionEnabled = NO;
    [self beatAnimation:btn isEndlessLoop:NO];
    if ([self.delegate respondsToSelector:@selector(onTapShraeButton)]) {
        [self.delegate onTapEnjoyButton];
    }
}

- (void)beatAnimation:(UIButton *)btn isEndlessLoop:(BOOL)loop{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画选项设定
    animation.delegate = self;
    animation.duration = 0.2; // 动画持续时间
    if (loop) {// 是否重复
        animation.repeatCount = HUGE_VALF;
    } else {
        animation.repeatCount = 0;
    }
    animation.autoreverses = YES; // 动画结束时执行逆动画
    animation.removedOnCompletion = NO;
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:1.1]; // 结束时的倍率
    // 添加动画
    [btn.layer addAnimation:animation forKey:@"scale-layer"];
}

//心跳动画
- (void)enjoyAnimation:(UIButton *)btn {
    
    UIImageView *myAnimatedView = [[UIImageView alloc]init];
    myAnimatedView.frame = CGRectMake(-10, -10, 59, 60);
    myAnimatedView.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"lad1"],
                                      [UIImage imageNamed:@"lad1"],
                                      [UIImage imageNamed:@"lad3"],
                                      [UIImage imageNamed:@"lad4"],
                                      [UIImage imageNamed:@"lad5"],
                                      [UIImage imageNamed:@"lad6"],
                                      [UIImage imageNamed:@"lad6"],
                                      [UIImage imageNamed:@"lad6"],nil];//将序列帧数组赋给UIImageView的animationImages属性
    myAnimatedView.animationDuration = 1;//设置动画时间
    myAnimatedView.animationRepeatCount = 1;//设置动画次数 0 表示无限
    
    UIImageView *controllerAnimatedView = [[UIImageView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/3, [[UIScreen mainScreen] bounds].size.height/3, 100, 100)];
    controllerAnimatedView.animationImages = [NSArray arrayWithObjects:
                                     [UIImage imageNamed:@"lad11"],
                                     [UIImage imageNamed:@"lad11"],
                                     [UIImage imageNamed:@"lad22"],
                                     [UIImage imageNamed:@"lad33"],
                                     [UIImage imageNamed:@"lad33"],
                                     [UIImage imageNamed:@"lad44"],
                                     [UIImage imageNamed:@"lad55"],
                                     [UIImage imageNamed:@"lad66"],nil];
    controllerAnimatedView.animationDuration = 1;//设置动画时间
    controllerAnimatedView.animationRepeatCount = 1;//设置动画次数 0 表示无限
    
    
    [controllerAnimatedView startAnimating];
    [myAnimatedView startAnimating];//开始播放动画
    [[UIViewController currentViewController].view addSubview:controllerAnimatedView];
    [btn addSubview:myAnimatedView];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.userInteractionEnabled = YES;
}

- (void)shareButtonBecomeWeiXin {
    [_shareButton setImage:[UIImage imageNamed:@"video_weixin"] forState:UIControlStateNormal];
    [self beatAnimation:_shareButton isEndlessLoop:YES];
}

- (void)SideBarViewAlphaWithFloat:(CGFloat)alphaFloat {
    alpha = alphaFloat;
    [_enjoyButton setImage:[[UIImage imageNamed:@"video_like"]
                            imageChangeColor:alphaFloat] forState:UIControlStateNormal];
    [_commentButton setImage:[[UIImage imageNamed:@"video_comment"]
                            imageChangeColor:alphaFloat] forState:UIControlStateNormal];
    [_shareButton setImage:[[UIImage imageNamed:@"video_share"]
                            imageChangeColor:alphaFloat] forState:UIControlStateNormal];
}

- (void)doubleClickScreen {
    _enjoyButton.selected = !_enjoyButton.selected;
    if (_enjoyButton.selected) {
        self.userInteractionEnabled = NO;
        [self enjoyAnimation:_enjoyButton];
    }
    if ([self.delegate respondsToSelector:@selector(onTapEnjoyButton)]) {
        [self.delegate onTapEnjoyButton];
    }
}

@end
