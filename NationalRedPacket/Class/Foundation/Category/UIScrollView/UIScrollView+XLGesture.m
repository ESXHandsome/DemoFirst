//
//  UIScrollView+XLGesture.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/7/12.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "UIScrollView+XLGesture.h"
#import "XLMyUploadViewController.h"

@implementation UIScrollView (XLGesture)

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    
    BaseNavigationController *nav = (BaseNavigationController *)self.viewController.navigationController.navigationController;
    if([view isKindOfClass:[UISlider class]]) {
        //如果响应view是UISlider,则scrollview禁止滑动
        if (self.xl_interactiveGestureConflict) {
            self.scrollEnabled = NO;
        }
        if (nav && [nav respondsToSelector:@selector(setEnableRightGesture:)]) {
            nav.enableRightGesture = NO;
        }
    } else {   //如果不是,则恢复滑动
        if (self.xl_interactiveGestureConflict) {
            self.scrollEnabled = YES;
        }
        if (nav && [nav respondsToSelector:@selector(setEnableRightGesture:)]) {
            XLMyUploadViewController *uploadVC = [(RTContainerController *)[nav.viewControllers lastObject] contentViewController];
            if ([uploadVC isKindOfClass:[XLMyUploadViewController class]]) {
                if (uploadVC.isUploadAlertPush) {
                    nav.enableRightGesture = NO;
                } else {
                    nav.enableRightGesture = YES;
                }
            } else {
                nav.enableRightGesture = YES;
            }
        }
    }
    return view;
}


- (BOOL)xl_interactiveGestureConflict {
    
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setXl_interactiveGestureConflict:(BOOL)xl_interactiveGestureConflict {
    
    objc_setAssociatedObject(self, @selector(xl_interactiveGestureConflict), @(xl_interactiveGestureConflict), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
