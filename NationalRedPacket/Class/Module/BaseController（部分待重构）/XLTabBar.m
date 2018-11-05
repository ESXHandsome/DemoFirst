//
//  XLTabBar.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/7/11.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLTabBar.h"

@interface XLTabBar ()

@property (strong, nonatomic) UIButton *publishButton;

@end

@implementation XLTabBar

+ (instancetype)tabBarWithPublishTarget:(id)target publishAction:(SEL)action {
    
    XLTabBar *tabBar = [XLTabBar new];
    [tabBar.publishButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return tabBar;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.publishButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 设置发布按钮的位置
    self.publishButton.centerX = self.width*0.5;
    self.publishButton.centerY = self.height*0.5;
    
    // 设置其他TabbarButton的frame
    CGFloat tabBarButtonWidth = self.width / 5;
    NSArray *titleArray = [self.items valueForKeyPath:@"title"];
    
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            NSInteger tabBarButtonIndex = 0;
            NSString *title = [(UILabel *)child.subviews[1] text];
            if ([titleArray containsObject:title]) {
                tabBarButtonIndex = [titleArray indexOfObject:title];
            }
            if (tabBarButtonIndex >= 2) {
                tabBarButtonIndex++;
            }
            child.x = tabBarButtonIndex * tabBarButtonWidth;
            child.width = tabBarButtonWidth;
        }
    }
}

#pragma mark - lazy loading
- (UIButton *)publishButton {
    if (!_publishButton) {
        self.publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *groundImage = [UIImage imageNamed:@"release"];
        [self.publishButton setBackgroundImage:groundImage forState:UIControlStateNormal];
        self.publishButton.size = groundImage.size;
    }
    return _publishButton;
}

@end
