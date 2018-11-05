//
//  XLFileHandler.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/4/10.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLFileHandler.h"
#import "NSString+MD5String.h"

#define XLFileManager [NSFileManager defaultManager]

@interface XLFileHandler ()
@property (strong, nonatomic) NSFileHandle *writeFileHandle;
@property (strong, nonatomic) NSFileHandle *readFileHandle;
@end

@implementation XLFileHandler

/**
 创建临时文件
 */
+ (BOOL)createTempFile {
    NSString *path = [XLResourceFileLocalPath tempFilePath];
    if ([XLFileManager fileExistsAtPath:path]) {
        [XLFileManager removeItemAtPath:path error:nil];
    }
    return [XLFileManager createFileAtPath:path contents:nil attributes:nil];
}

/**
 往临时文件写入数据
 */
+ (void)writeToTempFileData:(NSData *)data {
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:[XLResourceFileLocalPath tempFilePath]];
    [handle seekToEndOfFile];
    [handle writeData:data];
}

/**
 读取临时文件数据
 */
+ (NSData *)readTempFileDataWithOffset:(NSUInteger)offset length:(NSUInteger)length {
    
#warning 有崩溃
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:[XLResourceFileLocalPath tempFilePath]];
    [handle seekToFileOffset:offset];
    return [handle readDataOfLength:length];
}

/**
 将临时文件缓存

 @param fileURL 文件URL
 */
+ (void)cacheTempFileWithFileURL:(NSURL *)fileURL {
    NSString *rootPath = [XLResourceFileLocalPath resourceCacheRootPath];;
 
    if (![XLFileManager fileExistsAtPath:rootPath]) {
        [XLFileManager createDirectoryAtPath:rootPath withIntermediateDirectories:YES
                                  attributes:nil error:nil];
    }
    NSString *cachePath = [XLResourceFileLocalPath resourceCachePathForURL:fileURL];
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] copyItemAtPath:[XLResourceFileLocalPath tempFilePath]
                                                           toPath:cachePath error:&error];

    XLLog(@"cache file : %@", success ? @"success" : @"fail");
    XLLog(@"error is %@",error);
}

/**
 移除临时文件
 */
+ (void)removeTempFile {
    [[NSFileManager defaultManager] removeItemAtPath:[XLResourceFileLocalPath tempFilePath] error:nil];
}

/**
 判断指定的url文件是否存在
 
 @return 存在：返回文件路径 不存在：返回nil
 */
+ (NSString *)cacheFileExistsWithURL:(NSURL *)url {
    NSString *videoCachePath = [XLResourceFileLocalPath resourceCachePathForURL:url];
    if ([XLFileManager fileExistsAtPath:videoCachePath]) {
        return videoCachePath;
    }
    return nil;
}

/**
 清空缓存文件
 */
+ (BOOL)clearCache {
    return [XLFileManager removeItemAtPath:[XLResourceFileLocalPath resourceCacheRootPath] error:nil];
}

/**
 根据URL清除缓存
 
 @param url 要清除缓存文件的名称
 */
+ (void)clearCacheWithFileURL:(NSURL *)url {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *cacheFolderPath = [XLResourceFileLocalPath resourceCachePathForURL:url];
        if ([XLFileManager fileExistsAtPath:cacheFolderPath isDirectory:NULL]) {
            [XLFileManager removeItemAtPath:cacheFolderPath error:nil];
        }
    });
}

@end
