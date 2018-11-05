//
//  PersonInfoView.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/1/25.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "PersonalTopView.h"
#import "PersonalTopView.h"
#import "NSString+NumberAdapt.h"

@interface PersonalTopView ()<FollowButtonDelegate>

@property (strong, nonatomic) UIImageView *avatarImageView;         // 头像
@property (strong, nonatomic) UIView      *avatarBackView;          // 头像背景
@property (strong, nonatomic) UILabel     *nickNameLabel;           // 昵称
@property (strong, nonatomic) UIImageView *genderBgImageView;       // 性别背景
@property (strong, nonatomic) UIImageView *genderIconImageView;     // 性别图标
@property (strong, nonatomic) UILabel     *ageLabel;                // 年龄
@property (strong, nonatomic) UIImageView *locationImageView;       // 地点图标
@property (strong, nonatomic) UILabel     *locationLabel;           // 地点
@property (strong, nonatomic) UIImageView *constellationImageView;  // 星座图标
@property (strong, nonatomic) UILabel     *constellationLabel;      // 星座
@property (strong, nonatomic) UILabel     *bioLabel;                // 简介
@property (strong, nonatomic) UILabel     *followerNumLabel;        // 粉丝数
@property (strong, nonatomic) UILabel     *followNumLabel;          // 粉丝文字
@property (strong, nonatomic) UILabel     *followerLabel;           // 关注数
@property (strong, nonatomic) UILabel     *followLabel;             // 关注文字
@property (strong, nonatomic) UILabel     *segmentTopLine;          // 动态上部分割线
@property (strong, nonatomic) UILabel     *segmentBottomLine;       // 动态下部分割线

@end

#define kLeftMargin adaptWidth750(30)

@implementation PersonalTopView

