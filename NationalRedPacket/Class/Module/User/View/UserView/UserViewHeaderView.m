//
//  UserViewHeaderView.m
//  NationalRedPacket
//
//  Created by Ying on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "UserViewHeaderView.h"
#import "RedPacketTimingView.h"

@interface UserViewHeaderView() <RedPacketTimingViewDelegate>

@property (strong, nonatomic) UIImageView *authorImageView;
@property (strong, nonatomic) UILabel *authorName;
@property (strong, nonatomic) UILabel *invitedCode;
@property (strong, nonatomic) UILabel *invitedName;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) RedPacketTimingView *redPacketTimingView;
@property (assign, nonatomic) BOOL hasRedPakage;
@property (strong, nonatomic) UIImageView *tailImageView;


@end

@implementation UserViewHeaderView

- (instancetype)initWithRedType:(UserViewHeaderViewType)type {
    self = [super init];
    
    switch (type) {
        case UserViewHeaderViewNone:
            self.hasRedPakage = NO;
            self.frame = CGRectMake(0, 0, SCREEN_WIDTH, adaptHeight1334(100*2));
            break;
        case UserViewHeaderViewHasRedPackage:
            self.hasRedPakage = YES;
             self.frame = CGRectMake(0, 0, SCREEN_WIDTH, adaptHeight1334(234*2));
            break;
        default:
            break;
    }
    [self setUpUI];
    return self;
}

- (void)userHeaderView:(NSString *)imageUrlString authorName:(NSString *)authorName invitedCode:(NSString *)invitedCode {
    [self.authorImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"my_avatar"]];
    [self.authorName setText:authorName];
    [self.invitedCode setText:invitedCode];
}

/**
 更新定时红包装填
 
 @param isAvailable 定时红包是否可用
 @param countDown 定时红包倒计时时间戳
 @param availableTime 开抢时间
 */
- (void)updateTimingRedPacketAvailable:(BOOL)isAvailable
                         withCountDown:(long)countDown
                     withAvailableTime:(NSString *)availableTime {
    [self.redPacketTimingView updateTimingRedPacketAvailable:isAvailable
                                               withCountDown:countDown
                                           withAvailableTime:availableTime];
}

- (void)setUpUI {
    
    [self addSubview:self.headerView];
    [self.headerView addSubview:self.authorImageView];
    [self.headerView addSubview:self.authorName];
    [self.headerView addSubview:self.invitedName];
    [self.headerView addSubview:self.invitedCode];
    [self.headerView addSubview:self.tailImageView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(adaptHeight1334(100*2));
    }];
    
    [self.authorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).mas_equalTo(adaptWidth750(18*2));
        make.top.equalTo(self.headerView).mas_equalTo(adaptHeight1334(15*2));
        make.width.mas_equalTo(adaptWidth750(70*2));
        make.height.mas_equalTo(adaptHeight1334(70*2));
    }];
    
    [self.authorName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorImageView.mas_right).mas_equalTo(adaptWidth750(17*2));
        make.top.equalTo(self.headerView).mas_equalTo(adaptHeight1334(24*2));
        make.right.equalTo(self.headerView).mas_equalTo(-adaptWidth750(18*2));
    }];
    
    [self.invitedName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorImageView.mas_right).mas_equalTo(adaptWidth750(17*2));
        make.top.equalTo(self.authorName.mas_bottom).mas_equalTo(adaptHeight1334(7*2));
    }];
    
    [self.invitedCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.invitedName.mas_right);
        make.top.equalTo(self.authorName.mas_bottom).mas_equalTo(adaptHeight1334(7*2));
    }];
    
    [self.tailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).mas_offset(-adaptWidth750(13.6*2));
        make.width.mas_equalTo(adaptWidth750(8.4*2));
        make.height.mas_equalTo(adaptHeight1334(14.4*2));
    }];
    
    /**判断类型中是否有红包*/
    if (!self.hasRedPakage) return;
    [self addSubview:self.redPacketTimingView];
    [self.redPacketTimingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_equalTo(adaptWidth750(12*2));
        make.top.equalTo(self.headerView.mas_bottom).mas_equalTo(adaptHeight1334(12*2));
        make.right.equalTo(self).mas_equalTo(-adaptWidth750(12*2));
        make.bottom.equalTo(self).mas_equalTo(-adaptHeight1334(12*2));
    }];
}

#pragma mark -
#pragma mark - RedPacket Delegate

- (void)didClickTimingRedPacketEvent {
    if (!self.redPacketTimingView.packetIsAvailable) {
        [MBProgressHUD showError:@"还没到开抢时间"];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickTimingRedPacketEvent)]) {
        [self.delegate didClickTimingRedPacketEvent];
    }
}

- (void)timingRedPacketShowStateChanged:(BOOL)available {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headViewTimingRedPacketShowStateChanged:)]) {
        [self.delegate headViewTimingRedPacketShowStateChanged:available];
    }
}

#pragma mark -
#pragma mark - lazy load
- (UILabel *)authorName {
    if (!_authorName) {
        _authorName = [UILabel labWithText:@"老师都是狗娘养jsjslllLasjhdf你dddddd" fontSize:adaptFontSize(18*2) textColorString:COLOR333333];
        _authorName.numberOfLines = 0;
    }
    return _authorName;
}

- (UIImageView *)authorImageView {
    if (!_authorImageView) {
        _authorImageView = [UIImageView new];
        _authorImageView.size = CGSizeMake(adaptWidth750(70*2), adaptHeight1334(70*2));
        _authorImageView.layer.cornerRadius = _authorImageView.height/2;
        _authorImageView.layer.masksToBounds = YES;
        _authorImageView.image = [UIImage imageNamed:@"my_avatar"];
    }
    return _authorImageView;
}

- (UILabel *)invitedCode {
    if (!_invitedCode) {
        _invitedCode = [UILabel labWithText:@"111111111" fontSize:adaptFontSize(14*2) textColorString:COLOR666666];
    }
    return _invitedCode;
}

- (UILabel *)invitedName {
    if (!_invitedName) {
        _invitedName = [UILabel labWithText:@"邀请码: " fontSize:adaptFontSize(14*2) textColorString:COLOR666666];
    }
    return _invitedName;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.backgroundColor = [UIColor colorWithString:COLORffffff];
    }
    return _headerView;
}

- (RedPacketTimingView *)redPacketTimingView {
    if(!_redPacketTimingView) {
        _redPacketTimingView = [[RedPacketTimingView alloc] init];
        _redPacketTimingView.timingRedPacketDelegate = self;
    }
    return _redPacketTimingView;
}

/**尾巴的 " > "*/
- (UIImageView *)tailImageView {
    if (!_tailImageView) {
        _tailImageView = [[UIImageView alloc] init];
        _tailImageView.image = [UIImage imageNamed:@"my_return"];
    }
    return _tailImageView;
}

@end
