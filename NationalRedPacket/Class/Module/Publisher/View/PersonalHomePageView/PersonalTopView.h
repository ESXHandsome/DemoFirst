//
//  PersonalTopView.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/1/26.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowButton.h"
#import "XLPublisherModel.h"

@protocol PersonalTopViewDelegate <NSObject>

- (void)didClickPersonalFollowButtonEvent:(XLPublisherModel *)model
                 withFollowButton:(FollowButton *)followButton;

- (void)didClickTopViewSegmentView:(NSInteger)selectIndex;

- (void)didClickTopViewDynamicButton;

- (void)didClickTopViewVideoButton;

@end

@interface PersonalTopView : UIView

@property (strong, nonatomic) XLPublisherModel *model;
@property (assign, nonatomic) CGRect        leftBtnFrame;
@property (assign, nonatomic) CGRect        rightBtnFrame;
@property (assign, nonatomic) CGFloat       itemHeight;
@property (strong, nonatomic) FollowButton  *followButton;        // 关注按钮
@property (strong, nonatomic) UIImageView   *personalBgImageView; // 顶部背景
@property (strong, nonatomic) UILabel       *segmentSelectedLine; // 选择提示线
@property (assign, nonatomic) NSInteger     selectedItemIndex;
@property (weak, nonatomic) id<PersonalTopViewDelegate> personalDelegate;
@property (strong, nonatomic) UIButton      *leftButton;              // 动态按钮
@property (strong, nonatomic) UIButton      *rightButton;             // 视频按钮

@end
