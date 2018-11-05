//
//  TotalAssetProtocol.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/21.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

@protocol TotalAssetProtocol <NSObject>

/**
 提现按钮点击
 */
- (void)didClickExchangeButton;

/**
 兑换规则点击
 */
- (void)didClickExchangeRuleButton;

/**
 
 分段控制器切换
 @param index 切换位置
 */
- (void)didSelectSegmentControlIndex:(NSInteger)index;

/**
 分段控制器滚动切换动画

 @param offSet 滚动距离
 */
- (void)scrollAnimationWithOffSet:(CGFloat)offSet;

@end
