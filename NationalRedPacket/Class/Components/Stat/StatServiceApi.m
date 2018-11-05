//
//  StatServiceApi.m
//  StatProject
//
//  Created by 刘永杰 on 2018/1/2.
//  Copyright © 2018年 刘永杰. All rights reserved.
//

#import "StatServiceApi.h"
#import "StatDataBase.h"
#import "StatConst.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import <RTRootNavigationController/RTRootNavigationController.h>
#import "UIDevice+Info.h"
#import "BaseFeedListViewController.h"
#import "VideoDisplayView.h"
#import "XLPhotoShowView.h"

#ifdef DEBUG
//测试环境
//static NSString *const baseUrl = @"http://home.vsjj.net:8088";
static NSString *const baseUrl = @"http://139.129.162.59:9537";

#else
//正式环境
static NSString *const baseUrl = @"http://paopaojie.jipi-nobug.cn";
#endif

static NSString *const statUrl = @"/Record/itemEvent";
//签名key
static NSString *const signtureKey = @"OjSwvqT91tdhk7r3";

static NSString *const FORWARD = @"FORWARD";
static NSString *const VIDEO = @"VIDEO";

@interface StatServiceApi ()

@property (strong, nonatomic) AFHTTPSessionManager *manager;
@property (strong, nonatomic) dispatch_source_t timer;
@property (strong, nonatomic) NSMutableDictionary *pageDurationKeyValueDictionary;

@property (strong, nonatomic) NSMutableDictionary *feedShowCacheDictionary;

@end

@implementation StatServiceApi

