//
//  UIImage+Create.m
//  NationalRedPacket
//
//  Created by sunmingyue on 17/7/18.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "UIImage+Tool.h"

@implementation UIImage (Tool)

// 根据颜色创建图片
+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 缩放
/**
 缩放图片到指定Size
 */
- (UIImage *)scaleImageWithSize:(CGSize)size {
    
    // 创建上下文
    UIGraphicsBeginImageContextWithOptions(size, YES, self.scale);
    
    // 绘图
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 获取新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 按比例缩放图片
 */
- (UIImage *)scaleImageWithScale:(CGFloat)scale {
    
    if (scale < 0) {
        return self;
    }
    CGSize scaleSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
    return [self scaleImageWithSize:scaleSize];
}


/**
 缩放图片到指定宽
 */
- (UIImage *)scaleImageToTargetWidth:(CGFloat)targetW {
    
    CGSize size = self.size;
    if (size.width <= targetW) {
        return self;
    }
    
    CGFloat scale = targetW / size.width;
    return [self scaleImageWithScale:scale];
}

/**
 缩放图片到指定高
 */
- (UIImage *)scaleImageToTargetHeight:(CGFloat)targetH {
    
    CGSize size = self.size;
    if (size.height <= targetH) {
        return self;
    }
    
    CGFloat scale = targetH / size.height;
    return [self scaleImageWithScale:scale];
}

#pragma mark - 裁剪
- (UIImage *)clipImageWithPath:(UIBezierPath *)path bgColor:(UIColor *)bgColor {
    
    CGSize imageSize = self.size;
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    // 创建位图上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, self.scale);
    if (bgColor) {
        UIBezierPath *bgRect = [UIBezierPath bezierPathWithRect:rect];
        [bgColor setFill];
        [bgRect fill];
    }
    // 裁剪
    [path addClip];
    // 绘制
    [self drawInRect:rect];
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return clipImage;
}

/**
 裁剪圆角图片
 */
- (UIImage *)clipImageWithCornerRadius:(CGFloat)cornerRadius bgColor:(UIColor *)bgColor {

    CGSize imageSize = self.size;
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    UIBezierPath *roundRectPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    return [self clipImageWithPath:roundRectPath bgColor:bgColor];
}

/**
 从指定的rect裁剪出图片
 */
- (UIImage *)clipImageWithRect:(CGRect)rect {
    
    CGFloat scale = self.scale;
    CGImageRef clipImageRef = CGImageCreateWithImageInRect(self.CGImage,
                                                           CGRectMake(rect.origin.x * scale,
                                                                      rect.origin.y  * scale,
                                                                      rect.size.width * scale,
                                                                      rect.size.height * scale));
    
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(clipImageRef)/scale, CGImageGetHeight(clipImageRef)/scale);
    
    UIGraphicsBeginImageContextWithOptions(smallBounds.size, YES, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, smallBounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(0, 0, smallBounds.size.width, smallBounds.size.height), clipImageRef);
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    CGImageRelease(clipImageRef);
    return clipImage;
}

#pragma mark - 图片压缩

/**
 压缩到指定千字节(kb)
 */

// 压缩图片
+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}

+ (UIImage *)clipImage:(UIImage *)image toRect:(CGSize)size offset:(CGFloat)offset {
    
    // 被切图片宽比例比高比例小 或者相等，以图片宽进行放大
    if (image.size.width*size.height <= image.size.height*size.width) {
        
        // 以被剪裁图片的宽度为基准，得到剪切范围的大小
        CGFloat width  = image.size.width;
        CGFloat height = image.size.width * size.height / size.width;
        
        // 调用剪切方法
        // 这里是以中心位置剪切，也可以通过改变rect的x、y值调整剪切位置
        return [self imageFromImage:image inRect:CGRectMake(0, (image.size.height -height)/2 - offset, width, height)];
        
    } else { // 被切图片宽比例比高比例大，以图片高进行剪裁
        
        // 以被剪切图片的高度为基准，得到剪切范围的大小
        CGFloat width  = image.size.height * size.width / size.height;
        CGFloat height = image.size.height;
        
        // 调用剪切方法
        // 这里是以中心位置剪切，也可以通过改变rect的x、y值调整剪切位置
        return [self imageFromImage:image inRect:CGRectMake((image.size.width -width)/2, - offset, width, height)];
    }
    return nil;
}

