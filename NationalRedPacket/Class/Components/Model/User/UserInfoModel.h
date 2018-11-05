//
//  UseInfoModel.h
//  LovePlayNews
//
//  Created by 刘永杰 on 2017/6/28.
//  Copyright © 2017年 sail. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LuckymoneyconfigModel,ExchangePeopleNumModel,CommonluckyModel,LuckywaveModel,LottertluckyModel,ShareMode,Share_UrlModel,NewLoginIncome, PPSInviteConfigModel,ScreenAdModel,AttentionPageAdModel,HotPageAdModel;

@interface UserInfoModel : NSObject

@property (copy, nonatomic) NSString *sex;

@property (strong, nonatomic) NSArray *payMode;

@property (copy, nonatomic) NSString *inviteCode;//邀请码

@property (copy, nonatomic) NSString *userStatus; // 0正常用户，1异常用户

@property (strong, nonatomic) LuckymoneyconfigModel *luckyMoneyConfig;

@property (strong, nonatomic) ExchangePeopleNumModel *exchangePeopleNum;

@property (assign, nonatomic) NSInteger sensitiveArea;

@property (assign, nonatomic) NSInteger verifyStatus; // 1是审核模式 0非审核模式

@property (copy, nonatomic) NSString *avatar;//头像

@property (strong, nonatomic) NSArray<PPSInviteConfigModel *> *inviteConfig;

@property (strong, nonatomic) NSArray *expressionPack;

@property (strong, nonatomic) NSArray *exchangeMode;

@property (strong, nonatomic) NSArray *payType; // alipay_native or wechat_h5

@property (strong, nonatomic) NSArray *tab;  //’tab’: [‘item’, ‘im’]

@property (copy, nonatomic) NSString *result;

@property (copy, nonatomic) NSString *nickname;//名称

@property (strong, nonatomic) Share_UrlModel *shareUrl;

@property (assign, nonatomic) NSInteger bindWechat;

@property (strong, nonatomic) ShareMode *shareMode;

@property (strong, nonatomic) NewLoginIncome *loginIncome;

@property (assign, nonatomic) NSInteger autoPlay;// 视频自动播放配置,0:否，1：是

@property (strong, nonatomic) ScreenAdModel *screenAd;
@property (strong, nonatomic) AttentionPageAdModel *attentionPageAd;
@property (strong, nonatomic) HotPageAdModel *hotPageAd;

@end

@interface ScreenAdModel : NSObject

@property (copy, nonatomic) NSString *appId;
@property (copy, nonatomic) NSString *adId;
@property (assign, nonatomic) NSInteger show;

@end

@interface AttentionPageAdModel : NSObject

@property (copy, nonatomic) NSString *appId;
@property (copy, nonatomic) NSString *adId;

@end

@interface HotPageAdModel : NSObject

@property (copy, nonatomic) NSString *appId;
@property (copy, nonatomic) NSString *adId;

@end

@interface LuckymoneyconfigModel : NSObject

@property (strong, nonatomic) CommonluckyModel *commonLucky;

@property (strong, nonatomic) LottertluckyModel *lotteryLucky;

@end

@interface ExchangePeopleNumModel : NSObject

@property (copy, nonatomic) NSString *phoneCardSum;

@property (copy, nonatomic) NSString *phoneCardExchanged;

@property (copy, nonatomic) NSString *wechat;

@end

@interface CommonluckyModel : NSObject

@property (copy, nonatomic) NSString *name;

@end

@interface LuckywaveModel : NSObject

@property (assign, nonatomic) NSInteger isLuckyWave;

@property (assign, nonatomic) NSInteger currentLuckyCount;

@property (assign, nonatomic) NSInteger sumLuckyCount;

@end

@interface LottertluckyModel : NSObject

@property (copy, nonatomic) NSString *afterGetName;

@property (copy, nonatomic) NSString *beforeGetName;

@property (copy, nonatomic) NSString *price;

@end

@interface Share_UrlModel : NSObject

@property (copy, nonatomic) NSString *WECHAT_MOMENT;

@end

@interface ShareMode : NSObject

@property (copy, nonatomic) NSString *article;
@property (copy, nonatomic) NSString *video;

@end

@interface NewLoginIncome : NSObject

@property (copy, nonatomic) NSString *have;

@end

@interface PPSInviteConfigModel : NSObject
@property (copy, nonatomic) NSString *shareMode;
@property (copy, nonatomic) NSString *contentType;
@property (copy, nonatomic) NSString *connector;
@property (copy, nonatomic) NSString *img;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *content;
@end
