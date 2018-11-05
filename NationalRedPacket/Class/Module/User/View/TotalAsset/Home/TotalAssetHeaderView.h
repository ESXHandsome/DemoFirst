//
//  TotalAssetHeaderView.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/20.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "BaseView.h"
#import "TotalAssetProtocol.h"

#define kTotalAssetHeight adaptHeight1334(620)

@interface TotalAssetHeaderView : BaseView

@property (weak, nonatomic) id<TotalAssetProtocol>delegate;

- (void)updateGoldNumber:(NSString *)number;
- (void)updateYesterdayIncome:(NSString *)income;
- (void)updateBalance:(NSString *)balance;

@end
