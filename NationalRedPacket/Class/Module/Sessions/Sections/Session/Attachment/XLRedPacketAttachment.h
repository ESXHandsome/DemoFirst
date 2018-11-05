//
//  XLRedPacketAttachment.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLBaseCustomAttachment.h"

typedef NS_ENUM(NSInteger,XLRedPacketStatus){
    RedPacketStatusNormal    = 0, //红包可抢（正常）
    RedPacketStatusEmpty     = 1, //红包被领完
    RedPacketStatusOverdue   = 2, //红包过期
    RedPacketStatusOpened    = 3, //红包已领
};

@interface XLRedPacketAttachment : XLBaseCustomAttachment

///红包id
@property (copy, nonatomic) NSString *luckyid;
///红包标题
@property (copy, nonatomic) NSString *content;
///自定义字段
@property (assign, nonatomic) XLRedPacketStatus status;

@end
