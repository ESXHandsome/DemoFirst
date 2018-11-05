//
//  UIViewController+ActionSheet.m
//  NationalRedPacket
//
//  Created by fensi on 2018/4/26.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "UIViewController+ActionSheet.h"

@implementation UIViewController (ActionSheet)

- (void)showActionSheetWithTitle:(NSString *)title {
    [self showActionSheetWithTitle:title message:nil];
}

- (void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message {
    [self showActionSheetWithTitle:title message:message actionTitles:nil actionHandler:nil];
}

- (void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message actionTitles:(NSArray<NSString *> *)actionTitles actionHandler:(void (^)(NSInteger))actionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (actionTitles) {
        
        for (NSInteger i = 0; i < actionTitles.count; i++) {
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (actionHandler) {
                    actionHandler(i);
                }
            }];
            
            [alert addAction:action];
            
            if (i == actionTitles.count - 1) {
                alert.preferredAction = action;
            }
        }
        
    } else {
        
        [alert addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil]];
        
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
