//
//  ExchangeTypeCell.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ExchangeProtocol.h"

static NSString *const ExchangeTypeCellID = @"ExchangeTypeCellID";

@interface ExchangeTypeCell : BaseTableViewCell

@property (weak, nonatomic) id<ExchangeProtocol>delegate;

@end
