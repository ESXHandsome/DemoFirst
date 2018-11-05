//
//  XLNotificationModel.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/7.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NotificationJumpType) {
    NotificationJumpTypeSession          = 0, //会话详情
    NotificationJumpTypeHome             = 1, //首页
    NotificationJumpTypeHomeRefresh      = 2, //首页刷新
    NotificationJumpTypeFeedDetail       = 3, //详情页
    NotificationJumpTypeSessionFans      = 4, //粉丝
    NotificationJumpTypeSessionVisitor   = 5, //访客
    NotificationJumpTypeSessionPraise    = 6, //收到赞
    NotificationJumpTypeSessionComment   = 7, //收到评论
};

@interface XLNotificationModel : NSObject

@property (assign, nonatomic) NotificationJumpType action;

@end

@interface XLNotificationModel (Session)

/// 0:群 1:个人
@property (copy, nonatomic)   NSString *sessionType;
@property (copy, nonatomic)   NSString *teamId;

@end

@interface XLNotificationModel (Feed)

@property (copy, nonatomic)   NSString *feedId;
@property (copy, nonatomic)   NSString *itemType;

@end




