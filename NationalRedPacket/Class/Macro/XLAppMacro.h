//
//  XLAppMacro.h
//  NationalRedPacket
//
//  Created by sunmingyue on 17/7/14.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#ifndef XLAppMacro_h
#define XLAppMacro_h

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define SCREEN_BOUNDS   [UIScreen mainScreen].bounds

#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define STATUS_BAR_HEIGHT CGRectGetHeight(UIApplication.sharedApplication.statusBarFrame)
#define NAVIGATION_BAR_HEIGHT (IS_IPHONE_X ? 88.f : 64.f)
#define TAB_BAR_HEIGHT 49

#endif /* XLAppMacro_h */
