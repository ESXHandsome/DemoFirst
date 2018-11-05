//
//  ShareAlertView.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/22.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseView.h"

@protocol ShareAlertViewDelegate <NSObject>
@optional
- (void)didSelectShareIndex:(NSInteger)index;
- (void)didSelectResportButton;

@end

@interface ShareAlertView : BaseView

@property (strong, nonatomic) UILabel *titleLabel;
@property (assign, nonatomic) BOOL hasReport;

- (void)showShareViewWithSceneArray:(NSArray *)array delegate:(id<ShareAlertViewDelegate>)delegate;

- (void)showReportView;

@end
