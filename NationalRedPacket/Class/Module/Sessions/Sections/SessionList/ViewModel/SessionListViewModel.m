//
//  SessionListViewModel.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/5/28.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "SessionListViewModel.h"
#import <NIMSDK/NIMSDK.h>
#import "NIMKitUtil.h"
#import "XLBaseCustomAttachment.h"
#import "XLRedPacketTipAttachment.h"
#import "XLIncomeNoticeAttachment.h"
#import "XLOnlyShowRedDotAttachment.h"
#import "NIMKit.h"
#import "XLBadgeRegister.h"
#import "NSObject+XLBadgeHandler.h"

@interface SessionListViewModel () <NIMLoginManagerDelegate,NIMConversationManagerDelegate,NIMSystemNotificationManagerDelegate>

/**
 *  删除会话时是不是也同时删除服务器会话 (防止漫游)
 */
@property (nonatomic,assign) BOOL autoRemoveRemoteSession;

@end

@implementation SessionListViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
        if (!self.recentSessions.count) {
            _recentSessions = [NSMutableArray array];
        } else {
            _recentSessions = [self customSortRecents:_recentSessions];
        }
        
        [[NIMSDK sharedSDK].conversationManager addDelegate:self];
        [[NIMSDK sharedSDK].loginManager addDelegate:self];
        [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    }
    return self;
}

- (void)dealloc {
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
}

#pragma mark - NIMLoginManagerDelegate

- (void)onLogin:(NIMLoginStep)step {
    if (step == NIMLoginStepSyncOK) {
        _recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
        _recentSessions = [self customSortRecents:_recentSessions];
        [self refresh];
    }
}

#pragma mark - NIMConversationManagerDelegate

- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount {
    
    NIMNotificationObject *object = recentSession.lastMessage.messageObject;
    if ([object isKindOfClass:NIMNotificationObject.class] && object.notificationType == NIMNotificationTypeTeam) {
        NIMTeamNotificationContent *content = (NIMTeamNotificationContent*)object.content;
        if (content.notificationType == NIMTeamOperationTypeKick && [content.sourceID isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) { //如果是你离开群，就不接受这个消息了
            [[NIMSDK sharedSDK].conversationManager deleteRecentSession:recentSession];
            return;
            
        }
    }
    
    [self.recentSessions addObject:recentSession];
    [self sort];
    _recentSessions = [self customSortRecents:_recentSessions];
    [self refresh];
    
    [self configBadgeShow:totalUnreadCount];
}

- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount {
    for (NIMRecentSession *recent in self.recentSessions) {
        if ([recentSession.session.sessionId isEqualToString:recent.session.sessionId]) {
            [self.recentSessions removeObject:recent];
            break;
        }
    }

    NSInteger insert = [self findInsertPlace:recentSession];
    [self.recentSessions insertObject:recentSession atIndex:insert];
    _recentSessions = [self customSortRecents:_recentSessions];
    [self refresh];
    
    [self configBadgeShow:totalUnreadCount];
}

- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount {
    //清理本地数据
    [self.recentSessions removeObject:recentSession];
    
    //如果删除本地会话后就不允许漫游当前会话，则需要进行一次删除服务器会话的操作
    if (self.autoRemoveRemoteSession) {
        [[NIMSDK sharedSDK].conversationManager deleteRemoteSessions:@[recentSession.session]
                                                          completion:nil];
    }
    _recentSessions = [self customSortRecents:_recentSessions];
    [self refresh];
    
    [self configBadgeShow:totalUnreadCount];
}

- (void)messagesDeletedInSession:(NIMSession *)session {
    _recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
    _recentSessions = [self customSortRecents:_recentSessions];
    [self refresh];
}

- (void)allMessagesDeleted {
    _recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
    _recentSessions = [self customSortRecents:_recentSessions];
    [self refresh];
}

- (void)allMessagesRead {
    _recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
    _recentSessions = [self customSortRecents:_recentSessions];
    [self refresh];
}

- (void)configBadgeShow:(NSInteger)totalUnreadCount {
    if (totalUnreadCount > 0) {
        NSArray *array = [NIMSDK.sharedSDK.conversationManager allRecentSessions];
        for (NIMRecentSession *recentSession in array) {
            if ([self noDisturbSession:recentSession.session]) { //总数需减去免打扰群消息的未读数量
                totalUnreadCount -= recentSession.unreadCount;
            }
            if ([self onlyShowSessionRedDotForRecentSession:recentSession]) { //减去不在列表显示的消息未读数，避免重复计算小红点数量，如果不减去，导致父节点IMTabBar将listKey与topView key 重复计算
                totalUnreadCount -= recentSession.unreadCount;
            }
        }
        [self resetBadgeCount:totalUnreadCount forKey:XLBadgeSessionListKey];
    } else {
        [self resetBadgeCount:0 forKey:XLBadgeSessionListKey];
    }
}

#pragma mark - Public Method

- (NSMutableArray *)customSortRecents:(NSMutableArray *)recentSessions {
    return self.recentSessions;
}

- (NSString *)nameForRecentSession:(NIMRecentSession *)recent {
    if (recent.session.sessionType == NIMSessionTypeP2P) {
        return [NIMKitUtil showNick:recent.session.sessionId inSession:recent.session];
    } else {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:recent.session.sessionId];
        return team.teamName;
    }
}

