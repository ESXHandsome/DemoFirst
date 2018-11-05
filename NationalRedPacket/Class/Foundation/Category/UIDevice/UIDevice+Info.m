//
//  UIDevice+Info.m
//  NationalRedPacket
//
//  Created by fensi on 2018/4/4.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "UIDevice+Info.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <sys/utsname.h>
#import <AdSupport/AdSupport.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <NetworkExtension/NetworkExtension.h>
#import "KeychainService.h"

@implementation UIDevice (Info)

// Wifi信息
+ (NSDictionary *)deviceWifiInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSDictionary *info = nil;
    for (NSString *ifname in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifname);
    }
    return info;
}

// 网络制式
+ (NSString *)deviceNetCarrier
{
    NSString *mobileCarrier;
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
    NSString *MCC = carrier.mobileCountryCode;
    NSString *MNC = carrier.mobileNetworkCode;
    
    if (!MCC || !MNC) {
        mobileCarrier = @"";
    } else {
        if ([MCC isEqualToString:@"460"]) {
            if ([MNC isEqualToString:@"00"]||[MNC isEqualToString:@"02"]||[MNC isEqualToString:@"07"]) {
                mobileCarrier=@"China Mobile";
            } else if ([MNC isEqualToString:@"01"]||[MNC isEqualToString:@"06"]) {
                mobileCarrier=@"China Unicom";
            } else if ([MNC isEqualToString:@"03"]||[MNC isEqualToString:@"05"]||[MNC isEqualToString:@"11"]) {
                mobileCarrier=@"China Telecom";
            } else if ([MNC isEqualToString:@"20"]) {
                mobileCarrier=@"China Tietong";
            } else {
                mobileCarrier=[NSString stringWithFormat:@"MNC%@",MNC];
            }
        } else {
            mobileCarrier=@"Foreign Carrier";
        }
    }
    return mobileCarrier;
}

// 获取设备网络状态
+ (NSString *)deviceNetWorkStatus
{
    UIApplication *app = [UIApplication sharedApplication];
    int type = 0;
    if (!IS_IPHONE_X) {  // 非iPhone X
        NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
        for (id child in children) {
            if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
                type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            }
        }
    } else {  //iPhone X
        NSArray *array = [[[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
        NSArray *children = [array[2] subviews];
        for (id child in children) {
            if ([child isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                type = 5;
            } else if ([child isKindOfClass:NSClassFromString(@"_UIStatusBarStringView")]){
                return [child valueForKeyPath:@"originalText"];
            }
        }
    }
    
    switch (type) {
        case 1:
            return @"2G";
        case 2:
            return @"3G";
        case 3:
            return @"4G";
        case 5:
            return @"WIFI";
        default:
            return @"UNKNOWN";//代表未知网络
    }
}

// 设备类型
+ (NSString *)deviceType {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
}

+ (NSString *)nameForDeviceType:(NSString *)deviceType {
    
    static NSDictionary *deviceNamesByCode = nil;
    
    if (!deviceNamesByCode) {
        
        deviceNamesByCode = @{@"i386"      : @"Simulator",
                              @"x86_64"    : @"Simulator",
                              @"iPod1,1"   : @"iPod Touch",        // (Original)
                              @"iPod2,1"   : @"iPod Touch",        // (Second Generation)
                              @"iPod3,1"   : @"iPod Touch",        // (Third Generation)
                              @"iPod4,1"   : @"iPod Touch",        // (Fourth Generation)
                              @"iPod7,1"   : @"iPod Touch",        // (6th Generation)
                              @"iPhone1,1" : @"iPhone",            // (Original)
                              @"iPhone1,2" : @"iPhone",            // (3G)
                              @"iPhone2,1" : @"iPhone",            // (3GS)
                              @"iPad1,1"   : @"iPad",              // (Original)
                              @"iPad2,1"   : @"iPad 2",            //
                              @"iPad3,1"   : @"iPad",              // (3rd Generation)
                              @"iPhone3,1" : @"iPhone 4",          // (GSM)
                              @"iPhone3,3" : @"iPhone 4",          // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" : @"iPhone 4S",         //
                              @"iPhone5,1" : @"iPhone 5",          // (model A1428, AT&T/Canada)
                              @"iPhone5,2" : @"iPhone 5",          // (model A1429, everything else)
                              @"iPad3,4"   : @"iPad",              // (4th Generation)
                              @"iPad2,5"   : @"iPad Mini",         // (Original)
                              @"iPhone5,3" : @"iPhone 5c",         // (model A1456, A1532 | GSM)
                              @"iPhone5,4" : @"iPhone 5c",         // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" : @"iPhone 5s",         // (model A1433, A1533 | GSM)
                              @"iPhone6,2" : @"iPhone 5s",         // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" : @"iPhone 6 Plus",     //
                              @"iPhone7,2" : @"iPhone 6",          //
                              @"iPhone8,1" : @"iPhone 6S",         //
                              @"iPhone8,2" : @"iPhone 6S Plus",    //
                              @"iPhone8,4" : @"iPhone SE",         //
                              @"iPhone9,1" : @"iPhone 7",          //
                              @"iPhone9,3" : @"iPhone 7",          //
                              @"iPhone9,2" : @"iPhone 7 Plus",     //
                              @"iPhone9,4" : @"iPhone 7 Plus",     //
                              @"iPhone10,1": @"iPhone 8",          // CDMA
                              @"iPhone10,4": @"iPhone 8",          // GSM
                              @"iPhone10,2": @"iPhone 8 Plus",     // CDMA
                              @"iPhone10,5": @"iPhone 8 Plus",     // GSM
                              @"iPhone10,3": @"iPhone X",          // CDMA
                              @"iPhone10,6": @"iPhone X",          // GSM
                              
                              @"iPad4,1"   : @"iPad Air",          // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2"   : @"iPad Air",          // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,4"   : @"iPad Mini",         // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5"   : @"iPad Mini",         // (2nd Generation iPad Mini - Cellular)
                              @"iPad4,7"   : @"iPad Mini",         // (3rd Generation iPad Mini - Wifi (model A1599))
                              @"iPad6,7"   : @"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1584)
                              @"iPad6,8"   : @"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1652)
                              @"iPad6,3"   : @"iPad Pro (9.7\")",  // iPad Pro 9.7 inches - (model A1673)
                              @"iPad6,4"   : @"iPad Pro (9.7\")"   // iPad Pro 9.7 inches - (models A1674 and A1675)
                              };
    }
    
    NSString *deviceName = [deviceNamesByCode objectForKey:deviceType];
    
    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:
        
        if ([deviceType rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([deviceType rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([deviceType rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
        else {
            deviceName = @"Unknown";
        }
    }
    
    return deviceName;
}

+ (NSString *)idfa {
    return ASIdentifierManager.sharedManager.advertisingIdentifier.UUIDString;
}

+ (NSString *)keychainIDFA {
    
    NSString *key = @"keychainIDFA";
    NSString *keychainIDFA = [KeychainService itemForKey:key];
    
    //初始没有值时，取出设备的idfa，存入钥匙串中
    if (keychainIDFA == nil) {
        keychainIDFA = UIDevice.idfa;
        //如果开启了限制广告跟踪，idfa为"00000000-0000-0000-0000-000000000000"，改用uuid
        if ([keychainIDFA containsString:@"00000000-"]) {
            keychainIDFA = UIDevice.uuid;
        }
        [KeychainService setItem:keychainIDFA forKey:key];
    }
    
    return keychainIDFA;
}

+ (NSString *)uuid {
    return NSUUID.UUID.UUIDString;
}

@end
