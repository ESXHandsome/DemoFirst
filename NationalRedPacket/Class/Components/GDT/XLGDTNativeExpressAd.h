//
//  XLGDTNativeExpressAd.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/22.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NativeExpressType) {
    NativeExpressTypeFollow,
    NativeExpressTypeHot
};

@protocol XLGDTNativeExpressAdDelegate <NSObject>

@optional;

- (void)nativeExpressAdDidFetchSuccess:(NSArray *)dataArray nativeExpressType:(NativeExpressType)type;
- (void)nativeExpressAdDidFetchFailure:(NSError *)error nativeExpressType:(NativeExpressType)type;

@end

@interface XLGDTNativeExpressAd : NSObject

- (void)fetchNativeExpressAd:(int)preloadCount withType:(NativeExpressType)type;

@property (weak, nonatomic) id<XLGDTNativeExpressAdDelegate> delegate;

@end
