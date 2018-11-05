//
//  SessionViewModel.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLSessionViewModel.h"
#import "RedPacketApi.h"
#import "XLSessionRedPacketDetailModel.h"
#import "XLSessionRedPacketWaitOpenModel.h"
#import "XLRedPacketAttachment.h"

@implementation XLSessionViewModel

/**
 打开群红包之前，检测红包状态
 */
- (void)fetchRedPacketStateWithMessage:(NIMMessage *)message
                               success:(SuccessBlock)success
                               failure:(FailureBlock)failure {
    
    // 群组
    if (message.session.sessionType == NIMSessionTypeTeam) {
        [self checkTeamRedPacketStateWithMessage:message success:success failure:failure];
    } else if (message.session.sessionType == NIMSessionTypeP2P) { // 点对点
        [self checkFocusRedPacketStateWithMessage:message success:success failure:failure];
    }
   
}

/**
 开红包
 */
- (void)grabRedPacketWithMessage:(NIMMessage *)message
                          success:(SuccessBlock)success
                          failure:(FailureBlock)failure {
    // 群组
    if (message.session.sessionType == NIMSessionTypeTeam) {
        [self grabTeamRedPacketWithMessage:message success:success failure:failure];
    } else if (message.session.sessionType == NIMSessionTypeP2P) { // 点对点
        [self grabFocusRedPacketWithMessage:message success:success failure:failure];
    }
}

/**
 获取群红包详情
 */
- (void)fetchRedPacketDetailWithMessage:(NIMMessage *)message
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure {
    // 群组
    if (message.session.sessionType == NIMSessionTypeTeam) {
        [self fetchTeamRedPacketDetailWithMessage:message success:success failure:failure];
    } else if (message.session.sessionType == NIMSessionTypeP2P) { // 点对点
        [self fetchFocusRedPacketDetailWithMessage:message success:success failure:failure];
    }
}

#pragma mark - Private

/**
 检查群红包状态
 */
- (void)checkTeamRedPacketStateWithMessage:(NIMMessage *)message
                                   success:(SuccessBlock)success
                                   failure:(FailureBlock)failure {
  
    XLRedPacketAttachment *attachment = ((NIMCustomObject *)message.messageObject).attachment;
    NSString *packetID = attachment.luckyid;
    NSString *teamID = message.session.sessionId;
    
    [RedPacketApi fetchTeamRedPacketStateWithPacketID:packetID teamID:teamID success:^(NSDictionary *responseDict) {

        XLSessionRedPacketWaitOpenModel *openModel = [XLSessionRedPacketWaitOpenModel yy_modelWithJSON:responseDict];
        
        if (success) {
            success(openModel);
        }
        
    } failure:failure];
}

/**
 检查关注红包状态
 */
- (void)checkFocusRedPacketStateWithMessage:(NIMMessage *)message
                                    success:(SuccessBlock)success
                                    failure:(FailureBlock)failure {
    XLRedPacketAttachment *attachment = ((NIMCustomObject *)message.messageObject).attachment;
    NSString *packetID = attachment.luckyid;

    [RedPacketApi fetchFocusRedPacketDetailWithPacketID:packetID action:@"check" success:^(id responseDict) {
        
        XLSessionRedPacketWaitOpenModel *openModel = [XLSessionRedPacketWaitOpenModel yy_modelWithJSON:responseDict];
        
        if (success) {
            success(openModel);
        }
        
    } failure:failure];
}

/**
 开群红包
 */
- (void)grabTeamRedPacketWithMessage:(NIMMessage *)message success:(SuccessBlock)success failure:(FailureBlock)failure {
   
    XLRedPacketAttachment *attachment = ((NIMCustomObject *)message.messageObject).attachment;
    NSString *packetID = attachment.luckyid;
    NSString *teamID = message.session.sessionId;

    [RedPacketApi grabTeamRedPacketWithPacketID:packetID teamID:teamID success:^(NSDictionary *responseDict) {

//        XLSessionRedPacketDetailModel *detailModel = [XLSessionRedPacketDetailModel yy_modelWithJSON:responseDict];
        
//        if (detailModel.status == XLRedPacketStateNormal) {
            if (success) {
                success(responseDict);
            }
//        } else {
//            XLSessionRedPacketWaitOpenModel *openModel = [XLSessionRedPacketWaitOpenModel yy_modelWithJSON:responseDict];
//        openModel.status = XLRedPacketStateDeliveryFinished;
//            if (success) {
//                success(openModel);
//            }
//        }
    } failure:failure];
}

/**
 开关注红包
 */
- (void)grabFocusRedPacketWithMessage:(NIMMessage *)message success:(SuccessBlock)success failure:(FailureBlock)failure {
    XLRedPacketAttachment *attachment = ((NIMCustomObject *)message.messageObject).attachment;
    NSString *packetID = attachment.luckyid;
    
    [RedPacketApi fetchFocusRedPacketDetailWithPacketID:packetID action:@"get" success:^(id responseDict) {
        
        if (success) {
            success(responseDict);
        }
        
    } failure:failure];
}

/**
 获取群红包详情
 */
- (void)fetchTeamRedPacketDetailWithMessage:(NIMMessage *)message success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    XLRedPacketAttachment *attachment = ((NIMCustomObject *)message.messageObject).attachment;
    NSString *packetID = attachment.luckyid;
    NSString *teamID = message.session.sessionId;

    [RedPacketApi fetchTeamRedPacketDetailWithPacketID:packetID teamID:teamID success:^(id responseDict) {

        XLSessionRedPacketDetailModel *detailModel = [XLSessionRedPacketDetailModel yy_modelWithJSON:responseDict];

        if (success) {
            success(detailModel);
        }
    } failure:failure];
}

/**
 获取关注红包详情
 */
- (void)fetchFocusRedPacketDetailWithMessage:(NIMMessage *)message success:(SuccessBlock)success failure:(FailureBlock)failure {

    XLRedPacketAttachment *attachment = ((NIMCustomObject *)message.messageObject).attachment;
    NSString *packetID = attachment.luckyid;

    [RedPacketApi fetchFocusRedPacketDetailWithPacketID:packetID action:@"detail" success:^(id responseDict) {
        
        XLSessionRedPacketDetailModel *detailModel = [XLSessionRedPacketDetailModel yy_modelWithJSON:responseDict];
        
        if (success) {
            success(detailModel);
        }
        
    } failure:failure];
}

/**
 获取跳转群ID
 */
- (void)fetchJumpTeamIDWithType:(NSString *)type
                        Success:(SuccessBlock)success
                       failure:(FailureBlock)failure {
    [RedPacketApi fetchJumpTeamIDWithType:type Success:^(id responseDict) {
        if (success) {
            success(responseDict);
        }
    } failure:failure];
}

/**
 根据错误码获取红包状态
 */
- (XLRedPacketState)redPacketStateForStatusCode:(NSInteger)status {
   // 红包状态，0:可抢;1:已抢完;2:超时;3:已抢过;4:其它错误
   if (status == 0) {
        return XLRedPacketStateNormal;
        
    } else if (status == 1) {
        return XLRedPacketStateReceived;
        
    } else if (status == 2) {
        return XLRedPacketStateExpired;
        
    }  else if (status == 3) {
        return XLRedPacketStateDeliveryFinished;
        
    } else {
        return XLRedPacketStateError;
  
    }
}

@end
