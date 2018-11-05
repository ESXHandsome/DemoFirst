//
//  XLSessionMessageModel.h
//  NationalRedPacket
//
//  Created by Ying on 2018/5/30.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLSessionMessageModel : NSObject
@property (copy, nonatomic) NSString *avatar;   ///用户头像
@property (copy, nonatomic) NSString *content;  ///消息内容
@property (copy, nonatomic) NSString *name;     ///用户昵称
@property (copy, nonatomic) NSString *uid;      ///用户id
@property (copy, nonatomic) NSString *extra;    ///业务逻辑判断 1:双方未互相关注, 2:对方关注自己, 3:自己关注对方, 4互相关注
@property (copy, nonatomic) NSString *image;    ///消息图片
@property (copy, nonatomic) NSString *create_at; ///消息创建的时间戳
@property (copy, nonatomic) NSString *type;     ///消息类型
@property (copy, nonatomic) NSString *MssageID; ///我也不知道干嘛的
@end
