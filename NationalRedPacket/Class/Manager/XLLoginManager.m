//
//  LoginManager.m
//  NationalRedPacket
//
//  Created by fensi on 2018/4/9.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLLoginManager.h"
#import "LoginApi.h"
#import "NewsApi.h"
#import "XLPublisherDataSource.h"
#import "AppDelegate.h"

@interface XLLoginManager ()

@property (assign, nonatomic) LoginState state;
@property (strong, nonatomic) NSString *UUID;
@property (strong, nonatomic) NSString *serverToken;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *luckyId;

@property (strong, nonatomic) NSString *thirdpartyOpenId;
@property (strong, nonatomic) NSString *thirdpartyAccessToken;
@property (strong, nonatomic) NSString *thirdpartyPlatform;

@end

@implementation XLLoginManager

@synthesize UUID = _UUID;
@synthesize userInfo = _userInfo;
@synthesize thirdpartyOpenId = _thirdpartyOpenId;
@synthesize thirdpartyAccessToken = _thirdpartyAccessToken;
@synthesize thirdpartyPlatform = _thirdpartyPlatform;

#pragma mark - Class Method

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static XLLoginManager *sharedInstance;
    dispatch_once(&onceToken, ^{ sharedInstance = [self new]; });
    return sharedInstance;
}

#pragma mark - Intialize

- (instancetype)init {
    self = [super init];
    if (self) {
        _state = LoginStateInitial;
        _UUID = [NSUserDefaults.standardUserDefaults stringForKey:XLUserDefaultsUUIDKey];
        _userId = [NSUserDefaults.standardUserDefaults stringForKey:XLUserDefaultsUserIdKey];
        _thirdpartyOpenId = [NSUserDefaults.standardUserDefaults stringForKey:XLUserDefaultsThirdpartyOpenIdKey];
        _thirdpartyAccessToken = [NSUserDefaults.standardUserDefaults stringForKey:XLUserDefaultsThirdpartyAccessTokenKey];
        _thirdpartyPlatform = [NSUserDefaults.standardUserDefaults stringForKey:XLUserDefaultsThirdpartyPlatformKey];
    }
    return self;
}

#pragma mark - Public Property

- (BOOL)isVisitorLogined {

    switch (self.state) {
        case LoginStateInitial:
            return NO;
        case LoginStateVisitor:
            return YES;
        case LoginStateAccount:
            return YES;
        case LoginStateAccountNoServer:
            return NO;
    }
}

- (BOOL)isAccountLogined {
    
    switch (self.state) {
        case LoginStateInitial:
            return NO;
        case LoginStateVisitor:
            return NO;
        case LoginStateAccount:
            return YES;
        case LoginStateAccountNoServer:
            return YES;
    }
}

- (NSString *)UUID {
    
    if (_UUID == nil) {
        [self setUUID:NSUUID.UUID.UUIDString];
    }
    
    return _UUID;
}

