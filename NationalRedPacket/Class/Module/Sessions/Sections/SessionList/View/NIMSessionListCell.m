//
//  NTESSessionListCell.m
//  NIMDemo
//
//  Created by chris on 15/2/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NIMSessionListCell.h"
#import "NIMAvatarImageView.h"
#import "UIView+NIM.h"
#import "NIMKitUtil.h"
#import "NIMBadgeView.h"
#import "UIView+XLBadge.h"
#import "XLBadgeRegister.h"
#import "NSString+XLBadgeCount.h"

@implementation NIMSessionListCell

#define AvatarWidth adaptWidth750(100)

#pragma mark -

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.backgroundColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:adaptFontSize(34)];
        _nameLabel.textColor = [UIColor colorWithString:COLOR333333];
        [self addSubview:_nameLabel];
        
        _officialLogo = [UIImageView new];
        _officialLogo.image = [UIImage imageNamed:@"official_logo"];
        _officialLogo.hidden = NO;
        [self addSubview:_officialLogo];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.backgroundColor = [UIColor whiteColor];
        _messageLabel.font = [UIFont systemFontOfSize:adaptFontSize(30)];
        _messageLabel.textColor = [UIColor colorWithString:COLOR979AA0];
        [self addSubview:_messageLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.backgroundColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:adaptFontSize(24)];
        _timeLabel.textColor = [UIColor colorWithString:COLORA7A7A7];
        [self addSubview:_timeLabel];
        
        _noDisturbImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noDisturb"]];
        [self addSubview:_noDisturbImageView];
        
        _avatarImageView = [[NIMAvatarImageView alloc] initWithFrame:CGRectMake(0, 0, AvatarWidth, AvatarWidth)];
        [self addSubview:_avatarImageView];
        _avatarImageView.cornerRadius = 6.0f;
        
        _badgeView = [NIMBadgeView viewWithBadgeTip:@""];
        [self addSubview:_badgeView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //Session List
    NSInteger sessionListAvatarLeft             = 10;
    NSInteger sessionListNameTop                = 12;
    NSInteger sessionListNameLeftToAvatar       = 10;
    NSInteger sessionListOfficialLogoLeftToName = 6;
    NSInteger sessionListMessageLeftToAvatar    = 10;
    NSInteger sessionListMessageBottom          = 12;
    NSInteger sessionListTimeRight              = 12;
    NSInteger sessionListTimeTop                = 12;
    
    _avatarImageView.nim_left    = sessionListAvatarLeft;
    _avatarImageView.nim_centerY = self.nim_height * .5f;
    _nameLabel.nim_top           = sessionListNameTop;
    _nameLabel.nim_left          = _avatarImageView.nim_right + sessionListNameLeftToAvatar;
    _officialLogo.nim_left       = _nameLabel.nim_right + sessionListOfficialLogoLeftToName;
    _officialLogo.nim_centerY    = _nameLabel.nim_centerY;
    _officialLogo.nim_height     = adaptHeight1334(32);
    _officialLogo.nim_width      = adaptWidth750(56);
    _messageLabel.nim_left       = _avatarImageView.nim_right + sessionListMessageLeftToAvatar;
    _messageLabel.nim_bottom     = self.nim_height - sessionListMessageBottom;
    _timeLabel.nim_right         = self.nim_width - sessionListTimeRight;
    _timeLabel.nim_top           = sessionListTimeTop;
    _noDisturbImageView.nim_right = _timeLabel.nim_right;
    _noDisturbImageView.centerY  = _messageLabel.centerY;
    _badgeView.nim_centerX       = _avatarImageView.nim_right;
    _badgeView.nim_centerY       = _avatarImageView.nim_top;
    _badgeView.nim_width         = 10;
    _badgeView.nim_height        = 10;
}

#pragma mark - Public Method

#define NameLabelMaxWidth    adaptWidth750(250 * 2)
#define MessageLabelMaxWidth adaptWidth750(271 * 2)

- (void)refresh:(NIMRecentSession*)recent{
    self.nameLabel.nim_width = self.nameLabel.nim_width > NameLabelMaxWidth ? NameLabelMaxWidth : self.nameLabel.nim_width;
    self.messageLabel.nim_width = self.messageLabel.nim_width > MessageLabelMaxWidth ? MessageLabelMaxWidth : self.messageLabel.nim_width;
    
    if (recent.unreadCount) {
        self.avatarImageView.badgeValue = [NSString badgeCount:recent.unreadCount];
    } else {
        self.avatarImageView.badgeValue = nil;
    }
    
    if (recent.session.sessionType == NIMSessionTypeTeam) {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:recent.session.sessionId];
        if (team.notifyStateForNewMsg == NIMTeamNotifyStateNone) {
            self.noDisturbImageView.hidden = NO;
            self.avatarImageView.badgeValue = nil;
            if (recent.unreadCount != 0) {
                self.badgeView.hidden = NO;
            } else {
                self.badgeView.hidden = YES;
            }
        } else {
            self.noDisturbImageView.hidden = YES;
            self.badgeView.hidden = YES;
        }
    } else {
        self.noDisturbImageView.hidden = YES;
        self.badgeView.hidden = YES;
    }
    
    //官方账号集合
    NSMutableArray *officialIdArray = @[@"robot_c_1", @"robot_s_1", @"robot_a_1"].mutableCopy;
    if (!XLLoginManager.shared.isAccountLogined) {
        [officialIdArray addObject:@"客服小段"];  //非登录下假账号
    }
    
    if ([officialIdArray containsObject:recent.session.sessionId]) {
        self.nameLabel.textColor = [UIColor colorWithString:COLOR576B95];
        self.officialLogo.hidden = NO;
    } else {
        self.nameLabel.textColor = [UIColor colorWithString:COLOR333333];
        self.officialLogo.hidden = YES;
    }
}

@end
