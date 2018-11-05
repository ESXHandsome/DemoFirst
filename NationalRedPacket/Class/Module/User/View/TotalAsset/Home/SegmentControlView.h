//
//  SegmentControlView.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/3/21.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "BaseView.h"
#import "TotalAssetProtocol.h"

#define kSegmentControlHeight adaptHeight1334(100)

@interface SegmentControlView : BaseView

@property (weak, nonatomic) id<TotalAssetProtocol>delegate;

- (void)selectSegmentControlIndex:(NSInteger)index animated:(BOOL)animated;

- (void)doScrollAnimationWithOffSet:(CGFloat)offSet;

@end
