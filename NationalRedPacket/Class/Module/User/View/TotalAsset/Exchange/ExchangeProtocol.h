//
//  ExchangeProtocol.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/23.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

@protocol ExchangeProtocol <NSObject>

@optional

- (void)didSelectExchangeOptionWithModel:(id)model;

- (void)didClickExchangeSureButton;

@end
