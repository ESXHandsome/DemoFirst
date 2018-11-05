//
//  FloatView.m
//  NationalRedPacket
//
//  Created by Ying on 2018/1/25.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "FloatView.h"
#import "XLH5WebViewController.h"
#import "FloatViewApi.h"
#define NavBarBottom 64
#define TabBarHeight 49
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define centerViewWidth  adaptWidth750(600)
#define centerViewHeight adaptHeight1334(400)
#define bottomViewWidth  adaptWidth750(40)
#define bottomViewHeight adaptHeight1334(40)
#define maskViewTag  = 100001
#define imageViewTag = 100002

@implementation FloatView

-(instancetype)init{
    self = [super init];
    self.show = YES;
    if (self){
        _marginVertical = 0;
        _marginHorizontal = 0;
        self.backgroundColor = [UIColor clearColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.userInteractionEnabled = YES;
        /**  允许拖动
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(objectDidDragged:)];
        [self addGestureRecognizer:panGR];
         */
        [self addSubview:_imageView];
    }
    return self;
}

- (void)objectDidDragged:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateChanged ||
        sender.state == UIGestureRecognizerStateEnded) {
        CGPoint offset = [sender translationInView:[UIApplication sharedApplication].keyWindow];
        [self setCenter:CGPointMake(self.center.x + offset.x, self.center.y + offset.y)];
        [sender setTranslation:CGPointMake(0, 0) inView:[UIApplication sharedApplication].keyWindow] ;
    }
}

-(void)floatViewClickMaskClose{
    if(_isMask){
        UITapGestureRecognizer *tapGesturRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction)];
        [self addGestureRecognizer:tapGesturRecognizer];
    }
}

-(void)closeAction{
    [self floatViewDisappearAnimation:_disappearAinmationMode];
    [_closeButton removeFromSuperview];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.show = NO;
        [self removeFromSuperview];
    });
}

-(void)floatViewInitWithFrame:(CGRect)frame{
    self.frame = frame;
    _imageView.frame = frame;
}

-(void)floatViewInitImage:(NSString *)imageUrlString{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]];
    UITapGestureRecognizer *tapGesturRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickFloatView)];
    _imageView.userInteractionEnabled = YES;
    [_imageView addGestureRecognizer:tapGesturRecognizer];
}


-(void)onClickFloatView{
    UIViewController *viewController = [self getCurrentVC];
    XLH5WebViewController* webViewController = [XLH5WebViewController new];
    webViewController.urlString = self.showUrlString;
    [viewController.navigationController pushViewController:webViewController animated:YES];
    if (!self.repeat)
        [self removeFromSuperview];
    [StatServiceApi statEvent:FLOATING_H5_CLICK model:nil otherString:self.ID];
}

#pragma mask 添加遮盖
-(void)floatViewAddMask{
    _isMask = YES;
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.userInteractionEnabled = YES;
    self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
}

#pragma mask 消失按钮
-(void)floatViewCloseButtonPosition:(CloseButtonPosition)closeButtonPosition imageUrl:(NSString*)imageUrlString {
    _closeButton = [[UIButton alloc] init];
    if(![imageUrlString isEqualToString:@""]){
        [_closeButton.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]];
    }else{
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"my_out"] forState:UIControlStateNormal];
    }
    [_closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    switch (closeButtonPosition) {
        case CLOSEBUTTONPOSITION_LEFT_TOP:
            _closeButton.frame = CGRectMake(_imageView.frame.origin.x, _imageView.frame.origin.y,bottomViewWidth,bottomViewHeight);
            break;
        case CLOSEBUTTONPOSITION_RIGHT_TOP:
            _closeButton.frame = CGRectMake(_imageView.frame.origin.x+_imageView.frame.size.width-bottomViewWidth, _imageView.frame.origin.y,bottomViewWidth,bottomViewHeight);
            break;
        case CLOSEBUTTONPOSITION_LEFT_BOTTOM:
            _closeButton.frame = CGRectMake(_imageView.frame.origin.x, _imageView.frame.origin.y+_imageView.frame.size.height-bottomViewWidth,bottomViewWidth,bottomViewHeight);
            break;
        case CLOSEBUTTONPOSITION_RIGHT_BOTTOM:
            _closeButton.frame = CGRectMake(_imageView.frame.origin.x+_imageView.frame.size.width-bottomViewWidth, _imageView.frame.origin.y+_imageView.frame.size.height-bottomViewWidth,bottomViewWidth,bottomViewHeight);
            break;
        default:
            break;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addSubview:self.closeButton];
        });
    });
    
}

