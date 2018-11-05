//
//  LikeAnimationButton.h
//  LikeButtonDemo
//
//  Created by 刘永杰 on 2018/7/6.
//  Copyright © 2018年 刘永杰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LikeAnimationButtonType) {
    LikeAnimationButtonTypeTop    = 0,  //赞
    LikeAnimationButtonTypeTread  = 1,  //踩
};

@class LikeAnimationButton;

@protocol LikeAnimationButtonDelegate <NSObject>

- (void)didClickAnimationButton:(LikeAnimationButton *)animationButton type:(LikeAnimationButtonType)animationType;

@end

@interface LikeAnimationButton : UIButton

@property (strong, nonatomic) id<LikeAnimationButtonDelegate> delegate;

@property (assign, nonatomic) LoginSourceType loginSourceType;

@property (strong, nonatomic) XLFeedModel *feedModel;

+ (instancetype)animationButtonWithType:(LikeAnimationButtonType)animationType;

@end
