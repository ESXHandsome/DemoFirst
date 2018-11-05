//
//  XLDatePickerViewController.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/27.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLDatePickerDelegate <NSObject>

- (void)finishToChooseDate:(NSString *)timeString;

@end

@interface XLDatePickerViewController : UIViewController

@property (weak, nonatomic) id<XLDatePickerDelegate> delegate;

- (void)showDatePickerViewForm:(UIViewController *)contentView;

@end
