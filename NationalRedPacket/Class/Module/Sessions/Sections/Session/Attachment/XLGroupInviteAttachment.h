//
//  XLGroupInviteAttachment.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLBaseCustomAttachment.h"

@interface XLGroupInviteAttachment : XLBaseCustomAttachment

/* 这里不包含群信息的群id，需要请求接口获取群id后进行页面跳转 */

///方便以后扩展
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *icon;

@end
