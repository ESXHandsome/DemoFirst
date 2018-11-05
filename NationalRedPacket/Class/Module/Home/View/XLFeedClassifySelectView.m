//
//  XLFeedClassifySelectView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/7/13.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLFeedClassifySelectView.h"

#define kButtonWidth    adaptWidth750(62*2)
#define kFontSize       adaptFontSize(16*2)
#define kSelectFontSize adaptFontSize(16*2)
#define kNormalColor    [UIColor colorWithString:COLOR666666]
#define kSelectedColor  [UIColor colorWithString:COLORFE6969]

@interface XLFeedClassifySelectView ()

@property (strong, nonatomic) UIScrollView *backScrollView;
@property (strong, nonatomic) UIButton     *selectedButton;
@property (strong, nonatomic) UIView       *animationView;
@property (weak, nonatomic)   id<XLFeedClassifySelectViewDelegate> delegate;

@end

@implementation XLFeedClassifySelectView

- (void)setupViews {
    self.userInteractionEnabled = YES;
    
    self.frame = CGRectMake(0, 0, self.bounds.size.width, 44);
    
    self.backScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    self.backScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.backScrollView];
    
}

- (void)cofigureDelegate:(id<XLFeedClassifySelectViewDelegate>)delegate dataArray:(NSMutableArray *)dataArray {
    
    self.delegate = delegate;
    
    if (!dataArray || dataArray.count == 0) {
        dataArray = @[@"关注", @"推荐", @"视频", @"趣图"].mutableCopy;
    }
    
    self.backScrollView.frame = CGRectMake(0, 0, kButtonWidth * dataArray.count, self.height);
    self.backScrollView.centerX = self.centerX;
    
    [dataArray enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(idx * kButtonWidth, 12, kButtonWidth, 22);
        button.tag = 500 + idx;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:kNormalColor forState:UIControlStateNormal];
        [button setTitleColor:kSelectedColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:kFontSize];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.backScrollView addSubview:button];
        
        UIView *redDotView = [UIView new];
        redDotView.tag = 600 + idx;
        redDotView.frame = CGRectMake(0, 0, 7, 7);
        redDotView.backgroundColor = [UIColor colorWithString:COLORFF3E3D];
        redDotView.layer.cornerRadius = 7 / 2.0;
        redDotView.clipsToBounds = YES;
        redDotView.hidden = YES;
        [button.titleLabel addSubview:redDotView];
        redDotView.x = button.titleLabel.width + button.titleLabel.x - 4;
        redDotView.y = -5;
        
    }];
    
    UIButton *button = (UIButton *)[self viewWithTag:501];
    button.titleLabel.font = [UIFont systemFontOfSize:kSelectFontSize];
    button.selected = YES;
    self.selectedButton = button;
    
    self.animationView = [UIView new];
    self.animationView.backgroundColor = kSelectedColor;
    self.animationView.layer.cornerRadius = 2;
    self.animationView.layer.masksToBounds = YES;
    [self.backScrollView addSubview:self.animationView];
    
    self.animationView.frame = CGRectMake(0, self.height - 4 - 4.5, adaptWidth750(32), 4);
    self.animationView.centerX = self.selectedButton.centerX;
    
}

- (void)buttonAction:(UIButton *)sender {
    
    [self switchToButton:sender backBlock:YES];
}

- (void)selectClassifyIndex:(NSInteger)index {
    
    UIButton *button = (UIButton *)[self viewWithTag:index + 500];
    [self switchToButton:button backBlock:NO];
}

- (void)switchToButton:(UIButton *)sender backBlock:(BOOL)isBackBlock {
    
    if (self.selectedButton != sender) {
        
        self.selectedButton.titleLabel.font = [UIFont systemFontOfSize:kFontSize];
        sender.selected = !sender.selected;
        self.selectedButton.selected = !self.selectedButton.selected;
        self.selectedButton = sender;
        self.selectedButton.titleLabel.font = [UIFont systemFontOfSize:kSelectFontSize];
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(classifySelectView:didSelectClassify:)] && isBackBlock) {
            [self.delegate classifySelectView:self didSelectClassify:sender.tag - 500];
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            self.animationView.centerX = self.selectedButton.centerX;
        }];
        
    }
}

- (void)scrollAnimationView:(UIScrollView *)scrollView {
    
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat moveLength = kButtonWidth;
    CGFloat imageViewX = offsetX/SCREEN_WIDTH*moveLength + 25;
    
    self.animationView.x = imageViewX;
}

- (void)showClassifyRedDotTip:(BOOL)show index:(NSInteger)index {
    UIView *redDot = [self viewWithTag:index + 600];
    redDot.hidden = !show;
}

@end
