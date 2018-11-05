//
//  PPSUserInfoMode.h
//  NationalRedPacket
//
//  Created by Ying on 2018/3/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPSMyInfoModel : NSObject
@property (copy, nonatomic) NSString *avatar;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *sex;
@property (copy, nonatomic) NSString *birth;
@property (copy, nonatomic) NSString *province;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *intro;
@end

@interface PPSUserBalanceModel : NSObject
@property (copy, nonatomic) NSString *balance;
@property (copy, nonatomic) NSString *coin;
@property (copy, nonatomic) NSString *inviteIncome;
@end

@interface PPSShareConfigModel : NSObject
@property (copy, nonatomic) NSString *shareMode;
@property (copy, nonatomic) NSString *contentType;
@property (copy, nonatomic) NSString *connector;
@property (copy, nonatomic) NSString *img;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *content;
@end

@interface PPSinvitationLuckyMoneyModel : NSObject
@property (assign, nonatomic) NSInteger haveLuckyMoney;
@property (assign, nonatomic) NSInteger availability;
@property (copy, nonatomic)   NSString *money;
@property (copy, nonatomic)   NSString *show;
@property (copy, nonatomic)   NSString *jumpUrl;
@property (copy, nonatomic)   NSString *inviteIcomeJumpUrl;
@end

@interface PPSShareLuckyMoneyModel : NSObject
@property (assign, nonatomic) NSInteger availability;
@property (strong, nonatomic) NSArray<PPSShareConfigModel *> *shareConfig;
@end

@interface PPSTimeLuckyMoneyModel : NSObject
@property (assign, nonatomic) NSInteger availability;
@property (copy, nonatomic)   NSString *timeAvailable;
@property (assign, nonatomic) NSInteger countdown;
@end

@interface PPSSignLuckyMoneyModel : NSObject
@property (assign, nonatomic) NSInteger availability;
@property (assign, nonatomic) NSInteger continuousDay;
@end

@interface PPSUserInfoModel : NSObject
@property (copy, nonatomic) NSString *result;
@property (strong, nonatomic) PPSTimeLuckyMoneyModel       *timeLuckyMoney;
@property (strong, nonatomic) PPSSignLuckyMoneyModel       *signLuckyMoney;
@property (strong, nonatomic) PPSUserBalanceModel          *userBalance;
@property (strong, nonatomic) PPSShareLuckyMoneyModel      *shareLuckyMoney;
@property (strong, nonatomic) PPSinvitationLuckyMoneyModel *invitationLuckyMoney;
@property (strong, nonatomic) PPSMyInfoModel               *myInfo;


@end
