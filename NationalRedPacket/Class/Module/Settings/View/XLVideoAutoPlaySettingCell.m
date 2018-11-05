//
//  XLVideoAutoPlaySettingCell.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/8/6.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLVideoAutoPlaySettingCell.h"

@interface XLVideoAutoPlaySettingCell ()

@end

@implementation XLVideoAutoPlaySettingCell

- (void)setupViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.autoPlaySettingSwitch];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).mas_offset(adaptWidth750(24));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.autoPlaySettingSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).mas_offset(-adaptWidth750(24));
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setTitleLabelText:(NSString *)title isSwitch:(BOOL)isSwitch {
    self.titleLabel.text = title;
    [self.autoPlaySettingSwitch setOn : isSwitch];
}

- (void)didSwitchChangeAction {
    if (self.switchChangedBlock) {
        self.switchChangedBlock(self.autoPlaySettingSwitch.isOn);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor colorWithString:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(17*2)];
    }
    return _titleLabel;
}

- (UISwitch *)autoPlaySettingSwitch {
    if (!_autoPlaySettingSwitch) {
        _autoPlaySettingSwitch = [UISwitch new];
        _autoPlaySettingSwitch.onTintColor= [UIColor colorWithString:COLORFE6969];
        [_autoPlaySettingSwitch addTarget:self action:@selector(didSwitchChangeAction)forControlEvents:UIControlEventValueChanged];
    }
    return _autoPlaySettingSwitch;
}

@end
