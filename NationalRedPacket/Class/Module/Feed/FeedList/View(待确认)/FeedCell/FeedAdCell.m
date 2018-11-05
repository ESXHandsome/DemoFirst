//
//  FeedAdCell.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/3/27.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "FeedAdCell.h"

@interface FeedAdCell ()

@property (strong, nonatomic) UIImageView *adImageView;
@property (strong, nonatomic) UILabel *adTitleLabel;

@end

@implementation FeedAdCell

#pragma mark -
#pragma mark UI Initialize

- (void)setupViews {
    [super setupViews];
    [self.contentView addSubview:self.adTitleLabel];
    [self.contentView addSubview:self.adImageView];
    
    [self.adTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).mas_offset(adaptWidth750(38));
        make.top.equalTo(self.contentView.mas_top).mas_offset(adaptWidth750(16));
        make.width.mas_equalTo(SCREEN_WIDTH - (2 * adaptWidth750(38)));
    }];
    [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).mas_offset(adaptWidth750(38));
        make.right.equalTo(self.contentView.mas_right).mas_offset(adaptWidth750(-38));
        make.top.equalTo(self.adTitleLabel.mas_bottom).mas_offset(adaptWidth750(16));
        make.height.mas_equalTo(adaptHeight1334(189*2));
        make.bottom.equalTo(self.contentView.mas_bottom).mas_offset(-adaptWidth750(36));
    }];
}

#pragma mark - 
#pragma mark Public Method

- (void)configModelData:(XLFeedModel *)model indexPath:(NSIndexPath *)indexPath {
    self.adTitleLabel.text = model.adModel.title;
    [self.adImageView sd_setImageWithURL:[NSURL URLWithString:model.adModel.image]];
}

#pragma mark -
#pragma mark - Setters and Getters

- (UIImageView *)adImageView {
    if (!_adImageView) {
        _adImageView = [UIImageView new];
    }
    return _adImageView;
}

- (UILabel *)adTitleLabel {
    if (!_adTitleLabel) {
        _adTitleLabel = [UILabel new];
        _adTitleLabel.numberOfLines = 0;
        _adTitleLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
        _adTitleLabel.textColor = [UIColor colorWithString:COLOR333333];
    }
    return _adTitleLabel;
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
