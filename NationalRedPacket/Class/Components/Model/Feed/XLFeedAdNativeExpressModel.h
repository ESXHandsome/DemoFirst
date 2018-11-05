//
//  XLFeedAdNativeExpressModel.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/22.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTNativeExpressAdView.h"

@interface XLFeedAdNativeExpressModel : NSObject

@property (strong, nonatomic) GDTNativeExpressAdView *expressAdView;
@property (assign, nonatomic) NSTimeInterval fetchTimestamp;
@property (assign, nonatomic) NSInteger position;

@end
