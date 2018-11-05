//
//  UIViewController+Tracking.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/12.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "UIViewController+Tracking.h"
#import "UIView+Display.h"
#import "FloatViewManager.h"

@interface UIViewController ()

@property (strong, nonatomic) NSMutableDictionary *viewControllerDictionary;

@end

@implementation UIViewController (Tracking)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        // viewWillAppear
        Method originalAppearMethod = class_getInstanceMethod(class, @selector(viewWillAppear:));
        Method swizzledAppearMethod = class_getInstanceMethod(class, @selector(XL_viewWillAppear:));
        method_exchangeImplementations(originalAppearMethod, swizzledAppearMethod);
        
        // viewDidLoad
        Method originalDidLoadMethod = class_getInstanceMethod(class, @selector(viewDidLoad));
        Method swizzledDidLoadMethod = class_getInstanceMethod(class, @selector(XL_viewDidLoad));
        method_exchangeImplementations(originalDidLoadMethod, swizzledDidLoadMethod);
        
        // viewWillDisAppear
        Method originalWillDisappearMethod = class_getInstanceMethod(class, @selector(viewWillDisappear:));
        Method swizzledWillDisappearMethod = class_getInstanceMethod(class, @selector(XL_viewWillDisappear:));
        method_exchangeImplementations(originalWillDisappearMethod, swizzledWillDisappearMethod);
        
        // viewDidDisappear
        Method originalDisappearMethod = class_getInstanceMethod(class, @selector(viewDidDisappear:));
        Method swizzledDisappearMethod = class_getInstanceMethod(class, @selector(XL_viewDidDisappear:));
        method_exchangeImplementations(originalDisappearMethod, swizzledDisappearMethod);
        
    });
}

#pragma mark - Method Swizzling
- (void)XL_viewWillAppear:(BOOL)animated {
    [self XL_viewWillAppear:animated];
    
    NSString *duationValue = [StatServiceApi.sharedService pageDurationValueWithViewController:self];
    if (duationValue != nil) {
        [StatServiceApi statEventBegin:duationValue];
    }
    
    if ([StatServiceApi.sharedService.viewControllerDictionary.allKeys containsObject:NSStringFromClass([self class])]) {
        [StatServiceApi sharedService].currentVCStr = NSStringFromClass([self class]);
    }
}

- (void)XL_viewDidLoad {
    [self XL_viewDidLoad];
    
    if ([StatServiceApi.sharedService.viewControllerDictionary.allKeys containsObject:NSStringFromClass([self class])]) {
        [StatServiceApi sharedService].currentVCStr = NSStringFromClass([self class]);
    }
    
    [[FloatViewManager sharedInstance] getCurrentVeiwController:self];
    [[FloatViewManager sharedInstance] showSuspensionView];
    [[FloatViewManager sharedInstance] showH5AlertView];
}

- (void)XL_viewWillDisappear:(BOOL)animated {
    [self XL_viewWillDisappear:animated];
    
    if (![UIView isDisplayedInScreenForView:self.view]) {  //特殊处理，热门和关注页
        return;
    }
    NSString *duationValue = [StatServiceApi.sharedService pageDurationValueWithViewController:self];
    if (duationValue != nil) {
        [StatServiceApi statEventEnd:duationValue];
    }
}

- (void)XL_viewDidDisappear:(BOOL)animated {
    
    [self XL_viewDidDisappear:animated];
    
    if ([StatServiceApi.sharedService.viewControllerDictionary.allKeys containsObject:NSStringFromClass([self class])]) {
        [StatServiceApi sharedService].lastVCStr = NSStringFromClass([self class]);
    }
}

@end
