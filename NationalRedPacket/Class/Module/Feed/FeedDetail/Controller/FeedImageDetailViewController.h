//
//  FeedImageDetailViewController.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/7.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "FeedDetailViewController.h"

@protocol FeedImageDetailViewControllerDelete <NSObject>

- (void)imageDetailDidClickDelegateButton;

@end

@interface FeedImageDetailViewController : FeedDetailViewController

///进入时GIF播放位置
@property (assign, nonatomic) NSInteger palyPlace;
///回传GIF播放位置
@property (copy, nonatomic) void (^ContinueGifPlayPlace)(NSInteger place);

@end