#pragma mask 悬浮按钮消失动画
-(void)floatViewDisappearAnimation:(DisappearAnimationMode)disappearAinmationMode{
    switch (disappearAinmationMode) {
        case DISAPPEARANIMATIONMODE_SCALE_DOWN:
            if(_isMask){
                [self view:_imageView animationForFrame:_imageView.frame toFrame:CGRectMake(_imageView.center.x, _imageView.center.y, 0, 0)];
            }else{
                [self view:_imageView animationForFrame:_imageView.frame toFrame:CGRectMake(self.frame.size.width/2, self.frame.size.height/2, 0, 0)];
            }
            break;
        case DISAPPEARANIMATIONMODE_SLIDE_OUT_UP:
            if(_isMask){
                [self view:_imageView animationForFrame:_imageView.frame toFrame:CGRectMake(_imageView.frame.origin.x, NAVIGATION_BAR_HEIGHT, _imageView.frame.size.width, 0)];
            }else{
                [self view:_imageView animationForFrame:_imageView.frame toFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT-self.origin.y, self.frame.size.width, 0)];
            }
            break;
        case DISAPPEARANIMATIONMODE_SLIDE_OUT_DOWN:
            if(_isMask){
               [self view:_imageView animationForFrame:_imageView.frame toFrame:CGRectMake(_imageView.frame.origin.x, SCREEN_HEIGHT-TabBarHeight, _imageView.frame.size.width, 0)];
            }else{
                [self view:_imageView animationForFrame:_imageView.frame toFrame:CGRectMake(0,SCREEN_HEIGHT-self.frame.origin.y, self.frame.size.width, 0)];
            }
            break;
        case DISAPPEARANIMATIONMODE_SLIDE_OUT_LEFT:
            if(_isMask){
                [self view:_imageView animationForFrame:_imageView.frame toFrame:CGRectMake(0, _imageView.frame.origin.y, 0, _imageView.frame.size.height)];
            }else{
                [self view:_imageView animationForFrame:_imageView.frame toFrame:CGRectMake(-1*(self.frame.origin.x),0, 0, self.frame.size.height)];
            }
            break;
        case DISAPPEARANIMATIONMODE_SLIDE_OUT_RIGHT:
            if(_isMask){
                [self view:_imageView animationForFrame:_imageView.frame toFrame:CGRectMake(SCREEN_WIDTH, _imageView.frame.origin.y, 0, _imageView.frame.size.height)];
            }else{
                [self view:_imageView animationForFrame:_imageView.frame toFrame:CGRectMake(SCREEN_WIDTH-self.frame.origin.x,0, 0, self.frame.size.height)];
            }
            break;
        default:
            
            break;
    }
}


