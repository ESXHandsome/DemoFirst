//
//  XLSessionGroupInviteContentView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/28.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLSessionGroupInviteContentView.h"
#import "TTTAttributedLabel.h"
#import "XLGroupInviteAttachment.h"

@interface XLSessionGroupInviteContentView ()

@property (strong, nonatomic) UILabel            *titleLabel;
@property (strong, nonatomic) TTTAttributedLabel *subTitleLabel;
@property (strong, nonatomic) UIImageView        *redPacketImageView;

@end

@implementation XLSessionGroupInviteContentView

- (instancetype)initSessionMessageContentView {
    
    if (self = [super initSessionMessageContentView]) {
        
        self.titleLabel = [UILabel labWithText:@"邀请你加入群聊" fontSize:adaptHeight1334(32) textColorString:COLOR333333];
        
        self.subTitleLabel = [TTTAttributedLabel new];
        self.subTitleLabel.text = @"“凉小虾米”邀请你加入群聊\n定时红包群，进入领取更多\n红包。";
        self.subTitleLabel.font = [UIFont systemFontOfSize:adaptFontSize(26)];
        self.subTitleLabel.textColor = [UIColor colorWithString:COLOR979AA0];
        self.subTitleLabel.lineSpacing = adaptHeight1334(4);
        self.subTitleLabel.numberOfLines = 0;
        self.subTitleLabel.userInteractionEnabled = NO;
        
        self.redPacketImageView = [UIImageView new];
        self.redPacketImageView.image = [UIImage imageNamed:@"chat_invite_packet"];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
        [self addSubview:self.redPacketImageView];
    }
    return self;
}

- (void)layoutSubviews {
    
    [self.bubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(adaptWidth750(36));
        make.top.equalTo(self).offset(adaptHeight1334(18));
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(adaptHeight1334(10));
        make.right.equalTo(self.redPacketImageView.mas_left).offset(-adaptWidth750(40));
    }];
    
    [self.redPacketImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitleLabel);
        make.right.equalTo(self).offset(-adaptWidth750(40));
        make.height.mas_equalTo(adaptHeight1334(47*2));
        make.width.mas_equalTo(adaptWidth750(41*2));

    }];
    
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    
    XLGroupInviteAttachment *attachment =[(NIMCustomObject *) data.message.messageObject attachment];
    self.subTitleLabel.text = attachment.content;
    [self.redPacketImageView sd_setImageWithURL:[NSURL URLWithString:attachment.icon]];

}

- (void)onTouchUpInside:(id)sender
{
    NIMKitEvent *event = [[NIMKitEvent alloc] init];
    event.eventName = NIMKitEventNameTapGroupInvite;
    event.messageModel = self.model;
    [self.delegate onCatchEvent:event];
}

@end
