//
//  XLStartConfigManager.h
//  NationalRedPacket
//
//  Created by Ying on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLStartConfigApi.h"
#import "XLStartConfigModel.h"

@interface XLStartConfigManager : NSObject

@property (strong, nonatomic) XLStartConfigModel *startConfigModel;
+ (instancetype)shared;
- (void)fetchStartConfigData:(void(^)(XLStartConfigModel *model))succeed failed:(void(^)(void))failed;
@end
