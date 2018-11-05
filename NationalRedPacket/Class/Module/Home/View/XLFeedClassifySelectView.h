//
//  XLFeedClassifySelectView.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/7/13.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "BaseView.h"

@class XLFeedClassifySelectView;

@protocol XLFeedClassifySelectViewDelegate <NSObject>

- (void)classifySelectView:(XLFeedClassifySelectView *)selectView didSelectClassify:(NSInteger)index;

@end


@interface XLFeedClassifySelectView : BaseView

- (void)cofigureDelegate:(id<XLFeedClassifySelectViewDelegate>)delegate dataArray:(NSMutableArray *)dataArray;

- (void)selectClassifyIndex:(NSInteger)index;

- (void)scrollAnimationView:(UIScrollView *)scrollView;

- (void)showClassifyRedDotTip:(BOOL)show index:(NSInteger)index;

@end