- (void)setUUID:(NSString *)UUID {
    
    _UUID = UUID;
    
    if (UUID == nil) {
        [NSUserDefaults.standardUserDefaults removeObjectForKey:XLUserDefaultsUUIDKey];
    } else {
        [NSUserDefaults.standardUserDefaults setValue:UUID forKey:XLUserDefaultsUUIDKey];
    }
    
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)setUserId:(NSString *)userId {
    
    _userId = userId;
    
    if (userId == nil) {
        [NSUserDefaults.standardUserDefaults removeObjectForKey:XLUserDefaultsUserIdKey];
    } else {
        [NSUserDefaults.standardUserDefaults setValue:userId forKey:XLUserDefaultsUserIdKey];
    }
    
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (UserInfoModel *)userInfo {
    
    if (_userInfo == nil) {
        
        NSString *filePath = self.userInfoFilePath;
        
        if ([NSFileManager.defaultManager fileExistsAtPath:filePath]) {
            id keyValues = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
            _userInfo = [UserInfoModel yy_modelWithJSON:keyValues];
        }
    }
    
    return _userInfo;
}

- (void)setUserInfo:(UserInfoModel *)userInfo {
    
    _userInfo = userInfo;
    
    if (userInfo == nil) {
        [NSFileManager.defaultManager removeItemAtPath:self.userInfoFilePath error:nil];
    } else {
        [NSKeyedArchiver archiveRootObject:userInfo.yy_modelToJSONObject
                                    toFile:self.userInfoFilePath];
    }
}

#pragma mark - Private Property

- (void)setThirdpartyOpenId:(NSString *)thirdpartyOpenId {
    
    _thirdpartyOpenId = thirdpartyOpenId;
    
    if (thirdpartyOpenId == nil) {
        [NSUserDefaults.standardUserDefaults removeObjectForKey:XLUserDefaultsThirdpartyOpenIdKey];
    } else {
        [NSUserDefaults.standardUserDefaults setValue:thirdpartyOpenId forKey:XLUserDefaultsThirdpartyOpenIdKey];
    }
}

- (void)setThirdpartyAccessToken:(NSString *)thirdpartyAccessToken {

    _thirdpartyAccessToken = thirdpartyAccessToken;
    
    if (thirdpartyAccessToken == nil) {
        [NSUserDefaults.standardUserDefaults removeObjectForKey:XLUserDefaultsThirdpartyAccessTokenKey];
    } else {
        [NSUserDefaults.standardUserDefaults setValue:thirdpartyAccessToken forKey:XLUserDefaultsThirdpartyAccessTokenKey];
    }
}

- (void)setThirdpartyPlatform:(NSString *)thirdpartyPlatform {
    
    _thirdpartyPlatform = thirdpartyPlatform;
    
    if (thirdpartyPlatform == nil) {
        [NSUserDefaults.standardUserDefaults removeObjectForKey:XLUserDefaultsThirdpartyPlatformKey];
    } else {
        [NSUserDefaults.standardUserDefaults setValue:thirdpartyPlatform forKey:XLUserDefaultsThirdpartyPlatformKey];
    }
}

- (NSString *)userInfoFilePath {
    
    NSString *diskStr = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES)[0];
    
    return [diskStr stringByAppendingString:@"userInfo.plist"];
}

#pragma mark - Public Method

- (void)loginWithThirdpartyPlatform:(NSString *)platform openId:(NSString *)openId accessToken:(NSString *)accessToken success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    [LoginApi requestUserLoginWithThirdpartyOpenId:openId accessToken:accessToken success:^(id responseDict) {
        
        self.userId = responseDict[@"userId"] ?: @"";
        self.luckyId = responseDict[@"luckyid"] ?: @"";
        self.thirdpartyOpenId = openId;
        self.thirdpartyAccessToken = accessToken;
        self.thirdpartyPlatform = platform;
        XLLog(@"当前登录的用户：%@", self.userId);

        // 设置登录状态
        if ([NSString isBlankString:openId] || [NSString isBlankString:accessToken]) {
            self.state = LoginStateVisitor;
        } else {
            self.state = LoginStateAccount;
        }
        
        void(^validSuccess)(id) = ^(id res) {
            if (success) {
                success(responseDict);
            }
        };
        
        // 需要加载新的用户信息
        [self reloadUserInfo:validSuccess failure:^(NSInteger errorCode) {
            validSuccess(responseDict);
        }];
        
        // 需要加载新用户的关注人列表
        [self reloadFollowingList];
        
        // 需要重新初始化统计服务
        [StatServiceApi initWithStatUserId:responseDict[@"userId"] refer:APP_REFER];
        
    } failure:^(NSInteger errorCode) {
        // 接口请求失败了，但是微信已经登录过了
        if (![NSString isBlankString:openId] && ![NSString isBlankString:accessToken]) {
            self.state = LoginStateAccountNoServer;
        } else {
            self.state = LoginStateInitial;
        }
        if (failure) {
            failure(errorCode);
        }
    }];
}

- (void)relogin:(SuccessBlock)success failure:(FailureBlock)failure {
    
    [self reloadServerToken:^(NSString * _Nonnull token) {
        
        [self loginWithThirdpartyPlatform:self.thirdpartyPlatform
                                   openId:self.thirdpartyOpenId
                              accessToken:self.thirdpartyAccessToken
                                  success:success
                                  failure:failure];

    } failure:failure];
}

- (void)logoutWithIsEnforce:(BOOL)isEnforce success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    void(^logout)(id) = ^(id responseDict) {
        
        [self resetLoginStatus];
        
        //云信退出
        [XLNIMService.shared logout];
        
        [StatServiceApi statEvent:USER_QUIT_LOGIN];
        
        [self relogin:success
              failure:^(NSInteger errorCode) { if (success) { success(@{}); }}];
    };
    
    if (isEnforce) {
        
        logout(nil);
        
    } else {
    
        [LoginApi requestUserLogout:^(id responseDict) { logout(responseDict); }
                            failure:failure];

    }
}

