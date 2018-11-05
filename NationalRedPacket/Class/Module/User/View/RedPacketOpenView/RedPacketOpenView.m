//
//  RedPacketOpenView.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/3/21.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "RedPacketOpenView.h"
#import "UIImage+Tool.h"

@interface RedPacketOpenView ()

/// 黑色背景
@property (strong, nonatomic) UIImageView *blackBgView;
/// 内容容器
@property (strong, nonatomic) UIView *openViewContainerView;

//////// 开红包弹窗容器
@property (strong, nonatomic) UIView *redContainerView;
/// 整体背景图
@property (strong, nonatomic) UIImageView *redBgImageView;
/// “開”动画上部分背景图
@property (strong, nonatomic) UIImageView *redTopBgImageView;
/// ”開“动画下部分背景图
@property (strong, nonatomic) UIImageView *redBottomBgImageView;
/// 头像
@property (strong, nonatomic) UIImageView *avatarImageView;
/// 红包来源（泡泡街）
@property (strong, nonatomic) UILabel *packetFromLabel;
/// 红包标题
@property (strong, nonatomic) UILabel *packetTitleLabel;
/// 红包备注
@property (strong, nonatomic) UILabel *packetRemarkLabel;
/// 关闭按钮
@property (strong, nonatomic) UIButton *closeButton;
/// 开按钮
@property (strong, nonatomic) UIImageView *openImageView;
/// 开按钮图片数组
@property (strong, nonatomic) NSMutableArray *openImageArray;

/////// 红包确认弹窗容器
@property (strong, nonatomic) UIView *confirmContainerView;
/// 头像下移动画容器
@property (strong, nonatomic) UIView *confirmAvatarAnimationContainer;
/// 确认弹窗顶部背景图
@property (strong, nonatomic) UIImageView *confirmContainerBgImageView;
/// 确认弹窗头像
@property (strong, nonatomic) UIImageView *confirmAvatarImageView;
/// 关闭按钮
@property (strong, nonatomic) UIButton *confirmCloseButton;
/// 红包来源
@property (strong, nonatomic) UILabel *confirmPacketFromLabel;
/// 红包提示
@property (strong, nonatomic) UILabel *confirmPacketTitleLabel;
/// 红包金额
@property (strong, nonatomic) UILabel *confirmPacketMoneyLabel;
/// 红包提现提示
@property (strong, nonatomic) UILabel *confirmPacketWithdrawTipLabel;
/// 确认
@property (strong, nonatomic) UIButton *confirmButton;
/// 分享
@property (strong, nonatomic) UIButton *shareButton;
/// 分享配置模型
@property (strong, nonatomic) ShareConfigModel *shareConfigModel;
/// 红包更新信息
@property (strong, nonatomic) NSDictionary *updateInfo;

@end

@implementation RedPacketOpenView

#pragma mark -
#pragma mark UI Initialize

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        [self addContraint];
        [self initComponentMessage];
    }
    return self;
}

- (void)initUI {
    
    // 整体黑色背景图
    [self addSubview:self.blackBgView];
    //内容容器
    [self addSubview:self.openViewContainerView];
    
    ////// 确认弹窗容器
    [self.openViewContainerView addSubview:self.confirmContainerView];
    /////// 开红包弹窗容器
    [self.openViewContainerView addSubview:self.redContainerView];
    
    // 整体红色背景图
    [self.redContainerView addSubview:self.redBgImageView];
    // 开动画上部背景图
    [self.redContainerView addSubview:self.redTopBgImageView];
    // 開动画底部背景图
    [self.redContainerView addSubview:self.redBottomBgImageView];
    // 关闭按钮
    [self.redContainerView addSubview:self.closeButton];
    // 头像
    [self.redContainerView addSubview:self.avatarImageView];
    // 红包名称
    [self.redContainerView addSubview:self.packetFromLabel];
    // 红包信息
    [self.redContainerView addSubview:self.packetTitleLabel];
    // 红包备注
    [self.redContainerView addSubview:self.packetRemarkLabel];
    // 打开按钮
    [self.redContainerView addSubview:self.openImageView];
    
    // 头像动画容器
    [self.confirmContainerView addSubview:self.confirmAvatarAnimationContainer];
    // 顶部背景图
    [self.confirmAvatarAnimationContainer addSubview:self.confirmContainerBgImageView];
    // 头像
    [self.confirmAvatarAnimationContainer addSubview:self.confirmAvatarImageView];
    // 关闭按钮
    [self.confirmContainerView addSubview:self.confirmCloseButton];
    // 红包内容
    [self.confirmContainerView addSubview:self.confirmPacketTitleLabel];
    // 红包来源
    [self.confirmContainerView addSubview:self.confirmPacketFromLabel];
    // 红包金额
    [self.confirmContainerView addSubview:self.confirmPacketMoneyLabel];
    // 红包提现提示
    [self.confirmContainerView addSubview:self.confirmPacketWithdrawTipLabel];
    // 确认按钮
    [self.confirmContainerView addSubview:self.confirmButton];
    // 分享按钮
    [self.confirmContainerView addSubview:self.shareButton];
}

