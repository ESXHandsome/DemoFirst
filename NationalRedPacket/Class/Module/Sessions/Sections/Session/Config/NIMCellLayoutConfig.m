//
//  NIMSessionDefaultConfig.m
//  NIMKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "NIMCellLayoutConfig.h"
#import "NIMSessionMessageContentView.h"
#import "NIMSessionUnknowContentView.h"
#import "M80AttributedLabel+NIMKit.h"
#import "NIMKitUtil.h"
#import "UIImage+NIMKit.h"
#import "NIMMessageModel.h"
#import "NIMBaseSessionContentConfig.h"
#import "NIMKit.h"

@interface NIMCellLayoutConfig()

@end

@implementation NIMCellLayoutConfig

- (CGSize)contentSize:(NIMMessageModel *)model cellWidth:(CGFloat)cellWidth{
    id<NIMSessionContentConfig>config = [[NIMSessionContentConfigFactory sharedFacotry] configBy:model.message];
    return [config contentSize:cellWidth message:model.message];
}

- (NSString *)cellContent:(NIMMessageModel *)model{
    id<NIMSessionContentConfig>config = [[NIMSessionContentConfigFactory sharedFacotry] configBy:model.message];
    NSString *cellContent = [config cellContent:model.message];
    return cellContent.length ? cellContent : @"NIMSessionUnknowContentView";
}


- (UIEdgeInsets)contentViewInsets:(NIMMessageModel *)model{
    id<NIMSessionContentConfig>config = [[NIMSessionContentConfigFactory sharedFacotry] configBy:model.message];    
    return [config contentViewInsets:model.message];
}


- (UIEdgeInsets)cellInsets:(NIMMessageModel *)model
{
    if ([[self cellContent:model] isEqualToString:@"NIMSessionNotificationContentView"]) {
        return UIEdgeInsetsZero;
    }
    CGFloat cellTopToBubbleTop           = 0;
    CGFloat otherNickNameHeight          = 20;
    CGFloat otherBubbleOriginX           = [self shouldShowAvatar:model]? adaptWidth750(55*2) : 0;
    CGFloat cellBubbleButtomToCellButtom = 13;
    if ([self shouldShowNickName:model])
    {
        //要显示名字
        return UIEdgeInsetsMake(cellTopToBubbleTop + otherNickNameHeight ,otherBubbleOriginX,cellBubbleButtomToCellButtom, 0);
    }
    else
    {
        return UIEdgeInsetsMake(cellTopToBubbleTop,otherBubbleOriginX,cellBubbleButtomToCellButtom, 0);
    }

}

- (BOOL)shouldShowAvatar:(NIMMessageModel *)model
{
    return [[NIMKit sharedKit].config setting:model.message].showAvatar;
}


- (BOOL)shouldShowNickName:(NIMMessageModel *)model{
    NIMMessage *message = model.message;
    if (message.messageType == NIMMessageTypeNotification)
    {
        NIMNotificationType type = [(NIMNotificationObject *)message.messageObject notificationType];
        if (type == NIMNotificationTypeTeam) {
            return NO;
        }
    }
    if (message.messageType == NIMMessageTypeTip) {
        return NO;
    }
    if (message.messageType == NIMMessageTypeCustom) {
        XLBaseCustomAttachment *attachment = [(NIMCustomObject *)message.messageObject attachment];
        if (attachment.customMessageType == CustomMessageTypeIncomNotice) {
            return NO;
        }
    }
    return (!message.isOutgoingMsg && message.session.sessionType == NIMSessionTypeTeam);
}


- (BOOL)shouldShowLeft:(NIMMessageModel *)model
{
    return !model.message.isOutgoingMsg;
}

- (CGPoint)avatarMargin:(NIMMessageModel *)model
{
    return CGPointMake(adaptWidth750(20), 0.f);
}

- (CGSize)avatarSize:(NIMMessageModel *)model
{
    return CGSizeMake(42, 42);
}

- (CGPoint)nickNameMargin:(NIMMessageModel *)model
{
    return [self shouldShowAvatar:model] ? CGPointMake(adaptWidth750(62*2), -3.f) : CGPointMake(10.f, -3.f);
}


- (NSArray *)customViews:(NIMMessageModel *)model
{
    return nil;
}

- (BOOL)disableRetryButton:(NIMMessageModel *)model
{
    return YES;
}

@end
