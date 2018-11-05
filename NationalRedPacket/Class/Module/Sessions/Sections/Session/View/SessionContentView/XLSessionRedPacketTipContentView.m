
//
//  XLSessionRedPacketTipContentView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/31.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLSessionRedPacketTipContentView.h"
#import "UIImage+NIMKit.h"
#import "XLRedPacketTipAttachment.h"
#import "NIMKit.h"

@interface XLSessionRedPacketTipContentView ()

@property (strong, nonatomic) UIView      *backgroundView;
@property (strong, nonatomic) UIImageView *tipImageView;
@property (strong, nonatomic) UILabel     *tipLabel;
@property (strong, nonatomic) UIButton    *redPacketButton;

@end

@implementation XLSessionRedPacketTipContentView

- (instancetype)initSessionMessageContentView {
    if (self = [super initSessionMessageContentView]) {
        
        self.backgroundView = [UIView new];
        self.backgroundView.backgroundColor = [UIColor colorWithString:COLORD8D8D8];
        self.backgroundView.layer.cornerRadius = 4;
        self.backgroundView.layer.masksToBounds = YES;
        
        self.tipImageView = [UIImageView new];
        self.tipImageView.image = [UIImage imageNamed:@"chat_prompt_packet"];
        
        self.tipLabel = [UILabel labWithText:@"你领取了狮子座的" fontSize:adaptFontSize(28) textColorString:COLORffffff];
        
        self.redPacketButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.redPacketButton setTitle:@"红包" forState:UIControlStateNormal];
        [self.redPacketButton setTitleColor:[UIColor colorWithString:COLORFFA716] forState:UIControlStateNormal];
        self.redPacketButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(28)];
        [self.redPacketButton addTarget:self action:@selector(redPacketButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.redPacketButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
        
        [self addSubview:self.backgroundView];
        [self.backgroundView addSubview:self.tipImageView];
        [self.backgroundView addSubview:self.tipLabel];
        [self.backgroundView addSubview:self.redPacketButton];
        
        self.bubbleImageView.hidden = YES;
        
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    
    XLRedPacketTipAttachment *attachment = [(NIMCustomObject *)data.message.messageObject attachment];
    
    NSString *me = NIMSDK.sharedSDK.loginManager.currentAccount;
    
    NIMKitInfo * senderInfo = [[NIMKit sharedKit] infoByUser:attachment.senderId option:nil];
    NIMKitInfo * openerInfo = [[NIMKit sharedKit] infoByUser:attachment.openerId option:nil];
    
    NSString *senderName = [attachment.senderId isEqualToString:me] ? @"你" : senderInfo.showName;
    NSString *openerName = [attachment.openerId isEqualToString:me] ? @"你" : openerInfo.showName;
    self.tipLabel.text = [NSString stringWithFormat:@"%@领取了%@的", openerName, senderName];
    
}

- (void)redPacketButtonAction {
    
    XLLog(@"点击红包提示消息");
    NIMKitEvent *event = [[NIMKitEvent alloc] init];
    event.eventName = NIMKitEventNameTapRedPacketTip;
    event.messageModel = self.model;
    [self.delegate onCatchEvent:event];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.tipImageView.mas_left).offset(-adaptWidth750(20));
        make.right.equalTo(self.redPacketButton.mas_right).offset(adaptWidth750(20));
    }];
    
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tipLabel.mas_left).offset(-adaptWidth750(12));
        make.centerY.equalTo(self);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.redPacketButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.tipLabel.mas_right);
    }];
    
}

@end
