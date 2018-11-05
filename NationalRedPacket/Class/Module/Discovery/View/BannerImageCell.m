//
//  BannerImageCell.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "BannerImageCell.h"

@implementation BannerImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.masksToBounds = NO;
    
    self.bannerImageView.layer.cornerRadius = adaptWidth750(20);
    self.bannerImageView.layer.masksToBounds = YES;
    //阴影
    self.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.layer.shadowOffset = CGSizeMake(0,adaptHeight1334(4));
    self.layer.shadowOpacity = 0.25;//阴影透明度，默认0
    self.layer.shadowRadius = adaptHeight1334(4);//阴影半径，默认3
}

@end
