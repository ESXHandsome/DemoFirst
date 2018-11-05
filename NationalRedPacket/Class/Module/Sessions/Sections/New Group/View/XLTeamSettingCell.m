//
//  XLTeamSettingCell.m
//  NationalRedPacket
//
//  Created by bulangguo on 2018/7/27.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLTeamSettingCell.h"
#import "UILabel+Extension.h"

@implementation XLTeamSettingCell

- (void)setupViews {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel = [UILabel labWithText:@"群名称" fontSize:adaptFontSize(32) textColorString:COLOR333333];
    [self.contentView addSubview:self.titleLabel];
    
    self.contentLabel = [UILabel labWithText:@"段友聚集地" fontSize:adaptFontSize(32) textColorString:COLOR999999];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    
    self.switchButton = [UISwitch new];
    self.switchButton.onTintColor = [UIColor colorWithString:COLORFE6969];
    self.switchButton.tintColor = [UIColor colorWithString:COLORE6E6E6];
    [self.contentView addSubview:self.switchButton];
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = [UIColor colorWithString:COLORE6E6E6];
    [self.contentView addSubview:self.lineView];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(adaptWidth750(32));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-adaptWidth750(32));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-adaptWidth750(32));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void)configModelData:(XLTeamSettingModel *)model indexPath:(NSIndexPath *)indexPath {
    
    self.switchButton.hidden = indexPath.section == 0 ? YES : NO;
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    
    if ([model.title isEqualToString:@"群公告"]) {
        self.contentLabel.font = [UIFont systemFontOfSize:adaptFontSize(28)];
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).offset(adaptWidth750(32));
        }];
        
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(adaptWidth750(16));
            make.left.equalTo(self.titleLabel);
            make.width.mas_equalTo(SCREEN_WIDTH - adaptWidth750(64));
            make.bottom.equalTo(self.contentView).offset(-adaptWidth750(32));
        }];
        
    } else {
        self.contentLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(adaptWidth750(32));
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-adaptWidth750(32));
            make.centerY.equalTo(self.contentView);
        }];
    }
    
    self.switchButton.on = model.isNoDisturb;
    
    [self.contentLabel setLineSpacing:adaptHeight1334(6)];
    
}

@end
