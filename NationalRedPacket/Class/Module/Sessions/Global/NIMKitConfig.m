//
//  NIMKitConfig.m
//  NIMKit
//
//  Created by chris on 2017/10/25.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "NIMKitConfig.h"
#import "NIMGlobalMacro.h"
#import "NIMMediaItem.h"
#import "UIImage+NIMKit.h"
#import <NIMSDK/NIMSDK.h>
#import "XLBaseCustomAttachment.h"

@interface NIMKitSettings()
{
    BOOL _isRight;
}

- (instancetype)init:(BOOL)isRight;

@end


@implementation NIMKitConfig

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        [self applyDefaultSettings];
    }
    return self;
}


- (NSArray *)defaultMediaItems
{
    return @[[NIMMediaItem item:@"onTapMediaItemPicture:"
                    normalImage:[UIImage nim_imageInKit:@"chat_pic"]
                  selectedImage:[UIImage nim_imageInKit:@"chat_pic_h"]
                          title:@"照片"],
             
//             [NIMMediaItem item:@"onTapMediaItemShoot:"
//                    normalImage:[UIImage nim_imageInKit:@"bk_media_shoot_normal"]
//                  selectedImage:[UIImage nim_imageInKit:@"bk_media_shoot_pressed"]
//                          title:@"拍摄"],
//
//             [NIMMediaItem item:@"onTapMediaItemLocation:"
//                    normalImage:[UIImage nim_imageInKit:@"bk_media_position_normal"]
//                  selectedImage:[UIImage nim_imageInKit:@"bk_media_position_pressed"]
//                          title:@"位置"],
             ];
}


- (CGFloat)maxNotificationTipPadding{
    return 20.f;
}


- (void)applyDefaultSettings
{
    _messageInterval = 300;
    _messageLimit    = 20;
    _recordMaxDuration = 60.f;
    _placeholder = @"";
    _inputMaxLength = 1000;
    _nickFont  = [UIFont systemFontOfSize:adaptFontSize(24)];
    _nickColor = [UIColor colorWithString:COLOR737373];
    _receiptFont  = [UIFont systemFontOfSize:adaptFontSize(24)];
    _receiptColor = [UIColor colorWithString:COLOR737373];
    _avatarType = NIMKitAvatarTypeNone;
    _cellBackgroundColor = [UIColor colorWithString:COLORF2F2F2];
    _leftBubbleSettings  = [[NIMKitSettings alloc] init:NO];
    _rightBubbleSettings = [[NIMKitSettings alloc] init:YES];
}

