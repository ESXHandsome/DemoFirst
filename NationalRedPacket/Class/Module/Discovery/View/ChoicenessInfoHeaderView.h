//
//  ChoicenessInfoHeaderView.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CycleBannerView.h"

@class CycleBannerView, FollowButton;

@interface ChoicenessInfoHeaderView : BaseView

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *bannerDataArray;
@property (strong, nonatomic) NSMutableArray *publisherCardArray;

- (void)configDelegate:(id)delegateObject;

- (void)setBannerTimerStart:(BOOL)isStart;

@end
