//
//  NIMInputEmoticonTabView.m
//  NIMKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "NIMInputEmoticonTabView.h"
#import "NIMInputEmoticonManager.h"
#import "UIView+NIM.h"
#import "UIImage+NIMKit.h"
#import "NIMGlobalMacro.h"

const NSInteger NIMInputEmoticonTabViewHeight = 35;
const NSInteger NIMInputEmoticonSendButtonWidth = 55;

const CGFloat NIMInputLineBoarder = .5f;

@interface NIMInputEmoticonTabView()

@property (nonatomic,strong) NSMutableArray * tabs;

@property (nonatomic,strong) NSMutableArray * seps;

@end

#define sepColor NIMKit_UIColorFromRGB(0xE6E6E6)

@implementation NIMInputEmoticonTabView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, frame.size.width, NIMInputEmoticonTabViewHeight)];
    if (self) {
        _tabs = [[NSMutableArray alloc] init];
        _seps = [[NSMutableArray alloc] init];
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendButton setTitleColor:[UIColor colorWithString:COLOR333333] forState:UIControlStateNormal];
        [_sendButton setBackgroundColor:[UIColor colorWithString:COLORFE6969]];
        
        _sendButton.nim_height = NIMInputEmoticonTabViewHeight;
        _sendButton.nim_width = NIMInputEmoticonSendButtonWidth;
        [self addSubview:_sendButton];
        
        self.layer.borderColor = sepColor.CGColor;
        self.layer.borderWidth = NIMInputLineBoarder;
        
    }
    return self;
}


- (void)loadCatalogs:(NSArray*)emoticonCatalogs
{
    for (UIView *subView in [_tabs arrayByAddingObjectsFromArray:_seps]) {
        [subView removeFromSuperview];
    }
    [_tabs removeAllObjects];
    [_seps removeAllObjects];
    for (NIMInputEmoticonCatalog * catelog in emoticonCatalogs) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage nim_fetchEmoticon:catelog.icon] forState:UIControlStateNormal];
        [button setImage:[UIImage nim_fetchEmoticon:catelog.iconPressed] forState:UIControlStateHighlighted];
        [button setImage:[UIImage nim_fetchEmoticon:catelog.iconPressed] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(onTouchTab:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        [self addSubview:button];
        [_tabs addObject:button];
        
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, NIMInputLineBoarder, NIMInputEmoticonTabViewHeight)];
        sep.backgroundColor = sepColor;
        [_seps addObject:sep];
        [self addSubview:sep];
    }
}

- (void)onTouchTab:(id)sender{
    NSInteger index = [self.tabs indexOfObject:sender];
    [self selectTabIndex:index];
    if ([self.delegate respondsToSelector:@selector(tabView:didSelectTabIndex:)]) {
        [self.delegate tabView:self didSelectTabIndex:index];
    }
}


- (void)selectTabIndex:(NSInteger)index{
    for (NSInteger i = 0; i < self.tabs.count ; i++) {
        UIButton *btn = self.tabs[i];
        btn.selected = i == index;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat spacing = 10;
    CGFloat left    = spacing;
    for (NSInteger index = 0; index < self.tabs.count ; index++) {
        UIButton *button = self.tabs[index];
        button.nim_left = left;
        button.nim_centerY = self.nim_height * .5f + 5/2.0;
        button.height = 25;
        button.width = 25;
        
        UIView *sep = self.seps[index];
        sep.nim_left = (int)(button.nim_right + spacing);
        left = (int)(sep.nim_right + spacing);
    }
    _sendButton.nim_right = (int)self.nim_width;
}


@end

