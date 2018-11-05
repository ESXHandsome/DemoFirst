//
//  TopAuthorView.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/2/19.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLFeedModel.h"
#import "FollowButton.h"
#import "NegativeFeedbackView.h"

@protocol TopAuthorViewDelegate <NSObject>
@optional
- (void)didClickAvatarInTopAuthorViewEvent:(XLFeedModel *)model;
- (void)didClickFollowButtonInTopAuthorView:(FollowButton *)followButton;

@end

@interface TopAuthorView : UIView

@property (weak, nonatomic) id<TopAuthorViewDelegate> topAuthorViewDelegate;
@property (weak, nonatomic) id<NegativeFeedbackDelegate> negativeFeedbackDelegate;

@property (strong, nonatomic) NegativeFeedbackView *feedbackView;
//@property (strong, nonatomic) FollowButton *followButton;

- (void)configFeedModel:(XLFeedModel *)model;

- (void)setPublishTime:(NSInteger)timestamp;

- (void)hiddenFollowButton:(BOOL)hidden;

- (void)hiddenPublishLabel;

- (void)showFeedbackButton;

- (void)hiddenFeedBackButton;

@end
