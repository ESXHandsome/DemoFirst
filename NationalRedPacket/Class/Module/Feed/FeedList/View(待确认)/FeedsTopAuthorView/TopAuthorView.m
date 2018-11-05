//
//  TopAuthorView.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/2/19.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "TopAuthorView.h"
#import "FollowButton.h"
#import "NSDate+Timestamp.h"

@interface TopAuthorView ()<FollowButtonDelegate>

@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *nicknameLabel;
@property (strong, nonatomic) UILabel *publishTimeLabel;
@property (strong, nonatomic) XLFeedModel *model;
@property (strong, nonatomic) UIButton *feedBackButton;

@end

@implementation TopAuthorView

#pragma mark -
#pragma mark UI Initialize

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self addSubviewsContraints];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.avatarImageView];
    [self addSubview:self.nicknameLabel];
    [self addSubview:self.publishTimeLabel];
//    [self addSubview:self.followButton];
}

- (void)addSubviewsContraints {
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(adaptWidth750(64));
        make.left.equalTo(self.mas_left).mas_offset(adaptWidth750(32));
    }];
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView).offset(adaptHeight1334(6));
        make.left.equalTo(self.avatarImageView.mas_right).mas_offset(adaptWidth750(18));
    }];
    [self.publishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).mas_offset(adaptWidth750(-30));
    }];
//    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self).mas_offset(-adaptWidth750(26));
//        make.width.mas_equalTo(adaptWidth750(58*2));
//        make.height.mas_equalTo(adaptHeight1334(28*2));
//        make.centerY.equalTo(self.nicknameLabel.mas_centerY);
//    }];
}

#pragma mark -
#pragma mark Public Method

- (void)configFeedModel:(XLFeedModel *)model {
    _model = model;
  
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]
                            placeholderImage:[UIImage imageNamed:@"edit_avatar"]];
    
    self.nicknameLabel.text = model.nickname;
    
    [self setPublishTime:model.releaseTime.integerValue];
    
    [self updateFollowState:_model];
}

- (void)setPublishTime:(NSInteger)timestamp {
    self.publishTimeLabel.text = [NSDate timeIntervalCompareWithTimestamp:timestamp isContainHour:NO];
}

- (void)hiddenFollowButton:(BOOL)hidden {
    
//    self.followButton.hidden = hidden;
}

- (void)hiddenPublishLabel {
    self.publishTimeLabel.hidden = YES;
    [self.nicknameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).mas_offset(adaptWidth750(16));
        make.centerY.equalTo(self.avatarImageView);
    }];
}

- (void)showFeedbackButton {
    
//    [self.followButton mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self).mas_offset(-adaptWidth750(48*2));
//    }];
    
    [self addSubview:self.feedBackButton];
    
    [self.feedBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(adaptHeight1334(20*2));
        make.width.mas_equalTo(adaptWidth750(20*2));
        make.centerY.equalTo(self.nicknameLabel);
        make.right.equalTo(self).mas_offset(-adaptWidth750(14.8*2));
    }];
}

- (void)hiddenFeedBackButton {
    self.feedBackButton.hidden = YES;
}

#pragma mark -
#pragma mark Private Method

- (void)updateFollowState:(XLFeedModel *)model {
//    [self.followButton stopAnimation];
//    self.followButton.followed = model.isFollowed;
}

#pragma mark -
#pragma mark Event Response

- (void)didClickAvatarButtonEvent {
    if (self.topAuthorViewDelegate && [self.topAuthorViewDelegate respondsToSelector:@selector(didClickAvatarInTopAuthorViewEvent:)]) {
        [self.topAuthorViewDelegate didClickAvatarInTopAuthorViewEvent:_model];
    }
}

- (void)followButtonClick:(FollowButton *)sender {
    if (self.topAuthorViewDelegate && [self.topAuthorViewDelegate respondsToSelector:@selector(didClickFollowButtonInTopAuthorView:)]) {
        [self.topAuthorViewDelegate didClickFollowButtonInTopAuthorView:sender];
    }
}

- (void)feedBackButtonAction {
    self.feedbackView = [[NegativeFeedbackView alloc] init];
    self.feedbackView.model = self.model;
    self.feedbackView.delegate = self.negativeFeedbackDelegate;
    [self.feedbackView presentFromView:self.feedBackButton toContainer:self.window animated:YES completion:nil];
}

#pragma mark -
#pragma mark Setters and Getters

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.userInteractionEnabled = YES;
        _avatarImageView.layer.cornerRadius = adaptWidth750(32);
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.layer.borderWidth = 0.5;
        _avatarImageView.layer.borderColor = [UIColor colorWithString:COLORE6E6E6].CGColor;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickAvatarButtonEvent)];
        [_avatarImageView addGestureRecognizer:tap];
    }
    return _avatarImageView;
}

- (UILabel *)nicknameLabel {
    if (!_nicknameLabel) {
        _nicknameLabel = [UILabel new];
        _nicknameLabel.font = [UIFont systemFontOfSize:adaptFontSize(28)];
        _nicknameLabel.textColor = [UIColor colorWithString:COLOR999999];
        _nicknameLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickAvatarButtonEvent)];
        [_nicknameLabel addGestureRecognizer:tap];
    }
    return _nicknameLabel;
}

- (UILabel *)publishTimeLabel {
    if (!_publishTimeLabel) {
        _publishTimeLabel = [UILabel  new];
        _publishTimeLabel.font = [UIFont systemFontOfSize:adaptFontSize(24)];
        _publishTimeLabel.textColor = [UIColor colorWithString:COLORA7A7A7];
    }
    return _publishTimeLabel;
}

//- (FollowButton *)followButton {
//    if (!_followButton) {
//        _followButton = [FollowButton buttonWithType:FollowButtonTypeHome];
//        _followButton.delegate = self;
//        _followButton.hidden = YES;
//    }
//    return _followButton;
//}

- (UIButton *)feedBackButton {
    if (!_feedBackButton) {
        _feedBackButton = [[UIButton alloc] init];
        [_feedBackButton setImage:[UIImage imageNamed:@"comment_pic_close"] forState:UIControlStateNormal];
        [_feedBackButton addTarget:self action:@selector(feedBackButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _feedBackButton;
}
@end
