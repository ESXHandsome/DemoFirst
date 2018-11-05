//
//  ExchangeNotesCell.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/12/1.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "ExchangeNotesCell.h"

@interface ExchangeNotesCell ()

@end

@implementation ExchangeNotesCell

- (void)setupViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.titleLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(32) textColorString:COLOR999999];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    self.contentLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(28) textColorString:COLOR666666];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.contentLabel];
    
    self.textLabel.text = @" ";
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.textLabel);
        make.top.equalTo(self.contentView).offset(adaptHeight1334(24));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.textLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(adaptHeight1334(20));
        make.right.equalTo(self.contentView).offset(-adaptWidth750(20*2));
        make.bottom.equalTo(self.contentView).offset(-adaptHeight1334(30));

    }];
    
}

@end
