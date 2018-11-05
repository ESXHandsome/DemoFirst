//
//  ExchangeAlertView.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/23.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "BaseView.h"
#import "ExchangeView.h"

@interface ExchangeAlertView : BaseView

+ (void)showExchangeSureViewWithType:(ExchangeType)exchangeType sureInfo:(NSMutableDictionary *)dicInfo sureInfoCallBack:(void(^)(void))sureInfoCallBack;

@end
