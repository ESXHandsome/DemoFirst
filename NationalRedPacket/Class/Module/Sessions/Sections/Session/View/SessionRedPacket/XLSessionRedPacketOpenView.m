//
//  RedPacketOpenView.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/3/21.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "XLSessionRedPacketOpenView.h"
#import "UIImage+Tool.h"
#import "UIButton+XLEdgeInsetsButton.h"
#import "XLRedPacketAttachment.h"

@interface XLSessionRedPacketOpenView ()

/// 黑色背景
@property (strong, nonatomic) UIImageView *blackBgView;
/// 内容容器
@property (strong, nonatomic) UIView *openViewContainerView;

/// 开红包弹窗容器
@property (strong, nonatomic) UIView *redContainerView;
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
/// 红包过期、领完提示
@property (strong, nonatomic) UILabel *packetErrorTipLabel;
/// 关闭按钮
@property (strong, nonatomic) UIButton *closeButton;
/// 开按钮
@property (strong, nonatomic) UIImageView *openImageView;
/// 查看详情按钮
@property (strong, nonatomic) UIButton *detailButton;
/// 开按钮图片数组
@property (strong, nonatomic) NSMutableArray *openImageArray;
/// 红包更新信息
@property (strong, nonatomic) NSDictionary *updateInfo;

/// 红包体消息
@property (strong, nonatomic) NIMMessage *imMessage;
/// 红包体消息
@property (strong, nonatomic) XLSessionRedPacketWaitOpenModel *waitOpenModel;

@end

@implementation XLSessionRedPacketOpenView

#pragma mark -
#pragma mark UI Initialize

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        [self addContraint];
        [self initComponentMessage];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return self;
}

- (void)initUI {
    // 整体黑色背景图
    [self addSubview:self.blackBgView];
    //内容容器
    [self addSubview:self.openViewContainerView];
    // 开红包弹窗容器
    [self.openViewContainerView addSubview:self.redContainerView];
    
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
    // 查看红包详情按钮
    [self.redContainerView addSubview:self.detailButton];
    // 红包过期、已领取提示
    [self.redContainerView addSubview:self.packetErrorTipLabel];
}

- (void)initComponentMessage {
    self.packetFromLabel.text = NSBundle.appName;
    self.packetTitleLabel.text = @"给你发送了一个红包";
    self.packetRemarkLabel.text = @"恭喜发财，大吉大利";
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
        make.height.mas_equalTo(adaptHeight1334(868));
        make.centerY.equalTo(self.blackBgView);
    }];
    [self.redContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.openViewContainerView);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.redContainerView.mas_left).offset(adaptWidth750(26));
        make.top.equalTo(self.redContainerView.mas_top).offset(adaptHeight1334(38));
        make.width.height.mas_equalTo(adaptWidth750(28));
    }];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(adaptWidth750(100));
        make.centerX.equalTo(self.redContainerView.mas_centerX);
        make.top.equalTo(self.redContainerView.mas_top).offset(adaptHeight1334(80));
    }];
    [self.packetFromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).mas_offset(adaptHeight1334(26));
        make.centerX.equalTo(self.redContainerView.mas_centerX);
    }];
    [self.packetTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.packetFromLabel.mas_bottom).mas_offset(adaptHeight1334(6));
        make.centerX.equalTo(self.redContainerView.mas_centerX);
    }];
    [self.packetRemarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.packetTitleLabel.mas_bottom).mas_offset(adaptHeight1334(42));
        make.centerX.equalTo(self.redContainerView.mas_centerX);
    }];
    [self.openImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.redContainerView.mas_bottom).mas_offset(-adaptHeight1334(97*2));
        make.centerX.equalTo(self.redContainerView.mas_centerX);
        make.width.height.mas_equalTo(adaptWidth750(198));
    }];
    [self.packetErrorTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.redContainerView);
        make.top.equalTo(self.packetFromLabel.mas_bottom).mas_offset(adaptHeight1334(88));
        make.left.equalTo(self.redContainerView.mas_left).mas_offset(adaptWidth750(32));
        make.right.equalTo(self.redContainerView.mas_right).mas_offset(adaptWidth750(-32));
    }];
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.redContainerView);
        make.bottom.equalTo(self.redContainerView).mas_offset(adaptHeight1334(-42));
    }];
    [self.redTopBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.redContainerView);
    }];
    [self.redBottomBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.redContainerView);
    }];
}

#pragma mark -
#pragma mark Public Method

/**
 设置关闭操作
 
 @param openViewCloseType 关闭类型
 */
