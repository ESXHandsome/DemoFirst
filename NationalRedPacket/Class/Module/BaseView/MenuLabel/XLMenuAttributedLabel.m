//
//  XLMenuAttributedLabel.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/25.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLMenuAttributedLabel.h"

@implementation XLMenuAttributedLabel

@synthesize delegate;

- (void)setDelegate:(id<XLMenuAttributedLabelDelegate>)delegate {
    super.delegate = delegate;
}

- (id<XLMenuAttributedLabelDelegate>)delegate {
    id menuDelegate = super.delegate;
    return menuDelegate;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

//绑定事件
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self attachLongPressHandler];
        self.pressBackgroundColor = [UIColor colorWithString:COLORE3E3E3];
        self.normalBackgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)attachLongPressHandler {
    UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:touch];
}

- (void)handleLongPress:(UITapGestureRecognizer *)recognizer {
    
    [self becomeFirstResponder];
    self.backgroundColor = self.pressBackgroundColor;
    
    //出现复制/删除/举报
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        UIMenuItem *copyMenuItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyAction:)];
        UIMenuItem *deleteMenuItem = [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(deleteAction:)];
        UIMenuItem *reportMenuItem = [[UIMenuItem alloc]initWithTitle:@"举报" action:@selector(reportAction:)];
        
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        
        if (self.menuType == (XLMenuTypeCopy | XLMenuTypeDelete)) {
            [menuController setMenuItems:[NSArray arrayWithObjects:copyMenuItem, deleteMenuItem, nil]];
        } else if (self.menuType == (XLMenuTypeCopy | XLMenuTypeReport)) {
            [menuController setMenuItems:[NSArray arrayWithObjects:copyMenuItem, reportMenuItem, nil]];
        } else if (self.menuType == XLMenuTypeCopy) {
            [menuController setMenuItems:[NSArray arrayWithObjects:copyMenuItem, nil]];
        } else {
            [menuController setMenuItems:[NSArray arrayWithObjects:copyMenuItem, deleteMenuItem, reportMenuItem, nil]];
        }
        
        [menuController setTargetRect:self.frame inView:self.superview];
        [menuController setMenuVisible:YES animated: YES];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"UIMenuControllerDidHideMenuNotification" object:nil];
    }
}

- (void)dismiss{
    self.backgroundColor = self.normalBackgroundColor;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copyAction:)) {
        return YES;
    }
    if (action == @selector(deleteAction:)) {
        return YES;
    }
    if (action == @selector(reportAction:)) {
        return YES;
    }
    return NO; //隐藏系统默认的菜单项
}

#pragma mark 实现方法

- (void)copyAction:(id)sender {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuAttributedLabelCopyAction)]) {
        [self.delegate menuAttributedLabelCopyAction];
    }
}

- (void)deleteAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuAttributedLabelDeleteAction)]) {
        [self.delegate menuAttributedLabelDeleteAction];
    }
}

- (void)reportAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuAttributedLabelReportAction)]) {
        [self.delegate menuAttributedLabelReportAction];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.activeLink) {  //点击的是链接，传递事件给TTT处理，否则自己处理
        [super touchesEnded:touches withEvent:event];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(touchAttributedLabel)]) {
            [self.delegate touchAttributedLabel];
        } else {
            [super touchesEnded:touches withEvent:event];
        }
    }
    
}

@end
