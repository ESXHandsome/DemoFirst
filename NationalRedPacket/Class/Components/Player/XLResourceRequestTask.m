//
//  XLResourceRequestTask.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/4/10.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLResourceRequestTask.h"
#import "NSURL+ResourceLoader.h"

#define RequestTimeout 10.0

static dispatch_queue_t videoSaveSerialQueue;
static NSOperationQueue *videoRequestOperationQueue;

@interface XLResourceRequestTask ()<NSURLConnectionDataDelegate, NSURLSessionDataDelegate>

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionDataTask *task;
@property (assign, nonatomic) BOOL hasConceled;

@end

@implementation XLResourceRequestTask

#pragma mark -
#pragma mark Public Method

- (instancetype)init {
    if (self = [super init]) {
        [XLFileHandler createTempFile];
        if (!videoSaveSerialQueue) {
            videoSaveSerialQueue = dispatch_queue_create("video_save_serial_queue",DISPATCH_QUEUE_SERIAL);
        }

        /** 在主队列中发起请求，查看耗时情况，是否需要更换队列 **/
   
        if (!videoRequestOperationQueue) {
            videoRequestOperationQueue = [[NSOperationQueue alloc] init];
            [videoRequestOperationQueue setMaxConcurrentOperationCount:3];
        }
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:videoRequestOperationQueue];
    }
    return self;
}

/** TODO: 使用AFNetWorking*/

/**
 开始下载
 */
- (void)start {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self.requestURL originalSchemeURL]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:RequestTimeout];
    if (self.requestOffset > 0) {
        [request addValue:[NSString stringWithFormat:@"bytes=%lld-%lld", self.requestOffset, self.fileLength - 1]
       forHTTPHeaderField:@"Range"];
    }
    self.task = [self.session dataTaskWithRequest:request];
    [self.task resume];
}

/**
 取消下载
 */
- (void)concel {
    self.hasConceled = YES;
    [self.task cancel];
    // [self.session invalidateAndCancel];
}

#pragma mark -
#pragma mark NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    if (self.hasConceled && [session isEqual:self.session]) return;

    if (self.delegate && [self.delegate respondsToSelector:@selector(requestTaskDidCompleteWithError:)]) {
        [self.delegate requestTaskDidCompleteWithError:error];
    }
}

//网络中断：-1005
//无网络连接：-1009
//请求超时：-1001
//服务器内部错误：-1004
//找不到服务器：-1003

/**
 服务器收到响应回调
 */
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    if (self.hasConceled && [session isEqual:self.session]) return;
    
    completionHandler(NSURLSessionResponseAllow);
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSString *contentRange = [[httpResponse allHeaderFields] objectForKey:@"Content-Range"];
    NSString *fileLength = [[contentRange componentsSeparatedByString:@"/"] lastObject];
    self.fileLength = fileLength.integerValue > 0 ? fileLength.integerValue : response.expectedContentLength;
}

/**
 服务器返回数据 可能会调用多次
 */
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    
    if (self.hasConceled && [session isEqual:self.session]) return;

    dispatch_async(videoSaveSerialQueue, ^{
        [XLFileHandler writeToTempFileData:data];
        self.cacheLength += data.length;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestTaskDidReceiveData)]) {
            [self.delegate requestTaskDidReceiveData];
        }
    });
}

/**
 数据请求完成
 */
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
    
    if (self.hasConceled && [session isEqual:self.session]) {
        XLLog(@"下载取消");
        return;
    }
    if (error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestTaskDidCompleteWithError:)]) {
            [self.delegate requestTaskDidCompleteWithError:error];
        }
        return;
    }
    // 可以缓存则保存文件
    if (self.cache) {
        dispatch_async(videoSaveSerialQueue, ^{
            [XLFileHandler cacheTempFileWithFileURL:self.requestURL];
        });
    }
}

@end
