//
//  XLFeedListSuperCommentCell.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/7/4.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLFeedListSuperCommentCell.h"

@implementation XLFeedListSuperCommentCell

- (void)setupViews {
    
    [super setupViews];
    
    self.contentView.backgroundColor = [UIColor colorWithString:COLORF7F7F7];
    
    self.headImageView.layer.cornerRadius = adaptHeight1334(24);
    self.timeLabel.hidden = YES;
    self.replyButton.hidden = YES;
    self.contentLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
    self.contentLabel.textColor = [UIColor colorWithString:COLOR666666];
    
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(adaptWidth750(30));
        make.top.equalTo(self.contentView).offset(adaptHeight1334(30));
        make.height.width.mas_equalTo(adaptHeight1334(24*2));
        
    }];
    
    [self.usernameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.headImageView.mas_right).offset(adaptWidth750(24));
        make.centerY.equalTo(self.headImageView);
        
    }];
    
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.headImageView.mas_bottom).offset(adaptHeight1334(20));
        make.left.equalTo(self.headImageView);
        make.width.mas_equalTo(SCREEN_WIDTH - adaptWidth750(32*2));
    }];
    
    [self.replyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentImageView.mas_bottom).offset(adaptHeight1334(0));
        make.left.equalTo(self.timeLabel.mas_right).offset(adaptWidth750(20));
        make.height.mas_equalTo(0);
        make.width.mas_equalTo(adaptWidth750(53*2));
        make.bottom.equalTo(self.contentView).offset(-adaptHeight1334(24));
    }];
    
}

@end