- (NSMutableAttributedString *)contentForRecentSession:(NIMRecentSession *)recent {
    NSString *content = [self messageContent:recent.lastMessage];
    NSString *draftStr = [NIMKitUtil draftInSession:recent.session];
    if (draftStr && draftStr.length != 0 ){
        NSString *draftTip = @"[草稿]";
        content = [NSString stringWithFormat:@"%@ %@", draftTip, draftStr];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, draftTip.length)];
        return attributedString;
    }
    return [[NSMutableAttributedString alloc] initWithString:content ?: @""];
}

- (NSString *)timestampDescriptionForRecentSession:(NIMRecentSession *)recent {
    return [NIMKitUtil showTime:recent.lastMessage.timestamp showDetail:NO];
}

- (BOOL)onlyShowSessionRedDotForRecentSession:(NIMRecentSession *)recentSession {
    if ([recentSession.session.sessionId isEqualToString:@"robot_push_1"]) {
        return YES;
    }
    return NO;
}

- (void)markOnlyShowRedDotSessionForMessageType:(NSString *)messageType {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        for (NIMRecentSession *recentSession in [NIMSDK.sharedSDK.conversationManager allRecentSessions]) {
            if ([self onlyShowSessionRedDotForRecentSession:recentSession]) {
                NSArray<NIMMessage *> *allMessageArray = [[[NIMSDK sharedSDK] conversationManager] messagesInSession:recentSession.session message:nil limit:1000000];
                for (NIMMessage *message in allMessageArray) {
                    XLOnlyShowRedDotAttachment *attachment = [(NIMCustomObject *)message.messageObject attachment];
                    if ([attachment.type isEqualToString:messageType]) {
                        [NIMSDK.sharedSDK.conversationManager deleteMessage:message];
                    }
                }
                [self updateSessionListTopViewMessageForRecentSession:recentSession];
                break;
            }
        }
    });
}

- (void)refreshTopViewMessage {
    //刷新顶部业务红点
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *array = [NIMSDK.sharedSDK.conversationManager allRecentSessions];
        for (NIMRecentSession *recentSession in array) {
            if ([self onlyShowSessionRedDotForRecentSession:recentSession]) {
                [self updateSessionListTopViewMessageForRecentSession:recentSession];
                break;
            }
        }
    });
}

