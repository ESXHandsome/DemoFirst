//
//  CustomEditView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/23.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "CustomEditView.h"

@implementation CustomEditView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{    
    self.titleLabel = [UILabel labWithText:@"手机号" fontSize:adaptFontSize(32) textColorString:COLOR000000];
    [self addSubview:self.titleLabel];
    
    self.contentTextField = [UITextField new];
    self.contentTextField.placeholder = @"手机号";
    self.contentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.contentTextField.font = [UIFont systemFontOfSize:adaptFontSize(32)];
    self.contentTextField.textColor = [UIColor colorWithString:COLOR333333];
    [self addSubview:self.contentTextField];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(adaptWidth750(30));
        make.centerY.equalTo(self);
    }];
    
    [self.contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(adaptWidth750(180));
        make.right.equalTo(self).offset(-adaptWidth750(30));
        make.centerY.equalTo(self);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
