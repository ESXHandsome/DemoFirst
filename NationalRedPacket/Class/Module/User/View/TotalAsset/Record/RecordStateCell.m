//
//  RecordStateCell.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/26.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "RecordStateCell.h"
#import "ExchangeModel.h"
#import "NSDate+Timestamp.h"

@interface RecordStateCell ()

@property (strong, nonatomic) UIImageView *topImageView;
@property (strong, nonatomic) UIImageView *topLineImageView;
@property (strong, nonatomic) UIImageView *midImageView;
@property (strong, nonatomic) UIImageView *midLineImageView;
@property (strong, nonatomic) UIImageView *bottomImageView;

@property (strong, nonatomic) UILabel     *topLabel;
@property (strong, nonatomic) UILabel     *midLabel;
@property (strong, nonatomic) UILabel     *midDetailLabel;
@property (strong, nonatomic) UILabel     *bottomLabel;
@property (strong, nonatomic) UILabel     *bottomDetailLabel;
@property (strong, nonatomic) UIView      *bottomLine;

@end

@implementation RecordStateCell

- (void)setupViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    self.topImageView = [UIImageView new];
    self.topImageView.image = [UIImage imageNamed:@"dian_one"];
    [self.contentView addSubview:self.topImageView];
    
    self.topLineImageView = [UIImageView new];
    self.topLineImageView.image = [UIImage imageNamed:@"xian_one"];
    [self.contentView addSubview:self.topLineImageView];
    
    self.midImageView = [UIImageView new];
    self.midImageView.image = [UIImage imageNamed:@"state_time"];
    [self.contentView addSubview:self.midImageView];
    
    self.midLineImageView = [UIImageView new];
    self.midLineImageView.image = [UIImage imageNamed:@"xian_two"];
    [self.contentView addSubview:self.midLineImageView];
    
    self.bottomImageView = [UIImageView new];
    self.bottomImageView.image = [UIImage imageNamed:@"dian_two"];
    [self.contentView addSubview:self.bottomImageView];
    
    self.topLabel = [UILabel labWithText:@"提交提现申请" fontSize:adaptFontSize(32) textColorString:COLOR888888];
    [self.contentView addSubview:self.topLabel];
    
    self.midLabel = [UILabel labWithText:@"订单处理中" fontSize:adaptFontSize(32) textColorString:COLOR333333];
    [self.contentView addSubview:self.midLabel];
    
    self.midDetailLabel = [UILabel labWithText:@"运营商正在为你充值" fontSize:adaptFontSize(28) textColorString:COLOR888888];
    [self.contentView addSubview:self.midDetailLabel];
    
    self.bottomLabel = [UILabel labWithText:@"充值成功" fontSize:adaptFontSize(32) textColorString:COLOR888888];
    [self.contentView addSubview:self.bottomLabel];
    
    self.bottomDetailLabel = [UILabel labWithText:@" " fontSize:adaptFontSize(28) textColorString:COLOR888888];
    self.bottomDetailLabel.numberOfLines = 0;
    [self.contentView addSubview:self.bottomDetailLabel];
    
    self.bottomLine = [UIView new];
    self.bottomLine.backgroundColor = [UIColor colorWithString:COLORD8D8D8];
    [self.contentView addSubview:self.bottomLine];
    
    [self my_layoutSubviews];

}

- (void)my_layoutSubviews
{
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(adaptHeight1334(64));
        make.left.equalTo(self.contentView).offset(adaptWidth750(160));
    }];
    
    [self.topLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topImageView);
        make.top.equalTo(self.topImageView.mas_bottom);
    }];
    
    [self.midImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topImageView);
        make.top.equalTo(self.topLineImageView.mas_bottom);
    }];
    
    [self.midLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topImageView);
        make.top.equalTo(self.midImageView.mas_bottom);
    }];
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topImageView);
        make.top.equalTo(self.midLineImageView.mas_bottom);
    }];
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topImageView.mas_right).offset(adaptWidth750(64));
        make.centerY.equalTo(self.topImageView);
    }];
    
    [self.midLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topLabel);
        make.bottom.equalTo(self.midImageView.mas_centerY);
    }];
    
    [self.midDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topLabel);
        make.top.equalTo(self.midLabel.mas_bottom).offset(adaptHeight1334(4));
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topLabel);
        make.centerY.equalTo(self.bottomImageView);
    }];
    
    [self.bottomDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topLabel);
        make.top.equalTo(self.bottomLabel.mas_bottom).offset(adaptHeight1334(4));
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(adaptWidth750(26*2));
        make.right.equalTo(self.contentView).offset(-adaptWidth750(26*2));
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.bottomDetailLabel.mas_bottom).offset(adaptHeight1334(26*2));
        make.bottom.equalTo(self.contentView).offset(-adaptHeight1334(6));
    }];
    
}

- (void)configModelData:(ExchangeModel *)model indexPath:(NSIndexPath *)indexPath
{
    [super configModelData:model indexPath:indexPath];
    
    if ([model.exchangeMode isEqualToString:@"ALIPAY_NATIVE"]) {
        self.midDetailLabel.text = [NSString stringWithFormat:@"预计%@前到账",[NSDate switchTimestamp:model.estimateTime.integerValue toFormatStr:@"MM月dd日HH:mm"]];
        self.midLabel.text = @"银行处理中";
        self.bottomLabel.text = @"到账成功";
        self.bottomDetailLabel.text = @"原因可能是：1.支付宝有误或者未\n实名认证2.存在违规行为（我们\n已经把提现金额打回到您的余额\n中了！）";

    } else {
        self.midDetailLabel.text = @"运营商正在为你充值";
        self.midLabel.text = @"订单处理中";
        self.bottomLabel.text = @"充值成功";
        self.bottomDetailLabel.text = @"原因可能是：1.运营商正在维护2.\n手机号填写错误（我们已经把提\n现金额打回到您的余额中了！）";
        
    }
    
    if (model.status == ExchangeStatusChecking) {
        self.midImageView.image = [UIImage imageNamed:@"state_time"];
        self.midLineImageView.image = [UIImage imageNamed:@"xian_two"];
        self.bottomImageView.image = [UIImage imageNamed:@"dian_two"];

        self.midLabel.textColor = [UIColor colorWithString:COLOR333333];
        self.bottomLabel.textColor = [UIColor colorWithString:COLOR888888];
        self.bottomDetailLabel.text = @" ";

    } else if (model.status == ExchangeStatusFail){
        
        self.midImageView.image = [UIImage imageNamed:@"dian_one"];
        self.midLineImageView.image = [UIImage imageNamed:@"xian_one"];
        self.bottomImageView.image = [UIImage imageNamed:@"state_delete"];

        self.midLabel.textColor = [UIColor colorWithString:COLOR888888];
        self.bottomLabel.text = @"非常抱歉，提现失败";
        self.bottomLabel.textColor = [UIColor colorWithString:COLOR333333];
        [self setLabelSpec:self.bottomDetailLabel];
    }
    
}

- (void)setLabelSpec:(UILabel *)label
{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:label.text attributes:nil];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:adaptHeight1334(6)];//行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, label.text.length)];
    label.attributedText = attributedString;
}

@end
