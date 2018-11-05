//
//  NegativeFeedbackView.m
//  NationalRedPacket
//
//  Created by Ying on 2018/5/7.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "NegativeFeedbackView.h"
#import "NegativeFeedbackTableView.h"

@interface NegativeFeedbackView() <UIGestureRecognizerDelegate, NegativeFeedbackTableViewDelegate>
@property (strong, nonatomic) NegativeFeedbackTableView *tableView;
@property (strong, nonatomic) UIView *fromView;
@property (strong, nonatomic) UIView *containerView;
@end

@implementation NegativeFeedbackView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor colorWithString:COLOR000000] colorWithAlphaComponent:0.3];
        self.frame = [UIScreen mainScreen].bounds;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf)];
        tapGesture.delegate = self;
        [tapGesture setNumberOfTapsRequired:1];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)presentFromView:(UIView *)fromView
            toContainer:(UIView *)container
               animated:(BOOL)animated
             completion:(void (^)(void))completion {
    /*没动画 激动了 还是写上吧*/
    
    if (!fromView) return;
    self.fromView = fromView;
    self.containerView = container;
    
   /*计算出formView在整个屏幕的Frame*/
    CGRect fromViewFrame = [self.fromView convertRect:fromView.bounds toView:self.containerView];
    
    /*计算一下需要初始化tableView的origin*/
    CGPoint tableViewOrigin = CGPointMake(fromViewFrame.origin.x + fromViewFrame.size.width - adaptWidth750(164*2),
                                          fromViewFrame.origin.y + fromViewFrame.size.height);
    
    /*这里对origin进行分析，是否产出边界*/
    if (tableViewOrigin.y > SCREEN_HEIGHT - 49 - adaptHeight1334(155*2)) {
        tableViewOrigin.y = fromViewFrame.origin.y - adaptHeight1334(155*2);
    }
    
    /*初始化tableView*/
    self.tableView = [[NegativeFeedbackTableView alloc] initWithOrigin:tableViewOrigin];
    self.tableView.negativeFeedbackDelegate = self;
    
    /*把tableView添加到遮罩上*/
    [self addSubview:self.tableView];
    
    /*将自己添加到容器视图上*/
    [self.containerView addSubview:self];
    
    /*你乐意加点啥都行*/
    if (completion)
        completion();
}

- (void)tapSelf {
    /*单击手势有冲突*/
    [self removeFromSuperview];
}

#pragma mark - negative feedback delegate
- (void)NegativeFeedbackTableView:(NegativeFeedbackTableView *)tableView didClickAtIndexPath:(NSIndexPath *)indexPath {
    [self removeFromSuperview];
    if (!self.delegate && [self.delegate respondsToSelector:@selector(negativeFeedBackButtonDidClicked:content:)]) return;
    switch (indexPath.row) {
        case 0:
            /*不感兴趣*/
            [self.delegate negativeFeedBackButtonDidClicked:self.model content:@"不感兴趣"];
            break;
        case 1:
            /*重复/过时*/
            [self.delegate negativeFeedBackButtonDidClicked:self.model content:@"重复/过时"];
            break;
        case 2:
            /*内容太差*/
            [self.delegate negativeFeedBackButtonDidClicked:self.model content:@"内容太差"];
            break;
        case 3:
            /*举报*/
            [self.delegate negativeFeedBackButtonDidClicked:self.model content:@"举报"];
            break;
        default:
            /*没啥用*/
            break;
    }

}

#pragma mark - gesture delegate 解决手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class])isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

@end
