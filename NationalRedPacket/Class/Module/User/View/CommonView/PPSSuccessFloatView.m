//
//  PPSSuccessFloatView.m
//  NationalRedPacket
//
//  Created by Ying on 2018/3/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "PPSSuccessFloatView.h"

@interface PPSSuccessFloatView()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *backGroundView;
@property (strong, nonatomic) UIView *background;
@end

@implementation PPSSuccessFloatView

-(instancetype)init{
    self = [super init];
    self.size = CGSizeMake(adaptWidth750(162*2), adaptHeight1334(164*2));
    self.center = [UIApplication sharedApplication].keyWindow.center;

    _background = [[UIView alloc] init];
    _background.frame = CGRectMake(0, 0, self.width, self.height);
    _background.layer.cornerRadius = adaptFontSize(14*2);
    _background.alpha = 0.65;
    _background.backgroundColor = [UIColor colorWithString:@"#000000"];
    [self addSubview:_background];
    
    _backGroundView = [[UIImageView alloc] initWithFrame:CGRectMake(adaptWidth750(11*2), adaptHeight1334(5*2), adaptWidth750(142*2), adaptHeight1334(90*2))];
    UIImage *image = [UIImage imageNamed:@"start_bg1"];
    UIImage *image2 = [UIImage imageNamed:@"start_bg2"];
    CGFloat scale = adaptWidth750(142*2) / image.size.width;
    _backGroundView.size = CGSizeMake(adaptWidth750(142*2), image.size.height*scale);
    [_backGroundView setAnimationImages:@[image,image2]];
    [_backGroundView setAnimationDuration:0.75];
    [_backGroundView setAnimationRepeatCount:3];
    _backGroundView.alpha = 1;
    [self addSubview:_backGroundView];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.image = [UIImage imageNamed:@"jinbi"];
    _imageView.size = CGSizeMake(_imageView.image.size.width*scale, _imageView.image.size.height*scale);
    _imageView.center = _backGroundView.center;
    _imageView.centerY = _imageView.centerY +adaptHeight1334(32);
    _imageView.alpha = 1;
    [self addSubview:_imageView];
    
    _titleLabel = [UILabel labWithText:@"签到成功" fontSize:adaptFontSize(17*2) textColorString:@"#FBD100"];
    CGSize titleSize = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}];
    _titleLabel.frame = CGRectMake(adaptWidth750(47*2), adaptHeight1334(100*2), titleSize.width, titleSize.height);
    [self addSubview:_titleLabel];
    
    _moneyLabel = [UILabel labWithText:@"+5金币" fontSize:adaptFontSize(20*2) textColorString:@"#FBD100"];
    CGSize moneySize = [_moneyLabel.text sizeWithAttributes:@{NSFontAttributeName:_moneyLabel.font}];
    _moneyLabel.frame = CGRectMake(adaptWidth750(49*2), adaptHeight1334(124*2), moneySize.width,moneySize.height);
    [self addSubview:_moneyLabel];
    
    return self;
}

-(void)pushView:(NSString *)title money:(NSString *)money{
    self.moneyLabel.text = [NSString stringWithFormat:@"+%@金币",money];
    CGSize moneySize = [self.moneyLabel.text sizeWithAttributes:@{NSFontAttributeName:self.moneyLabel.font}];
    self.moneyLabel.frame = CGRectMake(adaptWidth750(49*2), adaptHeight1334(124*2), moneySize.width,moneySize.height);
    self.moneyLabel.centerX = self.titleLabel.centerX;
    [self.titleLabel setText:title];
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @0.0f;
    animation.toValue = @1.0f;
    animation.duration = 0.2;
    [self.backGroundView startAnimating];
    [self.layer addAnimation:animation forKey:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.backGroundView stopAnimating];
        [self removeFromSuperview];
    });
}


@end
