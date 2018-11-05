//
//  PPSAlertView.m
//  NationalRedPacket
//
//  Created by Ying on 2018/2/26.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "PPSAlertView.h"

#define PPSAlertButtonHeight adaptHeight1334(104)
#define PPSAlertButtonAlpha  1
#define PPSAlertButtonFont   [UIFont fontWithName:@"PingFangSC-Regular" size:18]
#define PPSFreedomSize       CGSizeMake(SCREEN_WIDTH, adaptHeight1334(5))
#define COLORE9E9E9          @"#E9E9E9"
#define COLORE6E6E6          @"#E6E6E6"
#define COLORF6F6F6          @"#F6F6F6"

/*
 *ppsAlertView
 *卧槽这么牛逼的东西我都能写出来，我他娘的真是个天才！
 *啥都不说了，完美.
 */

@implementation XLAlertView
- (instancetype)init{
    self = [super init];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, PPSAlertButtonHeight);
    self.backgroundColor = [UIColor colorWithString:COLORffffff];
    self.alpha = PPSAlertButtonAlpha;
    return self;
}

- (void)alertButtonSetLabelText:(NSString *)labelText action:(void(^)(void))action{
    _labelText = labelText;
    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(0, 0, 0, 0);
    _label.textAlignment  = NSTextAlignmentCenter;
    _label.numberOfLines = 1;
    _label.font = PPSAlertButtonFont;
    _label.text = _labelText;
    CGSize maximumLabelSize = CGSizeMake(100, 9999);
    CGSize expectSize = [_label sizeThatFits:maximumLabelSize];
    _label.frame = CGRectMake(0, 0, expectSize.width, expectSize.height);
    _label.center = self.center;
    self.block = action;
    [self addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(highLight) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchCancel) forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:_label];
}
- (void)touchCancel{
    self.backgroundColor = [UIColor colorWithString:COLORffffff];
}
- (void)highLight{
    self.backgroundColor = [UIColor colorWithString:COLORF6F6F6];
}
- (void)action{
    if(self.block) {
        self.block();
    }
}
@end

@interface PPSAlertView ()
@property (strong, nonatomic) UIView *blackMaskBgView;
@end

@implementation PPSAlertView

- (instancetype)init{
    self = [super init];
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    _blackMaskBgView = [UIView new];
    _blackMaskBgView.alpha = 0.4;
    _blackMaskBgView.frame = self.bounds;
    _blackMaskBgView.backgroundColor = [UIColor colorWithString:COLOR000000];
    [self addSubview:_blackMaskBgView];
    
    _containerView = [[UIView alloc] init];
    _containerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    _containerView.backgroundColor = [UIColor grayColor];
    [self addSubview:_containerView];
    
    return self;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

- (void)addCellForAlerView:(NSString *)title style:(AlertViewStyle)style Action:(void (^)(void))action{
    XLAlertView *button = [[XLAlertView alloc] init];
    __weak typeof (self) weakself = self;
    [button alertButtonSetLabelText:title action:^{
        [weakself dismiss];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (action) {
                action();
            }
        });
    }];
    [self layoutAlertViewStyle:style button:button];
    
    [_containerView addSubview:button];
    
}

//调整frame
- (void)layoutAlertViewStyle:(AlertViewStyle)style button:(XLAlertView *)button{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 0.5)];
    view.backgroundColor = [UIColor colorWithString:COLORE6E6E6];
    switch (style) {
        case AlertActionStyleCancel:
            button.origin = CGPointMake(0, SCREEN_HEIGHT-_containerView.origin.y+adaptHeight1334(10)+0.5);
            _containerView.frame = CGRectMake(0, _containerView.frame.origin.y-PPSAlertButtonHeight-adaptHeight1334(10), SCREEN_WIDTH,_containerView.frame.size.height +PPSAlertButtonHeight +adaptHeight1334(10));
            break;
        case AlertActionStyleDefault:
            button.origin = CGPointMake(0, SCREEN_HEIGHT-_containerView.origin.y);
            view.origin = CGPointMake(0, SCREEN_HEIGHT-_containerView.origin.y+PPSAlertButtonHeight);
            [_containerView addSubview:view];
            _containerView.frame = CGRectMake(0, _containerView.frame.origin.y-PPSAlertButtonHeight-0.5, SCREEN_WIDTH,_containerView.frame.size.height +PPSAlertButtonHeight +0.5 );
            break;
        default:
            break;
    }
 
}


-(void)showWithAnimation:(BOOL)animation{
    if(animation){
        __block CGRect frame = _containerView.frame;
        _containerView.origin = CGPointMake(0, SCREEN_HEIGHT);
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [UIView animateWithDuration:0.25 animations:^{
            self.containerView.frame = frame;
        }];
    }
    
}

-(void)dismiss{
    __weak typeof (self) weakself = self;
    [UIView animateWithDuration:0.25 animations:^{
        self.blackMaskBgView.alpha = 0;
        self.containerView.frame = CGRectMake(0, SCREEN_HEIGHT, self.containerView.frame.size.width, self.containerView.frame.size.height );
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself removeFromSuperview];
    });
    
}

@end

