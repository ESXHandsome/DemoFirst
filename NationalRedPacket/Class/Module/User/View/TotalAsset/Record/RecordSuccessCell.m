//
//  RecordSuccessCell.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/26.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "RecordSuccessCell.h"
#import "ExchangeModel.h"

@interface RecordSuccessCell ()

@property (strong, nonatomic) UIImageView *successImageView;
@property (strong, nonatomic) UILabel     *successLabel;
@property (strong, nonatomic) UILabel     *successTitleLabel;
@property (strong, nonatomic) UILabel     *successMoneyLabel;
@property (strong, nonatomic) UIView      *bottomLine;

@end

@implementation RecordSuccessCell

- (void)setupViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.successImageView = [UIImageView new];
    self.successImageView.image = [UIImage imageNamed:@"carry_ok"];
    [self.contentView addSubview:self.successImageView];

    self.successLabel = [UILabel labWithText:@"恭喜您，提现成功！" fontSize:adaptFontSize(36) textColorString:COLOR1AAD19];
    [self.contentView addSubview:self.successLabel];

    self.successTitleLabel = [UILabel labWithText:@"提现到账" fontSize:adaptFontSize(32) textColorString:COLOR888888];
    [self.contentView addSubview:self.successTitleLabel];

    self.successMoneyLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(60) textColorString:COLOR000000];
    [self.contentView addSubview:self.successMoneyLabel];
    
    self.bottomLine = [UIView new];
    self.bottomLine.backgroundColor = [UIColor colorWithString:COLORD8D8D8];
    [self.contentView addSubview:self.bottomLine];
    
    //成功界面
    [self.successImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(adaptHeight1334(62));
    }];
    
    [self.successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.successImageView.mas_bottom).offset(adaptHeight1334(26*2));
    }];
    
    [self.successTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.successLabel.mas_bottom).offset(adaptHeight1334(68));
        make.left.equalTo(self.contentView).offset(adaptWidth750(26*2));
        make.bottom.equalTo(self.bottomLine.mas_top).offset(-adaptHeight1334(80));
    }];
    
    [self.successMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-adaptWidth750(26*2));
        make.centerY.equalTo(self.successTitleLabel);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(adaptWidth750(26*2));
        make.right.equalTo(self.contentView).offset(-adaptWidth750(26*2));
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.contentView).offset(-adaptHeight1334(6));
    }];
}

- (void)configModelData:(ExchangeModel *)model indexPath:(NSIndexPath *)indexPath
{
    self.successMoneyLabel.text = [NSString stringWithFormat:@"%.2f", model.money.floatValue];
}

@end
