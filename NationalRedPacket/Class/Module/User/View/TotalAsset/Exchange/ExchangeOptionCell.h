//
//  ExchangeOptionCell.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const ExchangeOptionCellID = @"ExchangeOptionCellID";

@interface ExchangeOptionCell : UICollectionViewCell

//赋值
- (void)configOptionModel:(id )model indexPath:(NSIndexPath *)indexPath;

- (void)setOptionCellHighlight:(BOOL)isHighlight;

@end
