//
//  ExchangeOptionCell.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "ExchangeOptionCell.h"
#import "OptionModel.h"

@interface ExchangeOptionCell ()

@property (strong, nonatomic) UILabel *moneyLabel;
@property (strong, nonatomic) UILabel *numberLabel;

@end

@implementation ExchangeOptionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    self.layer.borderColor = [UIColor colorWithString:COLOR108EE9].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    
    self.moneyLabel = [UILabel labWithText:@"30元" fontSize:adaptFontSize(36) textColorString:COLOR108EE9];
    [self.contentView addSubview:self.moneyLabel];
    
    self.numberLabel = [UILabel labWithText:@"剩余2988件" fontSize:adaptFontSize(24) textColorString:COLOR72C3FE];
    self.numberLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:adaptFontSize(24)];
    [self.contentView addSubview:self.numberLabel];
}

- (void)layoutSubviews
{
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(adaptHeight1334(18));
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-adaptHeight1334(18));
    }];
}

//赋值
- (void)configOptionModel:(OptionListModel *)model indexPath:(NSIndexPath *)indexPath
{
    self.moneyLabel.text = [NSString stringWithFormat:@"%@元", model.money];
    self.numberLabel.text = [NSString stringWithFormat:@"剩余%@件", model.available];
    
    if (model.available.integerValue == 0) {
        [self setOptionCellNoSelect:NO];
    } else {
        [self setOptionCellNoSelect:YES];
    }
}

- (void)setOptionCellHighlight:(BOOL)isHighlight
{
    self.backgroundColor = [UIColor colorWithString:isHighlight ? COLOR108EE9 : COLORffffff];
    self.moneyLabel.textColor = [UIColor colorWithString:!isHighlight ? COLOR108EE9 : COLORffffff];
    self.numberLabel.textColor = [UIColor colorWithString:!isHighlight ? COLOR72C3FE : COLORffffff];
}

- (void)setOptionCellNoSelect:(BOOL)canSelect;
{
    if (canSelect) {
        self.backgroundColor = [UIColor colorWithString:COLORffffff];
        self.moneyLabel.textColor = [UIColor colorWithString:COLOR108EE9];
        self.numberLabel.textColor = [UIColor colorWithString:COLOR72C3FE];
        self.layer.borderColor = [UIColor colorWithString:COLOR108EE9].CGColor;
    } else {
        self.backgroundColor = [UIColor colorWithString:COLORffffff];
        self.moneyLabel.textColor = [UIColor colorWithString:COLOR9A9A9A];
        self.numberLabel.textColor = [UIColor colorWithString:COLOR9A9A9A];
        self.layer.borderColor = [UIColor colorWithString:COLORE6E6E6].CGColor;
        self.numberLabel.text = @"剩余0件";
    }
}

@end