+ (instancetype)sharedService
{
    static dispatch_once_t onceToken;
    static StatServiceApi *api;
    dispatch_once(&onceToken, ^{
        api = [StatServiceApi new];
        [NSNotificationCenter.defaultCenter addObserver:api selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:api selector:@selector(applicationWillWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];

    });
    return api;
}

+ (void)initWithStatUserId:(NSString *)userId refer:(NSString *)refer;
{
    [StatServiceApi sharedService].userId = userId;
    [StatServiceApi sharedService].refer = refer;
    
    [[StatServiceApi sharedService] startGCDTimer];

}

/**
 统计自定义事件
 
 @param event 事件名称
 */
+ (void)statEvent:(NSString *)event
{
    [StatServiceApi statEvent:event model:nil];
}

/**
 统计带数据的自定义事件
 
 @param event 事件名称
 @param model 数据
 */
+ (void)statEvent:(NSString *)event model:(XLFeedModel *)model
{
    [StatServiceApi statEvent:event model:model otherString:nil];
}


/**
 统计带数据及二级参数的自定义事件

 @param event 事件名称
 @param model 数据
 @param otherString 二级参数
 */
+ (void)statEvent:(NSString *)event model:(XLFeedModel *)model otherString:(NSString *)otherString
{
    StatModel *statModel = [StatModel new];
    statModel.action = event;
    
    [[StatServiceApi sharedService] dealwithEvent:event StatModel:statModel newsModel:model otherString:otherString];
}

/**
 统计带数据及二级参数的自定义事件
 
 @param event 事件名称
 @param model 数据
 @param timeDuration 二级参数时长
 */
+ (void)statEvent:(NSString *)event model:(XLFeedModel *)model timeDuration:(NSString *)timeDuration
{
    
    StatModel *statModel = [StatModel new];
    statModel.action = event;
    statModel.time = timeDuration;
    [[StatServiceApi sharedService] dealwithEvent:event StatModel:statModel newsModel:model otherString:nil];
    
}

/**
 统计自定义事件开始
 
 @param event 事件名称
 */
+ (void)statEventBegin:(NSString *)event
{
    [StatServiceApi statEventBegin:event model:nil];
}

/**
 统计自定义事件结束
 
 @param event 事件名称
 */
+ (void)statEventEnd:(NSString *)event;
{
    [StatServiceApi statEventEnd:event model:nil];
}

/**
 统计自定义事件开始
 
 @param event 事件名称
 @param model 数据
 */
+ (void)statEventBegin:(NSString *)event model:(XLFeedModel *)model
{
    if (model == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", time(0)] forKey:event];
    } else {
        
        NSString *keyStr;
        if ([model isKindOfClass:[XLFeedModel class]]) {
            
            keyStr = [[event stringByAppendingString:model.itemId] stringByAppendingString:model.type];
            
        } else if ([model isKindOfClass:[XLPublisherModel class]]) {
            
            keyStr = [event stringByAppendingString:model.authorId];
            
        } else if ([model isKindOfClass:[NIMSession class]]) {
            
            keyStr = [event stringByAppendingString:[(NIMSession *)model sessionId]];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", time(0)] forKey:keyStr];
        
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 统计自定义事件结束
 
 @param event 事件名称
 @param model 数据
 */
+ (void)statEventEnd:(NSString *)event model:(XLFeedModel *)model
{
    StatModel *statModel = [StatModel new];
    statModel.action = event;

    if (model == nil) {
        statModel.time = [NSString stringWithFormat:@"%lld", time(0) - [[[NSUserDefaults standardUserDefaults] objectForKey:event] longLongValue]];
    } else {
        NSString *keyStr;
        if ([model isKindOfClass:[XLFeedModel class]]) {
            
            keyStr = [[event stringByAppendingString:model.itemId] stringByAppendingString:model.type];
            
        } else if ([model isKindOfClass:[XLPublisherModel class]]) {
            
            keyStr = [event stringByAppendingString:model.authorId];

        } else if ([model isKindOfClass:[NIMSession class]]) {
            
            keyStr = [event stringByAppendingString:[(NIMSession *)model sessionId]];
        }
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:keyStr] longLongValue] == 0) {
            XLLog(@"无效打点，无开始值，临界处理");
            return;
        }
        NSUInteger duration = time(0) - [[[NSUserDefaults standardUserDefaults] objectForKey:keyStr] longLongValue];
        statModel.time = [NSString stringWithFormat:@"%lu", (unsigned long)duration];
        
    }
    
    [[StatServiceApi sharedService] dealwithEvent:event StatModel:statModel newsModel:model otherString:nil];
}

#pragma mark - Private Methods

/**
 统一插入统计数据

 @param event 事件名称
 @param statModel 统计模型
 @param newsModel news模型
 */
- (void)dealwithEvent:(NSString *)event StatModel:(StatModel *)statModel newsModel:(XLFeedModel *)newsModel otherString:(NSString *)otherString
{
    //跟踪页面标志
    [StatServiceApi trackingPageIndexWithStatModel:statModel newsModel:newsModel];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        
        //只需发布者id字段
        if (event == PERSONPAGE_CLICK || event == PERSON_PAGE_DURATION || event == FOLLOW_CLICK) {
            
            statModel.authorId = newsModel.authorId;
            
        } else if ([newsModel isKindOfClass:[XLFeedModel class]]) {
            
            statModel.item_id = newsModel.itemId;
            statModel.item_type = newsModel.itemType; //信息流类型
            statModel.origin = newsModel.origin;
            
        } else if ([newsModel isKindOfClass:[NIMSession class]]) {
            statModel.sessionid = [(NIMSession *)newsModel sessionId];
            if ([(NIMSession *)newsModel sessionType] == NIMSessionTypeP2P) {
                statModel.sessiontype = @"2";
            } else {
                statModel.sessiontype = @"1";
            }
        }
        
        //其他参数字段
        if ([event containsString:VIDEO_DURATION] || event == VIDEO_PREVIEW_DURATION || event == VIDEO_FLOAT_PLAY_DURATION) {
            statModel.video_long = newsModel.videoLong;
        } else if (([event containsString:FORWARD] || [event containsString:@"INVITE"]) && otherString != nil) {
            if ([otherString containsString:@","]) {
                NSArray *array = [otherString componentsSeparatedByString:@","];
                statModel.forward_type = array.firstObject;
                statModel.position = array.lastObject;
            } else {
                statModel.forward_type = otherString;
            }
        } else if (event == USER_LOGIN_SUCCESS || event == USER_CLICK_LOGIN) {
            statModel.source = otherString;
            statModel.platform = [NSUserDefaults.standardUserDefaults stringForKey:XLUserDefaultsThirdpartyPlatformKey];
        } else if ([event isEqualToString:USER_GUIDEPAGE_CHOOSE_GENDER]) {
            statModel.sex = otherString;
        } else if ([event isEqualToString:DISCOVERY_BANNER_CLICK]) {
            statModel.title = otherString;
        } else if ([event isEqualToString:USER_TABBAR_CLICK]) {
            statModel.tab = otherString;
        } else if ([event isEqualToString:HOME_FEED_TYPE_CLICK]) {
            statModel.type = otherString;
        } else if (([event isEqualToString:ARTICLE_COMMENT] || [event isEqualToString:VIDEO_COMMENT] || [event isEqualToString:IMAGE_COMMENT]) && otherString != nil) {
            statModel.image = otherString;
        } else if ([event isEqualToString:SECOND_COMMENT]) {
            NSArray *array = [otherString componentsSeparatedByString:@","];
            statModel.comment_type = array.firstObject;
            statModel.comment_id = array.lastObject;
        } else if (event == VIDEO_COMMENT_LIKE || event == IMAGE_COMMENT_LIKE || event == COMMENT_IMAGE_CLICK || event == SECOND_COMMENT_LOAD_MORE || event == IMAGE_BEST_COMMENT_LIKE || event == VIDEO_BEST_COMMENT_LIKE || event == VIDEO_BEST_COMMENT_CLICK || event == IMAGE_BEST_COMMENT_CLICK) {
            statModel.comment_id = otherString;
        } else if (event == VIDEO_SOUND_CLICK || event == VIDEO_PAUSE_CLICK || event == VIDEO_MAX_SCREEN_CLCK || event == VIDEO_FLOAT_PAUSE_CLICK) {
            statModel.mode = otherString;
        } else if (event == VIDEO_COMMENT_BROWSER_DURATION || event == IMAGE_COMMENT_BROWSER_DURATION) {
            statModel.comment_id = newsModel.isBottom;
        } else if (event == MY_WALLET_CLICK) {
            statModel.moneyType = otherString;
        } else if ([event isEqualToString:FOLLOW_CLICK] && otherString != nil) {
            statModel.find_type = otherString;
        } else if ([event isEqualToString:PERSONPAGE_CLICK] && otherString != nil) {
            statModel.comment = otherString;
        } else if (event == LUCKYMONEY_CLICK) {
            NSArray *array = [otherString componentsSeparatedByString:@","];
            statModel.luckyid = array.firstObject;
            statModel.status = array.lastObject;
        } else if (event == LUCKYMONEY_OPEN) {
            statModel.luckyid = otherString;
        } else if (event == LUCKYMONEY_DETAIL) {
            NSArray *array = [otherString componentsSeparatedByString:@","];
            statModel.luckyid = array.firstObject;
            statModel.source = array.lastObject;
        } else if (event == MESSAGE_SEND) {
            statModel.msgtype = otherString;
        } else if (event == ALLOW_PUSH) {
            statModel.status = otherString;
        } else if (event == PUSH_CLICK) {
            NSArray *array = [otherString componentsSeparatedByString:@"&"];
            statModel.app_alive = array.firstObject;
            statModel.content = array.lastObject;
        } else if (event == MSG_CLICK || event == MSG_LOOK) {
            NSArray *array = [otherString componentsSeparatedByString:@","];
            statModel.type = array.firstObject;
            statModel.itemId = array.lastObject;
        } else if ([event containsString:@"H5"]) {
            statModel.itemId = otherString;
        } else if ([event containsString:@"_AD_"]) {
            if (event == FEED_AD_REQUEST) {
                NSArray *array = [otherString componentsSeparatedByString:@","];
                statModel.channel = array.firstObject;
                statModel.adId = array[1];
                statModel.request = array[2];
                statModel.get = array.lastObject;
            } else {
                if ([otherString containsString:@","]) {
                    NSArray *array = [otherString componentsSeparatedByString:@","];
                    statModel.channel = array.firstObject;
                    statModel.itemId = array.lastObject;
                } else {
                    statModel.channel = otherString;
                }
            }
        } else if (event == USER_PUBLISH_SEND_CLICK || event == USER_PUBLISH_SUCCESS) {
            statModel.uploadType = otherString;
        } else if (event == SHIELD_TEAM_CLICK) {
            statModel.mode = otherString;
        } else if (event == AUTO_PLAY_SWITCH) {
            NSArray *array = [otherString componentsSeparatedByString:@","];
            statModel.mode = array.firstObject;
            statModel.type = array.lastObject;
        }
        
        if ([event containsString:@"LOOK"] && [newsModel isKindOfClass:[XLFeedModel class]]) {  //展示过的不要重复统计
            if ([self feedIsShow:newsModel]) {
                return;
            }
            [self recordShowFeed:newsModel];
        }
        if (event == APP_BACKGROUND_DURATION) {
            if (statModel.time.integerValue > 180) { //打开的打点
                statModel.action = APP_LAUNCH;
                statModel.time = nil;
            } else {
                return;
            }
        }
        if (statModel.time != nil && statModel.time.integerValue < 1) { //小于1秒，本次统计无效
            return;
        }
        XLLog(@"打点：%@", statModel.yy_modelToJSONString);
        //插入统计数据库
        [[StatDataBase sharedManager] insertStatModel:statModel];
    });
    
}

