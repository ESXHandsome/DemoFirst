//
//  XLBaseCustomAttachment.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLActivityLinkModel.h"

typedef NS_ENUM(NSInteger,XLCustomMessageType){
    CustomMessageTypeRedPacket           = 201, //红包消息
    CustomMessageTypeGroupInvite         = 202, //群邀请
    CustomMessageTypeIncomNotice         = 203, //收入通知
    CustomMessageTypeBigPicture          = 204, //大图
    CustomMessageTypeTextAndPicture      = 205, //图文
    CustomMessageTypeGroupPictures       = 206, //组图
    CustomMessageTypeMiniApplication     = 207, //小应用
    CustomMessageTypeOnlyShowRedDot      = 208, //小红点显示消息，如：粉丝、收到赞、评论、访客等
    CustomMessageTypeRedPacketTip        = 300, //红包提示消息
};

@interface XLBaseCustomAttachment : NSObject  <NIMCustomAttachment>

@property (copy, nonatomic) NSString *attachmentId;
@property (assign, nonatomic) XLCustomMessageType customMessageType;
@property (copy, nonatomic) NSString *tip;

@end
