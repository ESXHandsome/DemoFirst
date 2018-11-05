//
//  XLResourceLoader.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/4/10.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "XLResourceRequestTask.h"

@class XLResourceLoader;

@protocol XLResourceLoaderDelegate <NSObject>

@required
- (void)loader:(XLResourceLoader *)loader cacheProgress:(CGFloat)progress;

@optional
- (void)loader:(XLResourceLoader *)loader failLoadingWithError:(NSError *)error;

@end

@interface XLResourceLoader : NSObject<AVAssetResourceLoaderDelegate, XLRequestTaskDelegate>

@property (weak, nonatomic)   id<XLResourceLoaderDelegate> delegate;
/// seek标识
@property (assign, nonatomic) BOOL seekRequired;

/**
 停止数据加载
 */
- (void)stopLoading;

@end