+ (void)trackingPageIndexWithStatModel:(StatModel *)statModel newsModel:(XLFeedModel *)newsModel
{
    NSDictionary *vcDic = [StatServiceApi sharedService].viewControllerDictionary;
    if ([vcDic objectForKey:[StatServiceApi sharedService].lastVCStr]) {
        statModel.from = [NSString stringWithFormat:@"%@", [vcDic objectForKey:[StatServiceApi sharedService].lastVCStr]];
    } else {
        statModel.from = @"";
    }
    if ([vcDic objectForKey:[StatServiceApi sharedService].currentVCStr]) {
        statModel.to = [NSString stringWithFormat:@"%@", [vcDic objectForKey:[StatServiceApi sharedService].currentVCStr]];
        //手动处理TabBar切换时To不对的情况（因为切换tabBar,先调用新页面的ViewWillAppear，导致To错误）
        if ([statModel.action isEqualToString:@"FIND_PAGE_LONG"] && ![statModel.to isEqualToString:@"VIEW_DISCOVERY"]) {
            statModel.to = @"VIEW_DISCOVERY";
        } else if ([statModel.action isEqualToString:HOME_PAGE_DURATION] && ![statModel.to isEqualToString:@"VIEW_HOME"]) {
            statModel.to = @"VIEW_HOME";
        } else if ([statModel.action isEqualToString:FOLLOWING_FEED_PAGE_DURATION] && ![statModel.to isEqualToString:@"VIEW_FOLLOWING_FEED"]) {
            statModel.to = @"VIEW_FOLLOWING_FEED";
        }  else if ([statModel.action isEqualToString:HOME_VIDEO_PAGE_DURATION] && ![statModel.to isEqualToString:@"VIEW_VIDEO"]) {
            statModel.to = @"VIEW_VIDEO";
        }  else if ([statModel.action isEqualToString:HOME_IMAGE_PAGE_DURATION] && ![statModel.to isEqualToString:@"VIEW_IMAGE"]) {
            statModel.to = @"VIEW_IMAGE";
        }  else if ([statModel.action isEqualToString:@"MSG_PAGE_LONG"] && ![statModel.to isEqualToString:@"VIEW_SESSION_LIST"]) {
            statModel.to = @"VIEW_SESSION_LIST";
        }
    } else {
        statModel.to = @"";
    }
}

