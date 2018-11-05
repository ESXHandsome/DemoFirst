//
//  UpgradeManager.m
//  NationalRedPacket
//
//  Created by fensi on 2018/4/20.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLUpgradeManager.h"
#import "LoginApi.h"

@interface XLUpgradeManager ()

@property (assign, nonatomic) BOOL isNeedUpgrade;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSURL *url;

@end

@implementation XLUpgradeManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{ sharedInstance = [self new]; });
    return sharedInstance;
}

#pragma mark - Public

- (void)reloadUpgradeInfo:(SuccessBlock)success failure:(FailureBlock)failure {
    
    [LoginApi checkUpdate:^(NSDictionary *responseDict) {
        
        self.isNeedUpgrade = [responseDict[@"needUpdate"] boolValue];
        self.message = responseDict[@"changeLog"] ?: @"";
        self.url = [NSURL URLWithString:responseDict[@"updateUrl"] ?: @""];
        
        if (success) {
            success(responseDict);
        }
        
    } failure:failure];
}

- (void)upgrade {

    if (self.url) {
        [[UIApplication sharedApplication] openURL:self.url];
    }
}

#pragma mark - Private

#pragma mark - Custom Accessors


@end