#pragma mask 悬浮按钮出现动画
-(void)floatViewAppearAnimation:(AppearAnimationMode)appearAnimationMode disAppearAnimation:(DisappearAnimationMode)disAppearAnimation{
    _disappearAinmationMode = disAppearAnimation;
    switch (appearAnimationMode) {
        case APPEARANIMATIONMODE_SCALE_UP:
            if(_isMask){
                [self view:_imageView animationForFrame:CGRectMake(_imageView.center.x, _imageView.center.y, 0, 0) toFrame:_imageView.frame];
            }else{
                [self view:_imageView animationForFrame:CGRectMake(self.frame.size.width/2, self.frame.size.height/2, 0, 0) toFrame:_imageView.frame];
            }
            break;
        case APPEARANIMATIONMODE_SLIDE_IN_TOP:
            if(_isMask){
                [self view:_imageView animationForFrame:CGRectMake(_imageView.frame.origin.x, NAVIGATION_BAR_HEIGHT, _imageView.frame.size.width, 0) toFrame:_imageView.frame];
            }else{
                [self view:_imageView animationForFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT-self.origin.y, self.frame.size.width, 0) toFrame:_imageView.frame];
            }
            break;
        case APPEARANIMATIONMODE_SLIDE_IN_DOWN:
            if(_isMask){
                [self view:_imageView animationForFrame:CGRectMake(_imageView.frame.origin.x, SCREEN_HEIGHT-TabBarHeight, _imageView.frame.size.width, 0) toFrame:_imageView.frame];
            }else{
                [self view:_imageView animationForFrame:CGRectMake(0,SCREEN_HEIGHT-self.frame.origin.y, self.frame.size.width, 0) toFrame:_imageView.frame];
            }
            break;
        case APPEARANIMATIONMODE_SLIDE_IN_LEFT:
            if(_isMask){
                [self view:_imageView animationForFrame:CGRectMake(0, _imageView.frame.origin.y, 0, _imageView.frame.size.height) toFrame:_imageView.frame];
            }else{
                [self view:_imageView animationForFrame:CGRectMake(-1*(self.frame.origin.x),0, 0, self.frame.size.height) toFrame:_imageView.frame];
            }
            break;
        case APPEARANIMATIONMODE_SLIDE_IN_RIGHT:
            if(_isMask){
                [self view:_imageView animationForFrame:CGRectMake(SCREEN_WIDTH, _imageView.frame.origin.y, 0, _imageView.frame.size.height) toFrame:_imageView.frame];
            }else{
                [self view:_imageView animationForFrame:CGRectMake(SCREEN_WIDTH-self.frame.origin.x,0, 0, self.frame.size.height) toFrame:_imageView.frame];
            }
            break;
        default:
        
            break;
    }
}
-(void)view:(UIView*)view animationForFrame:(CGRect)startFrame toFrame:(CGRect)endFrame{
    view.frame = startFrame;
    [UIView animateWithDuration:1 animations:^{
        view.frame = endFrame;
    }];
}
#pragma mask 悬浮按钮位置
-(void)floatViewStayPosition:(StayMode)stayMode{
    switch (stayMode) {
        case STAYMODE_CENTER:
            self.center = [UIApplication sharedApplication].keyWindow.center;
            _imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
            break;
        case STAYMODE_LEFT_BOTTOM:
            if(_isMask){
                _imageView.center = CGPointMake(_marginHorizontal+(_imageView.frame.size.width/2), SCREEN_HEIGHT-TabBarHeight-_marginVertical-(_imageView.frame.size.height/2)) ;
            }else{
                self.center = CGPointMake(_marginHorizontal+(self.frame.size.width/2), SCREEN_HEIGHT-TabBarHeight-_marginVertical-(self.frame.size.height/2));
            }
            break;
        case STAYMODE_RIGHT_BOTTOM:
            if(_isMask){
                _imageView.center = CGPointMake(SCREEN_WIDTH-_marginHorizontal-(_imageView.frame.size.width/2), SCREEN_HEIGHT-TabBarHeight-_marginVertical-(_imageView.frame.size.height/2));
            }else{
                self.center = CGPointMake(SCREEN_WIDTH-_marginHorizontal-(self.frame.size.width/2), SCREEN_HEIGHT-TabBarHeight-_marginVertical-(self.frame.size.height/2));
            }
            break;
        default:
            break;
    }
}
- (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        currentVC = rootVC;
    }
    return currentVC;
}
@end
