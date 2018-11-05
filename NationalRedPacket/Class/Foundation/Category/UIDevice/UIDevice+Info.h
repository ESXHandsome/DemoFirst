//
//  UIDevice+Info.h
//  NationalRedPacket
//
//  Created by fensi on 2018/4/4.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Info)

/**
 Wifi信息
 */
+ (NSDictionary *)deviceWifiInfo;

/**
 网络制式
 */
+ (NSString *)deviceNetCarrier;

/**
 获取设备网络状态
 */
+ (NSString *)deviceNetWorkStatus;

/**
 设备类型
 */
+ (NSString *)deviceType;

/**
 根据设备类型获取设备名称

 @param deviceType 设备类型
 @return 设备名称
 */
+ (NSString *)nameForDeviceType:(NSString *)deviceType;

/**
 IDFA
 */
+ (NSString *)idfa;

/**
 keychainIDFA

 @return 钥匙串的存储的IDFA
 */
+ (NSString *)keychainIDFA;

/**
 UUID
 */
+ (NSString *)uuid;

@end
