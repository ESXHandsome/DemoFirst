//
//  XLVideoFloatView.h
//  NationalRedPacket
//
//  Created by bulangguo on 2018/7/18.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "BaseView.h"
#import "XLPlayerConfigModel.h"
#import "CancleHighlightedButton.h"
#import "FeedDetailViewModel.h"

@interface XLVideoFloatView : BaseView

///进度显示条
@property (strong, nonatomic) UIProgressView      *bottomProgressView;

@property (strong, nonatomic) XLPlayerConfigModel *configModel;

@property (strong, nonatomic) XLFeedModel         *feedModel;

@property (strong, nonatomic) FeedDetailViewModel *viewModel;

@property (assign, nonatomic, getter=isClickCloseButton) BOOL clickCloseButton;

- (void)videoDidCompletedPlaying;

/**
 根据播放状态重置播放控件
 */
- (void)resetViewControl;

@end
