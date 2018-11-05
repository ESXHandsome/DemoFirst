//
//  TotalAssetHeaderView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/20.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "TotalAssetHeaderView.h"

@interface TotalAssetHeaderView ()

@property (strong, nonatomic) UIImageView *balanceBackgroundView;
@property (strong, nonatomic) UILabel     *balanceLabel;
@property (strong, nonatomic) UILabel     *balanceTitleLabel;
@property (strong, nonatomic) UILabel     *goldTitleLabel;
@property (strong, nonatomic) UILabel     *goldNumberLabel;
@property (strong, nonatomic) UIView      *verticalSpecLine;
@property (strong, nonatomic) UILabel     *incomeTitleLabel;
@property (strong, nonatomic) UILabel     *incomeLabel;

@property (strong, nonatomic) UIView      *horizontalSpecLine;

@property (strong, nonatomic) UIImageView *notificationIcon;
@property (strong, nonatomic) UILabel     *notificationLabel;
@property (strong, nonatomic) UIButton    *exchangeRuleButton;
@property (strong, nonatomic) UIView      *buttonLine;

@property (strong, nonatomic) UIView      *bottomLine;

@end

@implementation TotalAssetHeaderView

- (void)setupViews
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, kTotalAssetHeight);
    
    self.balanceBackgroundView = [UIImageView new];
    self.balanceBackgroundView.image = [UIImage imageNamed:@"wallet_bg"];
    [self addSubview:self.balanceBackgroundView];
    
    self.balanceLabel = [UILabel labWithText:@"--" fontSize:adaptFontSize(84) textColorString:COLORffffff];
    self.balanceLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:adaptFontSize(84)];
    [self.balanceBackgroundView addSubview:self.balanceLabel];
    
    self.balanceTitleLabel = [UILabel labWithText:@"我的零钱(元)" fontSize:adaptFontSize(28) textColorString:COLORffffff];
    [self.balanceBackgroundView addSubview:self.balanceTitleLabel];

    self.goldTitleLabel = [UILabel labWithText:@"金币收入(个)" fontSize:adaptFontSize(24) textColorString:COLORA9A9A9];
    [self addSubview:self.goldTitleLabel];
    
    self.goldNumberLabel = [UILabel labWithText:@"--" fontSize:adaptFontSize(34) textColorString:COLOR333333];
    [self addSubview:self.goldNumberLabel];
    
    self.verticalSpecLine = [UIView new];
    self.verticalSpecLine.backgroundColor = [UIColor colorWithString:COLORE6E6E6];
    [self addSubview:self.verticalSpecLine];
    
    self.incomeTitleLabel = [UILabel labWithText:@"昨日零钱收入(元)" fontSize:adaptFontSize(24) textColorString:COLORA9A9A9];
    [self addSubview:self.incomeTitleLabel];
    
    self.incomeLabel = [UILabel labWithText:@"--" fontSize:adaptFontSize(34) textColorString:COLOR333333];
    [self addSubview:self.incomeLabel];
    
    self.horizontalSpecLine = [UIView new];
    self.horizontalSpecLine.backgroundColor = [UIColor colorWithString:COLORE6E6E6];
    [self addSubview:self.horizontalSpecLine];
    
    self.notificationIcon = [UIImageView new];
    self.notificationIcon.image = [UIImage imageNamed:@"combined_news"];
    [self addSubview:self.notificationIcon];
    
    NSString *str = @"每晚12点金币自动兑换零钱";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithString:COLORFF8100]
                    range:NSMakeRange(2, 3)];
    self.notificationLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(28) textColorString:COLOR999999];
    self.notificationLabel.attributedText = attrStr;
    [self addSubview:self.notificationLabel];
    
    self.exchangeRuleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.exchangeRuleButton setTitle:@"兑换规则" forState:UIControlStateNormal];
    [self.exchangeRuleButton setTitleColor:[UIColor colorWithString:COLOR576C96] forState:UIControlStateNormal];
    self.exchangeRuleButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(28)];
    [self.exchangeRuleButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.exchangeRuleButton];
    
    self.buttonLine = [UIView new];
    self.buttonLine.backgroundColor = [UIColor colorWithString:COLOR576C96];
    [self.exchangeRuleButton addSubview:self.buttonLine];
    
    self.bottomLine = [UIView new];
    self.bottomLine.backgroundColor = [UIColor colorWithString:COLOREFEFEF];
    self.bottomLine.layer.borderWidth = 0.5;
    self.bottomLine.layer.borderColor = [UIColor colorWithString:COLORE6E6E6].CGColor;
    [self addSubview:self.bottomLine];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.balanceBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self);
        make.height.mas_equalTo(adaptHeight1334(400));
    }];
    
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.balanceBackgroundView).offset(adaptHeight1334(84));
        make.centerX.equalTo(self.balanceBackgroundView);
    }];
    
    [self.balanceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.balanceLabel.mas_bottom);
        make.centerX.equalTo(self.balanceBackgroundView);
    }];
    
    [self.verticalSpecLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.balanceBackgroundView.mas_bottom).offset(adaptHeight1334(26));
        make.height.mas_equalTo(adaptHeight1334(48));
        make.width.mas_equalTo(0.5);
        make.centerX.equalTo(self);
    }];
    
    [self.goldTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.balanceBackgroundView.mas_bottom).offset(adaptHeight1334(12));
        make.centerX.equalTo(self).offset(-(SCREEN_WIDTH/4.0));
    }];
    
    [self.goldNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.goldTitleLabel);
        make.top.equalTo(self.goldTitleLabel.mas_bottom).offset(adaptHeight1334(8));
    }];
    
    [self.incomeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goldTitleLabel);
        make.centerX.equalTo(self).offset(SCREEN_WIDTH/4.0);
    }];
    
    [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goldNumberLabel);
        make.centerX.equalTo(self.incomeTitleLabel);
    }];
    
    [self.horizontalSpecLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.verticalSpecLine.mas_bottom).offset(adaptHeight1334(38));
        make.height.mas_equalTo(0.5);
    }];
    
    [self.notificationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(adaptWidth750(26));
        make.top.equalTo(self.horizontalSpecLine.mas_bottom).offset(adaptHeight1334(30));
    }];
    
    [self.notificationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.notificationIcon.mas_right).offset(adaptWidth750(14));
        make.centerY.equalTo(self.notificationIcon);
    }];
    
    [self.exchangeRuleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-adaptWidth750(26));
        make.centerY.equalTo(self.notificationIcon);
    }];
    
    [self.buttonLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.exchangeRuleButton.titleLabel);
        make.top.equalTo(self.exchangeRuleButton.titleLabel.mas_bottom).offset(-adaptHeight1334(3));
        make.height.mas_equalTo(1);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(adaptHeight1334(20));
        make.left.equalTo(self).offset(-1);
        make.right.equalTo(self).offset(1);
        make.bottom.equalTo(self);
    }];
}

#pragma mark - Public Methods
- (void)updateGoldNumber:(NSString *)number
{
    self.goldNumberLabel.text = [NSString stringWithFormat:@"%ld", number.integerValue];
}

- (void)updateYesterdayIncome:(NSString *)income
{
    self.incomeLabel.text = [NSString stringWithFormat:@"%.2f", income.floatValue];
}

- (void)updateBalance:(NSString *)balance {
    
    self.balanceLabel.text = [NSString stringWithFormat:@"%.2f", balance.floatValue];
}

#pragma mark - Private Methods
- (void)buttonAction
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didClickExchangeRuleButton)]) {
        [self.delegate didClickExchangeRuleButton];
    }
}

@end
