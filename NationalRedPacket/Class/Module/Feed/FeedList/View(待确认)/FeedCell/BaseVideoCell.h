//
//  BaseVideoWithAuthorCell.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/5/7.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFeedAuthorCell.h"
#import "XLFeedModel.h"
#import "VideoDisplayView.h"

@class BaseVideoCell;

@interface BaseVideoCell : BaseFeedAuthorCell

@property (strong, nonatomic) XLFeedModel *model;
@property (strong, nonatomic) VideoDisplayView *videoDisPlayView;
@property (strong, nonatomic) UIView *videoDisPlayViewContainerView;

- (void)setupBaseSubviews;
- (void)configBaseModelData:(XLFeedModel *)model indexPath:(NSIndexPath *)indexPath;

@end
