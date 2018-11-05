//
//  NoCommentView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/1/14.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "FeedEmptyCommentView.h"

@implementation FeedEmptyCommentView

- (void)setupViews
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, kFooterHeight);
    self.backgroundColor = [UIColor whiteColor];
    
    UIButton *imageView = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:imageView];
    [imageView addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [imageView setImage:[UIImage imageNamed:@"newspage_sofa"] forState:UIControlStateNormal];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"暂无评论，点击抢沙发" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor colorWithString:COLOR9A9A9A] forState:UIControlStateNormal];
    [self addSubview:button];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(adaptHeight1334(55*2));
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.top.equalTo(imageView.mas_bottom).offset(adaptHeight1334(28*2));
        
    }];
    
}

- (void)buttonAction
{
    if (self.backResult) {
        self.backResult(0);
    }
}

@end
