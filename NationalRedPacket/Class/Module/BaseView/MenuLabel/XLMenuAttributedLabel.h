//
//  XLMenuAttributedLabel.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/25.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <TTTAttributedLabel/TTTAttributedLabel.h>

@class XLMenuAttributedLabel;

@protocol XLMenuAttributedLabelDelegate <TTTAttributedLabelDelegate>

- (void)menuAttributedLabelDeleteAction;
- (void)menuAttributedLabelReportAction;

@optional

- (void)menuAttributedLabelCopyAction;
- (void)touchAttributedLabel;

@end

typedef NS_ENUM(NSUInteger, XLMenuType) {
    XLMenuTypeCopy   = 1 << 0,  // 复制
    XLMenuTypeDelete = 1 << 1,  // 删除
    XLMenuTypeReport = 1 << 2,  // 举报
};

@interface XLMenuAttributedLabel : TTTAttributedLabel

@property (assign, nonatomic) XLMenuType menuType;
@property (weak, nonatomic) id<XLMenuAttributedLabelDelegate> delegate;
@property (readwrite, nonatomic, strong) TTTAttributedLabelLink *activeLink;

///正常背景色
@property (strong, nonatomic) UIColor *normalBackgroundColor;
///按下背景色
@property (strong, nonatomic) UIColor *pressBackgroundColor;

@end
