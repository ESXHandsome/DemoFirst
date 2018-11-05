//
//  NRReloadFailView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/27.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "XLReloadFailView.h"

@interface XLReloadFailView ()

@property (strong, nonatomic) UIButton *reloadButton;
@property (strong, nonatomic) UIImageView *imageView;
@property (copy, nonatomic) void(^reloadAction)(void);

@end

@implementation XLReloadFailView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"network_failed"];
    [self addSubview:imageView];
    self.imageView = imageView;
    
    UILabel *tipLabel = [UILabel new];
    tipLabel.text = @"网络不给力";
    tipLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
    tipLabel.textColor = [UIColor colorWithString:COLOR999999];
    [self addSubview:tipLabel];
    
    self.reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.reloadButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
    self.reloadButton.layer.cornerRadius = adaptWidth750(38);
    self.reloadButton.layer.masksToBounds = YES;
    [self.reloadButton addTarget:self action:@selector(didClickReloadButton) forControlEvents:UIControlEventTouchUpInside];
    [self.reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
    self.reloadButton.layer.shadowOffset =  CGSizeMake(1, 1);
    self.reloadButton.layer.shadowOpacity = 0.5;
    self.reloadButton.layer.shadowColor =  [UIColor colorWithString:COLORFE6969].CGColor;
    [self.reloadButton setTitleColor:[UIColor colorWithString:COLORffffff] forState:UIControlStateNormal];
    [self.reloadButton setBackgroundColor:[UIColor colorWithString:COLORFE6969]];
    
    [self addSubview:self.reloadButton];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).mas_offset(adaptHeight1334(-180));
        make.centerX.equalTo(self.mas_centerX);
    }];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).mas_offset(adaptHeight1334(30*2));
        make.centerX.equalTo(self.mas_centerX);
    }];
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(tipLabel.mas_bottom).mas_offset(adaptHeight1334(17*2));
        make.width.mas_equalTo(adaptWidth750(154*2));
        make.height.mas_equalTo(adaptHeight1334(38*2));
    }];
}

+ (void)showReloadFailInView:(UIView *)view reloadAction:(void(^)(void))reloadAction;
{
    [XLReloadFailView showReloadFailInView:view offSet:0 reloadAction:reloadAction];
}

+ (void)showReloadFailInView:(UIView *)view offSet:(NSInteger)offSet reloadAction:(void(^)(void))reloadAction
{
    XLReloadFailView *reloadView = [XLReloadFailView new];
    reloadView.frame = view.bounds;
    reloadView.y = 0;
    reloadView.backgroundColor = view.backgroundColor;
    reloadView.reloadAction = reloadAction;
    [reloadView setImageViewOffSet:offSet];
    [reloadView showInView:view];
    
}

- (void)setImageViewOffSet:(NSInteger)offSet
{
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).mas_offset(adaptHeight1334(-180) + offSet);
        make.centerX.equalTo(self.mas_centerX);
    }];
}

+ (void)hideReloadFailInView:(UIView *)view
{
    NSEnumerator *reverseSubviews = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in reverseSubviews) {
        if ([subview isKindOfClass:self]) {
            [(XLEmptyDataView *)subview removeFromSuperview];
        }
    }
}

- (void)didClickReloadButton
{
    if (self.reloadAction) {
        [XLReloadFailView hideReloadFailInView:self.superview];
        self.reloadAction();
    }
}

- (void)showInView:(UIView *)view
{
    if (!view) {
        return ;
    }
    if (self.superview != view) {
        
        [self removeFromSuperview];
        
        [view addSubview:self];
        
        [view bringSubviewToFront:self];
    }
}

+ (XLReloadFailView *)reloadFailForView:(UIView *)view
{
    NSEnumerator *reverseSubviews = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in reverseSubviews) {
        if ([subview isKindOfClass:self]) {
            return (XLReloadFailView *)subview;
        }
    }
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
