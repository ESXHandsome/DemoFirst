//
//  BaseView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2017/6/27.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    
}

@end
