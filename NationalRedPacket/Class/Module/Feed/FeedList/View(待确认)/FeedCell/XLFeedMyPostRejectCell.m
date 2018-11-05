//
//  XLFeedMyPostRejectCell.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/8/13.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLFeedMyPostRejectCell.h"

@interface XLFeedMyPostRejectCell ()<TTTAttributedLabelDelegate>

@property (strong, nonatomic) XLFeedModel *model;

@end

@implementation XLFeedMyPostRejectCell

- (void)setupAuthorCellSubViews {
    self.titleLabel.delegate = self;
    [self.topAuthorView hiddenFeedBackButton];
    // 头像
    UIView *contentView = self.contentView;
    [contentView addSubview:self.topAuthorView];
    [self.topAuthorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top).mas_offset(adaptHeight1334(16));
        make.left.equalTo(contentView.mas_left);
        make.right.equalTo(contentView.mas_right);
        make.height.mas_equalTo(adaptHeight1334(64));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topAuthorView.mas_bottom).mas_offset(adaptHeight1334(16));
        make.left.equalTo(self.contentView).mas_offset(kLeftMargin);
        make.width.mas_equalTo(SCREEN_WIDTH - kLeftMargin * 2);
    }];
    
    UIButton *deleteButton = [UIButton new];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor colorWithString:COLOR222222] forState:UIControlStateNormal];
    [deleteButton setBackgroundColor:[UIColor colorWithString:COLORffffff]];
    [deleteButton addTarget:self action:@selector(didClickDeleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:deleteButton];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).mas_offset(adaptHeight1334(16));
        make.left.equalTo(self.contentView);
        make.height.mas_equalTo(adaptHeight1334(92));
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.equalTo(contentView.mas_bottom).mas_offset(-adaptHeight1334(20));
    }];
    
    UIImageView *lineImageView = [UIImageView new];
    lineImageView.backgroundColor = [UIColor colorWithString:COLORE6E6E6];
    [deleteButton addSubview:lineImageView];
    [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(deleteButton);
        make.height.mas_equalTo(adaptHeight1334(2));
    }];
    
}

//文字的点击事件
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components {
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(didClickManagementSpecificationButtonEvent:)]) {
        [self.cellDelegate didClickManagementSpecificationButtonEvent:self.model];
    }
}

- (void)configModelData:(XLFeedModel *)model indexPath:(NSIndexPath *)indexPath {
    [self.topAuthorView configFeedModel:model];
    
    NSString *title = [model.title stringByAppendingString:model.href];
    
    //可自动识别url，显示为蓝色+下划线
    self.titleLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    
    //此属性可以不显示下划线，点击的颜色默认为红色
    self.titleLabel.linkAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:NO],(NSString *)kCTUnderlineStyleAttributeName,nil];
    
    [self.titleLabel setText:title afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange jumpStringRange = [[mutableAttributedString string] rangeOfString:model.href options:NSCaseInsensitiveSearch];
        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor colorWithString:COLORFE6969].CGColor range:jumpStringRange];
        return mutableAttributedString;
    }];
    NSRange selRange=[title rangeOfString:model.href];
    [self.titleLabel addLinkToTransitInformation:@{@"select":model.href} withRange:selRange];
}

- (void)didClickDeleteButtonAction {
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(tableCell:deleteModel:)]) {
        [self.cellDelegate tableCell:self deleteModel:self.model];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
