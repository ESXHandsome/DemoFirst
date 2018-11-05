//
//  RedPacketManager.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/3/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "XLRedPacketManager.h"
#import "UserRewardApi.h"
#import "RewardManager.h"
#import "WechatShare.h"
#import "ShareConfigModel.h"
#import "ShareImageTool.h"
#import "XLUserManager.h"

@interface XLRedPacketManager () <OpenViewDelegate>
@property (assign, nonatomic) RedPacketType redPacketType;
@property (strong, nonatomic) RedPacketOpenView *openView;
@property (assign, nonatomic) NSInteger fetchTimeRedPacketStateCount;

@end

@implementation XLRedPacketManager

#pragma mark -
#pragma mark Public Method

/**
 显示开红包浮窗
 
 @param redPacketType 红包类型
 */
- (void)showOpenViewWithType:(RedPacketType)redPacketType {
    _redPacketType =  redPacketType;
    switch (redPacketType) {
        case RedPacketTypeLogin:
            self.openView.openViewCloseType = RedPacketOpenViewCloseTypeButton;
            break;
        case RedPacketTypeInvite:
            self.openView.openViewCloseType = RedPacketOpenViewCloseTypeNone;
            break;
        case RedPacketTypeTiming:
            self.openView.openViewCloseType = RedPacketOpenViewCloseTypeDefault;
            break;
        default:
            break;
    }
    [self.openView showWithRedPacketType:redPacketType];
}

#pragma mark -
#pragma mark OpenView Delegate

/**
 開按钮点击事件回调
 */
- (void)didClickOpenButtonEvent {
    switch (self.openView.redPacketType) {
        case RedPacketTypeLogin:
            // 获取登录红包奖励
            [self fetchLoginRewardData];
            break;
        case RedPacketTypeTiming:
            // 获取计时红包奖励
            [self fetchTimeRedPacketMoneyData];
            break;
        case RedPacketTypeInvite:
            // 获取邀请奖励
            [self fetchInviteRedPacketMoneyData];
            break;
        default:
            break;
    }
}

/**
 分享按钮点击事件回调
 */
- (void)didClickShareButtonEvent:(ShareConfigModel *)shareConfigModel {
    [MBProgressHUD showChrysanthemum:@"分享中，请稍后" toView:[UIViewController currentViewController].view];
    [UIViewController currentViewController].view.userInteractionEnabled = NO;
    
    // 分享图片下载
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:shareConfigModel.img]
                                                options:0
                                               progress:nil
                                              completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                                  
                                                  [MBProgressHUD hideHUDForView:[UIViewController currentViewController].view animated:YES];
                                                  [UIViewController currentViewController].view.userInteractionEnabled = YES;
                                                  
                                                  if (image) {
                                                      [self dealwithShareImage:[ShareImageTool createShareImageWithUrl:shareConfigModel.url image:image]];
                                                  }
    }];
}

/**
 关闭按钮点击事件回调
 */
- (void)didClickCloseButtonEvent:(NSDictionary *)updateInfo {
    // 登录类型红包关闭，提交用户关闭操作数据
    if (_redPacketType == RedPacketTypeLogin) {
        [self fetchCloseLoginRewardData];
    } else if (_redPacketType == RedPacketTypeInvite) {
        [self checkNextInviteRedPacket:updateInfo];
    }
}

/**
 确认按钮点击事件

 @param updateInfo 红包详细信息
 */
- (void)didClickConfirmButtonEvent:(NSDictionary *)updateInfo {
    [self checkNextInviteRedPacket:updateInfo];
}

- (void)checkNextInviteRedPacket:(NSDictionary *)updateInfo {
    // 邀请类型红包关闭，检查是否有下一个邀请红包
    if (_redPacketType == RedPacketTypeInvite) {
        if ([updateInfo[@"haveNext"] boolValue]) {
            [self.openView showWithRedPacketType:RedPacketTypeInvite];
        } else {
            XLUserManager.shared.userInfoModel.invitationLuckyMoney.haveLuckyMoney = 0;
        }
    }
}

#pragma mark -
#pragma mark Fetch Data

/**
 拉取登录奖励
 */
- (void)fetchLoginRewardData {
    [UserRewardApi fetchUserNewLoginMoneySuccess:^(id responseDict) {
        if ([responseDict[@"result"] integerValue] == 0) {
            [self.openView updateOpenViewState:RedPacketStateOpenedSuccess
                                withUpdateInfo:responseDict];
            [self updateMemoryMoney:responseDict isInvaite:NO];
            [StatServiceApi statEvent:NEWS_OPEN_NEW_RED_SUCCESS];
        } else {
            [self.openView stopOpenButtonAnimation];
            [MBProgressHUD showError:XLAlertOpenRedpacketFailure];
        }
    } failure:^(NSInteger errorCode) {
        [self.openView stopOpenButtonAnimation];
        [MBProgressHUD showError:XLAlertOpenRedpacketFailure];
    }];
}

/**
 提交取消登录奖励数据
 */
- (void)fetchCloseLoginRewardData {
    [UserRewardApi fetchUserConcelNewLoginMoneySuccess:^(id responseDict) {
        // 更新本地登录奖励状态
        [RewardManager resetLocalLoginRewardState];
    } failure:^(NSInteger errorCode) {
        
    }];
}

