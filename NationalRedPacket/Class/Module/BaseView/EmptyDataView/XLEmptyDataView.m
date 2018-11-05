//
//  NREmptyDataView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/27.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "XLEmptyDataView.h"

@interface XLEmptyDataView ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel     *titleLabel;
@property (copy, nonatomic)   void(^tapAction)(void);

@end

@implementation XLEmptyDataView

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
    self.imageView = [UIImageView new];
    self.imageView.image = [UIImage imageNamed:@"nothing"];
    [self addSubview:self.imageView];
    
    self.titleLabel = [UILabel labWithText:@"暂无内容" fontSize:adaptFontSize(32) textColorString:COLOR999999];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(adaptHeight1334(173*2)+NAVIGATION_BAR_HEIGHT/2);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.imageView.mas_bottom).offset(adaptHeight1334(80));
    }];
}

+ (void)showEmptyDataInView:(UIView *)view
{
    [XLEmptyDataView showEmptyDataInView:view withTitle:nil imageStr:nil];

}

+ (void)showEmptyDataInView:(UIView *)view withTitle:(NSString *)title
{
    [XLEmptyDataView showEmptyDataInView:view withTitle:title imageStr:nil];
}

+ (void)showEmptyDataInView:(UIView *)view withTitle:(NSString *)title imageStr:(NSString *)imageStr
{
    [XLEmptyDataView showEmptyDataInView:view withTitle:title imageStr:imageStr offSet:0];
}

+ (void)showEmptyDataInView:(UIView *)view withTitle:(NSString *)title imageStr:(NSString *)imageStr offSet:(NSInteger)offSet
{
    [XLEmptyDataView showEmptyDataInView:view withTitle:title imageStr:imageStr offSet:offSet titleOffSet:0 tapAction:nil];
}

+ (void)showEmptyDataInView:(UIView *)view withTitle:(NSString *)title imageStr:(NSString *)imageStr offSet:(NSInteger)offSet titleOffSet:(NSInteger)titleOffSet tapAction:(void(^)(void))tapAction
{
    
    XLEmptyDataView *emptyView = [XLEmptyDataView new];
    emptyView.tapAction = tapAction;
    emptyView.frame = view.bounds;
    emptyView.backgroundColor = view.backgroundColor;
    emptyView.y = 0;
    if (title) {
        emptyView.titleLabel.text = title;
    }
    if (imageStr) {
        emptyView.imageView.image = [UIImage imageNamed:imageStr];
    }
    
    [emptyView setImageOffSet:offSet];
    [emptyView setTitleOffSet:titleOffSet];
    
    [emptyView showInView:view];
}

- (void)setImageOffSet:(NSInteger)offSet
{
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(adaptHeight1334(173*2)+NAVIGATION_BAR_HEIGHT/2 + offSet);
    }];
}

- (void)setTitleOffSet:(NSInteger)offSet {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.imageView.mas_bottom).offset(adaptHeight1334(80) + offSet);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.tapAction) {
        self.tapAction();
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

+ (void)hideEmptyDataInView:(UIView *)view
{
    NSEnumerator *reverseSubviews = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in reverseSubviews) {
        if ([subview isKindOfClass:self]) {
            [(XLEmptyDataView *)subview removeFromSuperview];
        }
    }
}

+ (XLEmptyDataView *)emptyDataForView:(UIView *)view {
    NSEnumerator *reverseSubviews = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in reverseSubviews) {
        if ([subview isKindOfClass:self]) {
            return (XLEmptyDataView *)subview;
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
