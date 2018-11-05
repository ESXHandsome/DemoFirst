//
//  ShowDataView.m
//  WatermelonNews
//
//  Created by sunmingyue on 17/11/14.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "ShowDataView.h"

@interface ShowDataView ()

@property (strong, nonatomic) UILabel *placeLabel;
@property (strong, nonatomic) UIView *leftAnimationView;
@property (strong, nonatomic) UIView *rightAnimationView;

@end

@implementation ShowDataView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    UIColor *color = [UIColor colorWithString:COLORFE6969];
    UIView *bgView = [UIView new];
    bgView.frame = self.frame;
    [self addSubview:bgView];
    UIView *placeView = [UIView new];
    [self addSubview:placeView];
    
    _placeLabel = [UILabel labWithText:@"" fontSize:adaptFontSize(30) textColorString:COLOR333333];
    _placeLabel.textAlignment = NSTextAlignmentCenter;
    [placeView addSubview:_placeLabel];

    [placeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.right.equalTo(self).mas_offset(-80);
        make.left.equalTo(self).mas_offset(80);
    }];
    _placeLabel.layer.backgroundColor = [color CGColor];
    _placeLabel.layer.cornerRadius = adaptHeight1334(32);

}

- (void)setDataNumber:(NSInteger)number {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.leftAnimationView.frame = CGRectMake(0, 0, 80, 42);
        self.rightAnimationView.frame = CGRectMake(SCREEN_WIDTH - 80, 0, 80, 42);
    } completion:^(BOOL finished) {
        
    }];
    
    if (number == 0) {
        self.placeLabel.text = [NSString stringWithFormat:@"暂时没有更新"];
    } else if (number > 0) {
        self.placeLabel.text = [NSString stringWithFormat:@"为您推荐%ld条新内容", (long)number];
    } else if (number == -1001) {
        self.placeLabel.text = [NSString stringWithFormat:@"请求超时"];
    } else if (number == -1009 || number == -1005) {
        self.placeLabel.text = [NSString stringWithFormat:@"网络不可用"];
    } else if (number == -1011) {
        self.placeLabel.text = [NSString stringWithFormat:@"服务器维护中，请稍后再试"];
    }
    
    CGSize size = [self.placeLabel.text sizeWithAttributes:@{NSFontAttributeName:self.placeLabel.font}];
    self.placeLabel.height = self.height;
    self.placeLabel.width = size.width + adaptWidth750(60);
    self.placeLabel.centerX = ([UIScreen mainScreen].bounds.size.width - 160)/2;
    self.placeLabel.centerY = self.placeLabel.height/2;
    self.placeLabel.layer.shadowColor = [[UIColor colorWithString:COLORFE6969] CGColor];
    self.placeLabel.layer.shadowOffset = CGSizeMake(0, adaptHeight1334(6));
    self.placeLabel.layer.shadowOpacity = 0.62;
    [self.placeLabel setTextColor:GetColor(COLORffffff)];
}

@end
