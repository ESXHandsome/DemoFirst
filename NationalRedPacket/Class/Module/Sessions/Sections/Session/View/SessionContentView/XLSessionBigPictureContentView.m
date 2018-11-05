//
//  XLSessionBigPictureContentView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/6/20.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLSessionBigPictureContentView.h"
#import "TTTAttributedLabel.h"
#import "XLBigPictureAttachment.h"

@interface XLSessionBigPictureContentView ()

@property (strong, nonatomic) UIImageView *backgroundView;
@property (strong, nonatomic) UIImageView *contentImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;

@end

@implementation XLSessionBigPictureContentView

- (instancetype)initSessionMessageContentView {
    if (self = [super initSessionMessageContentView]) {
        
        self.bubbleImageView.hidden = YES;
        
        self.backgroundView = [UIImageView new];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.backgroundView.layer.cornerRadius = 4;
        self.backgroundView.layer.borderWidth = 0.5;
        self.backgroundView.layer.borderColor = [UIColor colorWithString:COLORE6E6E6].CGColor;
        self.backgroundView.layer.masksToBounds = YES;
        
        self.contentImageView = [UIImageView new];
        self.contentImageView.backgroundColor = [UIColor colorWithString:COLOREDECED];
        self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.contentImageView.clipsToBounds = YES;
        
        self.titleLabel = [UILabel labWithText:@"动漫中的诗情画意 不管你在世界的哪里，我一定回去见你" fontSize:adaptFontSize(36) textColorString:COLOR000000];
        self.titleLabel.numberOfLines = 2;
        [self.titleLabel setLineSpacing:adaptHeight1334(4)];
        
        self.subtitleLabel = [UILabel labWithText:@"新海诚将这首和歌插入到剧中，正是利用黄昏时期的结缘、产灵，仿佛暗示着男女主角最后一定会再相遇。" fontSize:adaptFontSize(28) textColorString:COLOR888888];
        self.subtitleLabel.numberOfLines = 0;
        [self.subtitleLabel setLineSpacing:adaptHeight1334(6)];
        
        [self addSubview:self.backgroundView];
        [self.backgroundView addSubview:self.contentImageView];
        [self.backgroundView addSubview:self.titleLabel];
        [self.backgroundView addSubview:self.subtitleLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(adaptWidth750(30));
        make.width.mas_equalTo(SCREEN_WIDTH - adaptWidth750(60));
    }];
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.backgroundView);
        make.height.mas_equalTo(adaptHeight1334(196*2));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroundView).offset(adaptWidth750(40));
        make.right.equalTo(self.backgroundView).offset(-adaptWidth750(40));
        make.top.equalTo(self.contentImageView.mas_bottom).offset(adaptHeight1334(34));
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(adaptHeight1334(14));
    }];
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    
    XLBigPictureAttachment *attachment = [(NIMCustomObject *)data.message.messageObject attachment];
    self.titleLabel.text = attachment.title;
    self.subtitleLabel.text = attachment.subtitle;
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:attachment.image]];
    [self.titleLabel setLineSpacing:adaptHeight1334(4)];
    [self.subtitleLabel setLineSpacing:adaptHeight1334(6)];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
}

- (void)onTouchUpInside:(id)sender {
    
    XLBigPictureAttachment *attachment = [(NIMCustomObject *)self.model.message.messageObject attachment];
    
    NIMKitEvent *event = [[NIMKitEvent alloc] init];
    event.eventName = NIMKitEventNameTapActivityLink;
    event.messageModel = self.model;
    event.data = [XLActivityLinkModel yy_modelWithJSON:[attachment yy_modelToJSONObject]];
    [self.delegate onCatchEvent:event];
    
}

@end
