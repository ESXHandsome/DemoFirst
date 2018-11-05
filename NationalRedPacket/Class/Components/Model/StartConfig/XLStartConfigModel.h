//
//  XLStartConfig.h
//  NationalRedPacket
//
//  Created by Ying on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLStartConfigModel : NSObject

/**私聊大V头像*/
@property (copy, nonatomic) NSString *vAvatar;

/**私聊大V昵称*/
@property (copy, nonatomic) NSString *vNickname;

/**私聊大V云信id*/
@property (copy, nonatomic) NSString *vImAccid;

/**私聊消息内容*/
@property (copy, nonatomic) NSString *vMsg;

/**私聊客服头像*/
@property (copy, nonatomic) NSString *cAvatar;

/**私聊客服昵称*/
@property (copy, nonatomic) NSString *cNickname;

/**私聊客服消息内容*/
@property (copy, nonatomic) NSString *cMsg;

/**私聊红包ID*/
@property (copy, nonatomic) NSString *luckyid;

/**私聊红包提示语*/
@property (copy, nonatomic) NSString *luckymoneyTip;

/**私聊红包文本内容*/
@property (copy, nonatomic) NSString *luckymoneyText;

/**我的界面是否有红包 0:无, 1:有*/
@property (assign, nonatomic) NSInteger myLuckymoney;

/**云控启动推荐页是否有 0:无, 1:有*/
@property (assign, nonatomic) NSInteger startRecommend;

/**热门页引导手势，0-无，1-有*/
@property (assign, nonatomic) NSInteger hotPageLeadImg;

@end
