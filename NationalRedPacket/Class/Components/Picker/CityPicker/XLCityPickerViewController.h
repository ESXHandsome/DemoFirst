//
//  XLCityPickerViewController.h
//  NationalRedPacket
//
//  Created by Ying on 2018/7/27.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLCityPickerDelegate <NSObject>

- (void)finishToChoose:(NSString *)province city:(NSString *)city;

@end

@interface XLCityPickerViewController : UIViewController

@property (weak, nonatomic) id<XLCityPickerDelegate> delegate;

- (void)showCityPickerViewForm:(UIViewController *)contentView;

@end
