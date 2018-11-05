//
//  ContainerImageView.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/2/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "ContainerImageView.h"
#import "ImageCell.h"
#import "UIImage+Tool.h"
#import "UIImageView+PlayGIF.h"
#import "XLPhotoShowView.h"
#import "PPSAlertView.h"
#import "WechatShare.h"
#import "PPSSavePhoto.h"
#import "GifPlayManager.h"
#import "XLPlayer.h"
#import "SDWebImagePrefetcher.h"
#import "XLPlayerManager.h"

#define kImageSpec adaptWidth750(6)

@interface ContainerImageView ()<UICollectionViewDelegate, UICollectionViewDataSource ,PPSPhotoShowViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UICollectionView           *collectionView;
@property (strong, nonatomic) NSMutableArray             *imageArray;
@property (assign, nonatomic) BOOL                       isDetail;

@property (assign, nonatomic) CGFloat                    imageWidth1;
@property (assign, nonatomic) CGFloat                    imageWidth2;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;

@property (assign, nonatomic) NSInteger                  currentPhotoPage;
@property (strong, nonatomic) NSMutableArray             *playIndexArray; //记录所有可播放位置数组
@property (strong, nonatomic) ImageCell                  *playingCell;

@end

@implementation ContainerImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self p_setupViews];
    }
    return self;
}

- (void)p_setupViews
{
    [self addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.top.equalTo(self);
    }];
    
}

- (void)configImageArray:(NSArray *)array layoutType:(LayoutType)layoutType isDetail:(BOOL)isDetail
{
    self.isDetail = isDetail;
    self.imageArray = array.mutableCopy;
    [self updateCollectionViewLayout:array layoutType:layoutType];
    [self.collectionView reloadData];
    
    self.playIndexArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        ImageModel *model = array[i];
        if ([model.originalImage containsString:@".gif"]) {
            [self.playIndexArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
}

//递归播放
- (void)playGifImageViewWithNumber:(NSInteger)number
{
    if (![self isAutoPlayGifImageView] ||
        self.playIndexArray.count == 0 ||
        [self isAllCellCanNotPlay]) {
        //非wifi
        //没有gif图
        //不在范围内
        return;
    }
    [self.playingCell stopGifImageView]; //播放前停止正在播放的cell，避免同时播放问题
    self.playingPlace = number;
    ImageCell *cell = (ImageCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:number inSection:0]];
    __block NSInteger temp = number;
    if (!cell.isGifImageView || ![cell isConfineToPlayArea]) { //如果不是gif或者不再播放范围，则跳过
        temp++;
        if (temp > self.imageArray.count - 1) {
            temp = 0;
        }
        [self playGifImageViewWithNumber:temp];
        return;
    }
    [self cacheNextGifImageWithIndex:temp+1];
    //正在播放的cell
    self.playingCell = cell;
    self.playingCell.isPausePlayGif = NO; //开始递归
    
    if (XLPlayer.sharedInstance.isPlaying) {
        self.isPlaying = NO;
        return;
    }
    self.isPlaying = YES;
    //播放
    [cell startGifImageViewCompleted:^(BOOL isFromFirst) {
        if (isFromFirst) {
            [self playGifImageViewWithNumber:0];
        } else {
            temp++;
            if (temp > self.imageArray.count - 1) {
                temp = 0;
            }
            [self playGifImageViewWithNumber:temp];
        }
    }];
}

//停止递归
- (void)stopPlayGifImageView
{
    [self.playingCell stopGifImageView];   //停止当前播放的cell
    self.playingCell.isPausePlayGif = YES; //停止递归
}

//重启
- (void)rebootPlayGifImageView
{
    [self playGifImageViewWithNumber:self.playingCell.indexPlace];
}

- (BOOL)isAllCellCanNotPlay
{
    if (self.playIndexArray.count == 0) {  //先判断是否有gif
        return YES;
    }
    for (int i = 0; i < self.imageArray.count; i++) {
        ImageCell *cell = (ImageCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if ([cell isConfineToPlayArea] && [cell isGifImageView]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isOneGif
{
    return self.playIndexArray.count == 1 ? YES : NO;
}

//是否自动播放
- (BOOL)isAutoPlayGifImageView
{
    //暂时这么加，后续重构的时候写
    if (![NetworkManager.shared.netWorkTypeString isEqualToString:XLAlertNetworkWIFI]) {
        return XLPlayerManager.shared.video4GShouldAutoPlay;
    }
    return XLPlayerManager.shared.videoWifiShouldAutoPlay;

}

//缓存gif图
- (void)cacheNextGifImageWithIndex:(NSInteger)index
{
    if (self.imageArray.count == 1) {  //单图gif时不缓存下一个
        return;
    }
    if (index > self.imageArray.count - 1) {
        index = 0;
    }
    ImageModel *nextModel = self.imageArray[index];
    //缓存gif
    if (nextModel.previewGif) {
        [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:@[[NSURL URLWithString:nextModel.previewGif]]];
    }
}

//更新布局约束
- (void)updateCollectionViewLayout:(NSArray *)array layoutType:(LayoutType)layoutType
{
    self.imageWidth1 = (SCREEN_WIDTH - 2 * kImageSpec) / 3.0;
    self.imageWidth2 = (SCREEN_WIDTH - kImageSpec) / 2.0;
    
    NSInteger countHeight = [self getCountHeight:array.count];
    CGFloat   itemWidth;
    CGFloat   itemHeight;
    
    if (self.imageArray.count == 1) {
        ImageModel *imageModel = array.firstObject;
        CGSize itemSize = [self layoutSignImageWithImageModel:imageModel type:layoutType];
        itemWidth = itemSize.width;
        itemHeight = itemSize.height;
    } else {
        itemWidth = itemHeight = [self getImageWidth:array.count];
    }
    
    self.layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(itemHeight * countHeight + kImageSpec * (countHeight - 1));
    }];
    
}

#pragma mark - CollectionViewDelegateAndDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCellID forIndexPath:indexPath];
    ImageModel *imageModel = self.imageArray[indexPath.row];
    [cell configImageModel:imageModel indexPath:indexPath isMultiImage:self.imageArray.count > 1 ? YES : NO isDetail:self.isDetail];
    
    return cell;
}

/*图片展示代码这里开始*/
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self stopPlayGifImageView];
    [GifPlayManager sharedManager].playingGifCell.containerView.isPlaying = NO;
    
    [StatServiceApi statEvent:IMAGE_BROWSER_CLICK model:self.newsModel];
    [StatServiceApi statEventBegin:IMAGE_BROWSER_DURATION model:self.newsModel];
    
    ImageCell * cell = (ImageCell *)[collectionView cellForItemAtIndexPath:indexPath];
    XLPhotoShowView *photoShowView = [[XLPhotoShowView alloc] initWithGroupItems:_imageArray];
    photoShowView.delegate = self;
    photoShowView.isDetail = _isDetail;
    photoShowView.currentPage = indexPath.row;
    photoShowView.newsModel = self.newsModel;
    [photoShowView presentFromImageView:cell toContainer:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
    
}

- (UIView *)dismissAction:(NSInteger)currentPage{
    return [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:(currentPage-1) inSection:0]];
}
-(void)dismissAtCurrentPage:(NSInteger)currentPage{
    if (![XLPlayer sharedInstance].isPlaying && [self isAutoPlayGifImageView]) {
        if ((self == [GifPlayManager sharedManager].playingGifCell.containerView && [GifPlayManager sharedManager].playingGifCell.containerView.isPlaying == NO)) {
            [self stopPlayGifImageView];
            [self playGifImageViewWithNumber:currentPage - 1];
            self.playingCell.labelImageView.hidden = YES;
            self.playingCell.loadIndicator.hidden = YES;
        } else {
            if (self.isDetail) {
                [self stopPlayGifImageView];
                [self playGifImageViewWithNumber:currentPage - 1];
                self.playingCell.labelImageView.hidden = YES;
                self.playingCell.loadIndicator.hidden = YES;
            }
        }
    }
    [StatServiceApi statEventEnd:IMAGE_BROWSER_DURATION model:self.newsModel];
}

