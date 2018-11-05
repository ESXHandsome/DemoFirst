//
//  XLDataSourceManager.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/13.
//  Copyright © 2018年 XLook. All rights reserved.
//
//  数据源管理者，目前主要是管理所有观察者，由网络层调用，并转发所有数据改变的事件到所有数据源中
//
//  注意：此类需要遵从所有监听数据源改变的观察者协议，以便暴露所有需要转发的方法给外部

#import <Foundation/Foundation.h>
#import "XLDataSource.h"
#import "XLFeedDataSourceChangingObservable.h"
#import "XLPublisherDataSourceChangingObservable.h"

@interface XLDataSourceManager : NSObject

/** 单例 */
+ (instancetype)shared;

/**
 添加观察者

 @param observer 实现了 XLDataSourceChangingObservable 协议的 XLDataSource 对象
 */
- (void)addObserver:(XLDataSource<XLDataSourceChangingObservable> *)observer;

@end
                    
@interface XLDataSourceManager (Feed) <XLFeedDataSourceChangingObservable>
@end

@interface XLDataSourceManager (Publisher) <XLPublisherDataSourceChangingObservable>
@end
