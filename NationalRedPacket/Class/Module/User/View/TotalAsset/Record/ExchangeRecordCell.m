//
//  ExchangeRecordCell.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/23.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "ExchangeRecordCell.h"
#import "ExchangeModel.h"
#import "NSDate+Timestamp.h"

@interface ExchangeRecordCell ()

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel     *typeLabel;
@property (strong, nonatomic) UILabel     *timeLabel;
@property (strong, nonatomic) UILabel     *moneyLabel;
@property (strong, nonatomic) UILabel     *stateLabel;
@property (strong, nonatomic) UIView      *bottomLine;

@end

@implementation ExchangeRecordCell

- (void)setupViews
{
    self.iconImageView = [UIImageView new];
    self.iconImageView.image = [UIImage imageNamed:@"carry_phone"];
    [self.contentView addSubview:self.iconImageView];
    
    self.typeLabel = [UILabel labWithText:@"话费提现" fontSize:adaptFontSize(30) textColorString:COLOR333333];
    [self.contentView addSubview:self.typeLabel];
    
    self.timeLabel = [UILabel labWithText:@"2017-09-08 20:24:17" fontSize:adaptFontSize(26) textColorString:COLOR999999];
    [self.contentView addSubview:self.timeLabel];
    
    self.moneyLabel = [UILabel labWithText:@"50.00" fontSize:adaptFontSize(36) textColorString:COLOR000000];
    self.moneyLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:adaptFontSize(36)];
    [self.contentView addSubview:self.moneyLabel];

    self.stateLabel = [UILabel labWithText:@"审核中" fontSize:adaptFontSize(28) textColorString:COLORFF8100];
    [self.contentView addSubview:self.stateLabel];
    
    self.bottomLine = [UIView new];
    self.bottomLine.backgroundColor = [UIColor colorWithString:COLORE6E6E6];
    [self.contentView addSubview:self.bottomLine];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(adaptWidth750(30));
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView).offset(-adaptHeight1334(2));
        make.left.equalTo(self.iconImageView.mas_right).offset(adaptWidth750(32));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel);
        make.bottom.equalTo(self.iconImageView);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-adaptWidth750(30));
        make.bottom.equalTo(self.stateLabel.mas_top);
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLabel);
        make.right.equalTo(self.moneyLabel);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.contentView);
        make.left.equalTo(self.typeLabel);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)configModelData:(ExchangeModel *)model indexPath:(NSIndexPath *)indexPath
{
    if ([model.exchangeMode isEqualToString:@"ALIPAY_NATIVE"]) {
        self.iconImageView.image = [UIImage imageNamed:@"carry_alipay"];
        self.typeLabel.text = @"支付宝提现";
    } else if([model.exchangeMode isEqualToString:@"TELEPHONE"]) {
        self.iconImageView.image = [UIImage imageNamed:@"carry_phone"];
        self.typeLabel.text = @"话费提现";
    }
    self.timeLabel.text = [NSDate switchTimestamp:model.createdAt.integerValue toFormatStr:@"yyyy-MM-dd HH:mm:ss"];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", [model.money floatValue]];
    switch (model.status) {
        case ExchangeStatusChecking: {
            self.stateLabel.text = @"审核中";
            self.stateLabel.textColor = [UIColor colorWithString:COLORFF8100];
            break;
        }
        case ExchangeStatusSuccess: {
            self.stateLabel.text = @"提现成功";
            self.stateLabel.textColor = [UIColor colorWithString:COLOR999999];
            break;
        }
        case ExchangeStatusFail: {
            self.stateLabel.text = @"提现失败";
            self.stateLabel.textColor = [UIColor colorWithString:COLORFD2929];
            break;
        }
    }
}

@end
