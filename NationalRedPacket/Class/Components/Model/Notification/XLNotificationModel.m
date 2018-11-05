//
//  XLNotificationModel.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/7.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLNotificationModel.h"

@implementation XLNotificationModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"content" : [XLFeedModel class]};
}

@end
