//
//  XLFloatRefreshView.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/7/5.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "BaseView.h"

@interface XLFloatRefreshView : UIButton

+ (instancetype)floatWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

//结束刷新
- (void)endRefreshing;

@end
