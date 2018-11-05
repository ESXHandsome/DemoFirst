//
//  ExchangeEditViewController.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/23.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangeView.h"
#import "OptionModel.h"

@interface ExchangeEditController : UITableViewController

@property (assign, nonatomic) ExchangeType exchangeType;
@property (strong, nonatomic) OptionListModel *model;

@end
