//
//  AppDelegate.h
//  NationalRedPacket
//
//  Created by 孙明悦 on 2017/5/31.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (instancetype)shared;

- (void)resetToRootTabViewController;
- (void)resetToRootViewContoller:(UIViewController *)controller;

@end

