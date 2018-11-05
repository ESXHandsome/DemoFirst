//
//  XLResourceFileLocalPath.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/4/11.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLResourceFileLocalPath : NSObject

/**
 临时文件路径
 */
+ (NSString *)tempFilePath;

/**
 缓存文件地址
 */
+ (NSString *)resourceCachePathForURL:(NSURL *)resourceURL;

/**
 缓存文件夹根目录
 */
+ (NSString *)resourceCacheRootPath;

@end
