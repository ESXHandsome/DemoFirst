//
//  SuspensionViewManage.m
//  NationalRedPacket
//
//  Created by Ying on 2018/1/24.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "FloatViewManager.h"
#import "FloatViewModel.h"
#import "FloatView.h"
#import "BaseNetApi.h"
#import "FloatViewRequestURL.h"
#import "XLH5AlertView.h"

@interface FloatViewManager()

@property (strong, nonatomic) NSMutableDictionary <NSString * , NSString *>*showAlertDic;

@end

static FloatViewManager * _instance = nil;

@implementation FloatViewManager

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone ];
    });
    return _instance;
}

+(instancetype) sharedInstance{
    if (_instance == nil) {
        _instance = [[FloatViewManager alloc]init];
    }
    return _instance;
}

-(id)copyWithZone:(NSZone *)zone{
    return _instance;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}

- (void)fetchFloatViewResorce:(void(^)(void))success{
    if(!self.floatViewModel){
        @weakify(self)
        [BaseNetApi httpRequestWithURL:URL_FETCH_FLOATVIEW_CONFIG withParam:@{} success:^(id responseDict) {
            @strongify(self)
            if (responseDict != nil) {
                if (responseDict[@"top"]) {
                    self.appletsArray = [NSArray yy_modelArrayWithClass:XLAppletsModel.class json:responseDict[@"top"]];
                }
                NSArray *array = responseDict[@"floatingViews"];
                if(array.count>0)
                {
                    self.floatViewModel = [FloatViewModel yy_modelWithJSON:array.firstObject];
                    [self showSuspensionView];
                    if (array.count == 1) {
                        if (success) {
                            success();
                        }
                        return ;
                    }
                    self.popAlertModel = [FloatViewModel yy_modelWithJSON:array[1]];
                    [self showH5AlertView];
                }
                if (success) {
                    success();
                }
               
            }
        } failure:^(NSInteger errorCode) {
            NSLog(@"悬浮窗没有数据:%ld",(long)errorCode);
        }];
    }
}

- (void)showH5AlertView {
    if ([self.popAlertModel.page containsObject:self.currentClassString]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:XLUserDefaultsNeedPopAlertView] isEqual:@"1"]) {
            /**新用户状态不弹弹窗*/
            [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:XLUserDefaultsNeedPopAlertView];
            return;
        }
        if (self.showAlertDic.allKeys.count < self.popAlertModel.showCount) {
             [XLH5AlertView showH5GudieAlert:self.popAlertModel.picUrl
                                        open:self.popAlertModel.url
                                      target:self.currentViewController
                                          ID:self.popAlertModel.ID];
            NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
            NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
            NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
            [self.showAlertDic setValue:self.currentClassString forKey:timeString];
        } else return;
    }
   
}

-(void)getCurrentVeiwController:(UIViewController*)currentViewController{
    self.currentViewController = currentViewController;
    self.currentClassString = NSStringFromClass([currentViewController class]);
}

-(void)showSuspensionView{
    /**无数据不显示*/
    if (!self.floatViewModel) {
        return;
    }
    /**显示在所有页面之上*/
    if (self.floatViewModel.allPage) {
        [self showFloatViewLogic];
    } else {
        //出现在指定界面
        if ([self.floatViewModel.page containsObject:_currentClassString]) {
            [self showFloatViewInCurrentController];
        }
    }
    
}

-(void)showFloatViewInCurrentController{
    self.floatView = [[FloatView alloc] init];
    if ([self.floatViewModel.repeat isEqualToString:@"always"]) {
        self.floatView.repeat = YES;
    } else if ([self.floatViewModel.repeat isEqualToString:@"once"]) {
        self.floatView.repeat = NO;
    } else if ([self.floatViewModel.repeat isEqualToString:@"click"]) {
        self.floatView.repeat = NO;
    } else {
        
    }
    if ([self.currentClassString isEqualToString:@"HomePopularFeedListViewController"] ||
        [self.currentClassString isEqualToString:@"HomeFollowFeedListViewController"]) {
        self.floatViewModel.marginVertical = TAB_BAR_HEIGHT + adaptHeight1334(60);
    }
    for (UIView *view in [self.currentViewController.view subviews]) {
        if ([NSStringFromClass([view class]) isEqualToString:@"FloatView"]) {
            return;
        }
    };
    [self showFloatView];
}

