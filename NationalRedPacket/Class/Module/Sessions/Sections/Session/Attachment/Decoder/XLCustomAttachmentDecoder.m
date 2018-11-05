//
//  XLCustomAttachmentDecoder.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLCustomAttachmentDecoder.h"
#import "XLRedPacketAttachment.h"
#import "XLGroupInviteAttachment.h"
#import "XLIncomeNoticeAttachment.h"
#import "XLRedPacketTipAttachment.h"
#import "XLBigPictureAttachment.h"
#import "XLTextAndPictureAttachment.h"
#import "XLGroupPicturesAttachment.h"
#import "XLMiniApplicationAttachment.h"
#import "XLOnlyShowRedDotAttachment.h"

@implementation XLCustomAttachmentDecoder

- (id<NIMCustomAttachment>)decodeAttachment:(NSString *)content {
    
    XLBaseCustomAttachment *attachment = nil;
    
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            
            NSInteger type = [dict[@"type"] integerValue];
            NSDictionary *contentDic = dict[@"data"];
            
            switch (type) {
                case CustomMessageTypeRedPacket: {
                    attachment = [XLRedPacketAttachment yy_modelWithDictionary:contentDic];
                    ((XLRedPacketAttachment *)attachment).customMessageType = CustomMessageTypeRedPacket;
                    if ([((XLRedPacketAttachment *)attachment).luckyid isEqualToString:XLLoginManager.shared.luckyId]) { //新手红包的状态单独判断处理
                        if (XLLoginManager.shared.newUserRedPacketStatus == RedPacketStatusOpened) {
                            [((XLRedPacketAttachment *)attachment) setStatus:XLLoginManager.shared.newUserRedPacketStatus];
                        }
                    }
                    break;
                }
                case CustomMessageTypeGroupInvite: {
                    attachment = [XLGroupInviteAttachment yy_modelWithDictionary:contentDic];
                    ((XLGroupInviteAttachment *)attachment).customMessageType = CustomMessageTypeGroupInvite;
                    break;
                }
                case CustomMessageTypeIncomNotice: {
                    attachment = [XLIncomeNoticeAttachment yy_modelWithDictionary:contentDic];
                    ((XLIncomeNoticeAttachment *)attachment).customMessageType = CustomMessageTypeIncomNotice;
                    break;
                }
                case CustomMessageTypeBigPicture: {
                    attachment = [XLBigPictureAttachment yy_modelWithDictionary:contentDic];
                    ((XLBigPictureAttachment *)attachment).customMessageType = CustomMessageTypeBigPicture;
                    break;
                }
                case CustomMessageTypeTextAndPicture: {
                    attachment = [XLTextAndPictureAttachment yy_modelWithDictionary:contentDic];
                    ((XLTextAndPictureAttachment *)attachment).customMessageType = CustomMessageTypeTextAndPicture;
                    break;
                }
                case CustomMessageTypeGroupPictures: {
                    attachment = [XLGroupPicturesAttachment yy_modelWithDictionary:contentDic];
                    ((XLGroupPicturesAttachment *)attachment).customMessageType = CustomMessageTypeGroupPictures;
                    break;
                }
                case CustomMessageTypeMiniApplication: {
                    attachment = [XLMiniApplicationAttachment yy_modelWithDictionary:contentDic];
                    ((XLMiniApplicationAttachment *)attachment).customMessageType = CustomMessageTypeMiniApplication;
                    break;
                }
                case CustomMessageTypeOnlyShowRedDot: {
                    attachment = [XLOnlyShowRedDotAttachment yy_modelWithDictionary:contentDic];
                    ((XLOnlyShowRedDotAttachment *)attachment).customMessageType = CustomMessageTypeOnlyShowRedDot;
                    break;
                }
                case CustomMessageTypeRedPacketTip: {
                    attachment = [XLRedPacketTipAttachment yy_modelWithDictionary:contentDic];
                    ((XLRedPacketTipAttachment *)attachment).customMessageType = CustomMessageTypeRedPacketTip;
                    break;
                }
            }
            attachment.attachmentId = dict[@"id"];
        }
    }
    return attachment;
}

@end
