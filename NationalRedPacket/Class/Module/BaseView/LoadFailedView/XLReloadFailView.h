//
//  NRReloadFailView.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/27.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLReloadFailView : UIView

+ (void)showReloadFailInView:(UIView *)view reloadAction:(void(^)(void))reloadAction;

+ (void)showReloadFailInView:(UIView *)view offSet:(NSInteger)offSet reloadAction:(void(^)(void))reloadAction;

+ (void)hideReloadFailInView:(UIView *)view;

+ (XLReloadFailView *)reloadFailForView:(UIView *)view;

@end
