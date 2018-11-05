//
//  PPSRedPoint.m
//  NationalRedPacket
//
//  Created by Ying on 2018/3/21.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "PPSRedPoint.h"

@implementation PPSRedPoint

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init{
    self = [super init];
    self.backgroundColor = [UIColor colorWithString:COLORFF3E3D];
    self.frame = CGRectMake(0, 0, adaptWidth750(9*2), adaptHeight1334(9*2));
    self.layer.cornerRadius = self.width/2;
    return self;
}

-(void)removePoint{
    [self removeFromSuperview];
}




@end
