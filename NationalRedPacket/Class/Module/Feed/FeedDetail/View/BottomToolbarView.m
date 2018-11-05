//
//  BottomCommentView.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/8/23.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "BottomToolbarView.h"
#import <Lottie/Lottie.h>
#import "NSString+NumberAdapt.h"
#import "XLUserManager.h"

#define kPictureCommentButtonWidth adaptWidth750(56*2)
#define kCommentButtonWidth        adaptWidth750(218*2)
#define kAllButtonWidth            ((SCREEN_WIDTH - kCommentButtonWidth - adaptWidth750(30))/2.0)

@interface BottomToolbarView () <LikeAnimationButtonDelegate>

@property (strong, nonatomic) UIView   *lineView; //顶部分割线

///评论按钮触发
@property (strong, nonatomic) UIButton *commentButton;
///点赞
@property (strong, nonatomic) LikeAnimationButton *praiseButton;
///转发
@property (strong, nonatomic) UIButton *shareButton;
///图片评论按钮触发
@property (strong, nonatomic) UIButton *pictureCommentButton;

@end

@implementation BottomToolbarView

- (void)setupViews
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithString:COLORE1E1DF];
    [self addSubview:lineView];
    self.lineView = lineView;
    
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:commentButton];
    commentButton.layer.cornerRadius = 18;
    commentButton.layer.masksToBounds = YES;
    [commentButton setTitleColor:[UIColor colorWithString:COLOR9A9A9A] forState:UIControlStateNormal];
    commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [commentButton setTitle:@"期待你的神评论..." forState:UIControlStateNormal];
    commentButton.backgroundColor = [UIColor colorWithString:COLORF4F5F6];
    commentButton.layer.borderColor = [UIColor colorWithString:COLORE8E8E8].CGColor;
    commentButton.layer.borderWidth = 0.5;
    commentButton.titleEdgeInsets = UIEdgeInsetsMake(0, adaptWidth750(24), 0, 0);
    commentButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [commentButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    commentButton.tag = 800;
    self.commentButton = commentButton;
    
    self.praiseButton = [LikeAnimationButton animationButtonWithType:LikeAnimationButtonTypeTop];
    self.praiseButton.tag = 801;
    self.praiseButton.delegate = self;
    [self addSubview:self.praiseButton];
    
    self.shareButton = [self createButtonWithImageStr:@"detail_comment_forward"];
    self.shareButton.tag = 802;
    [self addSubview:self.shareButton];
    
    self.pictureCommentButton = [self createButtonWithImageStr:@"comment_picture"];
    self.pictureCommentButton.tag = 803;
    self.pictureCommentButton.hidden = YES;
    [self addSubview:self.pictureCommentButton];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(0.5);
        
    }];
    
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(adaptWidth750(30));
        make.top.equalTo(self).offset(7);
        make.bottom.equalTo(self).offset(-7);
        make.width.mas_equalTo(kCommentButtonWidth);
    }];
    
    [self.praiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(commentButton.mas_right);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(kAllButtonWidth);
        
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.praiseButton.mas_right);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(kAllButtonWidth-adaptWidth750(20));
    }];
    
    [self.pictureCommentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(kPictureCommentButtonWidth);
    }];
    
}

- (UIButton *)createButtonWithImageStr:(NSString *)imageStr
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(26)];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, adaptWidth750(12), 0, 0);
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor colorWithString:COLORBDBDBD] forState:UIControlStateNormal];
    
    return button;
}

- (void)buttonAction:(UIButton *)sender
{
    switch (sender.tag - 800) {
        case 0: {
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(toolbarView:commentAction:)]) {
                [self.delegate toolbarView:self commentAction:sender];
            }
            break;
        }
        case 2: {
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(toolbarView:forwardAction:)]) {
                [self.delegate toolbarView:self forwardAction:sender];
            }
            break;
        }
        case 3: {
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(toolbarView:pictureCommentAction:)]) {
                [self.delegate toolbarView:self pictureCommentAction:sender];
            }
            break;
        }
    }
}

- (void)didClickAnimationButton:(LikeAnimationButton *)animationButton type:(LikeAnimationButtonType)animationType {
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(toolbarView:praiseAction:)]) {
        [self.delegate toolbarView:self praiseAction:animationButton];
    }
}

- (void)setTranslucent:(BOOL)translucent {
    _translucent = translucent;
    
    self.backgroundColor = translucent ? [UIColor colorWithPatternImage:[UIImage imageNamed:@"deteail_comment_bg"]] : [UIColor whiteColor];
    
    self.commentButton.backgroundColor = translucent ? [[UIColor colorWithString:COLORF2F2F2] colorWithAlphaComponent:0.2] : [UIColor colorWithString:COLORF4F5F6];
    [self.commentButton setTitleColor:[UIColor colorWithString:translucent ? COLOREFEFEF : COLOR9A9A9A] forState:UIControlStateNormal];
    self.commentButton.layer.borderWidth = translucent ? 0 : 0.5;
    
    [self.praiseButton setImage:[UIImage imageNamed:translucent ? @"detail_comment_like_white" : @"detail_comment_like"] forState:UIControlStateNormal];
    [self.praiseButton setTitleColor:[UIColor colorWithString: translucent ? COLOREFEFEF : COLORBDBDBD] forState:UIControlStateNormal];

    [self.shareButton setImage:[UIImage imageNamed:translucent ? @"detail_comment_forward_white" : @"detail_comment_forward"] forState:UIControlStateNormal];
    [self.shareButton setTitleColor:[UIColor colorWithString:translucent ? COLOREFEFEF : COLORBDBDBD] forState:UIControlStateNormal];

    self.lineView.hidden = translucent;
}

- (void)setShortcutPictureComment:(BOOL)shortcutPictureComment {
    _shortcutPictureComment = shortcutPictureComment;
    
    self.praiseButton.hidden = shortcutPictureComment;
    self.shareButton.hidden = shortcutPictureComment;
    self.pictureCommentButton.hidden = !shortcutPictureComment;
    
    [self.commentButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(shortcutPictureComment ? (SCREEN_WIDTH - kPictureCommentButtonWidth - adaptWidth750(30)) : kCommentButtonWidth);
    }];
}

- (void)setModel:(XLFeedModel *)model
{
    _model = model;
    
    self.praiseButton.selected = model.isPraise;
    [self.praiseButton setTitle:model.praiseNum == 0 ? @"赞" : [NSString numberAdaptWithInteger:model.praiseNum] forState:UIControlStateNormal];
    if (XLUserManager.shared.isOnceShared) {
        [self.shareButton setTitle:model.forwardNum == 0 ? @"转发" : [NSString numberAdaptWithInteger:model.forwardNum] forState:UIControlStateNormal];
    } else {
        [self.shareButton setTitle:@"转发" forState:UIControlStateNormal];
    }
    
    if (model.type.integerValue == XLFeedCellMultiPictureType) {
        self.praiseButton.loginSourceType = LoginSourceTypeImagePraise;
    } else {
        self.praiseButton.loginSourceType = LoginSourceTypeVideoPraise;
    }
    self.praiseButton.feedModel = model;
    
}

@end
