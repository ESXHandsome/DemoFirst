//
//  ExchangeModel.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/26.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ExchangeStatus) {  //兑换类型
    ExchangeStatusChecking   = 0,
    ExchangeStatusSuccess    = 1,
    ExchangeStatusFail       = 2,
};

@interface ExchangeModel : NSObject

@property (copy, nonatomic) NSString *exchangeId;
@property (copy, nonatomic) NSString *money;
@property (copy, nonatomic) NSString *exchangeMode;
@property (copy, nonatomic) NSString *account;
@property (assign, nonatomic) ExchangeStatus status;
@property (copy, nonatomic) NSString *createdAt;
@property (copy, nonatomic) NSString *result;  //0:成功 1:兑换类型错误 2:兑换金额错误 3:余额不足 4:上一笔兑换审核中
@property (copy, nonatomic) NSString *estimateTime; //预计到账时间

@end