#pragma mark - StatShow
- (void)recordShowFeed:(XLFeedModel *)feed {
    
    NSString *keyValueStr = [self showFeedKeyValue:feed];
    [self.feedShowCacheDictionary setValue:keyValueStr forKey:keyValueStr];
}

- (BOOL)feedIsShow:(XLFeedModel *)feed {
    
    NSString *keyValueStr = [self showFeedKeyValue:feed];
    return [[self.feedShowCacheDictionary objectForKey:keyValueStr] isEqualToString:keyValueStr];
}

- (NSString *)showFeedKeyValue:(XLFeedModel *)feed {
    
    NSMutableArray *vcArray = [self screenDisplayViewController];
    NSString *pageStr = NSStringFromClass([vcArray.lastObject class]);
    NSString *resultStr = [NSString stringWithFormat:@"%@-%@-%@", feed.itemId, feed.type, pageStr];
    return resultStr;
}

#pragma mark - UIApplicationDelgate

/**
 APP将要进入后台
 */
- (void)applicationWillResignActive {
    
    NSMutableArray *vcArray = [self screenDisplayViewController];
    for (UIViewController *vc in vcArray) {
        [vc viewWillDisappear:NO];
    }
}

/**
 APP将要进入前台
 */
- (void)applicationWillWillEnterForeground {
    
    NSMutableArray *vcArray = [self screenDisplayViewController];
    for (UIViewController *vc in vcArray) {
        [vc viewWillAppear:NO];
    }
}

- (NSMutableArray *)screenDisplayViewController {
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (UIView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([subView isKindOfClass:[VideoDisplayView class]] || [subView isKindOfClass:[XLPhotoShowView class]]) { //如果是视频全屏页或者图片预览页，返回空数组，不手动调用控制器生命周期方法
            return resultArray;
        }
    }
    
    NSArray *vcArray = [UIViewController currentViewController].rt_navigationController.rt_viewControllers.lastObject.childViewControllers;
    if (vcArray.count != 0 && [[vcArray.firstObject superclass] isEqual:[BaseFeedListViewController class]]) {
        [vcArray enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([UIView isDisplayedInScreenForView:obj.view]) {
                [resultArray addObject:obj];
            }
        }];
    } else {
        UIViewController *vc = [[[UIViewController currentViewController] rt_navigationController] rt_viewControllers].lastObject;
        if (vc) {
            [resultArray addObject:vc];
        }
    }
    return resultArray;
}

