//
//  FeedVideoDetailViewController.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/7.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "FeedDetailViewController.h"

@interface FeedVideoDetailViewController : FeedDetailViewController

@property (assign, nonatomic) BOOL isVideoPlaying;
@property (copy, nonatomic) void (^videoDetailEndPlay_block)(BOOL isVideoPlaying,BOOL isVideoPlayToEnd);

@end
