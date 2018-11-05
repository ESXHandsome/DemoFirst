//
//  XLSessionTextAndPictureContentView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/6/20.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLSessionTextAndPictureContentView.h"
#import "XLTextAndPictureAttachment.h"

@interface XLSessionTextAndPictureContentView ()

@property (strong, nonatomic) UIImageView *contentImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;

@end

@implementation XLSessionTextAndPictureContentView

- (instancetype)initSessionMessageContentView {
    if (self = [super initSessionMessageContentView]) {
        
        self.contentImageView = [UIImageView new];
        self.contentImageView.backgroundColor = [UIColor colorWithString:COLOREDECED];
        self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.contentImageView.clipsToBounds = YES;
        
        self.titleLabel = [UILabel labWithText:@"急死了！工厂库存积压，基本10~20块赔钱甩卖，只敢亏1次！" fontSize:adaptFontSize(32) textColorString:COLOR333333];
        self.titleLabel.numberOfLines = 2;
        
        self.subtitleLabel = [UILabel labWithText:@"急死了！工厂库存积压，基本10~20块赔钱甩卖，只敢亏1次！" fontSize:adaptFontSize(24) textColorString:COLOR8B8B8B];
        self.subtitleLabel.numberOfLines = 3;
        
        [self addSubview:self.contentImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.subtitleLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(adaptWidth750(28));
        make.right.equalTo(self).offset(-adaptWidth750(20));
        make.top.equalTo(self).offset(adaptHeight1334(20));
    }];
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(adaptHeight1334(10));
        make.right.equalTo(self.titleLabel);
        make.width.height.mas_equalTo(adaptWidth750(90));
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentImageView);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.contentImageView.mas_left).offset(-adaptWidth750(20));
    }];
    
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    
    XLTextAndPictureAttachment *attachment = [(NIMCustomObject *)data.message.messageObject attachment];
    self.titleLabel.text = attachment.title;
    self.subtitleLabel.text = attachment.subtitle;
    [self.titleLabel setLineSpacing:adaptHeight1334(4)];
    [self.subtitleLabel setLineSpacing:adaptHeight1334(2)];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.subtitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:attachment.image]];
    
}

- (void)onTouchUpInside:(id)sender {
    
    XLTextAndPictureAttachment *attachment = [(NIMCustomObject *)self.model.message.messageObject attachment];
    
    NIMKitEvent *event = [[NIMKitEvent alloc] init];
    event.eventName = NIMKitEventNameTapActivityLink;
    event.messageModel = self.model;
    event.data = [XLActivityLinkModel yy_modelWithJSON:[attachment yy_modelToJSONObject]];
    [self.delegate onCatchEvent:event];
}

@end
