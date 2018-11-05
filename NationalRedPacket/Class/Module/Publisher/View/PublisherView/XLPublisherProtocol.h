
//
//  XLPublisherProtocol.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/6/7.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XLPublisherProtocol <NSObject>

@required
/**
 更新关注按钮状态及关注数UI
 */
- (void)updateFollowInfo;

@end
