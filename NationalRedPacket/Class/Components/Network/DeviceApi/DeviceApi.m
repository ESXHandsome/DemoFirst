//
//  DeviceInfoCollectionApi.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/17.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "DeviceApi.h"
#import "NSDate+Timestamp.h"

#define URL_USER_DEVICE_INFO   URL_BASE@"/Tool/setMovmentUserInfo"

@implementation DeviceApi

+ (void)uploadUserDeviceInfoIsLaunchAPP:(BOOL)isLaunchAPP
{
    //上传设备信息
    [self httpRequestWithURL:URL_USER_DEVICE_INFO
                   withParam:@{@"time"     : [NSDate timestamp],
                               @"network"  : [UIDevice deviceNetWorkStatus],
                               @"sim"      : [UIDevice deviceNetCarrier],
                               @"status"   : isLaunchAPP ? @"open" : @"close"
                               }
                     success:nil failure:nil];

}

@end
