//
//  XLStartConfigManager.m
//  NationalRedPacket
//
//  Created by Ying on 2018/5/29.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLStartConfigManager.h"
#import "XLStartConfigApi.h"

@implementation XLStartConfigManager

+ (instancetype)shared
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)fetchStartConfigData:(void(^)(XLStartConfigModel *model))succeed failed:(void(^)(void))failed {
    [XLStartConfigApi fetchStartConfig:^(id responseDict) {
        self.startConfigModel = [XLStartConfigModel yy_modelWithJSON:responseDict];
        if(succeed){
            succeed(self.startConfigModel);
        }
    } failure:^(NSInteger errorCode) {
        if (failed) {
            failed();
        }
    }];
}

@end
