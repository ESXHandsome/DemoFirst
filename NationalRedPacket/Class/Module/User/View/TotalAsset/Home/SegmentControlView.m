//
//  SegmentControlView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/21.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "SegmentControlView.h"

@interface SegmentControlView ()

@property (strong, nonatomic) UIView *animationView;
@property (strong, nonatomic) UIButton *saveButton;

@end

@implementation SegmentControlView

- (void)setupViews
{
    self.backgroundColor = [UIColor whiteColor];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, kSegmentControlHeight);
    
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = [UIColor colorWithString:COLORE6E6E6];
    [self addSubview:bottomLine];

    self.animationView = [UIView new];
    self.animationView.backgroundColor = [UIColor colorWithString:COLORFE6969];
    self.animationView.layer.cornerRadius = adaptHeight1334(3);
    self.animationView.layer.masksToBounds = YES;
    [self addSubview:self.animationView];
    
    NSArray *titleArray = @[@"金币", @"零钱"];
    [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 200 + idx;
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithString:COLOR999999] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithString:COLORFE6969] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            if (idx == 0) {
                make.left.equalTo(self).offset(adaptWidth750(140));
            } else {
                make.right.equalTo(self).offset(-adaptWidth750(140));
            }
            make.bottom.equalTo(self).offset(-adaptHeight1334(8));
            make.width.mas_equalTo(button.titleLabel.mj_textWith + adaptWidth750(20));
        }];
        
    }];
    
    UIButton *button = (UIButton *)[self viewWithTag:200];
    button.selected = YES;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:adaptFontSize(32)];
    self.saveButton = button;
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    [self layoutIfNeeded];
    
    self.animationView.frame = CGRectMake(100, self.height - adaptHeight1334(6) - 1, adaptWidth750(60), adaptHeight1334(6));
    self.animationView.centerX = self.saveButton.centerX;
}

- (void)buttonAction:(UIButton *)sender
{
    [self switchButton:sender animated:YES];
}

- (void)selectSegmentControlIndex:(NSInteger)index animated:(BOOL)animated
{
    UIButton *button = (UIButton *)[self viewWithTag:index + 200];
    [self switchButton:button animated:animated];
}

- (void)switchButton:(UIButton *)sender animated:(BOOL)animated
{
    if (self.saveButton != sender) {
        sender.selected = !sender.selected;
        self.saveButton.selected = !self.saveButton.selected;
        self.saveButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
        self.saveButton = sender;
        self.saveButton.titleLabel.font = [UIFont boldSystemFontOfSize:adaptFontSize(32)];
        if (animated) {
            [UIView animateWithDuration:0.25 animations:^{
                self.animationView.centerX = self.saveButton.centerX;
            }];
        } else {
            self.animationView.centerX = self.saveButton.centerX;
        }
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didSelectSegmentControlIndex:)]) {
            [self.delegate didSelectSegmentControlIndex:self.saveButton.tag - 200];
        }
    }
}

/**
 滚动动画

 @param offSet 偏移
 */
- (void)doScrollAnimationWithOffSet:(CGFloat)offSet
{
    //TODO
    return;
}

@end
