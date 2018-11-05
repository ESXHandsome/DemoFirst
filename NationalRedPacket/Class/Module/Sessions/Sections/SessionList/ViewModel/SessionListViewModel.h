//
//  SessionListViewModel.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/5/28.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLCustomNotificationModel.h"

static NSString *const XLMessageFans     = @"new_fans";
static NSString *const XLMessagePraise   = @"new_praise";
static NSString *const XLMessageComment  = @"new_comment";
static NSString *const XLMessageVisitor  = @"new_visitor";

@protocol SessionListViewModelDelegate <NSObject>

- (void)reloadData;

@end

@interface SessionListViewModel : NSObject

/**
 *  最近会话集合
 */
@property (strong, nonatomic) NSMutableArray *recentSessions;

@property (weak, nonatomic) id<SessionListViewModelDelegate> delegate;

/**
 *  自定义最近会话排序，上层可以重写这个方法对最近会话重新排序
 */
- (NSMutableArray *)customSortRecents:(NSMutableArray *)recentSessions;

- (NSString *)messageContent:(NIMMessage*)lastMessage;

/**
 *  cell显示的会话名
 *
 *  @param recent 最近会话
 *
 *  @return 会话名
 *
 *  @discussion 默认实现为：点对点会话，显示聊天对象的昵称(没有昵称则显示账号)；群聊会话，显示群名称。
 */
- (NSString *)nameForRecentSession:(NIMRecentSession *)recent;

/**
 *  cell显示的最近会话具体内容
 *
 *  @param recent 最近会话
 *
 *  @return 具体内容名
 *
 *  @discussion 默认实现为：显示最近一条消息的内容，文本消息则显示文本信息，其他类型消息详见本类中 - (NSAttributedString *)messageContent:(NIMMessage *)lastMessage 方法的实现。
 */
- (NSAttributedString *)contentForRecentSession:(NIMRecentSession *)recent;

/**
 *  cell显示的最近会话时间戳
 *
 *  @param recent 最近会话
 *
 *  @return 时间戳格式化后的字符串
 *
 *  @discussion 默认实现为：最后一条消息的时间戳，具体时间戳消息格式详见NIMKitUtil中， + (NSString*)showTime:(NSTimeInterval) msglastTime showDetail:(BOOL)showDetail 方法的实现。
 */
- (NSString *)timestampDescriptionForRecentSession:(NIMRecentSession *)recent;

/**
 回复是否是仅仅显示红点作用

 @param recentSession recentSession
 @return yes/no
 */
- (BOOL)onlyShowSessionRedDotForRecentSession:(NIMRecentSession *)recentSession;

/**
 标记粉丝、赞、评论、访客已读

 @param messageType 消息类型（粉丝、赞、评论、访客）
 */
- (void)markOnlyShowRedDotSessionForMessageType:(NSString *)messageType;

/**
 刷新顶部粉丝、赞、评论、访客红点消息
 */
- (void)refreshTopViewMessage;

@end
