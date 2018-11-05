//
//  TotalAssetViewController.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/20.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>

static XLRouterArgumentKey * const XLRouterArgumentIncomeKey = @"XLRouterArgumentIncomeKey";

@interface TotalAssetViewController : UIViewController <XLRoutableProtocol>

@property (assign, nonatomic) BOOL isIncome; //是否切换到零钱

- (void)setTableViewScroll:(BOOL)isScroll;

@end
