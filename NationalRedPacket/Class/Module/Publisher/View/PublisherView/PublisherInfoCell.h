//
//  PublisherInfoCell.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "ChoicenessInfoHeaderView.h"
#import "PublisherCardCell.h"
#import "XLPublisherProtocol.h"

@interface PublisherInfoCell : BaseTableViewCell <XLPublisherProtocol>

@property (weak, nonatomic) id<PublisherCellDelegate>delegate;

@end
