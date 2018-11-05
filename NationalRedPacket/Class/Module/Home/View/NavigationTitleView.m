//
//  NavigationTitleView.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/4/17.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "NavigationTitleView.h"

@implementation NavigationTitleView

- (CGSize )intrinsicContentSize {
    if (@available(iOS 11.0, *)) {
        return CGSizeMake(140, 44);
    } else {
        return UILayoutFittingExpandedSize;
    }
}

@end