//30秒上传一次
- (void)startGCDTimer
{
    // GCD定时器
    NSTimeInterval interval = 30.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), interval * NSEC_PER_SEC, 0); //每30秒执行
    // 事件回调
    dispatch_source_set_event_handler(self.timer, ^{
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
            [self statEventUpload];
        });
    });
    // 开启定时器
    dispatch_resume(self.timer);
}

- (void)cancelGCDTimer
{
    if (self.timer) {
        dispatch_cancel(self.timer);
    }
}

/**
 上传统计数据
 */
- (void)statEventUpload
{
    NSArray *statArray = [[StatDataBase sharedManager] queryNoUploadStat];
    if (statArray.count == 0) {
        XLLog(@"没有要上传的数据");
        return;
    }
    
    NSString *timeStr = [NSString stringWithFormat:@"%ld", time(0)];
    NSString *qDataStr = [[statArray valueForKeyPath:@"stat_data"] yy_modelToJSONString];
    NSString *signature = [StatServiceApi signatureWithKey:signtureKey timeStr:timeStr qDataStr:qDataStr];
    NSString *versionNumber = NSBundle.appVersionNumber;
    NSDictionary *dict = @{
                           @"t" : timeStr,
                           @"s" : signature,
                           @"u" : [NSString replaceNil:[StatServiceApi sharedService].userId],
                           @"q" : qDataStr,
                           @"v" : versionNumber,
                           };
    
    XLLog(@"url : %@", [baseUrl stringByAppendingString:statUrl]);
    
    [self.manager POST:[baseUrl stringByAppendingString:statUrl] parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        // 进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        XLLog(@"上传成功数目：%lu", [[statArray valueForKeyPath:@"stat_id"] count]);
        [[StatDataBase sharedManager] updateStatDidUpload:[statArray valueForKeyPath:@"stat_id"]];
        // 请求成功
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
    }];
    
}

+ (NSString *)signatureWithKey:(NSString *)key timeStr:(NSString *)timeStr qDataStr:(NSString *)qDataStr
{
    NSString *signature = [NSString stringWithFormat:@"%@_%@%@", key, timeStr,[self MD5Of32BitLowerString:qDataStr]];
    return [self MD5Of32BitLowerString:[self MD5Of32BitLowerString:signature]];
}

/**
 MD5加密32位小写
 */
+ (NSString *)MD5Of32BitLowerString:(NSString *)string;
{
    const char *data = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data, (CC_LONG)strlen(data), result);
    NSMutableString *md5Str = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        
        [md5Str appendFormat:@"%02x", result[i]];
    }
    return md5Str;
    
}

- (NSMutableDictionary *)viewControllerDictionary
{
    if (!_viewControllerDictionary) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"StatPageTracking" ofType:@"plist"];
        _viewControllerDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    }
    return _viewControllerDictionary;
}

- (NSMutableDictionary *)pageDurationKeyValueDictionary
{
    if (!_pageDurationKeyValueDictionary) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"StatPageDuration" ofType:@"plist"];
        _pageDurationKeyValueDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    }
    return _pageDurationKeyValueDictionary;
}

- (NSString *)pageDurationValueWithViewController:(UIViewController *)viewController {
    
    return [self.pageDurationKeyValueDictionary valueForKey:NSStringFromClass([viewController class])];
}

- (NSMutableDictionary *)feedShowCacheDictionary {
    if (!_feedShowCacheDictionary) {
        _feedShowCacheDictionary = [NSMutableDictionary new];
    }
    return _feedShowCacheDictionary;
}

- (AFHTTPSessionManager *)manager {
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
        NSMutableSet *acceptContentTypes = [NSMutableSet set];
        // 添加需要的类型
        acceptContentTypes.set = _manager.responseSerializer.acceptableContentTypes;
        [acceptContentTypes addObject:@"text/html"];
        // 给acceptableContentTypes赋值
        _manager.responseSerializer.acceptableContentTypes = acceptContentTypes;
        // 声明获取到的数据格式
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _manager;
}

@end