- (void)initComponentMessage {
    self.packetFromLabel.text = NSBundle.appName;
    self.packetTitleLabel.text = @"发了一个红包，金额随机";
    self.packetRemarkLabel.text = @"恭喜发财，大吉大利";
    self.confirmAvatarImageView.image = [UIImage imageNamed:@"details_icon_red_details_logo"];
    self.confirmPacketWithdrawTipLabel.text = @"已存入余额，可用于提现";
}

-(void)addContraint {
    [self.blackBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    [self.openViewContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(adaptWidth750(50));
        make.right.equalTo(self.mas_right).offset(adaptWidth750(-50));
        make.height.mas_equalTo(adaptHeight1334(850));
        make.centerY.equalTo(self.blackBgView);
    }];
    [self.redContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.openViewContainerView);
    }];
    [self.redBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.equalTo(self.redContainerView);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.redContainerView.mas_right).offset(-adaptWidth750(30));
        make.top.equalTo(self.redContainerView.mas_top).offset(adaptHeight1334(30));
        make.width.height.mas_equalTo(adaptWidth750(27));
    }];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(adaptWidth750(108));
        make.centerX.equalTo(self.redContainerView.mas_centerX);
        make.top.equalTo(self.redContainerView.mas_top).offset(adaptHeight1334(74));
    }];
    [self.packetFromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).mas_offset(adaptHeight1334(16));
        make.centerX.equalTo(self.redContainerView.mas_centerX);
    }];
    [self.packetTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.packetFromLabel.mas_bottom).mas_offset(adaptHeight1334(14));
        make.centerX.equalTo(self.redContainerView.mas_centerX);
    }];
    [self.packetRemarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.packetTitleLabel.mas_bottom).mas_offset(adaptHeight1334(74));
        make.centerX.equalTo(self.redContainerView.mas_centerX);
    }];
    [self.openImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.packetRemarkLabel.mas_bottom).mas_offset(adaptHeight1334(66));
        make.centerX.equalTo(self.redContainerView.mas_centerX);
        make.width.height.mas_equalTo(adaptWidth750(214));
    }];
    [self.redTopBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(self.frame.size.height*0.6);
    }];
    [self.redBottomBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(self.frame.size.height*0.36);
    }];
    // 确认视图布局
    [self.confirmContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.redContainerView.mas_top);
        make.left.right.bottom.equalTo(self.redContainerView);
    }];
    [self.confirmAvatarAnimationContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.confirmContainerView);
        make.height.mas_equalTo(adaptHeight1334(124 + 108));
    }];
    [self.confirmCloseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.confirmContainerView.mas_right).offset(-adaptWidth750(30));
        make.top.equalTo(self.confirmContainerView.mas_top).offset(adaptHeight1334(30));
        make.width.height.mas_equalTo(adaptWidth750(27));
    }];
    [self.confirmContainerBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.confirmContainerView);
        make.bottom.equalTo(self.confirmAvatarImageView.mas_centerY).mas_offset(adaptHeight1334(16));
    }];
    [self.confirmAvatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.confirmContainerView.mas_centerX);
        make.width.height.mas_equalTo(adaptWidth750(108));
        make.top.equalTo(self.redContainerView.mas_top).offset(adaptHeight1334(74));
    }];
    [self.confirmPacketFromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.confirmContainerView.mas_centerX);
        make.top.equalTo(self.confirmContainerView.mas_top).mas_offset(adaptHeight1334(250));
    }];
    [self.confirmPacketTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.confirmContainerView.mas_centerX);
        make.top.equalTo(self.confirmPacketFromLabel.mas_bottom).mas_offset(adaptHeight1334(10));
    }];
    [self.confirmPacketMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.confirmContainerView.mas_centerX);
        make.centerY.equalTo(self.confirmContainerView.mas_centerY).mas_offset(adaptHeight1334(10));
    }];
    [self.confirmPacketWithdrawTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.confirmContainerView.mas_centerX);
        make.top.equalTo(self.confirmPacketMoneyLabel.mas_bottom).offset(adaptHeight1334(30));
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.confirmContainerView.mas_centerX);
        make.bottom.equalTo(self.confirmContainerView.mas_bottom).mas_offset(-adaptHeight1334(66));
        make.width.mas_equalTo(adaptWidth750(466));
        make.height.mas_equalTo(adaptHeight1334(102));
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.confirmButton);
    }];
}