- (void)setOpenViewCloseType:(XLRedPacketOpenViewCloseType)openViewCloseType {
    _openViewCloseType = openViewCloseType;
    
    switch (openViewCloseType) {
            case XLRedPacketOpenViewCloseTypeButton:
            self.blackBgView.userInteractionEnabled = NO;
            self.closeButton.hidden = NO;
            break;
            case XLRedPacketOpenViewCloseTypeBackground:
            self.blackBgView.userInteractionEnabled = YES;
            self.closeButton.hidden = YES;
            break;
            case XLRedPacketOpenViewCloseTypeDefault:
            self.blackBgView.userInteractionEnabled = YES;
            self.closeButton.hidden = NO;
            break;
            case XLRedPacketOpenViewCloseTypeNone:
            self.blackBgView.userInteractionEnabled = NO;
            self.closeButton.hidden = YES;
            break;
        default:
            break;
    }
}

/**
 展示开红包弹窗
*/
- (void)showRedPacketOpenViewWithMessage:(NIMMessage *)message
                            openViewInfo:(XLSessionRedPacketWaitOpenModel *)waitOpenModel {
    self.imMessage = message;
    self.waitOpenModel = waitOpenModel;
                          
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:waitOpenModel.avatar]];
    self.packetFromLabel.text = waitOpenModel.name;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [self configUIWithStatusCode:waitOpenModel];
}

/**
 更新开红包弹窗状态
 */
- (void)updateRedPacketOpenViewWithMessage:(NIMMessage *)message
                            openViewInfo:(XLSessionRedPacketWaitOpenModel *)waitOpenModel {
    self.imMessage = message;
    self.waitOpenModel = waitOpenModel;
    
    [self reset];
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:waitOpenModel.avatar]];
    self.packetFromLabel.text = waitOpenModel.name;
    
    [self configUIWithStatusCode:waitOpenModel];
}


- (void)configUIWithStatusCode:(XLSessionRedPacketWaitOpenModel *)waitOpenModel {
    NSInteger status = waitOpenModel.status;
    //状态，0：成功(check或detail时是可抢)；2：超时；3：已领取；4:其它错误
    //红包状态，0:可抢;1:已抢完;2:超时;3:已抢过;4:其它错误
    if (status != XLRedPacketStateNormal) {
        self.packetRemarkLabel.hidden = YES;
        self.openImageView.hidden = YES;
        self.packetErrorTipLabel.hidden = NO;
        
        if (status == XLRedPacketStateError) {
            [MBProgressHUD showError:@"红包出错啦，请重试"];
            return;
        }
    
    } else {
        
        self.packetTitleLabel.hidden = NO;
        self.packetRemarkLabel.hidden = NO;
        self.openImageView.hidden = NO;
        self.packetErrorTipLabel.hidden = YES;
        self.detailButton.hidden = YES;
    }
    
    if (status == XLRedPacketStateDeliveryFinished) {
        self.packetTitleLabel.hidden = YES;
        self.detailButton.hidden = NO;
        self.packetErrorTipLabel.text = @"手慢，红包派完了";
        self.packetFromLabel.text = [NSString stringWithFormat:@"%@的红包",waitOpenModel.name];
        
    } else if (status == XLRedPacketStateExpired) {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"该红包已超过24小时。如已领取，可在“我的钱包”中查看"];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 2;
        [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributeString.length)];
        [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributeString.length)];
        self.packetErrorTipLabel.attributedText = attributeString;
        self.packetErrorTipLabel.textAlignment = NSTextAlignmentCenter;
    }
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

        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCloseButtonEvent:)]) {
            [self.delegate didClickCloseButtonEvent:self.updateInfo];
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
        if (self.delegate && [self.delegate respondsToSelector:@selector(openButtonDidClickWithMessage:openViewInfo:)]) {
            [self.delegate openButtonDidClickWithMessage:self.imMessage openViewInfo:self.waitOpenModel];
        }
    });
}

/**
 查看红包详情
 */
- (void)didClickDetailButtonAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailButtonDidClickWithMessage:)]) {
        [self.delegate detailButtonDidClickWithMessage:self.imMessage];
        XLRedPacketAttachment *attachment = (XLRedPacketAttachment *)[(NIMCustomObject *)self.imMessage.messageObject attachment];
        [StatServiceApi statEvent:LUCKYMONEY_DETAIL model:self.imMessage.session otherString:[NSString stringWithFormat:@"%@,%@", attachment.luckyid, @"alert"]];
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
    [self reset];
    self.openViewContainerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1
          initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.openViewContainerView.transform = CGAffineTransformMakeScale(0.000001, 0.0000001);
                     } completion:^(BOOL finished) {
                         [super removeFromSuperview];
                     }];
}

- (void)reset {
    self.packetErrorTipLabel.hidden = YES;
    self.detailButton.hidden = YES;
    self.openImageView.userInteractionEnabled = YES;
    [self.openImageView stopAnimating];
    self.packetTitleLabel.hidden = NO;
    [self configUIWithStatusCode:0];
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
//    self.confirmPacketMoneyLabel.attributedText = tempAttributeString;
}

/**
 展示红包确认信息动画
 */
