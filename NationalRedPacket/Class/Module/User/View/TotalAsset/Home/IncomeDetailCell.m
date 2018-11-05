//
//  IncomeDetailCell.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/21.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "IncomeDetailCell.h"
#import "IncomeListModel.h"

@interface IncomeDetailCell ()

@property (strong, nonatomic) UILabel *typeLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *numberLabel;
@property (strong, nonatomic) UIView  *bottomLine;

@end

@implementation IncomeDetailCell

- (void)setupViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.typeLabel = [UILabel labWithText:@"签到成功" fontSize:adaptFontSize(30) textColorString:COLOR333333];
    [self.contentView addSubview:self.typeLabel];
    
    self.timeLabel = [UILabel labWithText:@"2017-09-07 10:17:00" fontSize:adaptFontSize(26) textColorString:COLORA9A9A9];
    [self.contentView addSubview:self.timeLabel];
    
    self.numberLabel = [UILabel labWithText:@"+5金币" fontSize:adaptFontSize(32) textColorString:COLOR39AF34];
    [self.contentView addSubview:self.numberLabel];
    
    self.bottomLine = [UIView new];
    self.bottomLine.backgroundColor = [UIColor colorWithString:COLORE6E6E6];
    [self.contentView addSubview:self.bottomLine];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(adaptWidth750(24));
        make.top.equalTo(self.contentView).offset(adaptHeight1334(26));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel);
        make.bottom.equalTo(self.contentView).offset(-adaptHeight1334(26));
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-adaptWidth750(24));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void)configModelData:(IncomeListModel *)model indexPath:(NSIndexPath *)indexPath
{
    if (self.incomeType == IncomeTypeGold) {
        self.numberLabel.text = [NSString stringWithFormat:@"%@%@金币", model.isIncome ? @"+" :@"-", model.money];
    } else {
        self.numberLabel.text = [NSString stringWithFormat:@"%@%.2f元", model.isIncome ? @"+" :@"-", [model.money floatValue] ];
    }
    self.typeLabel.text = model.type;
    self.timeLabel.text = model.createdAt;
    self.numberLabel.textColor = [UIColor colorWithString:model.isIncome ? COLOR39AF34 : COLORFD2929];
}

@end