#pragma mark -
#pragma mark Public Method

/**
 设置关闭操作
 
 @param openViewCloseType 关闭类型
 */
- (void)setOpenViewCloseType:(RedPacketOpenViewCloseType)openViewCloseType {
    _openViewCloseType = openViewCloseType;
    
    switch (openViewCloseType) {
        case RedPacketOpenViewCloseTypeButton:
            self.blackBgView.userInteractionEnabled = NO;
            self.closeButton.hidden = NO;
            self.confirmCloseButton.hidden = NO;
            break;
        case RedPacketOpenViewCloseTypeBackground:
            self.blackBgView.userInteractionEnabled = YES;
            self.closeButton.hidden = YES;
            self.confirmCloseButton.hidden = YES;
            break;
        case RedPacketOpenViewCloseTypeDefault:
            self.blackBgView.userInteractionEnabled = YES;
            self.closeButton.hidden = NO;
            self.confirmCloseButton.hidden = NO;
            break;
        case RedPacketOpenViewCloseTypeNone:
            self.blackBgView.userInteractionEnabled = NO;
            self.closeButton.hidden = YES;
            self.confirmCloseButton.hidden = YES;
            break;
        default:
            break;
    }
}

/**
 展示开红包弹窗
 
 @param type 红包类型
 */
- (void)showWithRedPacketType:(RedPacketType)type {
    _redPacketType = type;
    self.redBgImageView.hidden = NO;
    self.redBottomBgImageView.hidden = YES;
    self.redTopBgImageView.hidden = YES;
    self.confirmContainerView.hidden = YES;
    self.openImageView.hidden = NO;
    self.packetFromLabel.hidden = NO;
    self.packetTitleLabel.hidden = NO;
    self.packetRemarkLabel.hidden = NO;
    
    if (_redPacketType == RedPacketTypeInvite) {
        self.packetRemarkLabel.text = @"恭喜你，邀请成功！";
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

/**
 更新开红包弹窗状态
 
 @param state 状态
 @param updateInfo 更新信息
 */
- (void)updateOpenViewState:(RedPacketOpenViewState)state
             withUpdateInfo:(NSDictionary *)updateInfo {
    
    _openViewState = state;
    _updateInfo = updateInfo;
    
    if (state != RedPacketStateOpenedFailure) {
        self.openViewCloseType = RedPacketOpenViewCloseTypeDefault;
    }
    [self stopOpenButtonAnimation];
    
    if (self.redPacketType == RedPacketTypeLogin) {
        self.confirmPacketTitleLabel.text = @"恭喜你，登录成功";
        self.confirmButton.hidden = NO;
    }
    if (self.redPacketType == RedPacketTypeTiming) {
        
        if (_openViewState == RedPacketStateSharedSuccess) {
            self.confirmPacketTitleLabel.text = @"恭喜你，分享成功";
            self.confirmButton.hidden = NO;
            self.shareButton.hidden = YES;
        } else {
            self.confirmPacketTitleLabel.text = @"恭喜发财，大吉大利";
        }
        
        if ([updateInfo[@"shareAvailable"] boolValue]) {
            self.openViewCloseType = RedPacketOpenViewCloseTypeButton;
            self.shareConfigModel = [ShareConfigModel yy_modelWithJSON:updateInfo[@"shareConfig"]];
            [self configShouldShareShow:self.shareConfigModel withShareMoney:updateInfo[@"shareMoney"]];
        }
    }
    if (self.redPacketType == RedPacketTypeInvite) {
        self.confirmPacketTitleLabel.text = @"恭喜你，邀请成功！";
        self.confirmButton.hidden = NO;
        self.shareButton.hidden = YES;
    }
    [self updateMoneyShow:updateInfo];
    [self startConfirmViewAnimation];
}

#pragma mark -
#pragma mark Event Response

/**
 关闭按钮点击事件
 */
- (void)didClickClosePacketButton {
    [self closeRedPacketOpenView];

    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        if (self.openViewDelegate && [self.openViewDelegate respondsToSelector:@selector(didClickCloseButtonEvent:)]) {
            [self.openViewDelegate didClickCloseButtonEvent:self.updateInfo];
        }
    });
}