- (void)startConfirmViewAnimation {
//    self.openImageView.hidden = YES;
//    self.redBgImageView.hidden = YES;
//    self.redBottomBgImageView.hidden = NO;
//    self.redTopBgImageView.hidden = NO;
//    self.packetFromLabel.hidden = YES;
//    self.packetTitleLabel.hidden = YES;
//    self.packetRemarkLabel.hidden = YES;
//    
//    self.shareButton.hidden = YES;
//    self.confirmButton.hidden = YES;
//    
//    [UIView animateWithDuration:0.25 animations:^{
//        
//        [self.redTopBgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.top.right.equalTo(self);
//            make.height.mas_equalTo(self.confirmAvatarImageView.height);
//        }];
//        [self.redBottomBgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.bottom.right.equalTo(self);
//            make.height.mas_equalTo(0);
//        }];
//        [self.redContainerView layoutIfNeeded];
//        
//    } completion:^(BOOL finished) {
//        [self hidden:self.redContainerView];
//        
//        [self.redTopBgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.right.equalTo(self);
//            make.height.mas_equalTo(self.frame.size.height*0.6);
//        }];
//        [self.redBottomBgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.bottom.right.equalTo(self);
//            make.height.mas_equalTo(self.frame.size.height*0.36);
//        }];
//        self.shareButton.hidden = shareButtonHidden;
//        self.confirmButton.hidden = !shareButtonHidden;
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [UIView animateWithDuration:0.1 animations:^{
//                [self.confirmAvatarImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.centerX.equalTo(self.confirmContainerView.mas_centerX);
//                    make.width.height.mas_equalTo(adaptWidth750(108));
//                    make.top.equalTo(_redContainerView.mas_top).offset(adaptHeight1334(124));
//                }];
//                [self.confirmAvatarAnimationContainer layoutIfNeeded];
//            }];
//        });
//    }];
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

- (UIImageView *)redTopBgImageView {
    if (!_redTopBgImageView) {
        _redTopBgImageView = [UIImageView new];
        _redTopBgImageView.image = [UIImage imageNamed:@"openview_open_top_bg"];
    }
    return _redTopBgImageView;
}

- (UIImageView *)redBottomBgImageView {
    if (!_redBottomBgImageView) {
        _redBottomBgImageView = [UIImageView new];
        _redBottomBgImageView.image = [UIImage imageNamed:@"openview_open_bottom_bg"];
    }
    return _redBottomBgImageView;
}

- (UIImageView *)avatarImageView {
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.image = [UIImage imageNamed:@"avatar_user"];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = adaptWidth750(10);
        _avatarImageView.layer.borderWidth = 1;
        _avatarImageView.layer.borderColor = [UIColor colorWithString:COLORFFE2B1].CGColor;
    }
    return _avatarImageView;
}

- (UILabel *)packetFromLabel {
    if (_packetFromLabel == nil) {
        _packetFromLabel = [[UILabel alloc] init];
        _packetErrorTipLabel.hidden = YES;
        [_packetFromLabel setTextColor:[UIColor colorWithString:COLORFFE2B1]];
        _packetFromLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
    }
    return _packetFromLabel;
}

- (UILabel *)packetTitleLabel {
    if (_packetTitleLabel == nil) {
        _packetTitleLabel = [[UILabel alloc] init];
        [_packetTitleLabel setTextColor:[UIColor colorWithString:COLORF7C69A]];
        _packetTitleLabel.font = [UIFont systemFontOfSize:adaptFontSize(28)];
    }
    return _packetTitleLabel;
}

- (UILabel *)packetRemarkLabel {
    if (_packetRemarkLabel == nil) {
        _packetRemarkLabel = [[UILabel alloc] init];
        [_packetRemarkLabel setTextColor:[UIColor colorWithString:COLORFFE2B1]];
        _packetRemarkLabel.font = [UIFont systemFontOfSize:adaptFontSize(44)];
    }
    return _packetRemarkLabel;
}

- (UILabel *)packetErrorTipLabel {
    if (!_packetErrorTipLabel) {
        _packetErrorTipLabel = [UILabel new];
        _packetErrorTipLabel.textColor = [UIColor colorWithString:COLORFFE2B1];
        _packetErrorTipLabel.font = [UIFont systemFontOfSize:adaptFontSize(44)];
        _packetErrorTipLabel.hidden = YES;
        _packetErrorTipLabel.numberOfLines = 0;
        _packetErrorTipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _packetErrorTipLabel;
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

- (UIButton *)detailButton {
    if (!_detailButton) {
        _detailButton = [UIButton new];
        _detailButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(30)];
        [_detailButton setTitle:@"查看领取详情" forState:UIControlStateNormal];
        _detailButton.hidden = YES;
        [_detailButton setTitleColor:[UIColor colorWithString:COLORFFE2B1] forState:UIControlStateNormal];
        [_detailButton addTarget:self action:@selector(didClickDetailButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_detailButton setImage:[UIImage imageNamed:@"openview_packet_detail_icon"] forState:UIControlStateNormal];
        
        [_detailButton layoutButtonWithEdgeInsetsStyle:XLButtonEdgeInsetsStyleRight imageTitleSpace:10];

        
    }
    return _detailButton;
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

@end

