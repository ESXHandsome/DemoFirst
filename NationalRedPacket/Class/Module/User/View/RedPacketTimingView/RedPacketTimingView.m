//
//  RedPacketTimingView.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/3/23.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "RedPacketTimingView.h"

@interface RedPacketTimingView ()

/// 红包背景
@property (strong, nonatomic) UIImageView *redPacketBgImageView;
/// 红包ICON
@property (strong, nonatomic) UIImageView *redPacketIconImageView;
/// 红包备注：“恭喜发财，大吉大利”
@property (strong, nonatomic) UILabel *remarkLabel;
/// 开红包提示：“点击领取”
@property (strong, nonatomic) UILabel *openTipLabel;
/// 应用名称
@property (strong, nonatomic) UILabel *appNameLabel;
/// 红包开抢时间
@property (strong, nonatomic) UILabel *availableStartTimeLabel;
/// 红包倒计时
@property (strong, nonatomic) UILabel *availableTimingLabel;

/// 红包倒计时Timer
@property (strong, nonatomic) NSTimer *redPacketCountDownTimer;

@property (strong, nonatomic) PPSUserInfoModel *ppsUserInfoModel;

@end

@implementation RedPacketTimingView

#pragma mark -
#pragma mark Initialize

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initComponents];
        [self initComponentsText];
        [self addContraint];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickSelfEvent)];
        [self addGestureRecognizer:tapGesture];
        
        [[NSRunLoop mainRunLoop] addTimer:self.redPacketCountDownTimer forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)initComponents {
    [self addSubview:self.redPacketBgImageView];
    [self addSubview:self.redPacketIconImageView];
    [self addSubview:self.remarkLabel];
    [self addSubview:self.openTipLabel];
    [self addSubview:self.availableStartTimeLabel];
    [self addSubview:self.availableTimingLabel];
    [self addSubview:self.appNameLabel];
}

- (void)initComponentsText {
    self.remarkLabel.text = @"恭喜发财，大吉大利";
    self.openTipLabel.text = @"点击领取";
    self.appNameLabel.text = NSBundle.appName;
}

- (void)addContraint {
    [self.redPacketBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    [self.redPacketIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).mas_offset(adaptWidth750(42));
        make.top.equalTo(self.mas_top).mas_offset(adaptHeight1334(34));
        make.width.mas_equalTo(adaptWidth750(88));
        make.height.mas_equalTo(adaptHeight1334(104));
    }];
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.redPacketIconImageView.mas_right).mas_offset(adaptWidth750(30));
        make.top.equalTo(self.mas_top).mas_offset(adaptHeight1334(40));
    }];
    [self.openTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.remarkLabel.mas_left);
        make.top.equalTo(self.remarkLabel.mas_bottom).mas_offset(adaptHeight1334(4));;
    }];
    [self.availableStartTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.remarkLabel.mas_left);
        make.top.equalTo(self.remarkLabel.mas_bottom);
    }];
    [self.availableTimingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.remarkLabel.mas_left);
        make.top.equalTo(self.availableStartTimeLabel.mas_bottom);
    }];
    
    [self.appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).mas_offset(adaptWidth750(24));
        make.bottom.equalTo(self.mas_bottom).mas_offset(-adaptHeight1334(16));
    }];
}

#pragma mark -
#pragma mark Public Method

/**
 更新红包状态
 
 @param updateInfoModel 更新信息
 */
- (void)updateTimingRedPacketStateWithInfo:(PPSUserInfoModel *)updateInfoModel {
    self.ppsUserInfoModel = updateInfoModel;

    [self updatetUIAvailableState:updateInfoModel.timeLuckyMoney.availability
                    withCountDown:self.ppsUserInfoModel.timeLuckyMoney.countdown
                withAvailableTime:self.ppsUserInfoModel.timeLuckyMoney.timeAvailable];
}

/**
 更新定时红包状态
 
 @param available 定时红包是否可用
 @param countDown 定时红包倒计时时间戳
 @param availableTime 开抢时间
 */
- (void)updateTimingRedPacketAvailable:(BOOL)available
                         withCountDown:(long)countDown
                     withAvailableTime:(NSString *)availableTime {

    self.ppsUserInfoModel.timeLuckyMoney.availability = available;
    self.ppsUserInfoModel.timeLuckyMoney.countdown = countDown;
    self.ppsUserInfoModel.timeLuckyMoney.timeAvailable = availableTime;
    
    [self updatetUIAvailableState:available withCountDown:countDown withAvailableTime:availableTime];
}

#pragma mark -
#pragma mark Private Method

/**
 更新红包显示状态

 @param available 红包是否可抢
 */
