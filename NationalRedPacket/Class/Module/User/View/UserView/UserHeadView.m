//
//  UserHeadView.m
//  NationalRedPacket
//
//  Created by 王海玉 on 2018/1/3.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "UserHeadView.h"

@interface UserHeadView()

@property (strong, nonatomic)  UIImageView *bgImageView;
@property (strong, nonatomic)  UIImageView *headImageView;
@property (strong, nonatomic)  UIButton *logInButton;

@end

@implementation UserHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"my_bg"]];
    bgImageView.userInteractionEnabled = YES;
    [self addSubview:bgImageView];
    _bgImageView = bgImageView;
    
    UIImageView *headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weixinNew"]];
    headImageView.layer.cornerRadius = adaptHeight1334(120)/2.0;
    headImageView.layer.masksToBounds = YES;
    headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [headImageView addGestureRecognizer:tap];
    [bgImageView addSubview:headImageView];
    _headImageView = headImageView;
    
    UIButton *logInButton = [[UIButton alloc]init];
    [logInButton setTitle:@"微信登录" forState:UIControlStateNormal];
    logInButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(34)];
    [logInButton addTarget:self action:@selector(tapView) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:logInButton];
    _logInButton = logInButton;
    
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgImageView);
        make.top.equalTo(bgImageView).offset(adaptHeight1334(68));
        make.height.width.mas_equalTo(adaptHeight1334(120));
    }];
    
    [logInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgImageView);
        make.top.equalTo(bgImageView).offset(adaptHeight1334(212));
        make.height.mas_equalTo(adaptHeight1334(48));
    }];
}

- (void)tapView {
    if (self.headBackResult) {
        self.headBackResult(0);
    }
}

//- (void)setUserIsLogin:(BOOL)isLogin {
//    [UIView animateWithDuration:1. animations:^{
//        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(self);
//            make.top.bottom.equalTo(self).offset(adaptHeight1334(40));
//        }];
//        
//        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_bgImageView);
//            make.left.equalTo(_bgImageView).offset(adaptHeight1334(30));
//            make.height.width.mas_equalTo(adaptHeight1334(120));
//        }];
//        
//        [_LogOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_bgImageView);
//            make.left.equalTo(_bgImageView).offset(adaptHeight1334(176));
//            make.height.mas_equalTo(adaptHeight1334(48));
//        }];
//    }completion:^(BOOL finished){
//        
//    }];
//
//}

@end
