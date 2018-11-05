//
//  IncomeListController.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/21.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IncomeDetailCell.h"

@interface IncomeListController : UITableViewController

@property (assign, nonatomic) BOOL       canScroll;
@property (assign, nonatomic) IncomeType incomeType;
@property (strong, nonatomic) NSArray    *dataArray;

@end