/**
 ”開“按钮点击事件
 */
- (void)didClickOpenPacketButton {
    self.openImageView.animationImages = self.openImageArray;
    self.openImageView.animationDuration = 0.42;
    [self.openImageView startAnimating];
    self.openImageView.userInteractionEnabled = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.openViewDelegate && [self.openViewDelegate respondsToSelector:@selector(didClickOpenButtonEvent)]) {
            [self.openViewDelegate didClickOpenButtonEvent];
        }
    });
}

/**
 确认按钮点击事件
 */
- (void)didClickConfirmButtonEvent {
    [self closeRedPacketOpenView];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        if (self.openViewDelegate && [self.openViewDelegate respondsToSelector:@selector(didClickConfirmButtonEvent:)]) {
            [self.openViewDelegate didClickConfirmButtonEvent:self.updateInfo];
        }
    });
}

/**
 分享按钮点击事件
 */
- (void)didClickShareuttonEvent {
    if (self.openViewDelegate && [self.openViewDelegate respondsToSelector:@selector(didClickShareButtonEvent:)]) {
        [self.openViewDelegate didClickShareButtonEvent:self.shareConfigModel];
    }
}

#pragma mark -
#pragma mark Private Method

/**
 视图将要显示放大动画
 */
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    self.openViewContainerView.transform = CGAffineTransformMakeScale(0.10, 0.10);
    
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.6
          initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.openViewContainerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                     } completion:^(BOOL finished) {
                         
                     }];
}

/**
 视图移除收缩动画
 */
- (void)removeFromSuperview {
    [self.confirmAvatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.confirmContainerView.mas_centerX);
        make.width.height.mas_equalTo(adaptWidth750(108));
        make.top.equalTo(self.redContainerView.mas_top).offset(adaptHeight1334(74));
    }];
    _openImageView.userInteractionEnabled = YES;
    self.openViewContainerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1
          initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.openViewContainerView.transform = CGAffineTransformMakeScale(0.000001, 0.0000001);
                     } completion:^(BOOL finished) {
                         [super removeFromSuperview];
                     }];
}

/**
 ”開“停止旋转
 */
- (void)stopOpenButtonAnimation {
    _openImageView.userInteractionEnabled = YES;
    [_openImageView stopAnimating];
}

/**
 关闭开红包弹窗
 */
- (void)closeRedPacketOpenView {
    self.redContainerView.hidden = NO;
    self.confirmContainerView.hidden = YES;
    [self stopOpenButtonAnimation];
    [self removeFromSuperview];
}

/**
 显示红包详情中的“金额”文本
 
 @param updateInfo 红包详情信息
 */
