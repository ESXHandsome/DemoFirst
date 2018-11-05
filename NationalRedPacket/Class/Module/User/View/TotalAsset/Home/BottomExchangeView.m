//
//  BottomChangeView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/20.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "BottomExchangeView.h"

@implementation BottomExchangeView

- (void)setupViews
{
    self.backgroundColor = [UIColor whiteColor];
    self.frame = CGRectMake(0, SCREEN_HEIGHT - adaptHeight1334(160), SCREEN_WIDTH, adaptHeight1334(160));
    
    //阴影
    self.layer.shadowColor = [UIColor colorWithString:COLOR9A9A9A].CGColor;//shadowColor阴影颜色
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = 0.35;//阴影透明度，默认0
    self.layer.shadowRadius = adaptHeight1334(48);//阴影半径，默认3
    
    UIButton *exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [exchangeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithString:COLORFE6969] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [exchangeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithString:COLORFE6969] size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];

    [exchangeButton setTitle:@"提现" forState:UIControlStateNormal];
    exchangeButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
    [exchangeButton setTitleColor:[UIColor colorWithString:COLORffffff] forState:UIControlStateNormal];
    [exchangeButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    exchangeButton.layer.cornerRadius = adaptWidth750(8);
    exchangeButton.layer.masksToBounds = YES;
    [self addSubview:exchangeButton];
    
    [exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(adaptWidth750(26));
        make.right.equalTo(self).offset(-adaptWidth750(26));
        make.height.mas_equalTo(adaptHeight1334(88));
        make.centerY.equalTo(self);
    }];
}

- (void)buttonAction
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickExchangeButton)]) {
        [self.delegate didClickExchangeButton];
    }
}

@end
