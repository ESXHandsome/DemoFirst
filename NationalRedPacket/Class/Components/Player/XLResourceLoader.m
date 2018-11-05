//
//  XLResourceLoader.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/4/10.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLResourceLoader.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define MimeType @"video/mp4"

static dispatch_queue_t videoLoaderSerialQueue;

@interface XLResourceLoader ()

@property (strong, nonatomic) NSMutableArray *requestList;
@property (strong, nonatomic) XLResourceRequestTask *requestTask;

@end

@implementation XLResourceLoader

#pragma mark -
#pragma mark Public Method

- (instancetype)init {
    if (self = [super init]) {
        self.requestList = [NSMutableArray array];
        if (!videoLoaderSerialQueue) {
            videoLoaderSerialQueue = dispatch_queue_create("video_loader_serial_queue",DISPATCH_QUEUE_SERIAL);
        }
    }
    return self;
}

/**
 停止资源加载
 */
- (void)stopLoading {
    [self.requestTask concel];
}

#pragma mark -
#pragma mark AVAssetResourceLoaderDelegate

/**
 等待资源加载代理

 @param resourceLoader 资源管理器
 @param loadingRequest 每一小块数据的请求
 @return 必须返回Yes，如果返回NO，则resourceLoader将会加载出现故障的数据
 */
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader
shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    dispatch_async(videoLoaderSerialQueue, ^{
        [self addLoadingRequest:loadingRequest];
    });
    return YES;
}

/**
 取消资源加载

 @param resourceLoader 资源管理器
 @param loadingRequest 每一小块数据的请求
 */
- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader
didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    dispatch_async(videoLoaderSerialQueue, ^{
        [self.requestList removeObject:loadingRequest];
    });
}

#pragma mark -
#pragma mark XLResourceRequestTaskDelegate

/**
 XLResourceRequestTask接受到数据
 */
- (void)requestTaskDidReceiveData {
    dispatch_async(videoLoaderSerialQueue, ^{
        [self processRequestList];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(loader:cacheProgress:)]) {
            CGFloat cacheProgress = (CGFloat)self.requestTask.cacheLength / (self.requestTask.fileLength - self.requestTask.requestOffset);
            [self.delegate loader:self cacheProgress:cacheProgress];
        }
    });
}

/**
 XLResourceRequestTask数据加载失败
 */
- (void)requestTaskDidCompleteWithError:(NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(loader:failLoadingWithError:)]) {
        [self.delegate loader:self failLoadingWithError:error];
    }
}

#pragma mark -
#pragma mark Private Method

/**
 处理LoadingRequest

 @param loadingRequest 每一小块数据的请求
 */
- (void)addLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    [self.requestList addObject:loadingRequest];
    NSRange range = NSMakeRange((NSUInteger)loadingRequest.dataRequest.currentOffset, NSUIntegerMax);
  
    if (!self.requestTask) {
        [self startNewTaskWithLoadingRequest:loadingRequest shouldCache:YES];
        return;
    }
    // 如果新的rang的起始位置比当前缓存的位置还大300k，则重新按照range请求数据
    if (self.requestTask.requestOffset + self.requestTask.cacheLength + 1024 * 300 < range.location ||
        // 如果往回拖也重新请求
        range.location < self.requestTask.requestOffset) {
        [self startNewTaskWithLoadingRequest:loadingRequest shouldCache:NO];
    } else {
        if (self.requestTask.cacheLength > 0) {
            [self processRequestList];
        }
    }
    
    
    //    if (self.requestTask) {
    //
    //        // 数据已经缓存，则直接完成
    //        if (loadingRequest.dataRequest.requestedOffset >= self.requestTask.requestOffset &&
    //            loadingRequest.dataRequest.requestedOffset <= self.requestTask.requestOffset + self.requestTask.cacheLength) {
    //            [self processRequestList];
    //        } else {
    //            // 数据还没缓存，则等待数据下载，如果是Seek操作，则重新请求
    //            if (self.seekRequired) {
    //                [self startNewTaskWithLoadingRequest:loadingRequest shouldCache:NO];
    //            }
    //
    //        }
    //    } else { // 不存在数据请求任务，启动一个新的任务
    //        [self startNewTaskWithLoadingRequest:loadingRequest shouldCache:YES];
    //    }
}

