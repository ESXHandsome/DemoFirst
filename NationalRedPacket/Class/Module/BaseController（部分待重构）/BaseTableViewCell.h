//
//  BaseTableViewCell.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2017/6/22.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackResult)(NSInteger index);

@interface BaseTableViewCell : UITableViewCell

@property (copy, nonatomic) BackResult backResult;

- (void)setupViews;

- (void)configModelData:(id)model indexPath:(NSIndexPath *)indexPath;

@end