-(void)showFloatViewLogic{
    /*出现在全部界面
     *保持视图的单一性
     */
    if ([self.floatViewModel.repeat isEqualToString:@"always"]) {
        self.floatView.repeat = YES;
    } else if ([self.floatViewModel.repeat isEqualToString:@"once"]) {
        self.floatView.repeat = NO;
    } else if ([self.floatViewModel.repeat isEqualToString:@"click"]) {
        self.floatView.repeat = NO;
    } else {
        
    }
    if (!self.floatView.show) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //确保没点取消,悬浮按钮一直保存在界面上
            if (!self.floatView) {
                self.floatView = [[FloatView alloc] init];
            } else {
                self.floatView.show = YES;
            }
            [self showFloatView];
            
        });
    }
}

/**悬浮窗悬浮的位置*/
-(void)stay{
    if (self.floatViewModel.position) {
        if ([self.floatViewModel.position isEqualToString:@"center"]) {
            self.stayMode = STAYMODE_CENTER;
        } else if ([self.floatViewModel.position isEqualToString:@"right_bottom"]) {
            self.stayMode = STAYMODE_RIGHT_BOTTOM;
        } else if ([self.floatViewModel.position isEqualToString:@"left_bottom"]) {
            self.stayMode = STAYMODE_LEFT_BOTTOM;
        }
    }
}

/**悬浮窗的出现动画*/
- (void)appearAnim{
    if (self.floatViewModel.appearAnim) {
        if ([self.floatViewModel.appearAnim isEqualToString:@"scale_up"]) {
            self.appearMode = APPEARANIMATIONMODE_SCALE_UP;
        } else if ([self.floatViewModel.appearAnim isEqualToString:@"slide_in_left"]) {
            self.appearMode = APPEARANIMATIONMODE_SLIDE_IN_LEFT;
        } else if ([self.floatViewModel.appearAnim isEqualToString:@"slide_in_right"]) {
            self.appearMode = APPEARANIMATIONMODE_SLIDE_IN_RIGHT;
        } else if ([self.floatViewModel.appearAnim isEqualToString:@"slide_in_top"]) {
            self.appearMode = APPEARANIMATIONMODE_SLIDE_IN_TOP;
        } else if ([self.floatViewModel.appearAnim isEqualToString:@"slide_in_bottom"]) {
            self.appearMode = APPEARANIMATIONMODE_SLIDE_IN_DOWN;
        }
    }
}

/**关闭按钮*/
- (void)closeButton {
    if(self.floatViewModel.closePosition){
        if ([self.floatViewModel.closePosition isEqualToString:@"left_bottom"]) {
            self.closeButtonMode = CLOSEBUTTONPOSITION_LEFT_BOTTOM;
        } else if ([self.floatViewModel.closePosition isEqualToString:@"right_bottom"]) {
            self.closeButtonMode = CLOSEBUTTONPOSITION_RIGHT_BOTTOM;
        } else if ([self.floatViewModel.closePosition isEqualToString:@"left_top"]) {
            self.closeButtonMode = CLOSEBUTTONPOSITION_LEFT_TOP;
        } else if ([self.floatViewModel.closePosition isEqualToString:@"right_top"]){
            self.closeButtonMode = CLOSEBUTTONPOSITION_RIGHT_TOP;
        }
    }
}

