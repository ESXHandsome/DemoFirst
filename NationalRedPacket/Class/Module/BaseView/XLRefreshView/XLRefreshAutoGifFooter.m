//
//  XLRefreshAutoGifFooter.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/10.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLRefreshAutoGifFooter.h"

@implementation XLRefreshAutoGifFooter

- (void)prepare
{
    [super prepare];
    NSMutableArray *freshImages = [NSMutableArray array];
    for (int i = 1; i < 12; i++) {
        [freshImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_%d", i]]];
    }
    [self setImages:freshImages forState:MJRefreshStateRefreshing];
    self.triggerAutomaticallyRefreshPercent = 0.1;
    self.stateLabel.textColor = [UIColor colorWithString:COLORB2B2B2];
    self.labelLeftInset = 10;
    [self setTitle:@"加载更多" forState:MJRefreshStateIdle];
    [self setTitle:@"正在加载中..." forState:MJRefreshStateRefreshing];
    [self setTitle:@"没有更多啦～" forState:MJRefreshStateNoMoreData];
}

@end
