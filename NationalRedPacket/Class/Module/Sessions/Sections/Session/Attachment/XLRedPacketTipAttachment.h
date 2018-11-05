//
//  XLRedPacketTipAttachment.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/31.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLBaseCustomAttachment.h"

@interface XLRedPacketTipAttachment : XLBaseCustomAttachment

///发红包人 id
@property (copy, nonatomic) NSString *senderId;
///领红包人 id
@property (copy, nonatomic) NSString *openerId;
///红包 id
@property (copy, nonatomic) NSString *luckyid;

@end
