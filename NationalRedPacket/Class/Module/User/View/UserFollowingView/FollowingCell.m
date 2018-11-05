//
//  FollowingCell.m
//  NationalRedPacket
//
//  Created by 王海玉 on 2018/1/25.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "FollowingCell.h"

@interface FollowingCell()

@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *nickNameLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UILabel *bottomline;

@end

@implementation FollowingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.avatarImageView];
    [self addSubview:self.nickNameLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.bottomline];

    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(adaptHeight1334(90));
        make.left.equalTo(self).offset(adaptHeight1334(30));
    }];
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView);
        make.left.equalTo(self.avatarImageView.mas_right).offset(adaptHeight1334(16));
        make.height.mas_equalTo(adaptHeight1334(44));
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nickNameLabel.mas_bottom).offset(adaptHeight1334(8));
        make.left.equalTo(self.avatarImageView.mas_right).offset(adaptHeight1334(16));
        make.height.mas_equalTo(adaptHeight1334(34));
        make.right.equalTo(self.mas_right).offset(-adaptHeight1334(16));
    }];
    
    [self.bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self);
        make.left.equalTo(self.avatarImageView);
        make.right.equalTo(self);
    }];
}

- (void)setModel:(XLPublisherModel *)model {
    _model = model;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"my_avatar"]];
    self.nickNameLabel.text = model.nickname;
    self.detailLabel.text = model.intro;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark Setters and Getters

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.layer.cornerRadius = adaptHeight1334(90)/2.0;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.userInteractionEnabled = YES;
    }
    return _avatarImageView;
}

- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [UILabel new];
        _nickNameLabel.text = @"玄英大王";
        _nickNameLabel.textColor = [UIColor colorWithString:COLOR333333];
        _nickNameLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
    }
    return _nickNameLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.text = @"简介：无～～";
        _detailLabel.textColor = [UIColor colorWithString:COLOR999999];
        _detailLabel.font = [UIFont boldSystemFontOfSize:adaptFontSize(24)];
        _detailLabel.numberOfLines = 1;
    }
    return _detailLabel;
}

- (UILabel *)bottomline {
    if (!_bottomline) {
        _bottomline = [UILabel new];
        _bottomline.backgroundColor = [UIColor colorWithString:COLOREAEAEA];
    }
    return _bottomline;
}

@end
