//
//  XLSessionRedPacketContentView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/28.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLSessionRedPacketContentView.h"
#import "XLRedPacketAttachment.h"

@interface XLSessionRedPacketContentView ()

@property (strong, nonatomic) UIImageView *backRedPacketImageView;
@property (strong, nonatomic) UIImageView *statusImageView;
@property (strong, nonatomic) UILabel     *titleLabel;
@property (strong, nonatomic) UILabel     *statusLabel;
@property (strong, nonatomic) UILabel     *detailLabel;

@end

@implementation XLSessionRedPacketContentView

- (instancetype)initSessionMessageContentView {
    
    if (self = [super initSessionMessageContentView]) {
        
        self.backRedPacketImageView = [UIImageView new];
        
        self.statusImageView = [UIImageView new];
        self.statusImageView.image = [UIImage imageNamed:@"chat_invite_packet"];
        
        self.titleLabel = [UILabel labWithText:@"恭喜发财，大吉大利" fontSize:adaptFontSize(32) textColorString:COLORffffff];
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        self.statusLabel = [UILabel labWithText:@"领取红包" fontSize:adaptFontSize(24) textColorString:COLORffffff];
        
        self.detailLabel = [UILabel labWithText:@"神段子红包" fontSize:adaptFontSize(22) textColorString:COLOR939393];
        
        [self addSubview:self.backRedPacketImageView];
        [self addSubview:self.statusImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.statusLabel];
        [self addSubview:self.detailLabel];
        
        self.bubbleImageView.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews {
    
    [self.backRedPacketImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(adaptWidth750(32));
        make.top.equalTo(self).offset(adaptHeight1334(20));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusImageView.mas_right).offset(adaptWidth750(20));
        make.width.mas_equalTo(adaptWidth750(166*2));
        make.top.equalTo(self.statusImageView);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(adaptHeight1334(4));
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusImageView);
        make.bottom.equalTo(self.mas_bottom).offset(-adaptHeight1334(8));
    }];
    
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    
    XLRedPacketAttachment *attachment = [(NIMCustomObject *)data.message.messageObject attachment];
    self.titleLabel.text = attachment.content ?: @"恭喜发财，大吉大利";
    
    NSString *imageStr = @"chat_packet_bg_h";
    NSString *statusImageStr = @"chat_packet_h";
    NSString *statusText;
    switch (attachment.status) {
        case RedPacketStatusNormal: {
            statusText = @"领取红包";
            imageStr = @"chat_packet_bg_no";
            statusImageStr = @"chat_invite_packet";
            break;
        }
        case RedPacketStatusOverdue: {
            statusText = @"红包已过期";
            break;
        }
        case RedPacketStatusOpened: {
            statusText = @"红包已领取";
            break;
        }
        case RedPacketStatusEmpty: {
            statusText = @"红包已被领完";
            break;
        }
    }
    self.statusLabel.text = statusText;
    self.statusImageView.image = [UIImage imageNamed:statusImageStr];
    self.backRedPacketImageView.image = [[UIImage imageNamed:imageStr] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{28,25,17,25}") resizingMode:UIImageResizingModeStretch];
    
}

- (void)onTouchUpInside:(id)sender
{
    NIMKitEvent *event = [[NIMKitEvent alloc] init];
    event.eventName = NIMKitEventNameTapRedPacket;
    event.messageModel = self.model;
    [self.delegate onCatchEvent:event];
}

@end