#pragma mark -
#pragma mark UI Initialize

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self addSubview:self.personalBgImageView];
    [self addSubview:self.avatarBackView];
    [self addSubview:self.avatarImageView];
    [self addSubview:self.followButton];
    [self addSubview:self.nickNameLabel];
    [self addSubview:self.genderBgImageView];
    [self addSubview:self.genderIconImageView];
    [self addSubview:self.ageLabel];
    [self addSubview:self.locationImageView];
    [self addSubview:self.locationLabel];
    [self addSubview:self.constellationImageView];
    [self addSubview:self.constellationLabel];
    [self addSubview:self.bioLabel];
    [self addSubview:self.followerNumLabel];
    [self addSubview:self.followerLabel];
    [self addSubview:self.followNumLabel];
    [self addSubview:self.followLabel];
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
    [self addSubview:self.segmentTopLine];
    [self addSubview:self.segmentBottomLine];
    [self addSubview:self.segmentSelectedLine];
    
    [self.personalBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).mas_offset(-SCREEN_HEIGHT/2);
        make.height.mas_equalTo(adaptHeight1334(246) + SCREEN_HEIGHT/2);
    }];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(kLeftMargin);
        make.width.height.mas_equalTo(adaptWidth750(160));
        make.centerY.equalTo(self.personalBgImageView.mas_bottom);
    }];
    [self.avatarBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(adaptWidth750(166));
        make.center.equalTo(self.avatarImageView);
    }];
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(adaptWidth750(160));
        make.height.mas_equalTo(adaptHeight1334(64));
        make.right.equalTo(self.mas_right).mas_offset(-adaptWidth750(28));
        make.top.equalTo(self.personalBgImageView.mas_bottom).mas_offset(adaptHeight1334(24));
    }];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_left);
        make.top.equalTo(self.avatarImageView.mas_bottom).mas_offset(adaptHeight1334(26));
    }];
    [self.genderBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameLabel.mas_right).mas_offset(adaptWidth750(8));
        make.bottom.equalTo(self.nickNameLabel).mas_offset(adaptHeight1334(-4));
        make.height.mas_equalTo(adaptHeight1334(36));
        make.right.equalTo(self.ageLabel.mas_right).mas_offset(adaptWidth750(10));
    }];
    [self.genderIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.genderBgImageView.mas_left).mas_offset(adaptWidth750(12));
        make.centerY.equalTo(self.genderBgImageView);
        make.width.height.mas_equalTo(adaptWidth750(18));
    }];
    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.genderBgImageView);
        make.left.equalTo(self.genderIconImageView.mas_right).mas_offset(adaptWidth750(2));
    }];
    [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_left);
        make.bottom.equalTo(self.locationLabel).mas_offset(adaptHeight1334(-4));
        make.width.mas_equalTo(adaptWidth750(18));
        make.height.mas_equalTo(adaptHeight1334(22));
    }];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locationImageView.mas_right).mas_offset(adaptHeight1334(6));;
        make.top.equalTo(self.nickNameLabel.mas_bottom).mas_offset(adaptHeight1334(16));
        make.height.mas_equalTo(adaptHeight1334(32));
    }];
    [self.constellationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.locationImageView.mas_bottom);
        make.left.equalTo(self.locationLabel.mas_right).mas_offset(adaptWidth750(20));
        make.width.mas_equalTo(adaptWidth750(22));
        make.height.mas_equalTo(adaptHeight1334(22));
    }];
    [self.constellationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.locationLabel.mas_bottom);
        make.left.equalTo(self.constellationImageView.mas_right).mas_offset(adaptWidth750(6));
    }];
    [self.bioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_left);
        make.top.equalTo(self.locationLabel.mas_bottom).mas_offset(adaptHeight1334(16));
        make.right.equalTo(self.mas_right).mas_offset(-kLeftMargin);
    }];
    [self.followerNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_left);
        make.bottom.equalTo(self.followerLabel.mas_bottom).mas_offset(2);
    }];
    [self.followerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bioLabel.mas_bottom).mas_offset(adaptHeight1334(20));
        make.left.equalTo(self.followerNumLabel.mas_right).mas_offset(adaptWidth750(8));
    }];
    [self.followNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.followerNumLabel.mas_bottom);
        make.left.equalTo(self.followerLabel.mas_right).mas_offset(adaptWidth750(26));
    }];
    [self.followLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.followerLabel.mas_bottom);
        make.left.equalTo(self.followNumLabel.mas_right).mas_offset(adaptWidth750(8));
    }];
    [self.segmentTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.followerLabel.mas_bottom).mas_offset(adaptHeight1334(34));
        make.left.right.equalTo(self);
        make.height.mas_equalTo(adaptHeight1334(1));
    }];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.segmentTopLine.mas_bottom);
        make.height.mas_equalTo(adaptHeight1334(80));
        make.width.mas_equalTo(adaptWidth750(120));
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftButton.mas_right);
        make.top.equalTo(self.segmentTopLine.mas_bottom);
        make.height.mas_equalTo(adaptHeight1334(80));
        make.width.mas_equalTo(adaptWidth750(120));
    }];
    [self.segmentBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(adaptHeight1334(1));
    }];
}

#pragma mark -
#pragma mark Public Method

- (void)setModel:(XLPublisherModel *)model {
    _model = model;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"edit_avatar_big"]];
    self.nickNameLabel.text = model.nickname;
    self.ageLabel.text = [NSString stringWithFormat:@"%@岁",model.age];
    self.locationLabel.text = model.location.length == 0 ? @"未填写" : model.location;
    self.constellationLabel.text = model.constellation.length == 0 ? @"未填写" : model.constellation;
   
    if ([model.intro isEqualToString:@""]) {
        self.bioLabel.text = @"简介：TA还没有freestyle...";
        self.bioLabel.textColor = [UIColor colorWithString:COLORD2D2D2];
    } else {
        self.bioLabel.text = [NSString stringWithFormat:@"简介：%@",model.intro?:@""];
    }
    self.followerNumLabel.text = [NSString numberAdaptWithInteger:model.fansCount];
    self.followNumLabel.text = [NSString numberAdaptWithInteger:model.attentionCount];
    self.genderIconImageView.image = [UIImage imageNamed:[model.sex integerValue] == 2 ? @"personal_women_icon": @"personal_man_icon"];
    self.genderBgImageView.backgroundColor = [UIColor colorWithString:[model.sex integerValue] == 2 ? COLORFE2C55 : COLOR04B5E1];
    self.followButton.followed = model.isFollowed;
}

- (void)followButtonClick:(FollowButton *)sender {
    if (self.personalDelegate && [self.personalDelegate respondsToSelector:@selector(didClickPersonalFollowButtonEvent:withFollowButton:)]) {
        [self.personalDelegate didClickPersonalFollowButtonEvent:self.model withFollowButton:sender];
    }
}

