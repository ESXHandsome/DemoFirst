//
//  XLNIMService.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/25.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLNIMService.h"
#import "XLNIMConst.h"
#import "XLCustomAttachmentDecoder.h"
#import "HttpCommonParam.h"
#import "NIMMessageMaker.h"
#import "UIDevice+Info.h"
#import "XLStartConfigManager.h"
#import "NIMInputEmoticonManager.h"

@interface XLNIMService ()

@property (copy, nonatomic) NSString *account;
@property (copy, nonatomic) NSString *token;

@end

@implementation XLNIMService

@synthesize account = _account;
@synthesize token = _token;

+ (instancetype)shared {
    
    static dispatch_once_t onceToken;
    static XLNIMService *service;
    dispatch_once(&onceToken, ^{
        service = [XLNIMService new];
    });
    return service;
}

- (void)initNIMSDKConfig {
    
    //设置为NO，避免云信自动将HTTP链接转换为HTTPS
    NIMSDKConfig.sharedConfig.enabledHttpsForMessage = NO;
    NIMSDKConfig.sharedConfig.enabledHttpsForInfo = NO;
    
    NIMSDKConfig.sharedConfig.shouldCountTeamNotification = YES;
    NIMSDKConfig.sharedConfig.shouldSyncUnreadCount = YES;
    
    //注册云信APPKey、推送证书名称
    [NIMSDK.sharedSDK registerWithAppID:XLNIMAppKey cerName:XLNIMAPNSCertificateName];
    
    //自定义消息解析器
    [NIMCustomObject registerCustomDecoder:[XLCustomAttachmentDecoder new]];
    
    [NIMInputEmoticonManager sharedManager];

}

- (void)loginNIMAccount:(NSString *)account token:(NSString *)token success:(void(^)(void))success failure:(void(^)(void))failure {
    
    self.account = account;
    self.token = token;
    
    [NIMSDK.sharedSDK.loginManager login:account token:token completion:^(NSError * _Nullable error) {
        if (error == nil) {
            XLLog(@"云信登录成功");
            if (success) {
                success();
            }
        } else {
            XLLog(@"云信登录失败%ld\nAccount:%@\nToken:%@", error.code, self.account, self.token);
            if (failure) {
                failure();
            }
            [self resetLoginStatus];
            [self autoLogin];
        }
    }];
    
}

- (void)autoLogin {
    
    NIMAutoLoginData *loginData = [NIMAutoLoginData new];
    loginData.account = self.account;
    loginData.token = self.token;
    if (self.isVisitorLogin) {
        XLLog(@"已退出登录，或从未登录过的用户");
        //本地没有信息存储
        //使用游客身份登录，登录的目的是可以使用本地数据库
        loginData.account = self.visitorAccount;
        loginData.token = self.visitorAccount;
    }
    [NIMSDK.sharedSDK.loginManager autoLogin:loginData];
    
    if (self.isVisitorLogin) {
        [self manuallyAddSessionAndMessage];
    }
}

- (void)configNIMAccount:(NSString *)account token:(NSString *)token {
    if (account && account.length != 0) {
        self.account = account;
    }
    if (token && token.length != 0) {
        self.token = token;
    }
}

- (void)logout {
    
    /*登出操作:
     1.云信自动清理当前用户本地保存的数据
     2.进行 APNs 推送信息的解绑操作
     */
    [NIMSDK.sharedSDK.loginManager logout:nil];
    
    [self resetLoginStatus];
    
}

- (void)resetLoginStatus {
    
    self.account = nil;
    self.token = nil;
}

#pragma mark - Setter

- (void)setAccount:(NSString *)account {
    
    _account = account;
    
    if (account == nil) {
        [NSUserDefaults.standardUserDefaults removeObjectForKey:XLUserDefaultsNIMAccount];
    } else {
        [NSUserDefaults.standardUserDefaults setValue:account forKey:XLUserDefaultsNIMAccount];
    }
    
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)setToken:(NSString *)token {
    
    _token = token;
    
    if (token == nil) {
        [NSUserDefaults.standardUserDefaults removeObjectForKey:XLUserDefaultsNIMToken];
    } else {
        [NSUserDefaults.standardUserDefaults setValue:token forKey:XLUserDefaultsNIMToken];
    }
    
    [NSUserDefaults.standardUserDefaults synchronize];
}

#pragma mark - Getter

- (NSString *)account {
    return [NSUserDefaults.standardUserDefaults stringForKey:XLUserDefaultsNIMAccount];
}

- (NSString *)token {
    return [NSUserDefaults.standardUserDefaults stringForKey:XLUserDefaultsNIMToken];
}

- (BOOL)isLogined {
    return NIMSDK.sharedSDK.loginManager.isLogined;
}

- (BOOL)isVisitorLogin {
    return !((self.account && self.token) && (self.account.length != 0 && self.token.length != 0));
}

- (NSString *)visitorAccount {
    //游客账户以iosLogin返回的userid作为游客的云信本地用户
    //不可使用 设备IDFA 和 UUID ，为保证userId变更时新消息就要收到
    return XLLoginManager.shared.userId ?: @"";
}

#pragma mark - Private

/**
 手动添加会话及会话消息
 */
- (void)manuallyAddSessionAndMessage {
    
    //对于同一个游客用户，已经发过假消息，不得再次重复发送
    if ([[NSUserDefaults.standardUserDefaults objectForKey:self.visitorAccount] isEqualToString:@"YES"]) {
        return;
    }
    
    XLStartConfigModel *configModel = XLStartConfigManager.shared.startConfigModel;
    
    //私聊大V
    NIMSession *vSession = [self recentSessionWithNickname:configModel.vNickname];

    NIMMessage *message = [NIMMessageMaker msgWithText:configModel.vMsg];
    message.from = configModel.vNickname;
    
    NIMMessage *redPacketMessage = [NIMMessageMaker msgWithRedPacketLuckyId:configModel.luckyid content:configModel.luckymoneyText luckyTip:configModel.luckymoneyTip];
    redPacketMessage.from = configModel.vNickname;
    
    [self saveMessage:redPacketMessage forSession:vSession];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self saveMessage:message forSession:vSession];
    });
    
    //私聊客服
    NIMSession *cSession = [self recentSessionWithNickname:configModel.cNickname];
    
    NIMMessage *cMessage = [NIMMessageMaker msgWithText:configModel.cMsg];
    cMessage.from = configModel.cNickname;
    
    [self saveMessage:cMessage forSession:cSession];
    
    [NSUserDefaults.standardUserDefaults setObject:@"YES" forKey:self.visitorAccount];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)saveMessage:(NIMMessage *)message forSession:(NIMSession *)session {
    
    [NIMSDK.sharedSDK.conversationManager saveMessage:message forSession:session completion:^(NSError * _Nullable error) {
        XLLog(@"%@", error);
    }];
}

- (NIMSession *)recentSessionWithNickname:(NSString *)nickname {
    
    NIMRecentSession *recent = [NIMRecentSession new];
    NIMSession *session = [NIMSession session:nickname type:NIMSessionTypeP2P];
    [recent setValue:session forKey:@"_session"];
    return session;
    
}

@end
