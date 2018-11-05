//
//  FollowButton.h
//  FollowButton
//
//  Created by 刘永杰 on 2018/1/25.
//  Copyright © 2018年 刘永杰. All rights reserved.
//
/*  使用示例
 {
 FollowButton *perButton = [FollowButton buttonWithType:FollowButtonTypePersonal];
 perButton.frame = CGRectMake(100, 200, adaptHeight1334(160), adaptWidth750(64));
 _button.followed = YES;  //初始状态是否点赞
 perButton.delegate = self;
 [self.view addSubview:perButton];
 
 }
 
 - (void)followButtonClick:(FollowButton *)sender
 {
 //模拟网络请求时长，正常使用不需要加延迟
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 if (sender.followed) {
 //发送网络请求
 if (arc4random() % 2) {  //请求成功
 sender.followed = NO;
 } else {  //请求失败
 [sender stopAnimation];
 }
 } else {
 //发送网络请求
 if (arc4random() % 2) {  //请求成功
 sender.followed = YES;
 } else {  //请求失败
 [sender stopAnimation];
 }
 }
 });
 }
 
 */

#import <UIKit/UIKit.h>
#import "CancleHighlightedButton.h"

#define COLORD9D9D9 @"#D9D9D9"
#define COLORCFCFCF @"#CFCFCF"
#define COLORFF9500 @"#FF9500"
#define COLORFEFAE8 @"#FEFAE8"

typedef NS_ENUM(NSInteger, FollowButtonType) {
    FollowButtonTypeHome        = 0,
    FollowButtonTypePersonal    = 1,
    FollowButtonTypeVideoDetail = 2
};

@protocol FollowButtonDelegate <NSObject>

- (void)followButtonClick:(UIView *)sender;

@end

@interface FollowButton : UIView

+ (instancetype)buttonWithType:(FollowButtonType)buttonType;
@property (strong, nonatomic) CancleHighlightedButton *button;
@property (weak, nonatomic) id<FollowButtonDelegate>delegate;
@property (nonatomic, getter=isSelected) BOOL followed; // default is NO
@property (strong, nonatomic) UIFont  *titleFont;      // 设置字号
@property (assign, nonatomic) CGFloat activityHeight;  // 设置菊花大小
@property (strong, nonatomic) UIColor *followedTitleColor;  //已关注的文字颜色
@property (strong, nonatomic) UIColor *followedActivityColor;  //已关注的圈圈颜色
@property (assign, nonatomic) FollowButtonType buttonType;     //关注按钮类型

/**
 开始images动效
 */
- (void)startImagesAnimation;

/**
 开始转圈动画，用于两个button同步转圈状态时调用
 */
- (void)startAnimation;

/**
 停止转圈动画，用于发送请求失败时button状态的恢复
 */
- (void)stopAnimation;

/**
 根据类型改变按钮状态,和配文

 @param type 1-4
 */
- (void)changeButtonState:(NSInteger)type;

@end
