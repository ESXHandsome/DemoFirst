//
//  RedPacketWaitOpenModel.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLSessionRedPacketWaitOpenModel : NSObject

/// 错误码
@property (assign, nonatomic) NSInteger errorCode;
/// 红包状态，0:可抢;1:已抢完;2:超时;3:已抢过;4:其它错误
@property (assign, nonatomic) NSInteger status;
/// 发红包用户昵称
@property (copy, nonatomic) NSString *name;
/// 发红包用户头像
@property (copy, nonatomic) NSString *avatar;

@end
