//
//  ShareAlertView.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/22.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "ShareAlertView.h"

@interface ShareAlertView ()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *shareBackView;
@property (weak, nonatomic) id<ShareAlertViewDelegate>delegate;

@end

@implementation ShareAlertView

- (void)setupViews
{
    
}

- (void)configUISceneArray:(NSArray *)sceneArray {
    self.frame = [UIScreen mainScreen].bounds;
    UIColor * color = [UIColor blackColor];
    self.backgroundColor = [color colorWithAlphaComponent:0.5];
    
    UIView *shareBackView = [UIView new];
    shareBackView.backgroundColor = [UIColor colorWithString:COLORFAFAFA];
    _shareBackView = shareBackView;
    _shareBackView.userInteractionEnabled = YES;
    [self addSubview:shareBackView];
    
    CGFloat shareBackViewHeight = self.hasReport ? adaptHeight1334(269*2) : adaptHeight1334(164*2);
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
    
    
    UILabel *titleLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(30) textColorString:COLOR999999];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_shareBackView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    NSMutableArray *iconArray = @[].mutableCopy;
    NSMutableArray *titleArray = @[].mutableCopy;
    
    [sceneArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@"wechat_session"] && [self isInstallWechat]) {
            [iconArray addObject:@"share_wechat_icon"];
            [titleArray addObject:@"微信"];
        } else if ([obj isEqualToString:@"wechat_moments"] && [self isInstallWechat]) {
            [iconArray addObject:@"share_timeline_icon"];
            [titleArray addObject:@"朋友圈"];
        } else if ([obj isEqualToString:@"qq_zone"] && [self isInstallQQ]) {
            [iconArray addObject:@"share_qq_zone"];
            [titleArray addObject:@"QQ空间"];
        } else if ([obj isEqualToString:@"qq_session"] && [self isInstallQQ]) {
            [iconArray addObject:@"share_qq_chat"];
            [titleArray addObject:@"QQ"];
        }
    }];
    
    if (sceneArray == nil || sceneArray.count == 0) {
        if ([self isInstallWechat]) {
            [iconArray addObject:@"share_wechat_icon"];
            [titleArray addObject:@"微信"];
            [iconArray addObject:@"share_timeline_icon"];
            [titleArray addObject:@"朋友圈"];
        }
        if ([self isInstallQQ]) {
            [iconArray addObject:@"share_qq_zone"];
            [titleArray addObject:@"QQ空间"];
            [iconArray addObject:@"share_qq_chat"];
            [titleArray addObject:@"QQ"];
        }
    }
    
    [iconArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.shareBackView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.shareBackView).offset(idx * SCREEN_WIDTH / iconArray.count);
            make.top.equalTo(titleLabel.mas_bottom).offset(adaptHeight1334(20));
            make.bottom.equalTo(cancleButton.mas_top);
            make.width.mas_equalTo(SCREEN_WIDTH / iconArray.count);
            make.height.mas_equalTo(adaptHeight1334(105*2));
            
        }];
        
        UIButton *iconImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconImageButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [iconImageButton addTarget:self action:@selector(buttonScaleDownAnimation:) forControlEvents:UIControlEventTouchDown];
        [iconImageButton addTarget:self action:@selector(buttonScaleUpAnimation:) forControlEvents:UIControlEventTouchCancel];
        if(titleArray.count == 2 && [titleArray.firstObject isEqualToString:@"QQ空间"]){
            iconImageButton.tag = 500 + idx + 2;
        }else{
            iconImageButton.tag = 500 + idx;
        }
        [iconImageButton setBackgroundImage:[UIImage imageNamed:obj] forState:UIControlStateNormal];
        [iconImageButton setBackgroundImage:[UIImage imageNamed:obj] forState:UIControlStateHighlighted];
        [button addSubview:iconImageButton];
        
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
        
        
        if([obj isEqualToString:@"share_wechat_icon"]){
            UIImageView *imageView = [[UIImageView alloc] init];
            UIImage *image = [UIImage imageNamed:@"new_h"];
            imageView.image = image;
            imageView.size = image.size;
            [iconImageButton addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(iconImageButton.mas_rightMargin);
                make.top.equalTo(iconImageButton.mas_top).offset(adaptWidth750(4));
            }];
        }
        
        
    }];
    
    if (self.hasReport) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.shareBackView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.shareBackView).offset(0 * SCREEN_WIDTH / 4);
            make.top.equalTo(self.shareBackView).offset(adaptHeight1334(115*2));
            make.width.mas_equalTo(SCREEN_WIDTH / 4);
            make.height.mas_equalTo(adaptHeight1334(105*2));
        }];
        
        UIButton *iconImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconImageButton addTarget:self action:@selector(reportButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [iconImageButton addTarget:self action:@selector(buttonScaleDownAnimation:) forControlEvents:UIControlEventTouchDown];
        [iconImageButton addTarget:self action:@selector(buttonScaleUpAnimation:) forControlEvents:UIControlEventTouchCancel];
        [iconImageButton setBackgroundImage:[UIImage imageNamed:@"report"] forState:UIControlStateNormal];
        [iconImageButton setBackgroundImage:[UIImage imageNamed:@"report"] forState:UIControlStateHighlighted];
        [button addSubview:iconImageButton];
        
        UILabel *titleLabel = [UILabel labWithText:@"举报" fontSize:adaptFontSize(26) textColorString:COLOR060606];
        [button addSubview:titleLabel];
        
        [iconImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(button);
            make.top.equalTo(button).offset(adaptHeight1334(15));
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(iconImageButton);
            make.top.equalTo(iconImageButton.mas_bottom).offset(adaptHeight1334(15));
            
        }];
    }
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.shareBackView);
        make.top.equalTo(self.shareBackView).offset(adaptHeight1334(0));
        make.height.mas_equalTo(adaptHeight1334(0));
        
    }];
    
    
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.shareBackView);
        make.height.mas_equalTo(adaptHeight1334(98));
        
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    self.userInteractionEnabled = YES;
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    UIImageView *lineImageView;
    lineImageView = ({
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor colorWithString:@"#E6E6E6"];
        imageView.size = CGSizeMake(SCREEN_WIDTH, 0.5f);
        imageView.origin = CGPointMake(0, adaptWidth750(115*2));
        imageView;
    });
    [self.shareBackView addSubview:lineImageView];
}

/*展示举报按钮*/
- (void)showReportView {
    self.hasReport = YES;
}

- (void)reportButtonAction:(UIButton *)sender {
    [self dismiss];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.delegate || [self.delegate respondsToSelector:@selector(didSelectResportButton)]) {
            [self.delegate didSelectResportButton];
        }
    });
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
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didSelectShareIndex:)]) {
        
        [self.delegate didSelectShareIndex:sender.tag - 500];
        [self dismiss];
    }
}

- (void)showShareViewWithSceneArray:(NSArray *)array delegate:(id<ShareAlertViewDelegate>)delegate;
{
    [self configUISceneArray:array];
    self.delegate = delegate;
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
    if(self.hasReport) {
        height = adaptHeight1334(269 * 2);
    }
    
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

- (BOOL)isInstallWechat {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
}

- (BOOL)isInstallQQ {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