- (void)resetLoginStatus {
    
    self.state = LoginStateInitial;
    self.UUID = nil;
    self.userInfo = nil;
    self.thirdpartyOpenId = nil;
    self.thirdpartyAccessToken = nil;
}

- (void)networkErrorHandlerWithErrorCode:(NSInteger)errorCode result:(NSDictionary *)result {
    
    UIViewController *topVC = UIViewController.currentViewController;
    
    if ([topVC isKindOfClass:UIAlertController.class]) {
        return;
    }
    
    if ([topVC isKindOfClass:RTContainerController.class] &&
        [[(RTContainerController *)topVC contentViewController] isKindOfClass:LoginViewController.class]) {
        return;
    }
    
    if (errorCode == NetworkIllegalAccountCode || errorCode == NetworkAccountPermanentBan) {
        
        NSString *message = errorCode == NetworkIllegalAccountCode ? @"对不起，你的「神段子」账号出现异常。" : @"对不起，因发布违规内容，您的账号已被管理员永久封禁";
        [topVC showAlertWithTitle:@"登录异常" message:message actionTitles:@[@"我知道了"] actionHandler:^(NSInteger index) {
            exit(0);
        }];
        
    } else if (errorCode == NetworkNeedReloginThirdpartyCode) {
        
        [topVC showAlertWithTitle:@"登录过期" message:@"你的「神段子」账号登录失效，请重新登录，获取你的账号信息." actionTitles:@[@"我知道了"] actionHandler:^(NSInteger index) {
            [LoginViewController showLoginVCFromSource:LoginSourceTypeNetworkError];
        }];
        
    } else if (errorCode == NetworkAccountRemoteLoginCode) {
        
        NSString *registerAt = result[@"registerAt"] ?: @"";
        NSString *deviceName = [UIDevice nameForDeviceType:result[@"model"] ?: @""];
        NSString *message = [NSString stringWithFormat:@"你的「神段子」账号于%@在设备“%@”登录，如非本人操作，请重新登录。", registerAt, deviceName];
        
        [topVC showAlertWithTitle:@"登录异常" message:message actionTitles:@[@"我知道了"] actionHandler:^(NSInteger index) {
            [LoginViewController showLoginVCFromSource:LoginSourceTypeNetworkError];
        }];
        
    }
}

#pragma mark - Private Method

- (void)reloadUserInfo:(void (^)(UserInfoModel *))success failure:(FailureBlock)failure {
    
    [LoginApi fetchUserInfoSuccess:^(id response) {
        
        self.userInfo = response;
        [self saveAdInfo];
        
        if (success) {
            success(response);
        }
        
    } failure:failure];
}

- (void)reloadServerToken:(void (^)(NSString *))success failure:(FailureBlock)failure {
    
    [TokenNetApi fetchRequestToken:^(NSString *token) {
        
        self.serverToken = token;
        
        if (success) {
            success(token);
        }
        
    } failure:^(NSInteger errorCode) {
        // 接口请求失败了(无网络进入)，但是微信已经登录过了
        if (![NSString isBlankString:self.thirdpartyOpenId] && ![NSString isBlankString:self.thirdpartyAccessToken]) {
            self.state = LoginStateAccountNoServer;
        } else {
            self.state = LoginStateInitial;
        }
        if (failure) {
            failure(errorCode);
        }
    }];
}

- (void)reloadFollowingList {
    
    [NewsApi fetchFollowListSuccess:^(NSArray *itemArray) {
        
        [XLPublisherDataSource setFollowingAuthorIds:itemArray];
        
    } failure:^(NSInteger errorCode) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reloadFollowingList];
        });
        
    }];
}

- (void)saveAdInfo {
    NSUserDefaults *userDefaults = NSUserDefaults.standardUserDefaults;
    [userDefaults setObject:[self.userInfo.screenAd yy_modelToJSONData] forKey:XLUserDefaultsSplashAdInfo];
    [userDefaults setObject:[self.userInfo.hotPageAd yy_modelToJSONData] forKey:XLUserDefaultsHotAdInfo];
    [userDefaults setObject:[self.userInfo.attentionPageAd yy_modelToJSONData] forKey:XLUserDefaultsFollowAdInfo];
    [userDefaults synchronize];
}

@end