- (void)updateMoneyShow:(NSDictionary *)updateInfo {
    NSString *moneyShowMessage;
    NSMutableAttributedString *tempAttributeString;
    
    NSString *moneyString;
    if ([updateInfo[@"money"] isKindOfClass:[NSString class]]) {
        moneyString = updateInfo[@"money"];
    } else {
        moneyString = [updateInfo[@"money"] stringValue];
    }
    
    if ([updateInfo[@"moneyType"] isEqualToString:@"coin"]) {
        moneyShowMessage = [NSString stringWithFormat:@"+%@金币",moneyString];
        tempAttributeString = [[NSMutableAttributedString alloc] initWithString:moneyShowMessage];
        [tempAttributeString addAttribute:NSFontAttributeName
                                    value:[UIFont boldSystemFontOfSize:adaptFontSize(70)]
                                    range:NSMakeRange(0, 1)];
        [tempAttributeString addAttribute:NSFontAttributeName
                                    value:[UIFont systemFontOfSize:adaptFontSize(119)]
                                    range:NSMakeRange(1, moneyString.length)];
        [tempAttributeString addAttribute:NSFontAttributeName
                                    value:[UIFont systemFontOfSize:adaptFontSize(36)]
                                    range:NSMakeRange(moneyString.length + 1, 2)];
        [tempAttributeString addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor colorWithString:COLORFFA902]
                                    range:NSMakeRange(0, moneyShowMessage.length)];
    } else {
        moneyShowMessage = [NSString stringWithFormat:@"%@元",moneyString];
        tempAttributeString = [[NSMutableAttributedString alloc] initWithString:moneyShowMessage];
        
        [tempAttributeString addAttribute:NSFontAttributeName
                                    value:[UIFont systemFontOfSize:adaptFontSize(119)]
                                    range:NSMakeRange(0, moneyString.length)];
        [tempAttributeString addAttribute:NSFontAttributeName
                                    value:[UIFont systemFontOfSize:adaptFontSize(36)]
                                    range:NSMakeRange(moneyString.length, 1)];
        [tempAttributeString addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor colorWithString:COLOR333333]
                                    range:NSMakeRange(0, moneyShowMessage.length)];
    }
    self.confirmPacketMoneyLabel.attributedText = tempAttributeString;
}

/**
 分享按钮文案显示
 */
- (void)configShouldShareShow:(ShareConfigModel *)shareModel withShareMoney:(NSString *)shareMoney{
    self.confirmButton.hidden = YES;
    self.shareButton.hidden = NO;
    NSString *shareTipMessage = [NSString stringWithFormat:@"分享再领%@金币",shareMoney];
    
    NSMutableAttributedString *tempAttributeString = [[NSMutableAttributedString alloc] initWithString:shareTipMessage];
    [tempAttributeString addAttribute:NSFontAttributeName
                                value:[UIFont systemFontOfSize:adaptFontSize(35)]
                                range:NSMakeRange(0, shareTipMessage.length)];
    [tempAttributeString addAttribute:NSForegroundColorAttributeName
                                value:[UIColor colorWithString:COLORffffff]
                                range:NSMakeRange(0, 4)];
    [tempAttributeString addAttribute:NSForegroundColorAttributeName
                                value:[UIColor colorWithString:COLORFFDD01]
                                range:NSMakeRange(4, shareTipMessage.length - 4)];
    [self.shareButton setAttributedTitle:tempAttributeString forState:UIControlStateNormal];
}

/**
 展示红包确认信息动画
 */
- (void)startConfirmViewAnimation {
    self.openImageView.hidden = YES;
    self.redBgImageView.hidden = YES;
    self.redBottomBgImageView.hidden = NO;
    self.redTopBgImageView.hidden = NO;
    self.confirmContainerView.hidden = NO;
    self.packetFromLabel.hidden = YES;
    self.packetTitleLabel.hidden = YES;
    self.packetRemarkLabel.hidden = YES;
    
    BOOL shareButtonHidden = self.shareButton.isHidden;
    self.shareButton.hidden = YES;
    self.confirmButton.hidden = YES;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.redTopBgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(self.confirmAvatarImageView.height);
        }];
        [self.redBottomBgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.mas_equalTo(0);
        }];
        [self.redContainerView layoutIfNeeded];
   
    } completion:^(BOOL finished) {
        [self hidden:self.redContainerView];
        
        [self.redTopBgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(self.frame.size.height*0.6);
        }];
        [self.redBottomBgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.mas_equalTo(self.frame.size.height*0.36);
        }];
        self.shareButton.hidden = shareButtonHidden;
        self.confirmButton.hidden = !shareButtonHidden;
      
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.1 animations:^{
                [self.confirmAvatarImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.confirmContainerView.mas_centerX);
                    make.width.height.mas_equalTo(adaptWidth750(108));
                    make.top.equalTo(self.redContainerView.mas_top).offset(adaptHeight1334(124));
                }];
                [self.confirmAvatarAnimationContainer layoutIfNeeded];
            }];
        });
    }];
}

- (void)hidden:(UIView *)view {
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.1;
    [view.layer addAnimation:animation forKey:nil];
    view.hidden = YES;
}