- (void)didClickRightButtonEvent {
    [_leftButton setTitleColor:[UIColor colorWithString:COLOR333333] forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor colorWithString:COLORFE6969] forState:UIControlStateNormal];
    
    if (self.personalDelegate && [self.personalDelegate respondsToSelector:@selector(didClickTopViewVideoButton)]) {
        [self.personalDelegate didClickTopViewVideoButton];
    }
}

- (void)didClickLeftButtonEvent {
    [_leftButton setTitleColor:[UIColor colorWithString:COLORFE6969] forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor colorWithString:COLOR333333] forState:UIControlStateNormal];
    
    if (self.personalDelegate && [self.personalDelegate respondsToSelector:@selector(didClickTopViewDynamicButton)]) {
        [self.personalDelegate didClickTopViewDynamicButton];
    }
}

#pragma mark -
#pragma mark Setters and Getters

- (void)setSelectedItemIndex:(NSInteger)selectedItemIndex {
    _selectedItemIndex = selectedItemIndex;
    
    if (selectedItemIndex == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.segmentSelectedLine.frame = CGRectMake(adaptWidth750(30), self.height - adaptHeight1334(2), adaptHeight1334(60), adaptHeight1334(2));
        }];
        [_leftButton setTitleColor:[UIColor colorWithString:COLORFE6969] forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor colorWithString:COLOR333333] forState:UIControlStateNormal];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.segmentSelectedLine.frame = CGRectMake(adaptWidth750(150), self.height - adaptHeight1334(1), adaptHeight1334(60), adaptHeight1334(2));
        }];
        [_leftButton setTitleColor:[UIColor colorWithString:COLOR333333] forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor colorWithString:COLORFE6969] forState:UIControlStateNormal];
    }
    
    if (self.personalDelegate && [self.personalDelegate respondsToSelector:@selector(didClickTopViewSegmentView:)]) {
        [self.personalDelegate didClickTopViewSegmentView:selectedItemIndex];
    }
}

- (UIImageView *)personalBgImageView {
    if (!_personalBgImageView) {
        _personalBgImageView = [UIImageView new];
        _personalBgImageView.image = [UIImage imageNamed:@"homepage_personal_topbg"];
    }
    return _personalBgImageView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.cornerRadius = adaptWidth750(80);
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UIView *)avatarBackView
{
    if (!_avatarBackView) {
        _avatarBackView = [UIView new];
        _avatarBackView.backgroundColor = [UIColor whiteColor];
        _avatarBackView.layer.borderWidth = 0.5;
        _avatarBackView.layer.borderColor = [UIColor colorWithString:COLORE9E9E9].CGColor;
        _avatarBackView.layer.cornerRadius = adaptWidth750(83);
        _avatarBackView.layer.masksToBounds = YES;
    }
    return _avatarBackView;
}

- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [UILabel new];
        _nickNameLabel.textColor = [UIColor colorWithString:COLOR333333];
        _nickNameLabel.font = [UIFont boldSystemFontOfSize:adaptFontSize(36)];
    }
    return _nickNameLabel;
}

- (UIImageView *)genderBgImageView {
    if (!_genderBgImageView) {
        _genderBgImageView = [UIImageView new];
        _genderBgImageView.layer.cornerRadius = 9;
        _genderBgImageView.clipsToBounds = YES;
    }
    return _genderBgImageView;
}

- (UIImageView *)genderIconImageView {
    if (!_genderIconImageView) {
        _genderIconImageView = [UIImageView new];
    }
    return _genderIconImageView;
}

- (UILabel *)ageLabel {
    if (!_ageLabel) {
        _ageLabel = [UILabel new];
        _ageLabel.font = [UIFont systemFontOfSize:adaptFontSize(22)];
        _ageLabel.textColor = [UIColor whiteColor];
    }
    return _ageLabel;
}

- (UIImageView *)locationImageView {
    if (!_locationImageView) {
        _locationImageView = [UIImageView new];
        _locationImageView.image = [UIImage imageNamed:@"personal_place_icon"];
    }
    return _locationImageView;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [UILabel new];
        _locationLabel.font = [UIFont systemFontOfSize:adaptFontSize(26)];
        _locationLabel.textColor = [UIColor colorWithString:COLOR666666];
    }
    return _locationLabel;
}

