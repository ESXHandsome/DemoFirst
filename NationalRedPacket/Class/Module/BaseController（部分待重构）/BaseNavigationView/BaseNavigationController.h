//
//  BaseNavigationController.h
//  NationalRedPacket
//
//  Created by 孙明悦 on 2017/5/31.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RTRootNavigationController/RTRootNavigationController.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

@interface BaseNavigationController : RTRootNavigationController

@property (nonatomic, assign) BOOL enableRightGesture; // default YES

@end
