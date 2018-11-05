//
//  XLResourceRequestTask.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/4/10.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLFileHandler.h"


@class XLResourceRequestTask;
@protocol XLRequestTaskDelegate <NSObject>

@required

/// 更新缓冲进度代理方法
- (void)requestTaskDidReceiveData;

@optional

/// 数据加载完成代理方法
- (void)requestTaskDidCompleteWithCache:(BOOL)cache;
/// 数据加载出错代理方法
- (void)requestTaskDidCompleteWithError:(NSError *)error;

@end

@interface XLResourceRequestTask : NSObject

@property (weak, nonatomic) id<XLRequestTaskDelegate> delegate;
/// 请求网址
@property (strong, nonatomic) NSURL *requestURL;
/// 请求起始位置
@property (assign, nonatomic) long long requestOffset;
/// 文件长度
@property (assign, nonatomic) long long fileLength;
/// 缓冲长度
@property (assign, nonatomic) NSUInteger cacheLength;
/// 是否缓存文件
@property (assign, nonatomic) BOOL cache;

/**
 开始请求
 */
- (void)start;

/**
 取消加载
 */
- (void)concel;

@end