- (NIMKitSetting *)setting:(NIMMessage *)message
{
    NIMKitSettings *settings = message.isOutgoingMsg? self.rightBubbleSettings : self.leftBubbleSettings;
    switch (message.messageType) {
        case NIMMessageTypeText:
            return settings.textSetting;
        case NIMMessageTypeImage:
            return settings.imageSetting;
        case NIMMessageTypeLocation:
            return settings.locationSetting;
        case NIMMessageTypeAudio:
            return settings.audioSetting;
        case NIMMessageTypeVideo:
            return settings.videoSetting;
        case NIMMessageTypeFile:
            return settings.fileSetting;
        case NIMMessageTypeTip:
            return settings.tipSetting;
        case NIMMessageTypeRobot:
            return settings.robotSetting;
        case NIMMessageTypeNotification:
        {
            NIMNotificationObject *object = (NIMNotificationObject *)message.messageObject;
            switch (object.notificationType)
            {
                case NIMNotificationTypeTeam:
                    return settings.teamNotificationSetting;
                case NIMNotificationTypeChatroom:
                    return settings.chatroomNotificationSetting;
                case NIMNotificationTypeNetCall:
                    return settings.netcallNotificationSetting;
                default:
                    break;
            }
            break;
        }
        case NIMMessageTypeCustom: {
            XLBaseCustomAttachment *attachment = [(NIMCustomObject *)message.messageObject attachment];
            switch (attachment.customMessageType) {
                case CustomMessageTypeRedPacket:
                    return settings.redPacketSetting;
                case CustomMessageTypeGroupInvite:
                    return settings.groupInviteSetting;
                case CustomMessageTypeIncomNotice:
                    return settings.incomeNoticeSetting;
                case CustomMessageTypeBigPicture:
                    return settings.bigPictureSetting;
                case CustomMessageTypeTextAndPicture:
                    return settings.textAndPictureSetting;
                case CustomMessageTypeGroupPictures:
                    return settings.groupPicturesSetting;
                case CustomMessageTypeMiniApplication:
                    return settings.miniApplicationSetting;
                case CustomMessageTypeRedPacketTip:
                    return settings.redPacketTipSetting;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    return settings.unsupportSetting;
}

@end


@implementation NIMKitSettings

- (instancetype)init:(BOOL)isRight
{
    self = [super init];
    if (self)
    {
        _isRight = isRight;
        [self applyDefaultSettings];
    }
    return self;
}

- (void)applyDefaultSettings
{
    [self applyDefaultTextSettings];
    [self applyDefaultAudioSettings];
    [self applyDefaultVideoSettings];
    [self applyDefaultFileSettings];
    [self applyDefaultImageSettings];
    [self applyDefaultLocationSettings];
    [self applyDefaultTipSettings];
    [self applyDefaultRobotSettings];
    [self applyDefaultUnsupportSettings];
    [self applyDefaultTeamNotificationSettings];
    [self applyDefaultChatroomNotificationSettings];
    [self applyDefaultNetcallNotificationSettings];
    [self applyDefaultRedPacketSettings];
    [self applyDefaultGroupInviteSettings];
    [self applyDefaultIncomeNoticeSettings];
    [self applyDefaultBigPictureSettings];
    [self applyDefaultTextAndPictureSettings];
    [self applyDefaultGroupPicturesSettings];
    [self applyDefaultMiniApplicationSettings];
    [self applyDefaultRedPacketTipSettings];

}

- (void)applyDefaultTextSettings
{
    _textSetting = [[NIMKitSetting alloc] init:_isRight];
    _textSetting.contentInsets = _isRight? UIEdgeInsetsFromString(@"{7,11,7,15}") : UIEdgeInsetsFromString(@"{7,15,7,9}");
    _textSetting.textColor = [UIColor colorWithString:_isRight ? COLORffffff :COLOR333333];
    _textSetting.font      = [UIFont systemFontOfSize:adaptFontSize(32)];
    _textSetting.showAvatar = YES;
}

- (void)applyDefaultAudioSettings
{
    _audioSetting = [[NIMKitSetting alloc] init:_isRight];
    _audioSetting.contentInsets = _isRight? UIEdgeInsetsFromString(@"{8,12,9,14}") : UIEdgeInsetsFromString(@"{8,13,9,12}");
    _audioSetting.textColor = _isRight? NIMKit_UIColorFromRGB(0xFFFFFF) : NIMKit_UIColorFromRGB(0x000000);
    _audioSetting.font      = [UIFont systemFontOfSize:14];
    _audioSetting.showAvatar = YES;
}

- (void)applyDefaultVideoSettings
{
    _videoSetting = [[NIMKitSetting alloc] init:_isRight];
    _videoSetting.contentInsets = _isRight? UIEdgeInsetsFromString(@"{3,3,3,8}") : UIEdgeInsetsFromString(@"{3,8,3,3}");
    _videoSetting.font      = [UIFont systemFontOfSize:14];
    _videoSetting.showAvatar = YES;
}

- (void)applyDefaultFileSettings
{
    _fileSetting = [[NIMKitSetting alloc] init:_isRight];
    _fileSetting.contentInsets = _isRight? UIEdgeInsetsFromString(@"{3,3,3,8}") : UIEdgeInsetsFromString(@"{3,8,3,3}");
    _fileSetting.font      = [UIFont systemFontOfSize:14];
    _fileSetting.showAvatar = YES;
}

- (void)applyDefaultImageSettings
{
    _imageSetting = [[NIMKitSetting alloc] init:_isRight];
    _imageSetting.contentInsets = _isRight? UIEdgeInsetsFromString(@"{3,3,3,8}") : UIEdgeInsetsFromString(@"{3,8,3,3}");
    _imageSetting.showAvatar = YES;
}

- (void)applyDefaultRedPacketSettings
{
    _redPacketSetting = [[NIMKitSetting alloc] init:_isRight];
    _redPacketSetting.contentInsets = _isRight? UIEdgeInsetsFromString(@"{3,3,3,8}") : UIEdgeInsetsFromString(@"{3,8,3,3}");
    _redPacketSetting.showAvatar = YES;
}

- (void)applyDefaultGroupInviteSettings {
    
    _groupInviteSetting = [[NIMKitSetting alloc] init:_isRight];
    _groupInviteSetting.contentInsets = _isRight? UIEdgeInsetsFromString(@"{3,3,3,8}") : UIEdgeInsetsFromString(@"{3,8,3,3}");
    _groupInviteSetting.showAvatar = YES;
}

- (void)applyDefaultIncomeNoticeSettings {
    
    _incomeNoticeSetting = [[NIMKitSetting alloc] init:_isRight];
    _incomeNoticeSetting.contentInsets = _isRight? UIEdgeInsetsFromString(@"{3,3,3,8}") : UIEdgeInsetsFromString(@"{3,8,3,3}");
    _incomeNoticeSetting.showAvatar = NO;
}

- (void)applyDefaultBigPictureSettings {
    
    _bigPictureSetting = [[NIMKitSetting alloc] init:_isRight];
    _bigPictureSetting.contentInsets = _isRight? UIEdgeInsetsFromString(@"{3,3,3,8}") : UIEdgeInsetsFromString(@"{3,8,3,3}");
    _bigPictureSetting.showAvatar = NO;
}

- (void)applyDefaultTextAndPictureSettings {
    
    _textAndPictureSetting = [[NIMKitSetting alloc] init:_isRight];
    _textAndPictureSetting.contentInsets = _isRight? UIEdgeInsetsFromString(@"{3,3,3,8}") : UIEdgeInsetsFromString(@"{3,8,3,3}");
    _textAndPictureSetting.showAvatar = YES;
}

- (void)applyDefaultGroupPicturesSettings {
    
    _groupPicturesSetting = [[NIMKitSetting alloc] init:_isRight];
    _groupPicturesSetting.contentInsets = _isRight? UIEdgeInsetsFromString(@"{3,3,3,8}") : UIEdgeInsetsFromString(@"{3,8,3,3}");
    _groupPicturesSetting.showAvatar = NO;
}

- (void)applyDefaultMiniApplicationSettings {
    
    _miniApplicationSetting = [[NIMKitSetting alloc] init:_isRight];
    _miniApplicationSetting.contentInsets = _isRight? UIEdgeInsetsFromString(@"{3,3,3,8}") : UIEdgeInsetsFromString(@"{3,8,3,3}");
    _miniApplicationSetting.showAvatar = YES;
}

- (void)applyDefaultRedPacketTipSettings {
    
    _redPacketTipSetting = [[NIMKitSetting alloc] init:_isRight];
    _redPacketTipSetting.contentInsets = UIEdgeInsetsZero;
    _redPacketTipSetting.textColor = NIMKit_UIColorFromRGB(0xFFFFFF);
    _redPacketTipSetting.font  = [UIFont systemFontOfSize:adaptFontSize(22)];
    _redPacketTipSetting.showAvatar = NO;
    UIImage *backgroundImage = [[UIImage nim_imageInKit:@"icon_session_time_bg"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{8,20,8,20}") resizingMode:UIImageResizingModeStretch];;
    _redPacketTipSetting.normalBackgroundImage    = backgroundImage;
    _redPacketTipSetting.highLightBackgroundImage = backgroundImage;
    
}

- (void)applyDefaultLocationSettings
{
    _locationSetting = [[NIMKitSetting alloc] init:_isRight];
    _locationSetting.contentInsets = _isRight? UIEdgeInsetsFromString(@"{3,3,3,8}") : UIEdgeInsetsFromString(@"{3,8,3,3}");
    _locationSetting.textColor = NIMKit_UIColorFromRGB(0xFFFFFF);
    _locationSetting.font      = [UIFont systemFontOfSize:12];
    _locationSetting.showAvatar = YES;
}

- (void)applyDefaultTipSettings
{
    _tipSetting = [[NIMKitSetting alloc] init:_isRight];
    _tipSetting.contentInsets = UIEdgeInsetsZero;
    _tipSetting.textColor = NIMKit_UIColorFromRGB(0xFFFFFF);
    _tipSetting.font  = [UIFont systemFontOfSize:adaptFontSize(22)];
    _tipSetting.showAvatar = NO;
    UIImage *backgroundImage = [[UIImage nim_imageInKit:@"icon_session_time_bg"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{8,20,8,20}") resizingMode:UIImageResizingModeStretch];;
    _tipSetting.normalBackgroundImage    = backgroundImage;
    _tipSetting.highLightBackgroundImage = backgroundImage;
}


- (void)applyDefaultRobotSettings
{
    _robotSetting = [[NIMKitSetting alloc] init:_isRight];
    _robotSetting.contentInsets = _isRight? UIEdgeInsetsFromString(@"{11,11,9,15}") : UIEdgeInsetsFromString(@"{11,15,9,9}");
    _robotSetting.textColor = [UIColor colorWithString:COLOR333333];
    _robotSetting.font      = [UIFont systemFontOfSize:adaptFontSize(32)];
    _robotSetting.showAvatar = YES;
}

- (void)applyDefaultUnsupportSettings
{
    _unsupportSetting = [[NIMKitSetting alloc] init:_isRight];
    _unsupportSetting.contentInsets = _isRight? UIEdgeInsetsFromString(@"{11,11,9,15}") : UIEdgeInsetsFromString(@"{11,15,9,9}");
    _unsupportSetting.textColor = [UIColor colorWithString:COLOR333333];
    _unsupportSetting.font      = [UIFont systemFontOfSize:adaptFontSize(32)];
    _unsupportSetting.showAvatar = YES;
}


- (void)applyDefaultTeamNotificationSettings
{
    _teamNotificationSetting = [[NIMKitSetting alloc] init:_isRight];
    _teamNotificationSetting.contentInsets = UIEdgeInsetsZero;
    _teamNotificationSetting.textColor = NIMKit_UIColorFromRGB(0xFFFFFF);
    _teamNotificationSetting.font      = [UIFont systemFontOfSize:adaptFontSize(22)];
    _teamNotificationSetting.showAvatar = NO;
    UIImage *backgroundImage = [[UIImage nim_imageInKit:@"icon_session_time_bg"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{8,20,8,20}") resizingMode:UIImageResizingModeStretch];
    _teamNotificationSetting.normalBackgroundImage    = backgroundImage;
    _teamNotificationSetting.highLightBackgroundImage = backgroundImage;
}

- (void)applyDefaultChatroomNotificationSettings
{
    _chatroomNotificationSetting = [[NIMKitSetting alloc] init:_isRight];
    _chatroomNotificationSetting.contentInsets = UIEdgeInsetsZero;
    _chatroomNotificationSetting.textColor = NIMKit_UIColorFromRGB(0xFFFFFF);
    _chatroomNotificationSetting.font      = [UIFont systemFontOfSize:adaptFontSize(22)];
    _chatroomNotificationSetting.showAvatar = NO;
    UIImage *backgroundImage = [[UIImage nim_imageInKit:@"icon_session_time_bg"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{8,20,8,20}") resizingMode:UIImageResizingModeStretch];
    _chatroomNotificationSetting.normalBackgroundImage    = backgroundImage;
    _chatroomNotificationSetting.highLightBackgroundImage = backgroundImage;
}

- (void)applyDefaultNetcallNotificationSettings
{
    _netcallNotificationSetting = [[NIMKitSetting alloc] init:_isRight];
    _netcallNotificationSetting.contentInsets = _isRight? UIEdgeInsetsFromString(@"{11,11,9,15}") : UIEdgeInsetsFromString(@"{11,15,9,9}");
    _netcallNotificationSetting.textColor = _isRight? NIMKit_UIColorFromRGB(0xFFFFFF) : NIMKit_UIColorFromRGB(0x000000);
    _netcallNotificationSetting.font      = [UIFont systemFontOfSize:14];
    _netcallNotificationSetting.showAvatar = YES;
}


@end





