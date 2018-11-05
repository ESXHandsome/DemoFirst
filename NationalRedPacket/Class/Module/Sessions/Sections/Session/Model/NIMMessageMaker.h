//
//  NIMMessageMaker.h
//  NIMKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>
#import "XLRedPacketTipAttachment.h"

@class NIMKitLocationPoint;

@interface NIMMessageMaker : NSObject

+ (NIMMessage*)msgWithText:(NSString *)text;

+ (NIMMessage *)msgWithAudio:(NSString *)filePath;

+ (NIMMessage *)msgWithImage:(UIImage *)image;

+ (NIMMessage *)msgWithImagePath:(NSString *)path;

+ (NIMMessage *)msgWithVideo:(NSString *)filePath;

+ (NIMMessage *)msgWithLocation:(NIMKitLocationPoint *)locationPoint;

+ (NIMMessage *)msgWithRobotQuery:(NSString *)text
                          toRobot:(NSString *)robotId;

+ (NIMMessage *)msgWithRobotSelect:(NSString *)text
                            target:(NSString *)target
                            params:(NSString *)params
                           toRobot:(NSString *)robotId;

+ (NIMMessage *)msgWithRedPacketTip:(XLRedPacketTipAttachment *)attachment;

+ (NIMMessage *)msgWithRedPacketLuckyId:(NSString *)luckyId content:(NSString *)content luckyTip:(NSString *)luckyTip;

@end
