//
//  alertView.m
//  NationalRedPacket
//
//  Created by 王海玉 on 2018/1/2.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "AlertView.h"
#import "UIImage+Tool.h"


@interface AlertView ()

@property (strong, nonatomic) UIView *popWindowView;
@property (strong, nonatomic) UILabel *titltLabel;
@property (strong, nonatomic) UILabel *detailLabel;

@end

@implementation AlertView


- (void)setupViews {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    _popWindowView = [[UIView alloc]init];
    _popWindowView.backgroundColor = [UIColor colorWithString:COLORffffff];
    _popWindowView.layer.cornerRadius = 4.0f;
    _popWindowView.layer.masksToBounds = YES;
    [self addSubview:_popWindowView];
    
    _titltLabel = [[UILabel alloc]init];
    _titltLabel.textColor = [UIColor colorWithString:COLOR000000];
    _titltLabel.font = [UIFont systemFontOfSize:adaptFontSize(40)];
    [_popWindowView addSubview:_titltLabel];
    
    _detailLabel = [[UILabel alloc]init];
    _detailLabel.textColor = [UIColor colorWithString:COLOR666666];
    _detailLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _detailLabel.numberOfLines = 0;
    [_popWindowView addSubview:_detailLabel];
    
    _leftButton = [[UIButton alloc]init];
    _leftButton.layer.cornerRadius = adaptFontSize(8);
    _leftButton.layer.masksToBounds = YES;
    [_leftButton setTitleColor:[UIColor colorWithString:COLORF85959] forState:UIControlStateNormal];
    [_leftButton setTitleColor:[UIColor colorWithString:COLORDE4F4F] forState:UIControlStateHighlighted];
    [_leftButton.layer setBorderColor:[UIColor colorWithString:COLORF85959].CGColor];
    [_leftButton.layer setBorderWidth:0.5];
    [_popWindowView addSubview:_leftButton];
    
    _rightButton = [[UIButton alloc]init];
    _rightButton.layer.cornerRadius = adaptFontSize(8);
    _rightButton.layer.masksToBounds = YES;
    [_rightButton setTitleColor:[UIColor colorWithString:COLORffffff] forState:UIControlStateNormal];
    [_rightButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithString:COLORF85959] size:CGSizeMake(adaptWidth750(235), adaptHeight1334(76))] forState:UIControlStateNormal];
    [_rightButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithString:COLORDE4F4F] size:CGSizeMake(adaptWidth750(235), adaptHeight1334(76))] forState:UIControlStateHighlighted];
    [_popWindowView addSubview:_rightButton];
}

- (void)alertViewWithTitle:(NSString *)title detail:(NSString *)detail leftBtnName:(NSString *)left rightBtnName:(NSString *)right {
    self.titltLabel.text = title;
    self.detailLabel.text = detail;
    [self.leftButton setTitle:left forState:UIControlStateNormal];
    [self.rightButton setTitle:right forState:UIControlStateNormal];
    [self initLayout];
}

- (void)initLayout {
    
    [self.popWindowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(adaptHeight1334(580));
        make.bottom.equalTo(self.leftButton).offset(adaptHeight1334(40));
    }];
    
    [self.titltLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.popWindowView);
        make.top.equalTo(self.popWindowView).offset(adaptHeight1334(44));
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titltLabel.mas_bottom).offset(adaptHeight1334(26));
        make.left.equalTo(self.popWindowView).offset(adaptWidth750(46));
        make.right.equalTo(self.popWindowView).offset(-adaptWidth750(46));
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_bottom).offset(adaptHeight1334(38));
        make.height.mas_equalTo(adaptHeight1334(76));
        make.width.mas_equalTo(adaptWidth750(235));
        make.left.equalTo(self.detailLabel);
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_bottom).offset(adaptHeight1334(38));
        make.height.width.equalTo(self.leftButton);
        make.right.equalTo(self.detailLabel);
    }];
}

@end
