//
//  NREmptyDataView.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/27.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLEmptyDataView : UIView

+ (void)showEmptyDataInView:(UIView *)view;

+ (void)showEmptyDataInView:(UIView *)view withTitle:(NSString *)title;

+ (void)showEmptyDataInView:(UIView *)view withTitle:(NSString *)title imageStr:(NSString *)imageStr;

+ (void)showEmptyDataInView:(UIView *)view withTitle:(NSString *)title imageStr:(NSString *)imageStr offSet:(NSInteger)offSet;

+ (void)showEmptyDataInView:(UIView *)view withTitle:(NSString *)title imageStr:(NSString *)imageStr offSet:(NSInteger)offSet titleOffSet:(NSInteger)titleOffSet tapAction:(void(^)(void))tapAction;

+ (void)hideEmptyDataInView:(UIView *)view;

+ (XLEmptyDataView *)emptyDataForView:(UIView *)view;


@end
