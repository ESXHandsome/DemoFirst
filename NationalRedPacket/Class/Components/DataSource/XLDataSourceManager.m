//
//  XLDataSourceManager.m
//  NationalRedPacket
//
//  Created by fensi on 2018/4/13.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLDataSourceManager.h"
#import "XLPublisherDataSource.h"

@interface XLDataSourceManager ()

@property (strong, nonatomic) NSHashTable *observers;

@end

@implementation XLDataSourceManager

#pragma mark - Class Method

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static XLDataSourceManager *sharedInstance;
    dispatch_once(&onceToken, ^{ sharedInstance = [self new]; });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _observers = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
    }
    return self;
}

#pragma mark - Public Method

- (void)addObserver:(XLDataSource<XLDataSourceChangingObservable> *)observer {
    [self.observers addObject:observer];
}

#pragma mark - 消息转发，将所有接收到的数据改变的事件转发给所有观察者

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        for (id observer in self.observers) {
            if ((signature = [observer methodSignatureForSelector:aSelector])) {
                break;
            }
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    for (id observer in self.observers) {
        if ([observer respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:observer];
        }
    }
}

@end