- (NSString *)messageContent:(NIMMessage*)lastMessage {
    NSString *text = @"";
    switch (lastMessage.messageType) {
            case NIMMessageTypeText:
            text = lastMessage.text;
            break;
            case NIMMessageTypeAudio:
            text = @"[语音]";
            break;
            case NIMMessageTypeImage:
            text = @"[图片]";
            break;
            case NIMMessageTypeVideo:
            text = @"[视频]";
            break;
            case NIMMessageTypeLocation:
            text = @"[位置]";
            break;
            case NIMMessageTypeNotification:{
                return [self notificationMessageContent:lastMessage];
            }
            case NIMMessageTypeFile:
            text = @"[文件]";
            break;
            case NIMMessageTypeTip:
            text = lastMessage.text;
            break;
            case NIMMessageTypeRobot:
            text = [self robotMessageContent:lastMessage];
            break;
            case NIMMessageTypeCustom:
            text = [self customMessageContent:lastMessage];
            break;
        default:
            text = @"[未知消息]";
    }
    if (lastMessage.session.sessionType == NIMSessionTypeP2P || lastMessage.messageType == NIMMessageTypeTip || [lastMessage.from isEqualToString:NIMSDK.sharedSDK.loginManager.currentAccount]) {
        return text;
    } else {
        NSString *from = lastMessage.from;
        if (lastMessage.messageType == NIMMessageTypeRobot) {
            NIMRobotObject *object = (NIMRobotObject *)lastMessage.messageObject;
            if (object.isFromRobot) {
                from = object.robotId;
            }
        }
        NSString *nickName = [NIMKitUtil showNick:from inSession:lastMessage.session];
        return nickName.length ? [nickName stringByAppendingFormat:@" : %@",text] : @"";
    }
}

#pragma mark - Private

- (void)refresh {
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadData)]) {
        [self.delegate reloadData];
    }
}

- (NSInteger)findInsertPlace:(NIMRecentSession *)recentSession {
    __block NSUInteger matchIdx = 0;
    __block BOOL find = NO;
    [self.recentSessions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NIMRecentSession *item = obj;
        if (item.lastMessage.timestamp <= recentSession.lastMessage.timestamp) {
            *stop = YES;
            find  = YES;
            matchIdx = idx;
        }
    }];
    if (find) {
        return matchIdx;
    } else {
        return self.recentSessions.count;
    }
}

- (void)sort {
    [self.recentSessions sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NIMRecentSession *item1 = obj1;
        NIMRecentSession *item2 = obj2;
        if (item1.lastMessage.timestamp < item2.lastMessage.timestamp) {
            return NSOrderedDescending;
        }
        if (item1.lastMessage.timestamp > item2.lastMessage.timestamp) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}

- (NSString *)notificationMessageContent:(NIMMessage *)lastMessage {
    NIMNotificationObject *object = lastMessage.messageObject;
    if (object.notificationType == NIMNotificationTypeNetCall) {
        NIMNetCallNotificationContent *content = (NIMNetCallNotificationContent *)object.content;
        if (content.callType == NIMNetCallTypeAudio) {
            return @"[网络通话]";
        }
        return @"[视频聊天]";
    }
    if (object.notificationType == NIMNotificationTypeTeam) {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:lastMessage.session.sessionId];
        if (team.type == NIMTeamTypeNormal) {
            return @"[讨论组信息更新]";
        } else {
            return @"[群信息更新]";
        }
    }
    return @"[未知消息]";
}

- (NSString *)robotMessageContent:(NIMMessage *)lastMessage {
    NIMRobotObject *object = lastMessage.messageObject;
    if (object.isFromRobot) {
        return @"[机器人消息]";
    } else {
        return lastMessage.text;
    }
}

- (BOOL)noDisturbSession:(NIMSession *)session {
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:session.sessionId];
    if (team.notifyStateForNewMsg == NIMTeamNotifyStateNone) {
        return YES;
    }
    return NO;
}

