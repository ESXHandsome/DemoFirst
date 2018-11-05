//
//  PersonalScrollView.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/1/29.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "PersonalScrollView.h"

@implementation PersonalScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  
    // 首先判断otherGestureRecognizer是不是系统pop手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
     
        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if ([self panBack:gestureRecognizer]) {
        return NO;
    }
    return YES;
}

- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer == self.panGestureRecognizer) {
        
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self]; 
        UIGestureRecognizerState state = gestureRecognizer.state;
        
        if (UIGestureRecognizerStateBegan == state || UIGestureRecognizerStatePossible == state) {
            
            if (point.x >= 0 && self.contentOffset.x <= 0) {
                return YES;
            }
        }
    }
    return NO;
}

@end