#pragma mark -
#pragma mark Setters and Getters

- (UIImageView *)blackBgView {
    if (_blackBgView == nil) {
        _blackBgView = [UIImageView new];
        _blackBgView.image = [UIImage createImageWithColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8] size:CGSizeMake(1, 1)];
        _blackBgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickClosePacketButton)];
        [_blackBgView addGestureRecognizer:tap];
    }
    return _blackBgView;
}

- (UIView *)openViewContainerView {
    if (!_openViewContainerView) {
        _openViewContainerView = [UIView new];
    }
    return _openViewContainerView;
}

- (UIView *)redContainerView {
    if (_redContainerView == nil) {
        _redContainerView = [[UIView alloc] init];
        _redContainerView.layer.masksToBounds = YES;
        _redContainerView.layer.cornerRadius = 5;
    }
    return _redContainerView;
}

- (UIImageView *)redBgImageView {
    if (!_redBgImageView) {
        _redBgImageView = [UIImageView new];
        _redBgImageView.image = [UIImage imageNamed:@"openview_open_bg"];
    }
    return _redBgImageView;
}

- (UIImageView *)redTopBgImageView {
    if (!_redTopBgImageView) {
        _redTopBgImageView = [UIImageView new];
        _redTopBgImageView.hidden = YES;
        _redTopBgImageView.image = [UIImage imageNamed:@"openview_open_top_bg"];
    }
    return _redTopBgImageView;
}

- (UIImageView *)redBottomBgImageView {
    if (!_redBottomBgImageView) {
        _redBottomBgImageView = [UIImageView new];
        _redBottomBgImageView.hidden = YES;
        _redBottomBgImageView.image = [UIImage imageNamed:@"openview_open_bottom_bg"];
    }
    return _redBottomBgImageView;
}

- (UIImageView *)avatarImageView {
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.image = [UIImage imageNamed:@"details_icon_red_details_logo"];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = adaptWidth750(50);
    }
    return _avatarImageView;
}

- (UILabel *)packetFromLabel {
    if (_packetFromLabel == nil) {
        _packetFromLabel = [[UILabel alloc] init];
        [_packetFromLabel setTextColor:[UIColor colorWithRed:255/255.0 green:226/255.0 blue:177/255.0 alpha:1]];
        _packetFromLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
    }
    return _packetFromLabel;
}

- (UILabel *)packetTitleLabel {
    if (_packetTitleLabel == nil) {
        _packetTitleLabel = [[UILabel alloc] init];
        [_packetTitleLabel setTextColor:[UIColor colorWithRed:243/255.0 green:178/255.0 blue:141/255.0 alpha:1]];
        _packetTitleLabel.font = [UIFont systemFontOfSize:adaptFontSize(28)];
    }
    return _packetTitleLabel;
}

- (UILabel *)packetRemarkLabel {
    if (_packetRemarkLabel == nil) {
        _packetRemarkLabel = [[UILabel alloc] init];
        [_packetRemarkLabel setTextColor:[UIColor colorWithRed:255/255.0 green:226/255.0 blue:177/255.0 alpha:1]];
        _packetRemarkLabel.font = [UIFont systemFontOfSize:adaptFontSize(44)];
    }
    return _packetRemarkLabel;
}

- (UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"openview_close_icon"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(didClickClosePacketButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIImageView *)openImageView {
    if (_openImageView == nil) {
        _openImageView = [[UIImageView alloc] init];
        _openImageView.userInteractionEnabled = YES;
        _openImageView.image = [UIImage imageNamed:@"openview_open_icon"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickOpenPacketButton)];
        [_openImageView addGestureRecognizer:tap];
    }
    return _openImageView;
}

-(NSMutableArray *)openImageArray {
    if (!_openImageArray) {
        _openImageArray = [[NSMutableArray alloc] init];
        for (int i = 1; i < 5; i++) {
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"openview_open_icon_%d",i]];
            [_openImageArray addObject:img];
        }
    }
    return _openImageArray;
}

- (UIView *)confirmContainerView {
    if (!_confirmContainerView) {
        _confirmContainerView = [UIView new];
        _confirmContainerView.backgroundColor = [UIColor whiteColor];
        _confirmContainerView.layer.masksToBounds = YES;
        _confirmContainerView.layer.cornerRadius = 5;
    }
    return _confirmContainerView;
}