//+ (UIImage *)clipImage:(UIImage *)image toSize:(CGSize)size {
//    if (image.size.height/image.size.width > 1.42) {
//        return [self imageFromImage:image inRect:CGRectMake(0, 0, image.size.width, image.size.height*(size.width/size.height))];
//    } else {
//        CGFloat width  = image.size.height * size.width / size.height;
//        CGFloat height = image.size.height;
//        return [self imageFromImage:image inRect:CGRectMake((image.size.width -width)/2, 0, width, height)];
//    }
//    return nil;
//}

+ (UIImage *)clipImage:(UIImage *)image toWidth:(CGFloat)width toHeight:(CGFloat)height
{
    CGFloat scale = image.size.width / image.size.height;
    CGFloat resultX = 0.0;
    CGFloat resultY = 0.0;
    CGFloat resultWidth = 0.0;
    CGFloat resultHeight = 0.0;
    if (scale < 1) {
        if (scale < 0.75) {
            if (scale < 0.33) {
                resultX = 0;
                resultY = 0;
                resultWidth = image.size.width;
                resultHeight = image.size.width * height / width;
            } else {
                resultX = 0;
                resultY = 0;
                resultWidth = image.size.width;
                resultHeight = image.size.width * height / width;
            }
        } else if (scale == 0.75) {
            resultX = 0;
            resultY = 0;
            resultWidth = image.size.width;
            resultHeight = image.size.height;
        } else {
            resultY = 0;
            resultWidth = image.size.height * width / height;
            resultHeight = image.size.height;
            resultX = (image.size.width - resultWidth) / 2;
        }
    } else if (scale == 1) {
        resultX = 0;
        resultY = 0;
        resultWidth = image.size.width;
        resultHeight = image.size.height;
    } else {
        if (scale < 1.33) {
            resultX = 0;
            resultWidth = image.size.width;
            resultHeight = image.size.width * height / width;
            resultY = (image.size.height - resultHeight) / 2;
        } else if (scale == 1.33) {
            resultX = 0;
            resultY = 0;
            resultWidth = image.size.width;
            resultHeight = image.size.height;
        } else {
            if (scale < 3.125) {
                resultY = 0;
                resultWidth = image.size.height * width / height;
                resultHeight = image.size.height;
                resultX = (image.size.width - resultWidth) / 2;
            } else {
                resultY = 0;
                resultWidth = image.size.height * width / height;
                resultHeight = image.size.height;
                resultX = (image.size.width - resultWidth) / 2;
            }
        }
    }
    return [self imageFromImage:image inRect:CGRectMake(resultX, resultY, resultWidth, resultHeight)];
}

+ (UIImage *)clipMultiImage:(UIImage *)image toWidth:(CGFloat)width toHeight:(CGFloat)height
{
    CGFloat scale = image.size.width / image.size.height;
    CGFloat resultX = 0.0;
    CGFloat resultY = 0.0;
    CGFloat resultWidth = 0.0;
    CGFloat resultHeight = 0.0;

    if (scale < 0.56) {
        resultX = 0;
        resultY = 0;
        resultWidth = image.size.width;
        resultHeight = image.size.width * height / width;
    } else if (scale > 3.125) {
        resultY = 0;
        resultWidth = image.size.height * width / height;
        resultHeight = image.size.height;
        resultX = (image.size.width - resultWidth) / 2;
    } else {
        resultX = 0;
        resultY = 0;
        resultWidth = image.size.width;
        resultHeight = image.size.height;
    }
    return [self imageFromImage:image inRect:CGRectMake(resultX, resultY, resultWidth, resultHeight)];
    
}

+ (BOOL)isPiiicWithImage:(UIImage *)image
{
    CGFloat scale = image.size.height / image.size.width;
    BOOL result = NO;
    if (scale > 18/9.0) {
        result = YES;
    }
    return result;
}

+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    
    // 将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [image CGImage];
    
    // 按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
        
    // 将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    
    // 返回剪裁后的图片
    return newImage;
}

@end
