//
//  RecordDetailViewController.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/26.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangeModel.h"

@interface RecordDetailViewController : UITableViewController

@property (strong, nonatomic) ExchangeModel *model;

@property (assign, nonatomic) BOOL isFromExchange;

@end
