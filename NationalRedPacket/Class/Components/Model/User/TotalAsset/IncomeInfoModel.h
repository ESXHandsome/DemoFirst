//
//  IncomeInfoModel.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IncomeInfoModel : NSObject

@property (copy, nonatomic) NSString *myCoin;
@property (copy, nonatomic) NSString *inviteIncome;
@property (copy, nonatomic) NSString *totalIncome;
@property (copy, nonatomic) NSString *balance;
@property (copy, nonatomic) NSString *yesterdayIncome;

@property (copy, nonatomic) NSString *coin;  //占位使用（外部不要使用该字段）

@end
