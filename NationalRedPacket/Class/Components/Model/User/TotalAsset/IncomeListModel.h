//
//  IncomeListModel.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IncomeListModel : NSObject

@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *money;
@property (copy, nonatomic) NSString *createdAt;
@property (assign, nonatomic) BOOL   isIncome;

@end
