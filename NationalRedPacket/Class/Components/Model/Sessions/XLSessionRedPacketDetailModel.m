//
//  RedPacketDetailModel.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLSessionRedPacketDetailModel.h"
#import "XLRedPacketDetailUserModel.h"

@implementation XLSessionRedPacketDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"detail" : [XLRedPacketDetailUserModel class]
             };
}

@end
