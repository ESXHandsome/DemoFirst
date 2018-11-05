//
//  TabSelectHeaderView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "CategorySelectHeaderView.h"

#define kButtonWidth adaptWidth750(52*2)
#define kLeftSpec    adaptWidth750(12)
#define kFontSize    adaptFontSize(16*2)
#define kSelectFontSize adaptFontSize(16*2)
#define kMaxWidth (SCREEN_WIDTH - adaptWidth750(52*2))

@interface CategorySelectHeaderView ()

@property (strong, nonatomic) UIScrollView *backScrollView;
@property (strong, nonatomic) UIButton     *selectedButton;
@property (strong, nonatomic) UIView       *animationView;
@property (weak, nonatomic)   id<CategorySelectHeaderViewDelegate> delegate;

@end

@implementation CategorySelectHeaderView

- (void)setupViews
{
    self.userInteractionEnabled = YES;
    
    self.frame = CGRectMake(0, 0, self.bounds.size.width, 44);
    
    self.backScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    self.backScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.backScrollView];
}

- (void)cofigureDelegate:(id<CategorySelectHeaderViewDelegate>)delegate dataArray:(NSMutableArray *)dataArray
{
    self.delegate = delegate;
    
    __block CGFloat totalAddLength = 0;
    
    [dataArray enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(idx * kButtonWidth + kLeftSpec + totalAddLength, 15, kButtonWidth, 22);
        button.tag = 200 + idx;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithString:COLOR999999] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithString:COLORFE6969] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:kFontSize];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.backScrollView addSubview:button];
        
        if (title.length > 2) {
            CGFloat addWidth = button.titleLabel.mj_textWith - adaptWidth750(32*2);
            button.width += addWidth;
            totalAddLength += addWidth;
        }
    }];
    
    self.backScrollView.contentSize = CGSizeMake(dataArray.count * kButtonWidth + kLeftSpec * 2 + totalAddLength, self.height);
    
    UIButton *button = (UIButton *)[self viewWithTag:200];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:kSelectFontSize];
    button.selected = YES;
    self.selectedButton = button;
    
    self.animationView = [UIView new];
    self.animationView.backgroundColor = [UIColor colorWithString:COLORFE6969];
    self.animationView.layer.cornerRadius = 1;
    self.animationView.layer.masksToBounds = YES;
    [self.backScrollView addSubview:self.animationView];
    
    self.animationView.frame = CGRectMake(0, self.height - 2 - 4.5, adaptWidth750(60), 2);
    self.animationView.centerX = self.selectedButton.centerX;
    
}

- (void)buttonAction:(UIButton *)sender
{
    [self switchToButton:sender backBlock:YES];
}

- (void)selectCategoryIndex:(NSInteger)categoryIndex
{
    UIButton *button = (UIButton *)[self viewWithTag:categoryIndex + 200];
    [self switchToButton:button backBlock:NO];
}

- (void)switchToButton:(UIButton *)sender backBlock:(BOOL)isBackBlock
{
    if (self.selectedButton != sender) {
        
        self.selectedButton.titleLabel.font = [UIFont boldSystemFontOfSize:kFontSize];
        sender.selected = !sender.selected;
        self.selectedButton.selected = !self.selectedButton.selected;
        self.selectedButton = sender;
        self.selectedButton.titleLabel.font = [UIFont boldSystemFontOfSize:kSelectFontSize];
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(categorySelectView:didSelectCategory:)] && isBackBlock) {
            [self.delegate categorySelectView:self didSelectCategory:sender.tag - 200];
        }
        
        //保证后面的按钮能提前显示出来
        CGFloat centerWidth = sender.x + sender.width;
        
        if (centerWidth > kMaxWidth && self.backScrollView.mj_offsetX <= sender.x - sender.width) { //向右滑动
            if (self.backScrollView.contentSize.width - centerWidth > kButtonWidth) {
                if (centerWidth - kMaxWidth > self.backScrollView.mj_offsetX) {
                    [self.backScrollView setContentOffset:CGPointMake(centerWidth - kMaxWidth, 0) animated:YES];
                }
            } else {
                if (self.backScrollView.contentSize.width > SCREEN_WIDTH) {
                    [self.backScrollView setContentOffset:CGPointMake(self.backScrollView.contentSize.width - SCREEN_WIDTH, 0) animated:YES];
                }
            }
        } else if (self.backScrollView.mj_offsetX > sender.x - sender.width) { //向左滑动
            if (self.backScrollView.mj_offsetX - sender.width < 0) {
                [self.backScrollView setContentOffset:CGPointZero animated:YES];
            } else {
                [self.backScrollView setContentOffset:CGPointMake(self.backScrollView.mj_offsetX - sender.width, 0) animated:YES];
            }
        }

        //延迟0.01秒执行，保证动画正常
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25 animations:^{
                self.animationView.width = self.selectedButton.titleLabel.mj_textWith;
                self.animationView.centerX = self.selectedButton.centerX;
                
            }];
        });
        
    }
}

@end
