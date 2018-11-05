//
//  BalanceHeaderView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "BalanceHeaderView.h"

@interface BalanceHeaderView ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *balanceLabel;
@property (strong, nonatomic) UIView  *bottomLine;

@end

@implementation BalanceHeaderView

- (void)setupViews
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, adaptHeight1334(172));
    
    self.titleLabel = [UILabel labWithText:@"账户余额(元)" fontSize:adaptFontSize(26) textColorString:COLORCCCCCC];
    [self addSubview:self.titleLabel];
    
    self.balanceLabel = [UILabel labWithText:@"****" fontSize:adaptFontSize(64) textColorString:COLOR333333];
    [self addSubview:self.balanceLabel];
    
    self.bottomLine = [UIView new];
    self.bottomLine.backgroundColor = [UIColor colorWithString:COLORE6E6E6];
    [self addSubview:self.bottomLine];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(adaptWidth750(24));
        make.top.equalTo(self).offset(adaptHeight1334(22));
    }];
    
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self).offset(-adaptHeight1334(12));
    }];
}

- (void)updateBalance:(NSString *)balance
{
    self.balanceLabel.text = balance;
}

@end
