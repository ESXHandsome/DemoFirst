//
//  StatModel.m
//  StatProject
//
//  Created by 刘永杰 on 2017/12/29.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "StatModel.h"
#import "StatServiceApi.h"
#import "HttpCommonParam.h"

@implementation StatModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.user_id = [StatServiceApi sharedService].userId ?: XLLoginManager.shared.userId;
        self.device_id = UIDevice.keychainIDFA;
        self.refer = [StatServiceApi sharedService].refer ?: APP_REFER;
        self.version = NSBundle.appVersionNumber;
        self.system = @"2";
        self.account = HttpCommonParam.userAccount;
        self.created_at = [NSString stringWithFormat:@"%ld", time(0)];
    }
    return self;
}

@end
