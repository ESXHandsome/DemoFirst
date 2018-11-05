//
//  XLH5AlertView.h
//  NationalRedPacket
//
//  Created by Ying on 2018/6/20.
//  Copyright © 2018 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLH5AlertView : UIView

/**
 图片地址
 */
@property (copy, nonatomic) NSString *imageUrlString;

/**
 展示H5入口弹窗

 @param imageUrlString 弹窗显示的图像链接
 @param urlString 点击挑战的链接
 @param target 当前视图控制器
 @param ID 弹窗标识
 */
+ (void)showH5GudieAlert:(NSString *)imageUrlString open:(NSString *)urlString target:(UIViewController *)target ID:(NSString  *)ID;

@end
