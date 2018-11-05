//
//  CycleBannerView.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoicenessInfoHeaderView.h"
#import "DiscoveryModel.h"
#import "TYCyclePagerView.h"
#import "TYPageControl.h"

#define kBannerHeight adaptHeight1334(166*2+27*4)

@class CycleBannerView;

@protocol CycleBannerViewDelegate <NSObject>

/**
 选择了banner
 
 @param bannerView bannerView
 @param model BannerModel
 */
- (void)didSelectBannerView:(CycleBannerView *)bannerView bannerModel:(BannerModel *)model;

@end

@interface CycleBannerView : BaseView

@property (strong, nonatomic) TYCyclePagerView *pagerView;

@property (weak, nonatomic) id<CycleBannerViewDelegate> delegate;

- (void)configDataArray:(NSArray *)dataArray;

@end
