//
//  SideBarView.h
//  SidebarView
//
//  Created by 王海玉 on 2017/11/15.
//  Copyright © 2017年 王海玉. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SideBarView;

@protocol SideBarViewDelegate <NSObject>

@optional

- (void)onTapEnjoyButton;
- (void)onTapDiscussButton;
- (void)onTapShraeButton;

@end

@interface SideBarView : UIView

@property (nonatomic, weak)   id <SideBarViewDelegate> delegate;

- (void)shareButtonBecomeWeiXin;    //分享按钮变成呼吸灯
- (void)sideBarViewAlphaWithFloat:(CGFloat)alphaFloat;    //设置边栏透明度
- (void)doubleClickScreen;      //双击屏幕

@end
