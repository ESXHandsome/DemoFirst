//
//  XLTableGifHeaderView.m
//  NationalRedPacket
//
//  Created by Ying on 2018/5/30.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLTableGifHeaderView.h"


@implementation XLTableGifHeaderView

+ (instancetype)tableGifHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    
    XLTableGifHeaderView *gifHeader = [XLTableGifHeaderView headerWithRefreshingTarget:target refreshingAction:action];
    [gifHeader.stateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
    }];
    gifHeader.backgroundColor = [UIColor colorWithString:COLORF2F2F2];
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    [gifHeader setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [gifHeader setTitle:@"下拉刷新..." forState:MJRefreshStateIdle];
    [gifHeader setTitle:@"松开刷新..." forState:MJRefreshStatePulling];
    return gifHeader;
}

@end