//用于显示粉丝、赞、评论、访客小红点逻辑
- (void)updateSessionListTopViewMessageForRecentSession:(NIMRecentSession *)recentSession {
    
    if (![self onlyShowSessionRedDotForRecentSession:recentSession]) {
        return;
    }
    
    NSArray<NIMMessage *> *allMessageArray = [[[NIMSDK sharedSDK] conversationManager] messagesInSession:recentSession.session message:nil limit:1000000];
    NSMutableArray *redDotArray = @[@"0", @"0", @"0", @"0"].mutableCopy;
    for (NIMMessage *message in allMessageArray) {
        XLOnlyShowRedDotAttachment *attachment = [(NIMCustomObject *)message.messageObject attachment];
        if ([attachment.type isEqualToString:XLMessageFans]) {
            redDotArray[0] = [NSString stringWithFormat:@"%ld", [redDotArray[0] integerValue] + 1];
        } else if ([attachment.type isEqualToString:XLMessagePraise]) {
            redDotArray[1] = [NSString stringWithFormat:@"%ld", [redDotArray[1] integerValue] + 1];
        } else if ([attachment.type isEqualToString:XLMessageComment]) {
            redDotArray[2] = [NSString stringWithFormat:@"%ld", [redDotArray[2] integerValue] + 1];
        } else if ([attachment.type isEqualToString:XLMessageVisitor]) {
            redDotArray[3] = [NSString stringWithFormat:@"%ld", [redDotArray[3] integerValue] + 1];
        } else {
            //非此四种消息，不显示红点，删除，避免未读数显示错误问题
            [NIMSDK.sharedSDK.conversationManager deleteMessage:message];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self resetBadgeCount:[redDotArray[0] integerValue] forKey:XLBadgeSessionFansKey];
        [self resetBadgeCount:[redDotArray[1] integerValue] forKey:XLBadgeSessionLikeKey];
        [self resetBadgeCount:[redDotArray[2] integerValue] forKey:XLBadgeSessionCommentKey];
        [self resetBadgeCount:[redDotArray[3] integerValue] forKey:XLBadgeSessionVisitorKey];
    });
    
}

- (NSString *)customMessageContent:(NIMMessage *)lastMessage {
    XLBaseCustomAttachment *attachment = ((NIMCustomObject *)lastMessage.messageObject).attachment;
    //注释：后加的字段，先判断有没tip，没有则客户端处理
    if (attachment.tip && attachment.tip.length != 0) {
        return attachment.tip;
    }
    switch (attachment.customMessageType) {
        case CustomMessageTypeRedPacket: {
            return @"[神段子红包]恭喜发财，大吉大利";
            break;
        }
        case CustomMessageTypeRedPacketTip: {
            
            XLRedPacketTipAttachment *attachment = [(NIMCustomObject *)lastMessage.messageObject attachment];
            
            NSString *me = NIMSDK.sharedSDK.loginManager.currentAccount;
            
            NIMKitInfo * senderInfo = [[NIMKit sharedKit] infoByUser:attachment.senderId option:nil];
            NIMKitInfo * openerInfo = [[NIMKit sharedKit] infoByUser:attachment.openerId option:nil];
            
            NSString *senderName = [attachment.senderId isEqualToString:me] ? @"你" : senderInfo.showName;
            NSString *openerName = [attachment.openerId isEqualToString:me] ? @"你" : openerInfo.showName;
            
            return [NSString stringWithFormat:@"%@领取了%@的红包", openerName, senderName];
            break;
        }
        case CustomMessageTypeGroupInvite: {
            return @"[链接]邀请你加入群聊";
            break;
        }
        case CustomMessageTypeIncomNotice: {
            XLIncomeNoticeAttachment *attachment = [(NIMCustomObject *)lastMessage.messageObject attachment];
            BOOL isIcon = [attachment.moneyType isEqualToString:@"coin"];
            if (isIcon) {
                return [NSString stringWithFormat:@"%@收入%@金币已到账", @"[金币收入]", attachment.money];
            } else {
                return [NSString stringWithFormat:@"%@昨日收入已自动转换为%@元", @"[零钱收入]", attachment.money];
            }
            break;
        }
        default:
            return @"[未知消息]";
    }
}

@end
