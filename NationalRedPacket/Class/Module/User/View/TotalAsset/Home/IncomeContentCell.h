//
//  IncomeContentCell.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/21.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "TotalAssetProtocol.h"

#define kContentCellHeight (SCREEN_HEIGHT - adaptHeight1334(260) - NAVIGATION_BAR_HEIGHT)

static NSString *const IncomeContentCellID = @"IncomeContentCellID";

@interface IncomeContentCell : BaseTableViewCell

@property (weak, nonatomic)   id<TotalAssetProtocol>delegate;
@property (assign, nonatomic) BOOL canScroll;

/**
 切换子view
 
 @param index index
 */
-(void)switchChildViewControllerIndex:(NSInteger)index animated:(BOOL)animated;

- (void)updateGoldListView:(NSArray *)goldListArray;
- (void)updateMoneyListView:(NSArray *)moneyListArray;

@end
