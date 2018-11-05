//
//  CommentContainerView.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/1/11.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "CommentContainerView.h"
#import "NSString+NumberAdapt.h"
#import "UIImage+Tool.h"
#import <Lottie/Lottie.h>
#import "XLUserManager.h"
#import "LikeAnimationButton.h"

@interface CommentContainerView ()<LikeAnimationButtonDelegate>

@property (strong, nonatomic) LikeAnimationButton *praiseButton;
@property (strong, nonatomic) LikeAnimationButton *treadPraiseButton;
@property (strong, nonatomic) UIButton *commentButton;
@property (strong, nonatomic) UIButton *forwardButton;

@end

@implementation CommentContainerView

#pragma mark -
#pragma mark UI Initialize

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.praiseButton];
    [self addSubview:self.treadPraiseButton];
    [self addSubview:self.commentButton];
    [self addSubview:self.forwardButton];
    
    [self addContraint];
}

- (void)addContraint {
    [self.praiseButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0, 0.0, 4)];
    [self.treadPraiseButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0, 0.0, 4)];
    [self.commentButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0, 0.0, 4)];
    [self.forwardButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0, 0.0, 4)];

    [self.praiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(adaptWidth750(32));
        make.centerY.equalTo(self);
        make.height.equalTo(self);
        make.width.mas_equalTo(60);
    }];
    [self.treadPraiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.praiseButton.mas_right);
        make.centerY.equalTo(self);
        make.height.equalTo(self);
        make.width.mas_equalTo(60);
    }];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.treadPraiseButton.mas_right);
        make.centerY.equalTo(self);
        make.height.equalTo(self);
        make.width.mas_equalTo(60);
    }];
    [self.forwardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(adaptWidth750(-32));
        make.centerY.equalTo(self);
        make.height.equalTo(self);
        make.width.mas_equalTo(60);
    }];
}

#pragma mark -
#pragma mark Response Event

// 点赞点击事件
- (void)didClickPraiseButtonAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickPraiseButtonEvent:)]) {
        [self.delegate didClickPraiseButtonEvent:self.model];
        if (!XLLoginManager.shared.isAccountLogined ||
            [NetworkManager.shared.netWorkTypeString isEqualToString:XLAlertNetworkNotReachable]) {
            return;
        }
    }
}

// 踩点击事件
- (void)didClickTreadButtonAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickTreadButtonEvent:)]) {
        [self.delegate didClickTreadButtonEvent:self.model];
        if (!XLLoginManager.shared.isAccountLogined ||
            [NetworkManager.shared.netWorkTypeString isEqualToString:XLAlertNetworkNotReachable]) {
            return;
        }
    }
}

// 评论点击事件
- (void)didClickCommentButtonAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCommentButtonEvent:)]) {
        [self.delegate didClickCommentButtonEvent:self.model];
    }
}

// 转发点击事件
- (void)didClickForwardButtonAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickForwardButtonEvent:)]) {
        [self.delegate didClickForwardButtonEvent:self.model];
    }
}

#pragma mark - AnimationButton Delegate

- (void)didClickAnimationButton:(LikeAnimationButton *)animationButton type:(LikeAnimationButtonType)animationType {
    
    if (animationType == LikeAnimationButtonTypeTread) {
        [self didClickTreadButtonAction:animationButton];
    } else {
        [self didClickPraiseButtonAction:animationButton];
    }
}

#pragma mark -
#pragma mark Setters and Getters

- (void)setModel:(XLFeedModel *)model {
    _model = model;
    
    self.praiseButton.selected = model.isPraise;
    self.treadPraiseButton.selected = model.isTread;
    
    [self.praiseButton setTitle:[NSString numberAdaptWithInteger: model.praiseNum]
                       forState:UIControlStateNormal];
    [self.treadPraiseButton setTitle:[NSString numberAdaptWithInteger: model.treadNum]
                            forState:UIControlStateNormal];
    [self.commentButton setTitle:[NSString numberAdaptWithInteger: model.commentNum]
                        forState:UIControlStateNormal];
    
    if (model.type.integerValue == XLFeedCellVideoVerticalWithAuthorType || model.type.integerValue == XLFeedCellVideoHorizonalWithAuthorType) {
        self.praiseButton.loginSourceType = LoginSourceTypeVideoPraise;
        self.treadPraiseButton.loginSourceType = LoginSourceTypeVideoTread;
    } else {
        self.praiseButton.loginSourceType = LoginSourceTypeImagePraise;
        self.treadPraiseButton.loginSourceType = LoginSourceTypeImageTread;
    }
    
    self.praiseButton.feedModel = model;
    self.treadPraiseButton.feedModel = model;
    
    if (!XLUserManager.shared.isOnceShared) {
        [self.forwardButton setTitle:@"转发"
                            forState:UIControlStateNormal];
    } else {
        [self.forwardButton setTitle:[NSString numberAdaptWithInteger: model.forwardNum]
                            forState:UIControlStateNormal];
    }
}

- (LikeAnimationButton *)praiseButton {
    if (!_praiseButton) {
        _praiseButton = [LikeAnimationButton animationButtonWithType:LikeAnimationButtonTypeTop];
        _praiseButton.delegate = self;
        _praiseButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(26)];
        [_praiseButton setTitleColor:[UIColor colorWithString:COLORBBBBBB] forState:UIControlStateNormal];
        [_praiseButton setTitleColor:[UIColor colorWithString:COLORFF6767] forState:UIControlStateSelected];
        _praiseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
        [_praiseButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
    }
    return _praiseButton;
}

- (LikeAnimationButton *)treadPraiseButton {
    if (!_treadPraiseButton) {
        _treadPraiseButton = [LikeAnimationButton animationButtonWithType:LikeAnimationButtonTypeTread];
        _treadPraiseButton.delegate = self;
        _treadPraiseButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(26)];
        [_treadPraiseButton setTitleColor:[UIColor colorWithString:COLORBBBBBB] forState:UIControlStateNormal];
        [_treadPraiseButton setTitleColor:[UIColor colorWithString:COLORFF6767] forState:UIControlStateSelected];
        _treadPraiseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
        [_treadPraiseButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    return _treadPraiseButton;
}

- (UIButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(26)];
        [_commentButton setImage:[UIImage imageNamed:@"main_comment_icon"] forState:UIControlStateNormal];
        [_commentButton setTitleColor:[UIColor colorWithString:COLORBBBBBB] forState:UIControlStateNormal];
        _commentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
        [_commentButton addTarget:self action:@selector(didClickCommentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_commentButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    return _commentButton;
}

- (UIButton *)forwardButton {
    if (!_forwardButton) {
        _forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _forwardButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(26)];
        [_forwardButton setImage:[UIImage imageNamed:@"main_forward_icon"] forState:UIControlStateNormal];
        [_forwardButton setTitleColor:[UIColor colorWithString:COLORBBBBBB] forState:UIControlStateNormal];
        _forwardButton.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
        [_forwardButton addTarget:self action:@selector(didClickForwardButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_forwardButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    }
    return _forwardButton;
}

@end
