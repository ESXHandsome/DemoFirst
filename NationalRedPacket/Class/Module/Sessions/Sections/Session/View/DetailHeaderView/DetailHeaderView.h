//
//  XLRedPacketDetailViewController.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLSessionRedPacketDetailModel.h"

//状态，0：成功(check或detail时是可抢)；2：超时；3：已领取；4:其它错误
typedef NS_ENUM(NSInteger, DetailHeaderType) {
    DetailHeaderTypeFocusDetailFirstOpen,
    DetailHeaderTypeFocusDetailOpened,
    DetailHeaderTypeTeamDetailReceived,
    DetailHeaderTypeTeamDetailUnReceived
};

@protocol DetailHeaderDelegate <NSObject>

- (void)detailHeaderViewDidClickWalletJump;

@end

@interface DetailHeaderView : UIView

@property (strong, nonatomic) UIImageView *packetTopBgImageView;
@property (weak, nonatomic) id<DetailHeaderDelegate> delegate;

- (void)configUIWithHeaderType:(DetailHeaderType)type detailModel:(XLSessionRedPacketDetailModel *)detailModel;

@end