/**
 开启一个新的请求

 @param loadingRequest 每一小段请求
 @param cache 是否需要缓存
 */
- (void)startNewTaskWithLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest
                                 shouldCache:(BOOL)cache {
    long long fileLength = 0;
    if (self.requestTask) {
        fileLength = self.requestTask.fileLength;
        [self.requestTask concel];
    }
    self.requestTask = [[XLResourceRequestTask alloc]init];
    self.requestTask.requestURL = loadingRequest.request.URL;
    self.requestTask.requestOffset = loadingRequest.dataRequest.requestedOffset;
    self.requestTask.cache = cache;
    if (fileLength > 0) {
        self.requestTask.fileLength = fileLength;
    }
    self.requestTask.delegate = self;
    [self.requestTask start];
    self.seekRequired = NO;
}

/**
 对requestList里面的loadingRequest填充响应数据，如果已完全响应，则将其从requestList中移除
 */
- (void)processRequestList {
    NSMutableArray *finishRequestList = [NSMutableArray array];
    for (AVAssetResourceLoadingRequest *loadingRequest in self.requestList) {
        if ([self finishLoadingWithLoadingRequest:loadingRequest]) {
            [finishRequestList addObject:loadingRequest];
        }
    }
    [self.requestList removeObjectsInArray:finishRequestList];
}

/**
 填充响应数据
 */
- (BOOL)finishLoadingWithLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    // 填充信息
    // 填写contentInformationRequest的信息，注意contentLength需要填写下载的文件的总长度，contentType需要转换
    CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)(MimeType), NULL);
    loadingRequest.contentInformationRequest.contentType = CFBridgingRelease(contentType);
    loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
    loadingRequest.contentInformationRequest.contentLength = self.requestTask.fileLength;
    
    
    // 读文件，填充数据
    // 计算可以响应的数据长度，注意数据读取的起始位置是当前avplayer当前播放的位置，
    // 结束位置是loadingRequest的结束位置或者目前文件下载到的位置
    NSUInteger cacheLength = self.requestTask.cacheLength;
    NSUInteger requestedOffset = loadingRequest.dataRequest.requestedOffset;
    
    if ((self.requestTask.requestOffset + self.requestTask.cacheLength) < requestedOffset) {
        return NO;
    }
    
    if (requestedOffset < self.requestTask.requestOffset) {
        return NO;
    }
    
    if (loadingRequest.dataRequest.currentOffset != 0) {
        requestedOffset = loadingRequest.dataRequest.currentOffset;
    }
    NSUInteger canReadLength = cacheLength - (requestedOffset - self.requestTask.requestOffset);
    NSUInteger respondLength = MIN(canReadLength, loadingRequest.dataRequest.requestedLength);
    
    // 读取数据并填充到loadingRequest
    [loadingRequest.dataRequest respondWithData:[XLFileHandler readTempFileDataWithOffset:requestedOffset - self.requestTask.requestOffset length:respondLength]];
    
    // 如果完全响应了所需要的数据，则完成
    // 如果完全响应了所需要的数据，则完成loadingRequest，注意判断的依据是 响应数据结束的位置 >= loadingRequest结束的位置
    NSUInteger nowendOffset = requestedOffset + canReadLength;
    NSUInteger reqEndOffset = loadingRequest.dataRequest.requestedOffset + loadingRequest.dataRequest.requestedLength;
    if (nowendOffset >= reqEndOffset) {
        [loadingRequest finishLoading];
        return YES;
    }
    return NO;
}

@end
