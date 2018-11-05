
//
//  FollowButton.m
//  FollowButton
//
//  Created by 刘永杰 on 2018/1/25.
//  Copyright © 2018年 刘永杰. All rights reserved.
//

#import "FollowButton.h"
#import "CancleHighlightedButton.h"

#define kChangeWidth adaptWidth750(12)

@interface FollowButton ()



/* 遮罩 */
@property (strong, nonatomic) UIView                  *maskView;
/* 菊花 */
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
/* 动效图 */
@property (strong, nonatomic) UIImageView             *animationImageView;
@property (strong, nonatomic) NSMutableArray          *imageArray;

@end

@implementation FollowButton

+ (instancetype)buttonWithType:(FollowButtonType)buttonType;
{
    FollowButton *followButton = [FollowButton new];
    followButton.buttonType = buttonType;
    [followButton setupViews];
    return followButton;
}

- (void)setupViews
{
    //设置button属性
    [self setFollowButtonProperty];
    
    [self addSubview:self.button];
    [self.button addSubview:self.maskView];
    [self addSubview:self.animationImageView];
    [self.maskView addSubview:self.activityView];
    
}

/**根据类型改变按钮状态和提案*/
- (void)changeButtonState:(NSInteger)type {
    if (type == 1) {
        /**双方未互相关注*/
        /**按钮显示为未选中状态,点击有显示已关注*/
        self.followed = NO;
        self.button.backgroundColor = [UIColor colorWithString:COLORFE6969];
        [self.button setTitle:@"已关注" forState:UIControlStateSelected];
        
    } else if (type == 2) {
        /**对方关注自己,自己没关注对方*/
        /**按钮显示为未选中状态,点击显示互相关注*/
        self.followed = NO;
        self.button.backgroundColor = [UIColor colorWithString:COLORFE6969];
        [self.button setTitle:@"互相关注" forState:UIControlStateSelected];
        
    } else if (type == 3) {
        /**对方没关注自己,但是自己关注了对方*/
        /**按钮显示已关注,点击显示未选中状态显示关注*/
        self.followed = YES; 
        [self.button setTitle:@"已关注" forState:UIControlStateSelected];
        
    } else {
        /**双方互相关注*/
        /**按钮显示互相关注,点击按钮显示未选中状态*/
        self.followed = YES;
        [self.button setTitle:@"互相关注" forState:UIControlStateSelected];
    }
}

- (void)layoutSubviews
{
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.button);
    }];
    
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.maskView);
    }];
    
    [self.animationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.button);
    }];
}

- (void)setButtonType:(FollowButtonType)buttonType {
    _buttonType = buttonType;
    [self setFollowButtonProperty];
}

- (void)setFollowButtonProperty
{
    if (self.buttonType == FollowButtonTypeHome) {
        //按钮
        self.button.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:adaptFontSize(30)];
        [self.button setTitleColor:[UIColor colorWithString:COLORFE6969] forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor colorWithString:COLORCFCFCF] forState:UIControlStateSelected];
        self.button.backgroundColor = [UIColor colorWithString:COLORffffff];
        
        //遮罩
        self.maskView.backgroundColor = [UIColor colorWithString:COLORffffff];
        //圈圈
        CGAffineTransform transform = CGAffineTransformMakeScale(adaptHeight1334(24)/20.0, adaptHeight1334(24)/20.0);
        self.activityView.transform = transform;
        self.button.layer.cornerRadius = adaptHeight1334(28);
        self.activityView.color = [UIColor grayColor]; // 改变圈圈的颜色为灰色
        
    } else if (self.buttonType == FollowButtonTypePersonal) {
        
        //按钮
        self.button.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:adaptFontSize(30)];
        [self.button setTitleColor:[UIColor colorWithString:COLORffffff] forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor colorWithString:COLORD9D9D9] forState:UIControlStateSelected];
        self.button.backgroundColor = [UIColor colorWithString:COLORFE6969];
        //遮罩
        self.maskView.backgroundColor = [UIColor colorWithString:COLORFE6969];
        self.button.layer.cornerRadius = 0;
        //圈圈
        CGAffineTransform transform = CGAffineTransformMakeScale(adaptHeight1334(30)/20.0, adaptHeight1334(30)/20.0);
        self.activityView.transform = transform;
        self.activityView.color = [UIColor whiteColor]; // 改变圈圈的颜色为白色
        self.followedActivityColor = [UIColor grayColor];
        
    } else if (self.buttonType == FollowButtonTypeVideoDetail) {
        
        //按钮
        self.button.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:adaptFontSize(24)];
        [self.button setTitleColor:[UIColor colorWithString:COLORffffff] forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor colorWithString:COLORCFCFCF] forState:UIControlStateSelected];
        self.button.backgroundColor = [UIColor colorWithString:COLORFE6969];
        self.button.layer.cornerRadius = adaptWidth750(23);
        self.button.layer.masksToBounds = YES;
        //遮罩
        self.maskView.backgroundColor = [UIColor colorWithString:COLORFE6969];
        //圈圈
        CGAffineTransform transform = CGAffineTransformMakeScale(adaptHeight1334(24)/20.0, adaptHeight1334(24)/20.0);
        self.activityView.transform = transform;
        self.activityView.color = [UIColor whiteColor]; // 改变圈圈的颜色为白色
    }    
}

