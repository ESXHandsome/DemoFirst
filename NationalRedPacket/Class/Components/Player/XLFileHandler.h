//
//  XLFileHandler.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/4/10.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLResourceFileLocalPath.h"

@interface XLFileHandler : NSObject

/**
 创建临时文件
 */
+ (BOOL)createTempFile;

/**
 往临时文件写入数据
 */
+ (void)writeToTempFileData:(NSData *)data;

/**
 读取临时文件数据
 */
+ (NSData *)readTempFileDataWithOffset:(NSUInteger)offset length:(NSUInteger)length;

/**
 保存临时文件到缓存文件夹
 */
+ (void)cacheTempFileWithFileURL:(NSURL *)fileURL;

/**
 是否存在缓存文件
 */
+ (NSString *)cacheFileExistsWithURL:(NSURL *)url;

/**
 清空缓存文件
 */
+ (BOOL)clearCache;

/**
 根据URL清除缓存
 
 @param url 要清除缓存文件的URL
 */
+ (void)clearCacheWithFileURL:(NSURL *)url;

@end
