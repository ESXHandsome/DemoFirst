
//
//  XLRedPacketDetailViewController.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "DetailHeaderView.h"
#import "Masonry.h"
#import "UIScreen+Additons.h"

@interface DetailHeaderView ()

@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *packetFromNameLabel;
@property (strong, nonatomic) UILabel *packetRemarkLabel;
@property (strong, nonatomic) UILabel *packetIncomeLabel;
@property (strong, nonatomic) UILabel *packetHasReceivedLabel;
@property (strong, nonatomic) UIButton *packetHasReceivedWalletJumpButton;

@end

@implementation DetailHeaderView

#pragma mark -

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        self.backgroundColor = [UIColor colorWithString:COLORF6F6F6];
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.packetTopBgImageView];
    [self addSubview:self.avatarImageView];
    [self addSubview:self.packetFromNameLabel];
    [self addSubview:self.packetRemarkLabel];
    [self addSubview:self.packetIncomeLabel];
    [self addSubview:self.packetHasReceivedLabel];
    [self addSubview:self.packetHasReceivedWalletJumpButton];
    
    self.packetIncomeLabel.hidden = YES;
    self.packetHasReceivedLabel.hidden = YES;
    self.packetHasReceivedWalletJumpButton.hidden = YES;
}

- (void)layoutSubviews {
    [self.packetTopBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(adaptHeight1334(0));
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(adaptHeight1334(118));
    }];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.packetTopBgImageView.mas_bottom);
        make.width.height.mas_equalTo(adaptWidth750(124));
    }];
    [self.packetFromNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(adaptHeight1334(26));;
        make.centerX.equalTo(self);
    }];
    [self.packetRemarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.packetFromNameLabel.mas_bottom).offset((adaptHeight1334(24)));
        make.centerX.equalTo(self);
    }];
    [self.packetIncomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.packetRemarkLabel.mas_bottom).mas_offset(adaptHeight1334(16));
        make.centerX.equalTo(self);
    }];
    [self.packetHasReceivedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.packetRemarkLabel.mas_bottom).mas_offset(adaptHeight1334(20));
    }];
    [self.packetHasReceivedWalletJumpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).mas_offset(adaptHeight1334(-32));
    }];
}

#pragma mark - Public

- (void)configUIWithHeaderType:(DetailHeaderType)type
                   detailModel:(XLSessionRedPacketDetailModel *)detailModel {
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.avatar]];
    self.packetFromNameLabel.text = [NSString stringWithFormat:@"%@的红包",detailModel.name];
    self.packetRemarkLabel.text = @"恭喜发财，大吉大利！";
    self.packetIncomeLabel.text = detailModel.money;
    
    NSString *moneyTypeString = [detailModel.moneyType isEqualToString:@"coin"] ? @"金币" : @"零钱";
    
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"+%@%@",detailModel.money, moneyTypeString]];
    
    [aStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:adaptFontSize(72)] range:NSMakeRange(0, 1)];
    [aStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:adaptFontSize(100)] range:NSMakeRange(1, detailModel.money.length)];
    [aStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:adaptFontSize(32)] range:NSMakeRange(detailModel.money.length + 1, 2)];
    self.packetIncomeLabel.attributedText = aStr;
    
    if (type == DetailHeaderTypeFocusDetailFirstOpen) {
        
        self.packetIncomeLabel.hidden = NO;
        self.packetHasReceivedWalletJumpButton.hidden = NO;
        [self.packetHasReceivedWalletJumpButton setTitle:[NSString stringWithFormat:@"金币价值%@，已存入钱包",detailModel.moneyValue] forState:UIControlStateNormal];
        
    } else if (type == DetailHeaderTypeFocusDetailOpened) {
    
        self.packetHasReceivedLabel.hidden = NO;
        self.packetHasReceivedWalletJumpButton.hidden = NO;
        
    } else if (type == DetailHeaderTypeTeamDetailReceived) {
        
        self.packetIncomeLabel.hidden = NO;
        
    }
}

#pragma mark - Event Response

- (void)jumpButtonDidClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailHeaderViewDidClickWalletJump)]) {
        [self.delegate detailHeaderViewDidClickWalletJump];
    }
}

#pragma mark - Custom Accessor

- (UIImageView *)packetTopBgImageView {
    if (!_packetTopBgImageView) {
        _packetTopBgImageView = [[UIImageView alloc] init];
        _packetTopBgImageView.image = [UIImage imageNamed:@"openview_detail_top_bg"];
    }
    return _packetTopBgImageView;
}

- (UIImageView *)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 5;
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.layer.borderColor = [UIColor colorWithString:COLORFFE2B1].CGColor;
        _avatarImageView.layer.borderWidth = 1;
    }
    return _avatarImageView;
}

- (UILabel *)packetFromNameLabel {
    if (!_packetFromNameLabel) {
        _packetFromNameLabel = [[UILabel alloc] init];
        _packetFromNameLabel.font = [UIFont boldSystemFontOfSize:adaptFontSize(30)];
        [_packetFromNameLabel setTextColor:[UIColor colorWithString:COLOR000000]];
    }
    return _packetFromNameLabel;
}

- (UILabel *)packetRemarkLabel {
    if (!_packetRemarkLabel) {
        _packetRemarkLabel = [[UILabel alloc] init];
        _packetRemarkLabel.font = [UIFont systemFontOfSize:adaptFontSize(14*2)];
        [_packetRemarkLabel setTextColor:[UIColor colorWithString:COLOR2C2C2C]];
    }
    return _packetRemarkLabel;
}

- (UILabel *)packetIncomeLabel {
    if (!_packetIncomeLabel) {
        _packetIncomeLabel = [[UILabel alloc] init];
        _packetIncomeLabel.font = [UIFont systemFontOfSize:adaptFontSize(50*2)];
        [_packetIncomeLabel setTextColor:[UIColor colorWithString:COLOR333333]];
    }
    return _packetIncomeLabel;
}

- (UILabel *)packetHasReceivedLabel {
    if (!_packetHasReceivedLabel) {
        _packetHasReceivedLabel = [UILabel new];
        _packetHasReceivedLabel.text = @"您已经领取过了";
        _packetHasReceivedLabel.textColor = [UIColor colorWithString:COLOR303030];
        _packetHasReceivedLabel.font = [UIFont systemFontOfSize:adaptFontSize(44)];
    }
    return _packetHasReceivedLabel;
}

- (UIButton *)packetHasReceivedWalletJumpButton {
    if (!_packetHasReceivedWalletJumpButton) {
        _packetHasReceivedWalletJumpButton = [UIButton new];
        [_packetHasReceivedWalletJumpButton setTitle:@"请在我的钱包中查看" forState:UIControlStateNormal];
        [_packetHasReceivedWalletJumpButton setTitleColor:[UIColor colorWithString:COLOR4B6DAE] forState:UIControlStateNormal];
        _packetHasReceivedWalletJumpButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(28)];
        [_packetHasReceivedWalletJumpButton addTarget:self action:@selector(jumpButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _packetHasReceivedWalletJumpButton;
}

@end
