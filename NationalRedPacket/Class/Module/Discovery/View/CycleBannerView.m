//
//  CycleBannerView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/4/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "CycleBannerView.h"
#import "BannerImageCell.h"

@interface CycleBannerView () <TYCyclePagerViewDelegate, TYCyclePagerViewDataSource>

@property (strong, nonatomic) TYPageControl    *pageControl;
@property (strong, nonatomic) NSMutableArray   *dataArray;

@end

@implementation CycleBannerView

- (void)setupViews
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, kBannerHeight);
    [self addSubview:self.pagerView];
    [self.pagerView addSubview:self.pageControl];
    
    self.pagerView.frame = self.frame;
    self.pageControl.frame = CGRectMake(0, kBannerHeight - adaptHeight1334(48*2), SCREEN_WIDTH, adaptHeight1334(24));
}

- (void)configDataArray:(NSArray *)dataArray
{
    self.dataArray = dataArray.mutableCopy;
    self.pageControl.numberOfPages = self.dataArray.count;
    [self.pagerView reloadData];
}

#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.dataArray.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    BannerImageCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"BannerImageCellID" forIndex:index];
    BannerModel *model = self.dataArray[index];
    [cell.bannerImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(adaptWidth750(320*2), adaptHeight1334(166*2));
    layout.itemSpacing = adaptWidth750(22);
    layout.minimumScale = 0.93;  //缩放比例
    layout.layoutType = TYCyclePagerTransformLayoutLinear;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    [self.pageControl setCurrentPage:toIndex animate:YES];
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectBannerView:bannerModel:)]) {
        [self.delegate didSelectBannerView:self bannerModel:self.dataArray[index]];
    }
}

#pragma mark - Lazy Loading
- (TYCyclePagerView *)pagerView
{
    if (!_pagerView) {
        self.pagerView = [[TYCyclePagerView alloc]init];
        self.pagerView.isInfiniteLoop = YES;
        self.pagerView.autoScrollInterval = 5.0;
        self.pagerView.dataSource = self;
        self.pagerView.delegate = self;
        [self.pagerView registerNib:[UINib nibWithNibName:NSStringFromClass([BannerImageCell class]) bundle:nil] forCellWithReuseIdentifier:@"BannerImageCellID"];
    }
    return _pagerView;
}

- (TYPageControl *)pageControl
{
    if (!_pageControl) {
        self.pageControl = [[TYPageControl alloc] init];
        CGFloat controlWidth = adaptWidth750(8);
        self.pageControl.currentPageIndicatorSize = CGSizeMake(controlWidth, controlWidth);
        self.pageControl.pageIndicatorSize = CGSizeMake(controlWidth, controlWidth);
        self.pageControl.pageIndicatorSpaing = controlWidth;
        self.pageControl.pageIndicatorTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
    return _pageControl;
}

@end