/**悬浮窗消失动画*/
- (void)disappearAnim {
    if (self.floatViewModel.disappearAnim) {
        if ([self.floatViewModel.disappearAnim isEqualToString:@"scale_down"]) {
            self.disappearMode = DISAPPEARANIMATIONMODE_SCALE_DOWN;
        } else if ([self.floatViewModel.disappearAnim isEqualToString:@"slide_out_left"]) {
            self.disappearMode = DISAPPEARANIMATIONMODE_SLIDE_OUT_LEFT;
        } else if ([self.floatViewModel.disappearAnim isEqualToString:@"slide_out_right"]) {
            self.disappearMode = DISAPPEARANIMATIONMODE_SLIDE_OUT_RIGHT;
        } else if ([self.floatViewModel.disappearAnim isEqualToString:@"slide_out_top"]) {
            self.disappearMode = DISAPPEARANIMATIONMODE_SLIDE_OUT_UP;
        } else if ([self.floatViewModel.disappearAnim isEqualToString:@"slide_out_bottom"]) {
            self.disappearMode = DISAPPEARANIMATIONMODE_SCALE_DOWN;
        }
    }
}

/**展示悬浮窗*/
- (void)showFloatView {
    @weakify(self);
    /**延时显示*/
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.floatViewModel.appear/1000 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            /**在当前视图上寻找是否有悬浮窗,避免循环弹出*/
            for (UIView *view in [self.currentViewController.view subviews]) {
                if([NSStringFromClass([view class]) isEqualToString:@"FloatView"]) {
                    return;
                }
            };
            
            /**悬浮窗整体动画*/
            [self stay];
            [self appearAnim];
            [self disappearAnim];
            [self closeButton];
            
            /*初始化添加弹窗大小*/
            if (self.floatViewModel.height||self.floatViewModel.width) {
                [self.floatView floatViewInitWithFrame:CGRectMake(0, 0, adaptWidth750(self.floatViewModel.width*2),adaptHeight1334(self.floatViewModel.height*2))];
            } else {
                if ([self.floatViewModel.position isEqualToString: @"center"]) {
                    [self.floatView floatViewInitWithFrame:CGRectMake(0, 0, adaptWidth750(300*2),adaptHeight1334(200*2))];
                } else {
                    [self.floatView floatViewInitWithFrame:CGRectMake(0, 0, adaptWidth750(40*2),adaptHeight1334(40*2))];
                }
            }
            
            self.floatView.marginVertical = self.floatViewModel.marginVertical;
            self.floatView.marginHorizontal = self.floatViewModel.marginHorizontal;
            
            /*添加背景遮盖*/
            if (self.floatViewModel.mask) {
                [self.floatView floatViewAddMask];
                self.floatView.isMask = YES;
            }
            
            /*悬浮按钮的图片URL*/
            [self.floatView floatViewInitImage:self.floatViewModel.picUrl];
            self.floatView.showUrlString = self.floatViewModel.url;
            
            /*悬浮按钮位置*/
            [self.floatView floatViewStayPosition:self.stayMode];
            
            /*添加点击背景关闭悬浮窗*/
            if (self.floatViewModel.maskClose) {
                [self.floatView floatViewClickMaskClose];
            }
            
            if (self.floatViewModel.allPage) {
            /*悬浮在所有界面之上*/
                [[UIApplication sharedApplication].keyWindow addSubview:self.floatView];
            } else {
                [self.currentViewController.view addSubview:self.floatView];
            }
            
            /*定时消失悬浮按钮*/
            if (self.floatViewModel.disappear) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.floatViewModel.disappear/1000 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.floatView closeAction];
                });
            }
            
            /*出现和消失的动画*/
            [self.floatView floatViewAppearAnimation:self.appearMode disAppearAnimation:self.disappearMode];
            
            /*取消按钮的位置*/
            if (self.floatViewModel.showClose) {
                [self.floatView floatViewCloseButtonPosition:self.closeButtonMode imageUrl:self.floatViewModel.closePic];
            }
            
            /**弹窗的唯一ID*/
            self.floatView.ID = self.floatViewModel.ID;
        });
    });
    [StatServiceApi statEvent:FLOATING_H5_LOOK model:nil otherString:self.floatViewModel.ID];
}


//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

- (NSMutableDictionary<NSString *,NSString *> *)showAlertDic {
    if (!_showAlertDic) {
        _showAlertDic = [[NSMutableDictionary alloc] init];
    }
    return _showAlertDic;
}

@end