- (void)updatetUIAvailableState:(BOOL)available
                  withCountDown:(long)countDown
              withAvailableTime:(nullable NSString *)availableTime {
    
    self.packetIsAvailable = available;
    self.availableTimingLabel.hidden = available;
    self.availableStartTimeLabel.hidden = available;
    self.openTipLabel.hidden = !available;
    self.redPacketBgImageView.image = [UIImage imageNamed: available ? @"redpacket_unopen_bg" : @"redpacket_opened_bg"];
    self.redPacketIconImageView.image = [UIImage imageNamed: available ? @"redpacket_icon_unopen" : @"redpacket_icon_opened"];
   
    if (!available) {
        self.redPacketCountDownTimer.fireDate = [NSDate distantPast];
        [self.remarkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.redPacketIconImageView.mas_right).mas_offset(adaptWidth750(30));
            make.top.equalTo(self.mas_top).mas_offset(adaptHeight1334(30));
        }];
        self.availableStartTimeLabel.text = [NSString stringWithFormat:@"%@开抢",self.ppsUserInfoModel.timeLuckyMoney.timeAvailable];
        self.availableTimingLabel.text = [NSString stringWithFormat:@"倒计时：%@",[self packetCountdownWithTimeInterval:self.ppsUserInfoModel.timeLuckyMoney.countdown]];
        self.appNameLabel.text = @"红包已领取";
    } else {
        self.appNameLabel.text = NSBundle.appName;
       [self.remarkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.redPacketIconImageView.mas_right).mas_offset(adaptWidth750(30));
            make.top.equalTo(self.mas_top).mas_offset(adaptHeight1334(40));
        }];
    }
}

/**
 timer倒计时事件
 */
- (void)redPacketCountDownTimerEvent {
    if (self.ppsUserInfoModel.timeLuckyMoney.countdown <= 0) {
        self.redPacketCountDownTimer.fireDate = [NSDate distantFuture];
     
        if (self.timingRedPacketDelegate && [self.timingRedPacketDelegate respondsToSelector:@selector(timingRedPacketShowStateChanged:)]) {
            [self.timingRedPacketDelegate timingRedPacketShowStateChanged:YES];
        }
        return;
    }
    self.availableTimingLabel.text = [NSString stringWithFormat:@"倒计时：%@",[self packetCountdownWithTimeInterval:self.ppsUserInfoModel.timeLuckyMoney.countdown]];
    
    self.ppsUserInfoModel.timeLuckyMoney.countdown = self.ppsUserInfoModel.timeLuckyMoney.countdown - 60;
}

- (NSString *)packetCountdownWithTimeInterval:(long long)timeInterval {
    NSInteger hour = timeInterval / (60 * 60);
    if (hour >= 1) {
        timeInterval = timeInterval % (60 * 60);
    }
    NSInteger minute = timeInterval / 60;
    return  [NSString stringWithFormat:@"%ld小时%ld分",(long)hour,(long)minute];
}

#pragma mark -
#pragma mark Event Response

/**
 视图单击事件
 */
- (void)didClickSelfEvent {
    if (self.timingRedPacketDelegate && [self.timingRedPacketDelegate respondsToSelector:@selector(didClickTimingRedPacketEvent)]) {
        [self.timingRedPacketDelegate didClickTimingRedPacketEvent];
    }
}

#pragma mark -
#pragma mark Setters and Getters

- (UIImageView *)redPacketBgImageView {
    if (!_redPacketBgImageView) {
        _redPacketBgImageView = [UIImageView new];
        _redPacketBgImageView.image = [UIImage imageNamed:@"redpacket_unopen_bg"];
    }
    return _redPacketBgImageView;
}

- (UIImageView *)redPacketIconImageView {
    if (!_redPacketIconImageView) {
        _redPacketIconImageView = [UIImageView new];
        _redPacketIconImageView.image = [UIImage imageNamed:@"redpacket_icon_unopen"];
    }
    return _redPacketIconImageView;
}

- (UILabel *)remarkLabel {
    if (!_remarkLabel) {
        _remarkLabel = [UILabel new];
        _remarkLabel.font = [UIFont systemFontOfSize:adaptFontSize(34)];
        _remarkLabel.textColor = [UIColor colorWithString:COLORffffff];
    }
    return _remarkLabel;
}

- (UILabel *)openTipLabel {
    if (!_openTipLabel) {
        _openTipLabel = [UILabel new];
        _openTipLabel.font = [UIFont systemFontOfSize:adaptFontSize(28)];
        _openTipLabel.textColor = [UIColor colorWithString:COLORffffff];
    }
    return _openTipLabel;
}

- (UILabel *)availableStartTimeLabel {
    if (!_availableStartTimeLabel) {
        _availableStartTimeLabel = [UILabel new];
        _availableStartTimeLabel.hidden = YES;
        _availableStartTimeLabel.font = [UIFont systemFontOfSize:adaptFontSize(28)];
        _availableStartTimeLabel.textColor = [UIColor colorWithString:COLORffffff];
    }
    return _availableStartTimeLabel;
}

- (UILabel *)availableTimingLabel {
    if (!_availableTimingLabel) {
        _availableTimingLabel = [UILabel new];
        _availableTimingLabel.hidden = YES;
        _availableTimingLabel.font = [UIFont systemFontOfSize:adaptFontSize(28)];
        _availableTimingLabel.textColor = [UIColor colorWithString:COLORffffff];
    }
    return _availableTimingLabel;
}

- (UILabel *)appNameLabel {
    if (!_appNameLabel) {
        _appNameLabel = [UILabel new];
        _appNameLabel.textColor = [UIColor colorWithString:COLORA5A5A5];
        _appNameLabel.font = [UIFont systemFontOfSize:adaptFontSize(24)];
    }
    return _appNameLabel;
}

- (NSTimer *)redPacketCountDownTimer {
    if (!_redPacketCountDownTimer) {
        _redPacketCountDownTimer = [NSTimer timerWithTimeInterval:60 target:self selector:@selector(redPacketCountDownTimerEvent) userInfo:nil repeats:YES];
    }
    return _redPacketCountDownTimer;
}

@end
