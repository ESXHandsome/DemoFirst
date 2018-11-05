//
//  ExchangeView.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/23.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "BaseView.h"
#import "ExchangeProtocol.h"

typedef NS_ENUM(NSInteger, ExchangeType) {  //兑换类型
    ExchangeTypeAlipay    = 0,
    ExchangeTypeTelephone = 1,
};

@interface ExchangeView : UIView

- (instancetype)initWithExchangeType:(ExchangeType)exchangeType delegate:(id<ExchangeProtocol>)delegate;

- (void)becomeCanEditState;

- (NSMutableDictionary *)exchangeRequestDictionary;

@end
