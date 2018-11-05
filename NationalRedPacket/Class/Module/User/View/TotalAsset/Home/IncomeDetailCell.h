//
//  IncomeDetailCell.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/21.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef NS_ENUM(NSInteger, IncomeType) {  //收入类型
    IncomeTypeGold  = 0,
    IncomeTypeMoney = 1,
};

#define kIncomeDetailCellHeight adaptHeight1334(66*2)

static NSString *const IncomeDetailCellID = @"IncomeDetailCellID";

@interface IncomeDetailCell : BaseTableViewCell

@property (assign, nonatomic) IncomeType incomeType;

@end