- (UIView *)confirmAvatarAnimationContainer {
    if (!_confirmAvatarAnimationContainer) {
        _confirmAvatarAnimationContainer = [UIView new];
    }
    return _confirmAvatarAnimationContainer;
}

- (UIImageView *)confirmContainerBgImageView {
    if (!_confirmContainerBgImageView) {
        _confirmContainerBgImageView = [UIImageView new];
        _confirmContainerBgImageView.image = [UIImage imageNamed:@"openview_detail_top_bg"];
        
    }
    return _confirmContainerBgImageView;
}

- (UIImageView *)confirmAvatarImageView {
    if (!_confirmAvatarImageView) {
        _confirmAvatarImageView = [UIImageView new];
    }
    return _confirmAvatarImageView;
}

- (UIButton *)confirmButton {
    if (_confirmButton == nil) {
        _confirmButton = [UIButton new];
        _confirmButton.layer.cornerRadius = adaptWidth750(51);
        _confirmButton.backgroundColor = [UIColor colorWithString:COLORE05449];
        [_confirmButton setTitleColor:[UIColor colorWithString:COLORffffff] forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(35)];
        [_confirmButton addTarget:self action:@selector(didClickConfirmButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    }
    return _confirmButton;
}

- (UILabel *)confirmPacketFromLabel {
    if (!_confirmPacketFromLabel) {
        _confirmPacketFromLabel = [UILabel new];
        
        NSString *appName = NSBundle.appName;
        NSString *tempString = [NSString stringWithFormat:@"%@的红包",appName];
        
        NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:tempString];
        [aStr addAttribute:NSFontAttributeName
                     value:[UIFont boldSystemFontOfSize:adaptFontSize(30)]
                     range:NSMakeRange(0, appName.length)];
        [aStr addAttribute:NSFontAttributeName
                     value:[UIFont systemFontOfSize:adaptFontSize(28)]
                     range:NSMakeRange(appName.length, 3)];
        [aStr addAttribute:NSForegroundColorAttributeName
                     value:[UIColor colorWithString:COLOR333333]
                     range:NSMakeRange(0, tempString.length)];
        
        _confirmPacketFromLabel.attributedText = aStr;
    }
    return _confirmPacketFromLabel;
}

- (UILabel *)confirmPacketTitleLabel {
    if (!_confirmPacketTitleLabel) {
        _confirmPacketTitleLabel = [UILabel new];
        _confirmPacketTitleLabel.font = [UIFont systemFontOfSize:adaptFontSize(28)];
        _confirmPacketTitleLabel.textColor = [UIColor colorWithString:COLOR828282];
    }
    return _confirmPacketTitleLabel;
}

- (UILabel *)confirmPacketMoneyLabel {
    if (!_confirmPacketMoneyLabel) {
        _confirmPacketMoneyLabel = [UILabel new];
        _confirmPacketMoneyLabel.font = [UIFont systemFontOfSize:adaptFontSize(119)];
        _confirmPacketMoneyLabel.textColor = [UIColor colorWithString:COLOR333333];
    }
    return _confirmPacketMoneyLabel;
}

- (UILabel *)confirmPacketWithdrawTipLabel {
    if (!_confirmPacketWithdrawTipLabel) {
        _confirmPacketWithdrawTipLabel = [UILabel new];
        _confirmPacketWithdrawTipLabel.textColor = [UIColor colorWithString:COLOR5877B3];
        _confirmPacketWithdrawTipLabel.font = [UIFont systemFontOfSize:adaptFontSize(28)];
    }
    return _confirmPacketWithdrawTipLabel;
}

- (UIButton *)confirmCloseButton {
    if (_confirmCloseButton == nil) {
        _confirmCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmCloseButton setBackgroundImage:[UIImage imageNamed:@"openview_close_icon"] forState:UIControlStateNormal];
        [_confirmCloseButton addTarget:self action:@selector(didClickClosePacketButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmCloseButton;
}


- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton new];
        _shareButton.layer.cornerRadius = adaptWidth750(51);
        _shareButton.backgroundColor = [UIColor colorWithString:COLORE05449];
        _shareButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(35)];
        [_shareButton addTarget:self action:@selector(didClickShareuttonEvent) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.hidden = YES;
    }
    return _shareButton;
}

@end

