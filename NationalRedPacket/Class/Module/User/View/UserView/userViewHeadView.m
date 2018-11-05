//
//  HeadCell.m
//  NationalRedPacket
//
//  Created by 王海玉 on 2018/1/3.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "userViewHeadView.h"
#import "XLUserManager.h"

@interface userViewHeadView()<RedPacketTimingViewDelegate>

@property (nonatomic) UILabel *invitationCodeTitle;

@end

@implementation userViewHeadView

- (instancetype)init{
    self = [super init];
    if (self) {
//        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, adaptHeight1334(234*2));
    self.backgroundColor = [UIColor colorWithString:@"#F8F7F9"];
    
//    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, adaptHeight1334(99*2))];
//    _headerView.backgroundColor = [UIColor colorWithString:COLORffffff];
//    [self addSubview:_headerView];
//    
//    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(adaptWidth750(18*2), adaptHeight1334(14*2), adaptWidth750(70*2), adaptHeight1334(70*2))];
//    _iconImageView.image = [UIImage imageNamed:@"my_avatar"];
//    _iconImageView.layer.cornerRadius = _iconImageView.height/2;
//    _iconImageView.layer.masksToBounds = YES;
//    [_headerView addSubview:_iconImageView];
//    
//    _nickLabel = [UILabel labWithText:@"LINGER_蒋玲儿" fontSize:adaptFontSize(18*2) textColorString:@"#333333"];
//    CGSize sizeNew = [_nickLabel.text sizeWithAttributes:@{NSFontAttributeName:_nickLabel.font}];
//    _nickLabel.frame = CGRectMake(adaptWidth750(105*2), adaptHeight1334(23*2), sizeNew.width, sizeNew.height);
//    [_headerView addSubview:_nickLabel];
//    
//    _invitationCodeTitle = [UILabel labWithText:@"邀请码：" fontSize:adaptFontSize(14*2) textColorString:@"#666666"];
//    CGSize sizeNew0 = [_invitationCodeTitle.text sizeWithAttributes:@{NSFontAttributeName:_invitationCodeTitle.font}];
//    _invitationCodeTitle.frame = CGRectMake(adaptWidth750(105*2),adaptHeight1334(55*2), sizeNew0.width, sizeNew0.height);
//    [_headerView addSubview:_invitationCodeTitle];
//    
//    _invitationCode = [UILabel labWithText:@"01983423" fontSize:adaptFontSize(14*2) textColorString:@"#666666"];
//    CGSize sizeNew1 = [_invitationCode.text sizeWithAttributes:@{NSFontAttributeName:_invitationCode.font}];
//    _invitationCode.frame = CGRectMake(adaptWidth750(156*2),adaptHeight1334(55*2), sizeNew1.width, sizeNew1.height);
//    [_headerView addSubview:_invitationCode];
//    
//    //红包
    self.redPacketTimingView = [[RedPacketTimingView alloc] initWithFrame:CGRectMake(adaptWidth750(12*2), adaptHeight1334(113*2), adaptWidth750(351*2), adaptHeight1334(110*2))];
    self.redPacketTimingView.timingRedPacketDelegate = self;
    [self addSubview:self.redPacketTimingView];
}

#pragma mark -
#pragma mark Public Method

- (void)setUserInfoModel:(PPSUserInfoModel *)userInfoModel {
    [self.redPacketTimingView updateTimingRedPacketStateWithInfo:userInfoModel];
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

//更新收入信息
- (void)updateIncomeInfo
{

}


- (void)updateUserInfo:(UserInfoModel *)model{
    if(model){
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"edit_avatar_big"]];  //用户头像
        self.nickLabel.text = model.nickname;  //名称
        CGSize sizeNew = [_nickLabel.text sizeWithAttributes:@{NSFontAttributeName:_nickLabel.font}];
        self.nickLabel.size = sizeNew;
        if(self.nickLabel.x+_nickLabel.self.width > SCREEN_WIDTH){
            self.nickLabel.width = SCREEN_WIDTH - self.nickLabel.x -adaptWidth750(10);
            self.nickLabel.height = self.nickLabel.height*2 + adaptWidth750(1);
            self.nickLabel.numberOfLines = 0;
           
        }
        self.invitationCode.text = model.inviteCode;//邀请码
        CGSize sizeNew1 = [_invitationCode.text sizeWithAttributes:@{NSFontAttributeName:_invitationCode.font}];
        self.invitationCode.size = sizeNew1;
        self.invitationCode.y = self.nickLabel.y + self.nickLabel.height +adaptWidth750(7*2);
        _invitationCodeTitle.y = _invitationCode.y;
    }
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

@end
