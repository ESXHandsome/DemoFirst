//
//  BottomCommentView.h
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/23.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BaseView.h"
#import "XLFeedModel.h"
#import "LikeAnimationButton.h"

@class BottomToolbarView;

@protocol BottomToolbarViewDelegate  <NSObject>

- (void)toolbarView:(BottomToolbarView *)toolbar commentAction:(UIButton *)commentButton;
- (void)toolbarView:(BottomToolbarView *)toolbar praiseAction :(LikeAnimationButton *)praiseButton;
- (void)toolbarView:(BottomToolbarView *)toolbar forwardAction:(UIButton *)forwardButton;
- (void)toolbarView:(BottomToolbarView *)toolbar pictureCommentAction:(UIButton *)pictureCommentButton;

@end

@interface BottomToolbarView : BaseView

@property (weak, nonatomic) id<BottomToolbarViewDelegate>delegate;
@property (strong, nonatomic) XLFeedModel *model;
@property (assign, nonatomic) BOOL translucent;
@property (assign, nonatomic) BOOL shortcutPictureComment;

@end