- (UIImageView *)constellationImageView {
    if (!_constellationImageView) {
        _constellationImageView = [UIImageView new];
        _constellationImageView.image = [UIImage imageNamed:@"personal_constellat_icon"];
    }
    return _constellationImageView;
}

- (UILabel *)constellationLabel {
    if (!_constellationLabel) {
        _constellationLabel = [UILabel new];
        _constellationLabel.font = [UIFont systemFontOfSize:adaptFontSize(26)];
        _constellationLabel.textColor = [UIColor colorWithString:COLOR666666];
    }
    return _constellationLabel;
}

- (UILabel *)bioLabel {
    if (!_bioLabel) {
        _bioLabel = [UILabel new];
        _bioLabel.font = [UIFont systemFontOfSize:adaptFontSize(28)];
        _bioLabel.textColor = [UIColor colorWithString:COLOR333333];
    }
    return _bioLabel;
}

- (UILabel *)followerNumLabel {
    if (!_followerNumLabel) {
        _followerNumLabel = [UILabel new];
        _followerNumLabel.font = [UIFont systemFontOfSize:adaptFontSize(34)];
        _followerNumLabel.textColor = [UIColor colorWithString:COLORFE6969];
    }
    return _followerNumLabel;
}

- (UILabel *)followerLabel {
    if (!_followerLabel) {
        _followerLabel = [UILabel new];
        _followerLabel.text = @"粉丝";
        _followerLabel.font = [UIFont systemFontOfSize:adaptFontSize(26)];
        _followerLabel.textColor = [UIColor colorWithString:COLOR999999];
    }
    return _followerLabel;
}

- (UILabel *)followNumLabel {
    if (!_followNumLabel) {
        _followNumLabel = [UILabel new];
        _followNumLabel.font = [UIFont systemFontOfSize:adaptFontSize(34)];
        _followNumLabel.textColor = [UIColor colorWithString:COLORFE6969];
    }
    return _followNumLabel;
}

- (UILabel *)followLabel {
    if (!_followLabel) {
        _followLabel = [UILabel new];
        _followLabel.text = @"关注";
        _followLabel.font = [UIFont systemFontOfSize:adaptFontSize(26)];
        _followLabel.textColor = [UIColor colorWithString:COLOR999999];
    }
    return _followLabel;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton new];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(30)];
        [_leftButton setTitle:@"动态" forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor colorWithString:COLORFE6969] forState:UIControlStateNormal];
        [_leftButton addTarget:self
                        action:@selector(didClickLeftButtonEvent)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton new];
        [_rightButton setTitle:@"视频" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor colorWithString:COLOR333333] forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(30)];
        [_rightButton addTarget:self
                         action:@selector(didClickRightButtonEvent)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (UILabel *)segmentSelectedLine {
    if (!_segmentSelectedLine) {
        _segmentSelectedLine = [UILabel new];
        _segmentSelectedLine.backgroundColor = [UIColor colorWithString:COLORFE6969];
        _segmentSelectedLine.frame = CGRectMake(adaptWidth750(28), adaptHeight1334(2 * (272 + 40 + 20)) - adaptHeight1334(2),  adaptWidth750(60), adaptHeight1334(2));
    }
    return _segmentSelectedLine;
}

- (UILabel *)segmentTopLine {
    if (!_segmentTopLine) {
        _segmentTopLine = [UILabel new];
        _segmentTopLine.backgroundColor = [UIColor colorWithString:COLORF1F1F0];
    }
    return _segmentTopLine;
}

- (UILabel *)segmentBottomLine {
    if (!_segmentBottomLine) {
        _segmentBottomLine = [UILabel new];
        _segmentBottomLine.backgroundColor = [UIColor colorWithString:COLORF1F1F0];
    }
    return _segmentBottomLine;
}

- (FollowButton *)followButton {
    if (!_followButton) {
        _followButton = [FollowButton buttonWithType:FollowButtonTypePersonal];
        _followButton.delegate = self;
    }
    return _followButton;
}

- (CGRect)leftBtnFrame {
    return self.leftButton.frame;
}

- (CGRect)rightBtnFrame {
    return self.rightButton.frame;
}

@end