/**
 获取定时红包
 */
- (void)fetchTimeRedPacketMoneyData {
    [UserRewardApi fetchTimeRedPacketMoneySuccess:^(id responseDict) {
        [self fetchTimingRedPacketState];

        if ([responseDict[@"result"] integerValue] == 0) {
            [self.openView updateOpenViewState:RedPacketStateOpenedSuccess
                                withUpdateInfo:responseDict];
            [self updateMemoryMoney:responseDict isInvaite:NO];
            [StatServiceApi statEvent:NEWS_OPEN_PERIODIC_RED_SUCCESS];
        } else {
            [self.openView stopOpenButtonAnimation];
            [MBProgressHUD showError:XLAlertOpenRedpacketFailure];
        }
    } failure:^(NSInteger errorCode) {
        [self.openView stopOpenButtonAnimation];
        [MBProgressHUD showError:XLAlertOpenRedpacketFailure];
    }];
}

/**
 获取分享红包
 */
- (void)fetchShareRedPacketMoney {
    [UserRewardApi fetchShareRedPacketMoneySuccess:^(id responseDict) {
        if ([responseDict[@"result"] integerValue] == 0) {
            [self updateMemoryMoney:responseDict isInvaite:NO];
            [StatServiceApi statEvent:NEWS_OPEN_PERIODIC_AFTER_RED_SUCCESS];
            [self.openView updateOpenViewState:RedPacketStateSharedSuccess withUpdateInfo:responseDict];
        } else {
            [MBProgressHUD showError:@"分享失败"];
        }
    } failure:^(NSInteger errorCode) {
        [MBProgressHUD showError:@"分享失败"];
    }];
}

/**
 获取邀请红包奖励
 */
- (void)fetchInviteRedPacketMoneyData {
    [UserRewardApi fetchInviteRedPacketStateSuccess:^(id responseDict) {
        if ([responseDict[@"result"] integerValue] == 0) {
            [self updateMemoryMoney:responseDict isInvaite:YES];
            [self.openView updateOpenViewState:RedPacketStateOpenedSuccess
                                withUpdateInfo:responseDict];
        } else {
            [self.openView stopOpenButtonAnimation];
            [MBProgressHUD showError:XLAlertOpenRedpacketFailure];
        }
    } failure:^(NSInteger errorCode) {
        [self.openView stopOpenButtonAnimation];
        [MBProgressHUD showError:XLAlertOpenRedpacketFailure];
    }];
}

/**
 获取定时红包状态
 */
- (void)fetchTimingRedPacketState {
    [UserRewardApi fetchTimeRedPacketStateSuccess:^(id responseDict) {
       
        if ([responseDict[@"result"] integerValue] != 0) return;
      
        if (self.redPacketDelegate && [self.redPacketDelegate respondsToSelector:@selector(timingRedPacketAvailable:withCountDown:withAvailableTime:)]) {
           
            [self.redPacketDelegate timingRedPacketAvailable:[responseDict[@"availability"] boolValue]
                                               withCountDown:[responseDict[@"countdown"] floatValue]
                                           withAvailableTime:responseDict[@"timeAvailable"]];
        }
        
    } failure:^(NSInteger errorCode) {
        if (self.fetchTimeRedPacketStateCount < 3) {
            [self performSelector:@selector(fetchTimingRedPacketState) withObject:nil afterDelay:1];
        }
        self.fetchTimeRedPacketStateCount ++;
    }];
}

#pragma mark -
#pragma mark Private Method

/**
 微信分享

 @param image 分享图片
 */
- (void)dealwithShareImage:(UIImage *)image {
   
    // 缩略图压缩
    UIImage *thumbImage = [UIImage imageWithImage:image
                                     scaledToSize:CGSizeMake(image.size.width / 5.0, image.size.height / 5.0)];
    @weakify(self);
    [[WechatShare sharedInstance] shareImage:image
                                  thumbImage:thumbImage
                                          to:WechatSceneSession
                             sendReqCallback:^(int code) {
                                 @strongify(self);
                                 if (code == 0) {
                                     [self fetchShareRedPacketMoney];
                                 } else {
                                     [MBProgressHUD showError:@"分享失败" time:2.5];
                                 }
                             }];
}

/**
 更新全局金币数量或者零钱数
 */
- (void)updateMemoryMoney:(NSDictionary *)updateInfo isInvaite:(BOOL)invaite {
    NSString *money = updateInfo[@"money"];
    
    if (invaite) {
        [XLUserManager.shared addInviteIncomeMoney:money];
    } else if ([updateInfo[@"moneyType"] isEqualToString:XLRewardCoinType]) {
        [XLUserManager.shared addGoldIncomeNumber:money];
    } else if ([updateInfo[@"moneyType"] isEqualToString:XLRewardMoneyType]) {
        [XLUserManager.shared addBalanceIncomeMoney:money];
    }
}

#pragma mark -
#pragma mark Setters and Getters

- (RedPacketOpenView *)openView {
    if (!_openView) {
        _openView = [[RedPacketOpenView alloc] initWithFrame:SCREEN_BOUNDS];
        _openView.openViewDelegate = self;
    }
    return _openView;
}

@end