/**
 开始images动效
 */
- (void)startImagesAnimation
{
    self.animationImageView.hidden = NO;
    [self.animationImageView startAnimating];
    self.button.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{  //时长小于动画时长0.2时就显示按钮，避免突然出现
        self.button.hidden = NO;
        self.animationImageView.hidden = YES;
    });
}

#pragma mark - Private Methods
- (void)followAction
{
    [self startAnimation];

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(followButtonClick:)]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.delegate followButtonClick:self];
        });
    }
    
}

- (void)setFollowed:(BOOL)followed
{
    if (self.followed == followed) { //如果状态未变化，拦截掉
        return;
    }
    _followed = followed;
    self.button.selected = followed;
    [self stopAnimation];
    if (self.buttonType == FollowButtonTypeHome) {
        [self.superview layoutIfNeeded];
        if (self.button.selected) {
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(adaptWidth750(58*2) + kChangeWidth);
            }];
        } else {
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(adaptWidth750(58*2));
            }];
        }
    }
    
}

- (void)startAnimation
{
    [self.activityView startAnimating]; // 开始旋转
    if (self.buttonType == FollowButtonTypePersonal) {
        if (self.button.selected) {
            self.button.titleLabel.hidden = YES;
            self.maskView.backgroundColor = [UIColor clearColor];
            self.activityView.color = self.followedActivityColor; // 改变圈圈的颜色为灰色
        } else {
            self.maskView.backgroundColor = [UIColor colorWithString:COLORFE6969];
            self.activityView.color = [UIColor whiteColor]; // 改变圈圈的颜色为白色
        }
    } else if (self.buttonType == FollowButtonTypeHome){
        if (self.button.selected) {
            self.button.titleLabel.hidden = YES;
            self.maskView.backgroundColor = [UIColor whiteColor];
        } else {
            self.maskView.backgroundColor = [UIColor colorWithString:COLORffffff];
        }
    }
    self.maskView.hidden = NO;
}

- (void)stopAnimation
{
    [self.activityView stopAnimating];
    self.button.titleLabel.hidden = NO;
    self.maskView.hidden = YES;
    if (self.button.selected) {
        self.button.backgroundColor = [UIColor clearColor];
    } else {
        if (self.buttonType == FollowButtonTypePersonal) {
            self.button.backgroundColor = [UIColor colorWithString:COLORFE6969];
        } else if (self.buttonType == FollowButtonTypeHome){
            self.button.backgroundColor = [UIColor colorWithString:COLORffffff];
        } else {
            self.button.backgroundColor = [UIColor colorWithString:COLORFE6969];
        }
    }
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    self.button.titleLabel.font = titleFont;
}

- (void)setActivityHeight:(CGFloat)activityHeight
{
    _activityHeight = activityHeight;
    CGAffineTransform transform = CGAffineTransformMakeScale(activityHeight/20.0, activityHeight/20.0);
    self.activityView.transform = transform;
}

- (void)setFollowedTitleColor:(UIColor *)followedTitleColor {
    
    _followedTitleColor = followedTitleColor;
    [self.button setTitleColor:_followedTitleColor forState:UIControlStateSelected];
}

- (void)setFollowedActivityColor:(UIColor *)followedActivityColor {
    _followedActivityColor = followedActivityColor;
}

#pragma mark - Lazy loading
- (CancleHighlightedButton *)button
{
    if (!_button) {
        self.button = [CancleHighlightedButton buttonWithType:UIButtonTypeCustom];
        [self.button addTarget:self action:@selector(followAction) forControlEvents:UIControlEventTouchUpInside];
        [self.button setTitle:@"关注" forState:UIControlStateNormal];
        [self.button setTitle:@"已关注" forState:UIControlStateSelected];
        self.button.layer.cornerRadius = 2;
        self.button.layer.masksToBounds = YES;
        
    }
    return _button;
}

- (UIView *)maskView
{
    if (!_maskView) {
        self.maskView = [[UIView alloc] init];
        self.maskView.hidden = YES;
    }
    return _maskView;
}

- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityView.backgroundColor = [UIColor clearColor];
        [self.activityView stopAnimating]; // 结束旋转
        [self.activityView setHidesWhenStopped:YES]; //当旋转结束时隐藏
    }
    return _activityView;
}

- (UIImageView *)animationImageView
{
    if (!_animationImageView) {
        self.animationImageView = [UIImageView new];
        self.animationImageView.animationDuration = 1.2;
        self.animationImageView.animationImages = self.imageArray;
        self.animationImageView.animationRepeatCount = 1;
        self.animationImageView.hidden = YES;
    }
    return _animationImageView;
}

- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        self.imageArray = [NSMutableArray array];
        for (int i = 1; i < 8; ++i) {
            
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"gz%d",i]];
            [self.imageArray addObject:image];
        }
    }
    return _imageArray;
}

@end
