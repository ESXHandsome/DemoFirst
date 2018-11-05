//
//  HeartAnimationView.h
//  NationalRedPacket
//
//  Created by 王海玉 on 2018/1/10.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeartAnimationView :UIImageView

- (void)showWithPoint:(CGPoint)point;
- (void)showWithPoint:(CGPoint)point isRule:(BOOL)rule;

@end
