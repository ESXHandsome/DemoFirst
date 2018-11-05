//
//  NewsButtonContentView.m
//  NationalRedPacket
//
//  Created by Ying on 2018/5/28.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLSessionButtonContentView.h"

@interface XLSessionButtonContentView()
@property (copy, nonatomic) NSArray *imageNameArray;
@property (copy, nonatomic) NSArray *imageTitleArray;
@end

@implementation XLSessionButtonContentView

- (instancetype)init {
    if (self = [super init]){
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    self.backgroundColor = [UIColor colorWithString:COLORffffff];
    self.height = adaptHeight1334(80*2);
    self.width = SCREEN_WIDTH;
    self.y = NAVIGATION_BAR_HEIGHT;
    
    for (int i = 0; i<4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(SCREEN_WIDTH/4*i, 0, SCREEN_WIDTH/4, adaptHeight1334(80*2));
        [self addSubview:button];
        
        UIImage *image = [UIImage imageNamed:self.imageNameArray[i]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.center = CGPointMake(button.width/2, adaptHeight1334(60));
        [button addSubview:imageView];
        
        UILabel *label = [UILabel labWithText:self.imageTitleArray[i] fontSize:adaptFontSize(14*2) textColorString:COLOR838383];
        [button addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button);
            make.top.equalTo(button).mas_offset(adaptFontSize(50*2));
        }];
        
        button.tag = 99980 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)buttonAction:(UIButton *)sender {
    if (!self.delegate && ![self.delegate respondsToSelector:@selector(newsButtonContentViewButtonClicked:)])
        return;
    [self.delegate newsButtonContentViewButtonClicked:sender.tag-99980];
}

- (NSArray *)imageNameArray {
    return @[@"news_fans",@"news_laud",@"news_comment",@"news_visitor"];
}

- (NSArray *)imageTitleArray {
    return @[@"粉丝",@"收到赞",@"评论",@"访客"];
}

@end
