//
//  UIImage+Create.h
//  NationalRedPacket
//
//  Created by sunmingyue on 17/7/18.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tool)

#pragma mark - 绘制
/**
 根据颜色绘制图片
 */
+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size;

#pragma mark - 缩放
/**
 缩放图片到指定Size
 */
- (UIImage *)scaleImageWithSize:(CGSize)size;

/**
 缩放图片到指定宽
 */
- (UIImage *)scaleImageToTargetWidth:(CGFloat)targetW;

/**
 缩放图片到指定高
 */
- (UIImage *)scaleImageToTargetHeight:(CGFloat)targetH;

#pragma mark - 裁剪

/**
 从指定的rect裁剪出图片
 */
- (UIImage *)clipImageWithRect:(CGRect)rect;

#pragma mark - 图片压缩

/**
 压缩到指定千字节(kb)
 */
+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

+ (UIImage *)clipImage:(UIImage *)image toRect:(CGSize)size offset:(CGFloat)offset;

/**
 首页图片裁剪与显示长图规则
 */
+ (UIImage *)clipImage:(UIImage *)image toWidth:(CGFloat)width toHeight:(CGFloat)height;

/**
 首页多图裁剪规则
 */
+ (UIImage *)clipMultiImage:(UIImage *)image toWidth:(CGFloat)width toHeight:(CGFloat)height;

+ (BOOL)isPiiicWithImage:(UIImage *)image;

@end
