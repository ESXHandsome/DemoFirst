//
//  FeedsHeaderView.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2017/12/29.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "FeedsHeaderView.h"

@interface FeedsHeaderView ()
@property (assign ,nonatomic) BOOL isLoading;
@end

@implementation FeedsHeaderView

// 重写父类MJRefreshGifHeader布局
- (void)placeSubviews {
    [super placeSubviews];
    self.backgroundColor = [UIColor colorWithString:@"#F2F2F2"];
    self.lastUpdatedTimeLabel.hidden = YES;
    // stateLabel,gifView重新布局
    self.gifView.mj_origin = CGPointMake(adaptWidth750(115*2), adaptHeight1334(20));
    self.gifView.mj_size = CGSizeMake(adaptWidth750(65*2), adaptHeight1334(40*2));
    self.stateLabel.mj_y = adaptHeight1334(15);
    self.stateLabel.mj_x = adaptWidth750(75);
//    self.stateLabel.mj_h = 16;
    self.stateLabel.font = [UIFont systemFontOfSize:adaptFontSize(15*2)];
    self.stateLabel.textColor = [UIColor colorWithString:COLOR5D5D5D];
    
    [self.gifView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.mas_equalTo(adaptWidth750(115*2));
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gifView.mas_right).mas_offset(adaptWidth750(10*2));
        make.bottom.equalTo(self.mas_bottom).mas_offset(-adaptWidth750(20));
    }];
}

- (void)prepare {
    [super prepare];
    self.stateLabel.textAlignment = NSTextAlignmentCenter;
    self.gifView.contentMode = UIViewContentModeCenter;
}

- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state {
    [super setImages:images duration:duration forState:state]; //调用一下父类方法
}

- (void)setImages:(NSArray *)images forState:(MJRefreshState)state                              {
    [self setImages:images duration:images.count * 0.2 forState:state];
}

- (void)setTitle:(NSString *)title forState:(MJRefreshState)state{
    [super setTitle:title forState:state];
}

- (void)endRefreshing{
    [super endRefreshing];
    self.isLoading = NO;
}

- (void)changeLoadingString {
    self.isLoading = YES;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self changeLoadingStringCycle];
    });
}

- (void)changeLoadingStringCycle{
    NSString *loadingString = @"加载中";
    while (self.isLoading) {
        [NSThread sleepForTimeInterval:0.5];
        if (loadingString.length>5) {
            loadingString = @"加载中";
        }
        loadingString = [loadingString stringByAppendingString:@"."];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setTitle:loadingString forState:MJRefreshStateRefreshing];
        });
    }
}

@end
