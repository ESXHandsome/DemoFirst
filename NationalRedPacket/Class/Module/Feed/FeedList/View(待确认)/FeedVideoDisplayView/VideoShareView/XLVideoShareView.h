//
//  XLVideoShareView.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/7/5.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XLViewPlayToEndOperationType) {
    XLViewPlayToEndOperationTypeReplay,
    XLViewPlayToEndOperationTypeWechat,
    XLViewPlayToEndOperationTypeTimeLine,
    XLViewPlayToEndOperationTypeQQZone,
    XLViewPlayToEndOperationTypeQQChat
};

@protocol XLViewPlayToEndOperationDelegate <NSObject>

- (void)didClickOperationButton:(XLViewPlayToEndOperationType)type;
- (void)videoShareViewDidClickCloseButton;

@end

@interface XLVideoShareView : BaseView

@property (weak, nonatomic) id<XLViewPlayToEndOperationDelegate> delegate;

- (void)hiddeTopCloseButton:(BOOL)hidden;

@end
