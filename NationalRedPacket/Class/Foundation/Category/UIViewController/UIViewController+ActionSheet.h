//
//  UIViewController+ActionSheet.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/26.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ActionSheet)

- (void)showActionSheetWithTitle:(NSString *)title;

- (void)showActionSheetWithTitle:(NSString *)title
                         message:(NSString *)message;

- (void)showActionSheetWithTitle:(NSString *)title
                         message:(NSString *)message
                    actionTitles:(NSArray<NSString *> *)actionTitles
                   actionHandler:(void(^)(NSInteger index))actionHandler;

@end
