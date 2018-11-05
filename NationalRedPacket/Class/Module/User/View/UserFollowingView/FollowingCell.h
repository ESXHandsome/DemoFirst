//
//  FollowingCell.h
//  NationalRedPacket
//
//  Created by 王海玉 on 2018/1/25.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPublisherModel.h"

static NSString *const FollowingCellID = @"FollowingCell";

@interface FollowingCell : UITableViewCell

@property (strong, nonatomic) XLPublisherModel *model;

@end
