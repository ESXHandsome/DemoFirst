//
//  NIMBaseSessionContentConfig.m
//  NIMKit
//
//  Created by amao on 9/15/15.
//  Copyright (c) 2015 NetEase. All rights reserved.
//

#import "NIMBaseSessionContentConfig.h"
#import "NIMTextContentConfig.h"
#import "NIMImageContentConfig.h"
#import "NIMAudioContentConfig.h"
#import "NIMVideoContentConfig.h"
#import "NIMFileContentConfig.h"
#import "NIMNotificationContentConfig.h"
#import "NIMLocationContentConfig.h"
#import "NIMUnsupportContentConfig.h"
#import "NIMTipContentConfig.h"
#import "NIMRobotContentConfig.h"
#import "XLRedPacketContentConfig.h"
#import "XLGroupInviteContentConfig.h"
#import "XLIncomeNoticeContenConfig.h"
#import "XLRedPacketTipContentConfig.h"
#import "XLBigPictureContentConfig.h"
#import "XLTextAndPictureContentConfig.h"
#import "XLGroupPicturesContentConfig.h"
#import "XLMiniApplicationContentConfig.h"

@interface NIMSessionContentConfigFactory ()
@property (nonatomic,strong)    NSDictionary                *dict;
@property (nonatomic,strong)    NIMUnsupportContentConfig   *unsupportConfig;
@end

@implementation NIMSessionContentConfigFactory

+ (instancetype)sharedFacotry
{
    static NIMSessionContentConfigFactory *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NIMSessionContentConfigFactory alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _dict = @{@(NIMMessageTypeText)                 :       [NIMTextContentConfig new],
                  @(NIMMessageTypeImage)                :       [NIMImageContentConfig new],
                  @(NIMMessageTypeAudio)                :       [NIMAudioContentConfig new],
                  @(NIMMessageTypeVideo)                :       [NIMVideoContentConfig new],
                  @(NIMMessageTypeFile)                 :       [NIMFileContentConfig new],
                  @(NIMMessageTypeLocation)             :       [NIMLocationContentConfig new],
                  @(NIMMessageTypeNotification)         :       [NIMNotificationContentConfig new],
                  @(NIMMessageTypeTip)                  :       [NIMTipContentConfig new],
                  @(NIMMessageTypeRobot)                :       [NIMRobotContentConfig new],
                  @(CustomMessageTypeRedPacket)         :       [XLRedPacketContentConfig new],
                  @(CustomMessageTypeGroupInvite)       :       [XLGroupInviteContentConfig new],
                  @(CustomMessageTypeIncomNotice)       :       [XLIncomeNoticeContenConfig new],
                  @(CustomMessageTypeBigPicture)        :       [XLBigPictureContentConfig new],
                  @(CustomMessageTypeTextAndPicture)    :       [XLTextAndPictureContentConfig new],
                  @(CustomMessageTypeGroupPictures)     :       [XLGroupPicturesContentConfig new],
                  @(CustomMessageTypeMiniApplication)   :       [XLMiniApplicationContentConfig new],
                  @(CustomMessageTypeRedPacketTip)      :       [XLRedPacketTipContentConfig new],
                  };
        _unsupportConfig = [[NIMUnsupportContentConfig alloc] init];
    }
    return self;
}

- (id<NIMSessionContentConfig>)configBy:(NIMMessage *)message
{
    NIMMessageType type = message.messageType;
    id<NIMSessionContentConfig>config = [_dict objectForKey:@(type)];
    if (type == NIMMessageTypeCustom) { //自定义消息类型
        NIMCustomObject *object = message.messageObject;
        XLBaseCustomAttachment *attachment = object.attachment;
        if (attachment != nil) {
            config = [_dict objectForKey:@(attachment.customMessageType)];
        }
    }
    if (config == nil)
    {
        config = _unsupportConfig;
    }
    return config;
}

@end
