//
//  HeadCell.h
//  NationalRedPacket
//
//  Created by 王海玉 on 2018/1/3.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "BaseFeedCell.h"
#import "PPSUserInfoModel.h"
#import "RedPacketTimingView.h"

@class  userViewHeadView;
@protocol HeaderViewDelegate <NSObject>
- (void)didClickTimingRedPacketEvent;
- (void)headViewTimingRedPacketShowStateChanged:(BOOL)available;

@end

@interface userViewHeadView : BaseFeedCell

@property (weak  , nonatomic) id<HeaderViewDelegate> delegate;
@property (strong, nonatomic) UIView      *headerView;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel     *nickLabel;
@property (strong, nonatomic) UILabel     *invitationCode;
@property (strong, nonatomic) PPSUserInfoModel    *userInfoModel;
@property (strong, nonatomic) RedPacketTimingView *redPacketTimingView;

/**
 更新定时红包装填

 @param isAvailable 定时红包是否可用
 @param countDown 定时红包倒计时时间戳
 @param availableTime 开抢时间
 */
- (void)updateTimingRedPacketAvailable:(BOOL)isAvailable
                         withCountDown:(long)countDown
                     withAvailableTime:(NSString *)availableTime;

//更新收入信息
- (void)updateIncomeInfo;
//更新用户信息
- (void)updateUserInfo:(UserInfoModel *)model;
@end
