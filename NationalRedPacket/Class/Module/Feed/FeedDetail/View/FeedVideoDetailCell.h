//
//  FeedVideoDetailCell.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "BaseFeedAuthorCell.h"
#import "VideoDisplayView.h"

@interface FeedVideoDetailCell : BaseFeedAuthorCell

@property (strong, nonatomic) VideoDisplayView *videoDisplayView;

- (void)updateDetailInfo;

@end
