//
//  XLPostAlertCollectionViewCell.m
//  NationalRedPacket
//
//  Created by Ying on 2018/7/11.
//  Copyright © 2018 XLook. All rights reserved.
//

#import "XLPostAlertCollectionViewCell.h"

@interface XLPostAlertCollectionViewCell ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation XLPostAlertCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.button];
        [self addSubview:self.titleLabel];

        [self configUI];
    }
    return self;
}

#pragma mark -
#pragma mark - Public Method

- (void)configCell:(UIImage *)image labelTitle:(NSString *)titleText {
    self.title = titleText;
    [self.button setBackgroundImage:image forState:UIControlStateNormal];
    [self.titleLabel setText:titleText];
}

#pragma mark -
#pragma mark - Private Method

- (void)configUI {
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(adaptHeight1334(17*2));
        make.height.mas_equalTo(adaptHeight1334(54*2));
        make.width.mas_equalTo(adaptWidth750(54*2));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.button.mas_bottom).offset(adaptHeight1334(8*2));
    }];
}

#pragma mark -
#pragma mark - Action

- (void)buttonAction:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        sender.transform = CGAffineTransformScale(sender.transform, 0.909, 0.909);
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectButton:)]) {
        [self.delegate didSelectButton:self.title];
    }
}

- (void)buttonScaleDownAnimation:(UIButton *)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        sender.transform = CGAffineTransformScale(sender.transform, 1.1, 1.1);
        
    }];
}

-(void)buttonScaleUpAnimation:(UIButton *)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        sender.transform = CGAffineTransformScale(sender.transform, 0.909, 0.909);
    }];
}

#pragma mark -
#pragma mark - Lazy load

- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] init];
        _button.layer.cornerRadius = adaptHeight1334(54);
        _button.layer.masksToBounds = YES;
        [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_button addTarget:self action:@selector(buttonScaleUpAnimation:) forControlEvents:UIControlEventTouchUpOutside];
        [_button addTarget:self action:@selector(buttonScaleDownAnimation:) forControlEvents:UIControlEventTouchDown];
        
    }
    return _button;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labWithText:@"未知" fontSize:adaptFontSize(13*2) textColorString:COLOR373737];
    }
    return _titleLabel;
}

@end
