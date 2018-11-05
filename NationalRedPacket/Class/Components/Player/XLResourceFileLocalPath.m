//
//  XLResourceFileLocalPath.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/4/11.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLResourceFileLocalPath.h"
#import "NSString+MD5String.h"

#define XLFileManager [NSFileManager defaultManager]
#define XLResourceRootFolder @"VideoResourceCaches"
@implementation XLResourceFileLocalPath

/**
 临时文件路径
 */
+ (NSString *)tempFilePath {
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:@"VideoResourceTemp.mp4"];
}

/**
 缓存文件地址
 */
+ (NSString *)resourceCachePathForURL:(NSURL *)resourceURL {
    NSString *resourceRootPath = [[NSHomeDirectory( ) stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:XLResourceRootFolder];
   
    NSString *cacheFilePath = [NSString stringWithFormat:@"%@/%@", resourceRootPath, [self fileNameWithURL:resourceURL]];

    return cacheFilePath;
}

/**
 缓存文件夹根目录
 */
+ (NSString *)resourceCacheRootPath {
    NSString *videoFilePath = [[NSHomeDirectory( ) stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:XLResourceRootFolder];
    return videoFilePath;
}

+ (NSString *)fileNameWithURL:(NSURL *)url {
    return [[url.path componentsSeparatedByString:@"/"] lastObject];
}

@end
