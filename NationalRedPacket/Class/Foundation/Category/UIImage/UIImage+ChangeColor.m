//
//  UIImage+ChangeColor.m
//  ImageChangeDemo
//
//  Created by damon on 2017/2/14.
//  Copyright © 2017年 damon. All rights reserved.
//

#import "UIImage+ChangeColor.h"

@implementation UIImage (ChangeColor)

//绘图
- (UIImage*)imageChangeColor:(CGFloat)alphaFloat {
    //获取画布
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [[UIColor whiteColor] setFill];
    
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    //绘制一次
    [self drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:alphaFloat];
    //再绘制一次
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:alphaFloat];
    //获取图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
