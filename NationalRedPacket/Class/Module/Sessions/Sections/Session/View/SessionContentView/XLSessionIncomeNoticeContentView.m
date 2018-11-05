//
//  XLSessionIncomeNoticeContentView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/28.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLSessionIncomeNoticeContentView.h"
#import "XLIncomeNoticeAttachment.h"

@interface XLSessionIncomeNoticeContentView ()

@property (strong, nonatomic) UIImageView *backgroundView;

@property (strong, nonatomic) UILabel *incomeTypeLabel;
@property (strong, nonatomic) UILabel *incomeContentTypeLabel;
@property (strong, nonatomic) UILabel *incomeContentLabel;
@property (strong, nonatomic) UILabel *incomeUnitLabel;

@property (strong, nonatomic) UILabel *incomeExplainLabel;
@property (strong, nonatomic) UILabel *explainContentLabel;

@property (strong, nonatomic) UILabel *incomeStatusLabel;
@property (strong, nonatomic) UILabel *statusConetnLabel;

@property (strong, nonatomic) UIView  *specLine;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIImageView *indicateImageView;

@end

@implementation XLSessionIncomeNoticeContentView

- (instancetype)initSessionMessageContentView {
    
    if (self = [super initSessionMessageContentView]) {
        
        self.backgroundView = [UIImageView new];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.backgroundView.layer.cornerRadius = 4;
        self.backgroundView.layer.borderWidth = 0.5;
        self.backgroundView.layer.borderColor = [UIColor colorWithString:COLORE6E6E6].CGColor;
        self.backgroundView.layer.masksToBounds = YES;
        
        self.incomeTypeLabel = [UILabel labWithText:@"零钱收入" fontSize:adaptFontSize(34) textColorString:COLOR333333];
        
        self.incomeContentTypeLabel = [UILabel labWithText:@"收入金额" fontSize:adaptFontSize(30) textColorString:COLOR999999];
        
        self.incomeContentLabel = [UILabel labWithText:@"50.00" fontSize:adaptFontSize(38*2) textColorString:COLOR333333];
        self.incomeContentLabel.font = [UIFont boldSystemFontOfSize:adaptFontSize(38*2)];

        self.incomeUnitLabel = [UILabel labWithText:@"元" fontSize:adaptFontSize(30) textColorString:COLOR333333];
        self.incomeUnitLabel.font = [UIFont boldSystemFontOfSize:adaptFontSize(30)];
        
        self.incomeExplainLabel = [UILabel labWithText:@"到账说明" fontSize:adaptFontSize(30) textColorString:COLOR999999];

        self.explainContentLabel = [UILabel labWithText:@"昨日金币收入已自动转换为50元" fontSize:adaptFontSize(30) textColorString:COLOR333333];

        self.incomeStatusLabel = [UILabel labWithText:@"交易状态" fontSize:adaptFontSize(30) textColorString:COLOR999999];

        self.statusConetnLabel = [UILabel labWithText:@"到账成功" fontSize:adaptFontSize(30) textColorString:COLOR333333];
        
        self.specLine = [UIView new];
        self.specLine.backgroundColor = [UIColor colorWithString:COLORE1E1DF];
        
        self.detailLabel = [UILabel labWithText:@"查看详情" fontSize:adaptFontSize(32) textColorString:COLOR333333];
        
        self.indicateImageView = [UIImageView new];
        self.indicateImageView.image = [UIImage imageNamed:@"my_return"];
        
        [self addSubview:self.backgroundView];
        [self.backgroundView addSubview:self.incomeTypeLabel];
        [self.backgroundView addSubview:self.incomeContentTypeLabel];
        [self.backgroundView addSubview:self.incomeContentLabel];
        [self.backgroundView addSubview:self.incomeUnitLabel];
        [self.backgroundView addSubview:self.incomeExplainLabel];
        [self.backgroundView addSubview:self.explainContentLabel];
        [self.backgroundView addSubview:self.incomeStatusLabel];
        [self.backgroundView addSubview:self.statusConetnLabel];
        [self.backgroundView addSubview:self.specLine];
        [self.backgroundView addSubview:self.detailLabel];
        [self.backgroundView addSubview:self.indicateImageView];
        
        self.bubbleImageView.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews {
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(adaptWidth750(30));
        make.width.mas_equalTo(SCREEN_WIDTH - adaptWidth750(60));
    }];
    
    [self.incomeTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.backgroundView).offset(adaptWidth750(30));
    }];
    
    [self.incomeContentTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView).offset(adaptHeight1334(75*2));
        make.centerX.equalTo(self.backgroundView);
    }];
    
    [self.incomeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.incomeContentTypeLabel.mas_bottom).offset(adaptHeight1334(10));
        make.centerX.equalTo(self.backgroundView);
    }];
    
    [self.incomeUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.incomeContentLabel.mas_right);
        make.bottom.equalTo(self.incomeContentLabel).offset(-adaptHeight1334(12));
    }];
    
    [self.incomeExplainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.incomeTypeLabel);
        make.top.equalTo(self.incomeTypeLabel.mas_bottom).offset(adaptHeight1334(147*2));
    }];
    
    [self.explainContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.incomeExplainLabel.mas_right).offset(adaptWidth750(34));
        make.centerY.equalTo(self.incomeExplainLabel);
    }];
    
    [self.incomeStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.incomeExplainLabel);
        make.top.equalTo(self.incomeExplainLabel.mas_bottom).offset(adaptHeight1334(26));
    }];
    
    [self.statusConetnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.incomeStatusLabel.mas_right).offset(adaptWidth750(34));
        make.centerY.equalTo(self.incomeStatusLabel);
    }];
    
    [self.specLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.incomeStatusLabel.mas_bottom).offset(adaptHeight1334(48));
        make.left.equalTo(self.incomeStatusLabel);
        make.right.equalTo(self.backgroundView).offset(-adaptWidth750(30));
        make.height.mas_equalTo(0.5);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.specLine);
        make.top.equalTo(self.specLine.mas_bottom).offset(adaptHeight1334(20));
    }];
    
    [self.indicateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.specLine);
        make.centerY.equalTo(self.detailLabel);
    }];
    
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    
    XLIncomeNoticeAttachment *attachment = [(NIMCustomObject *)data.message.messageObject attachment];
    
    BOOL isIcon = [attachment.moneyType isEqualToString:@"coin"];
    
    self.incomeTypeLabel.text = attachment.title;
    self.incomeContentTypeLabel.text = isIcon ? @"收入金币" : @"收入金额";
    self.incomeContentLabel.text = attachment.money;
    
    self.incomeUnitLabel.text = isIcon ? @"金币" : @"元";
    
    self.explainContentLabel.text = attachment.content;
    self.statusConetnLabel.text = attachment.statusTxt;

}

- (void)onTouchUpInside:(id)sender
{
    NIMKitEvent *event = [[NIMKitEvent alloc] init];
    event.eventName = NIMKitEventNameTapIncomeNotice;
    event.messageModel = self.model;
    [self.delegate onCatchEvent:event];
}

@end
