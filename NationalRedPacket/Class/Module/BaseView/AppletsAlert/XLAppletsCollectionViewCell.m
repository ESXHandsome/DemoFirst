//
//  XLAppletsCollectionViewCell.m
//  NationalRedPacket
//
//  Created by Ying on 2018/6/21.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLAppletsCollectionViewCell.h"
#import "XLAppletsFloatLabel.h"

@interface XLAppletsCollectionViewCell()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) XLAppletsFloatLabel *floatLabel;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIImageView *underGroundView;
@property (strong, nonatomic) UIView *maskView;
@end

@implementation XLAppletsCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.frame = CGRectMake(0, 0, adaptWidth750(76*2), adaptHeight1334(76*2));
    self.layer.cornerRadius = adaptHeight1334(8*2);
    self.layer.masksToBounds = YES;
    [self addSubview:self.underGroundView];
    [self addSubview:self.maskView];
    [self addSubview:self.titleLabel];
}

- (void)congifAppletsView:(NSString *)bgImageString titleLabel:(NSString *)labelTitle floatLabel:(NSString *)floatTitle useMask:(BOOL)mask{
    
    if (!mask) {
        self.maskView.hidden = YES;
    }
    
    [self.underGroundView sd_setImageWithURL:[NSURL URLWithString:bgImageString] placeholderImage:GetImage(@"nothing")];
    
    [self.titleLabel setText:labelTitle];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(adaptWidth750(7*2));
        make.top.equalTo(self).mas_offset(adaptHeight1334(7*2));
        make.right.equalTo(self).mas_offset(-adaptHeight1334(7*2));
    }];
    
    if ([floatTitle isEqualToString:@""]) return;
    [self addSubview:self.floatLabel];
    self.floatLabel.textAlignment = NSTextAlignmentCenter;
    NSString *string = [NSString stringWithFormat:@" %@ ",floatTitle];
    [self.floatLabel setText:string];
    [self.floatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(adaptHeight1334(52*2));
        make.left.equalTo(self).mas_offset(adaptWidth750(7*2));
        make.height.mas_equalTo(adaptHeight1334(16*2));
    }];
    
    [self addSubview:self.label];
    [self.label setText:string];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.height.equalTo(self.floatLabel);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font =[UIFont fontWithName:@"PingFangSC-Regular" size:adaptFontSize(14*2)];
        _titleLabel.textColor = [UIColor colorWithString:COLORffffff];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (XLAppletsFloatLabel *)floatLabel {
    if (!_floatLabel) {
        _floatLabel = [[XLAppletsFloatLabel alloc] init];
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.frame = self.bounds;
        layer.colors = @[(__bridge id) [UIColor colorWithString:COLORFFEE33].CGColor,
                         (__bridge id) [UIColor colorWithString:COLORF7A800].CGColor];
        layer.startPoint = CGPointMake(0, 0);
        layer.endPoint = CGPointMake(1, 0);
        [_floatLabel.layer addSublayer:layer];
        _floatLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:adaptFontSize(10*2)];
        _floatLabel.textColor = [UIColor colorWithString:COLOR333333];
        _floatLabel.layer.cornerRadius = adaptHeight1334(8);
        _floatLabel.layer.masksToBounds = YES;

    }
    return _floatLabel;
}
- (UILabel *)label {
    if (!_label) {
        _label = [[XLAppletsFloatLabel alloc] init];
        _label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:adaptFontSize(10*2)];
        _label.textColor = [UIColor colorWithString:COLOR333333];
        _label.layer.cornerRadius = adaptHeight1334(8);
        _label.layer.masksToBounds = YES;
    }
    return _label;
}
- (UIImageView *)underGroundView {
    if (!_underGroundView) {
        _underGroundView = [[UIImageView alloc] init];
        _underGroundView.frame = self.frame;
    }
    return _underGroundView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.frame = self.underGroundView.frame;
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.frame = self.bounds;
        UIColor *color = [UIColor colorWithDisplayP3Red:0 green:0 blue:0 alpha:0.5];
        layer.colors = @[(__bridge id) [UIColor colorWithString:COLOR000000].CGColor,
                         (__bridge id) color.CGColor];
        layer.startPoint = CGPointMake(0, 0);
        layer.endPoint = CGPointMake(0, 1);
        [_maskView.layer addSublayer:layer];
        _maskView.alpha = 0.4;
    }
    return _maskView;
}

@end
