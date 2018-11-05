//
//  TotalAssetTableView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "AllRecognizeTableView.h"

@implementation AllRecognizeTableView

//允许同时识别多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
            return NO;
    }
    return YES;
}

@end
