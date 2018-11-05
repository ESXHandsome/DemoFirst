//
//  FloatView.h
//  NationalRedPacket
//
//  Created by Ying on 2018/1/25.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,StayMode){ ///悬浮位置
    STAYMODE_CENTER         =   0,
    STAYMODE_LEFT_BOTTOM    =   1,
    STAYMODE_RIGHT_BOTTOM   =   2
    
};

typedef NS_ENUM(NSInteger,AppearAnimationMode) { ///出现位置
    APPEARANIMATIONMODE_SCALE_UP       =   0,
    APPEARANIMATIONMODE_SLIDE_IN_LEFT  =   1,
    APPEARANIMATIONMODE_SLIDE_IN_RIGHT =   2,
    APPEARANIMATIONMODE_SLIDE_IN_TOP   =   3,
    APPEARANIMATIONMODE_SLIDE_IN_DOWN  =   4
    
};

typedef NS_ENUM(NSInteger,DisappearAnimationMode) {  ///消失位置
    DISAPPEARANIMATIONMODE_SCALE_DOWN     =   0,
    DISAPPEARANIMATIONMODE_SLIDE_OUT_LEFT =   1,
    DISAPPEARANIMATIONMODE_SLIDE_OUT_RIGHT=   2,
    DISAPPEARANIMATIONMODE_SLIDE_OUT_UP   =   3,
    DISAPPEARANIMATIONMODE_SLIDE_OUT_DOWN =   4
};

typedef NS_ENUM(NSInteger,CloseButtonPosition) { ///关闭按钮位置
    CLOSEBUTTONPOSITION_LEFT_BOTTOM   =   1,
    CLOSEBUTTONPOSITION_RIGHT_BOTTOM  =   2,
    CLOSEBUTTONPOSITION_LEFT_TOP      =   3,
    CLOSEBUTTONPOSITION_RIGHT_TOP     =   4
};

@interface FloatView : UIView

/**驻留模式*/
@property (assign, nonatomic) StayMode stayMode;

/**出现动画*/
@property (assign, nonatomic) AppearAnimationMode appearAnimationMode;

/**消失动画类型*/
@property (assign, nonatomic) DisappearAnimationMode disappearAinmationMode;

/**关闭按钮的位置*/
@property (assign, nonatomic) CloseButtonPosition closeButtonPosition;

/**即将展示的url字符串*/
@property (copy, nonatomic) NSString *showUrlString;

/**图像视图*/
@property (strong, nonatomic) UIImageView *imageView;

/**关闭按钮*/
@property (strong, nonatomic) UIButton *closeButton;

/**垂直间距*/
@property (assign, nonatomic)  CGFloat marginVertical;

/**水平间距*/
@property (assign, nonatomic)  CGFloat marginHorizontal;

/**消失时间*/
@property (assign, nonatomic)  NSInteger disappearTime;

/**是否展示*/
@property (assign, nonatomic) BOOL show;

/**是否点击消失*/
@property (assign, nonatomic) BOOL click;

/**是否重复显示*/
@property (assign, nonatomic) BOOL repeat;

/**悬浮窗遮罩*/
@property BOOL isMask;

/**悬浮窗的标识*/
@property (copy, nonatomic) NSString *ID;

/**
 初始化悬浮窗frame

 @param frame 需要设置的frame
 */
-(void)floatViewInitWithFrame:(CGRect)frame;

/**
 悬浮窗停留位置

 @param stayMode 枚举
 */
-(void)floatViewStayPosition:(StayMode)stayMode;

/**
 是否添加遮罩
 */
-(void)floatViewAddMask;

/**
 点击遮罩关闭悬浮窗
 */
-(void)floatViewClickMaskClose;

/**
 设置悬浮窗动画效果

 @param appearAnimationMode 进入动画
 @param disAppearAnimation 消失动画
 */
-(void)floatViewAppearAnimation:(AppearAnimationMode)appearAnimationMode disAppearAnimation:(DisappearAnimationMode)disAppearAnimation;

/**
 设置取消按钮位置和图案

 @param closeButtonPosition 取消按钮的位置
 @param imageUrlString 图案的URL String
 */
-(void)floatViewCloseButtonPosition:(CloseButtonPosition)closeButtonPosition imageUrl:(NSString*)imageUrlString;

/**
 设置悬浮窗的图像

 @param imageUrlString 悬浮窗图案的URL String
 */
-(void)floatViewInitImage:(NSString *)imageUrlString;

/**
 关闭后触发的时间
 */
-(void)closeAction;

@end
