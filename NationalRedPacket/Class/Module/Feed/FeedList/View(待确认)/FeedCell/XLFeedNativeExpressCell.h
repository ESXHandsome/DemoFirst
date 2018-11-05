//
//  XLFeedNativeExpressCell.h
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/6/22.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFeedCell.h"

typedef void(^DeleteBlock)();

@interface XLFeedNativeExpressCell : BaseFeedCell

@property (copy, nonatomic) DeleteBlock deleteBlock;

@end
