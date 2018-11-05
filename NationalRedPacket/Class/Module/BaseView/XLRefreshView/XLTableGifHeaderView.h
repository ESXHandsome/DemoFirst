//
//  XLTableGifHeaderView.h
//  NationalRedPacket
//
//  Created by Ying on 2018/5/30.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedsHeaderView.h"

@interface XLTableGifHeaderView : FeedsHeaderView
+ (instancetype)tableGifHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)action;
@end