/*这里结束*/

- (void)tapSignImageView
{
    [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

#pragma mark - layout相关方法

- (NSInteger)getCountHeight:(NSInteger)count
{
    NSInteger countHeight;
    if (count == 2 || count == 4) {  // 2、4图情况
        countHeight = count / 2;
    } else if (count <= 6) {
        if (count <= 3) {
            countHeight = 1;
        } else {
            countHeight = 2;
        }
    } else {
        countHeight = 3;
    }
    return countHeight;
}

- (CGFloat)getImageWidth:(NSInteger)count
{
    CGFloat imageWidth = self.imageWidth1;
    if (count == 2 || count == 4) {  // 2、4图情况
        imageWidth = self.imageWidth2;
    }
    return imageWidth;
}

- (CGSize)layoutSignImageWithImageModel:(ImageModel *)imageModel type:(LayoutType)layoutType
{
    CGFloat scale = imageModel.width.floatValue / imageModel.height.floatValue;
    CGFloat width = SCREEN_WIDTH;
    CGFloat height = width / scale;
    if (layoutType == LayoutTypeHome) {
        if (imageModel.height.floatValue / imageModel.width.floatValue > 18/9.0) {
            height = width;
            imageModel.isShowFullButton = YES;
        }
    }
    return CGSizeMake(width, height);
}

#pragma mark - Lazy Loading

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        self.layout.minimumLineSpacing = kImageSpec;
        self.layout.minimumInteritemSpacing = kImageSpec;
        self.layout.itemSize = CGSizeMake(self.imageWidth1, self.imageWidth1);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        [_collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:ImageCellID];
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

@end

