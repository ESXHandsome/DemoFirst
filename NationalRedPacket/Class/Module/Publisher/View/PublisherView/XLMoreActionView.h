//
//  XLMoreActionView.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/6/12.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLMoreActionView;

@protocol XLMoreActionViewDelegate <NSObject>

@optional

- (void)didSelectedMoreActionView:(XLMoreActionView *)view index:(NSInteger)index;

@end

@interface XLMoreActionView : UIView

@property (weak, nonatomic) id<XLMoreActionViewDelegate>delegate;

- (void)show;

@end
