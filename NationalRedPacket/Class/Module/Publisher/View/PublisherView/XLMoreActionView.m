//
//  XLMoreActionView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/6/12.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLMoreActionView.h"

@interface XLMoreActionView ()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *shareBackView;

@end

@implementation XLMoreActionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    self.frame = [UIScreen mainScreen].bounds;
    UIColor * color = [UIColor blackColor];
    self.backgroundColor = [color colorWithAlphaComponent:0.5];
    
    UIView *shareBackView = [UIView new];
    shareBackView.backgroundColor = [UIColor colorWithString:COLORFAFAFA];
    _shareBackView = shareBackView;
    _shareBackView.userInteractionEnabled = YES;
    [self addSubview:shareBackView];
    
    CGFloat shareBackViewHeight = adaptHeight1334(164*2);
    shareBackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, shareBackViewHeight);
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handlePan:)];
    [shareBackView addGestureRecognizer:panGestureRecognizer];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:shareBackView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(adaptHeight1334(10), adaptHeight1334(10))];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = shareBackView.bounds;
    shareBackView.clipsToBounds = YES;
    maskLayer.path = maskPath.CGPath;
    shareBackView.layer.mask = maskLayer;
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareBackView addSubview:cancleButton];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
    [cancleButton setTitleColor:[UIColor colorWithString:COLOR060606] forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor colorWithString:COLORB5B5B5] forState:UIControlStateHighlighted];
    CGSize size = CGSizeMake(SCREEN_WIDTH, adaptHeight1334(98));
    [cancleButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:size] forState:UIControlStateNormal];
    [cancleButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithString:COLORECECEB] size:size] forState:UIControlStateHighlighted];
    [cancleButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *titleArray = @[@"举报", @"拉黑"];
    NSArray *iconArray = @[@"report", @"blacklist"];
    
    [iconArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.shareBackView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.shareBackView).offset(idx * SCREEN_WIDTH / 4.0);
            make.top.equalTo(self.shareBackView).offset(adaptHeight1334(20));
            make.bottom.equalTo(cancleButton.mas_top);
            make.width.mas_equalTo(SCREEN_WIDTH / 4.0);
            make.height.mas_equalTo(adaptHeight1334(105*2));
            
        }];
        
        UIButton *iconImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconImageButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [iconImageButton addTarget:self action:@selector(buttonScaleDownAnimation:) forControlEvents:UIControlEventTouchDown];
        [iconImageButton addTarget:self action:@selector(buttonScaleUpAnimation:) forControlEvents:UIControlEventTouchCancel];
        [iconImageButton setBackgroundImage:[UIImage imageNamed:obj] forState:UIControlStateNormal];
        [iconImageButton setBackgroundImage:[UIImage imageNamed:obj] forState:UIControlStateHighlighted];
        [button addSubview:iconImageButton];
        iconImageButton.tag = 500 + idx;
        
        UILabel *titleLabel = [UILabel labWithText:titleArray[idx] fontSize:adaptFontSize(26) textColorString:COLOR060606];
        [button addSubview:titleLabel];
        
        [iconImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(button);
            make.top.equalTo(button).offset(adaptHeight1334(15));
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(iconImageButton);
            make.top.equalTo(iconImageButton.mas_bottom).offset(adaptHeight1334(15));
            
        }];
        
    }];
    
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.shareBackView);
        make.height.mas_equalTo(adaptHeight1334(98));
        
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    self.userInteractionEnabled = YES;
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
}

- (void)buttonScaleDownAnimation:(UIButton *)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        sender.transform = CGAffineTransformScale(sender.transform, 1.1, 1.1);
        
    }];
}
-(void)buttonScaleUpAnimation:(UIButton *)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        sender.transform = CGAffineTransformScale(sender.transform, 0.909, 0.909);
    }];
}

- (void)buttonAction:(UIButton *)sender
{
    sender.transform = CGAffineTransformScale(sender.transform, 0.909, 0.909);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedMoreActionView:index:)]) {
        
        [self.delegate didSelectedMoreActionView:self index:sender.tag - 500];
        [self dismiss];
        
    }
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        
        self.shareBackView.y = SCREEN_HEIGHT - self.shareBackView.height;
    }];
}

- (void)dismiss
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            self.shareBackView.y = SCREEN_HEIGHT;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isEqual:_shareBackView]) {
        return NO;
    }
    return YES;
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.shareBackView];
    CGFloat height =  adaptHeight1334(164 * 2);
    
    if (translation.y > 0) {
        self.shareBackView.frame = CGRectMake(0,SCREEN_HEIGHT - height + translation.y, self.bounds.size.width, SCREEN_HEIGHT*0.7);
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [recognizer velocityInView:self];
        if (self.shareBackView.frame.origin.y > SCREEN_HEIGHT*0.82 || velocity.y > 900) {
            [self dismiss];
        } else {
            [UIView animateWithDuration:0.1f animations:^{
                self.shareBackView.frame = CGRectMake(0,SCREEN_HEIGHT - height, self.bounds.size.width, height);
            } completion:^(BOOL finished) {
                self.shareBackView.frame = CGRectMake(0,SCREEN_HEIGHT - height, self.bounds.size.width, height);
                
            }];
        }
    }
}

@end
