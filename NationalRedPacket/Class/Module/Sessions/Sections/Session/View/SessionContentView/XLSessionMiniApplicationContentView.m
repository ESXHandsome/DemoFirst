//
//  XLSessionMiniApplicationContentView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/6/20.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLSessionMiniApplicationContentView.h"
#import "XLMiniApplicationAttachment.h"

@interface XLSessionMiniApplicationContentView ()

@property (strong, nonatomic) UIImageView *appIcon;
@property (strong, nonatomic) UILabel     *appNameLabel;
@property (strong, nonatomic) UILabel     *titleLabel;
@property (strong, nonatomic) UIImageView *contentImageView;
@property (strong, nonatomic) UIView      *specLine;
@property (strong, nonatomic) UIImageView *miniIcon;
@property (strong, nonatomic) UILabel     *miniLabel;

@end

@implementation XLSessionMiniApplicationContentView

- (instancetype)initSessionMessageContentView {
    if (self = [super initSessionMessageContentView]) {
        
        self.appIcon = [UIImageView new];
        self.appIcon.backgroundColor = [UIColor colorWithString:COLOREDEDED];
        self.appIcon.layer.cornerRadius = adaptWidth750(20);
        self.appIcon.layer.masksToBounds = YES;
        
        self.appNameLabel = [UILabel labWithText:@"神段子" fontSize:adaptFontSize(24) textColorString:COLOR999999];
        
        self.titleLabel = [UILabel labWithText:@"『神奇的不只是段子』" fontSize:adaptFontSize(32) textColorString:COLOR333333];
        self.titleLabel.numberOfLines = 2;
        [self.titleLabel setLineSpacing:adaptHeight1334(4)];
        
        self.contentImageView = [UIImageView new];
        self.contentImageView.backgroundColor = [UIColor colorWithString:COLOREDECED];
        self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.contentImageView.clipsToBounds = YES;
        
        self.specLine = [UIView new];
        self.specLine.backgroundColor = [UIColor colorWithString:COLORE6E6E6];
        
        self.miniIcon = [UIImageView new];
        self.miniIcon.image = [UIImage imageNamed:@"chat_icon_apply"];
        
        self.miniLabel = [UILabel labWithText:@"小应用" fontSize:adaptFontSize(20) textColorString:COLOR999999];
        
        [self addSubview:self.appIcon];
        [self addSubview:self.appNameLabel];
        [self addSubview:self.titleLabel];
        [self addSubview:self.contentImageView];
        [self addSubview:self.specLine];
        [self addSubview:self.miniIcon];
        [self addSubview:self.miniLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.appIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(adaptWidth750(30));
        make.top.equalTo(self).offset(adaptHeight1334(20));
        make.height.width.mas_equalTo(adaptWidth750(40));
    }];
    
    [self.appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.appIcon.mas_right).offset(adaptWidth750(10));
        make.centerY.equalTo(self.appIcon);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.appIcon);
        make.top.equalTo(self.appIcon.mas_bottom).offset(adaptHeight1334(16));
        make.right.equalTo(self).offset(-adaptWidth750(20));
    }];
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(adaptHeight1334(16));
        make.height.mas_equalTo(adaptHeight1334(168*2));
    }];
    
    [self.specLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(adaptWidth750(10));
        make.right.equalTo(self);
        make.top.equalTo(self.contentImageView.mas_bottom).offset(adaptHeight1334(18));
        make.height.mas_equalTo(0.5);
    }];
    
    [self.miniIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentImageView);
        make.top.equalTo(self.specLine.mas_bottom).offset(adaptHeight1334(10));
    }];
    
    [self.miniLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.miniIcon.mas_right).offset(adaptWidth750(10));
        make.centerY.equalTo(self.miniIcon);
    }];
    
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    
    XLMiniApplicationAttachment *attachment = [(NIMCustomObject *)data.message.messageObject attachment];
    [self.appIcon sd_setImageWithURL:[NSURL URLWithString:attachment.icon]];
    self.appNameLabel.text = attachment.nickname;
    self.titleLabel.text = attachment.title;
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:attachment.image]];
    [self.titleLabel setLineSpacing:adaptHeight1334(4)];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
}

- (void)onTouchUpInside:(id)sender {
    
    XLMiniApplicationAttachment *attachment = [(NIMCustomObject *)self.model.message.messageObject attachment];
    
    NIMKitEvent *event = [[NIMKitEvent alloc] init];
    event.eventName = NIMKitEventNameTapActivityLink;
    event.messageModel = self.model;
    event.data = [XLActivityLinkModel yy_modelWithJSON:[attachment yy_modelToJSONObject]];
    [self.delegate onCatchEvent:event];
}

@end
