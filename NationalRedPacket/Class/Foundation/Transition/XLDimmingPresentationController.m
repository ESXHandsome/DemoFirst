//
//  SheetAlert.h
//  NationalRedPacket
//
//  Created by Ying on 2018/4/25.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLDimmingPresentationController.h"

@interface XLDimmingPresentationController ()
@property (nonatomic, strong) UIView *dimmingView;
@property (assign, nonatomic) CGFloat height;
@end



@implementation XLDimmingPresentationController

#pragma mark - UIViewControllerTransitioningDelegate
- (UIPresentationController* )presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    self.height = presented.view.height;
    return self;
}

#pragma mark - 重写UIPresentationController个别方法
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    
    if (self) {
        // 必须设置 presentedViewController 的 modalPresentationStyle
        // 在自定义动画效果的情况下，苹果强烈建议设置为 UIModalPresentationCustom
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    
    return self;
}


// 自定义动画开始
- (void)presentationTransitionWillBegin {
    // 背景遮罩
    UIView *dimmingView = [[UIView alloc] initWithFrame:self.containerView.bounds];
    dimmingView.backgroundColor = [UIColor blackColor];
    dimmingView.opaque = self.opaque; //是否透明
    dimmingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [dimmingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmingViewTapped:)]];
    self.dimmingView = dimmingView;
    [self.containerView addSubview:dimmingView];
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    self.dimmingView.alpha = 0.f;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0.4f;
    } completion:NULL];
}

#pragma mark 点击了背景遮罩view
- (void)dimmingViewTapped:(UITapGestureRecognizer*)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

//动画完成
- (void)presentationTransitionDidEnd:(BOOL)completed {
    if (!completed) {
        self.dimmingView = nil;
    }
}

// 消失过渡即将开始的时候被调用的
- (void)dismissalTransitionWillBegin
{
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0.f;
    } completion:NULL];
}

// 动画完成之后调用，此时应该将视图移除，防止强引用
- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed == YES)
    {
        [self.dimmingView removeFromSuperview];
        self.dimmingView = nil;
    }
}

// 返回目标控制器Viewframe
- (CGRect)frameOfPresentedViewInContainerView {
    CGFloat height = self.height;
    CGRect containerViewBounds = self.containerView.bounds;
    containerViewBounds.origin.y = containerViewBounds.size.height - height;
    containerViewBounds.size.height = height;
    return containerViewBounds;
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container {
    [super preferredContentSizeDidChangeForChildContentContainer:container];
    
    if (container == self.presentedViewController)
        [self.containerView setNeedsLayout];
}

- (void)containerViewWillLayoutSubviews {
    [super containerViewWillLayoutSubviews];
    self.dimmingView.frame = self.containerView.bounds;
}

@end
