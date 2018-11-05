//
//  ImageCell.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/2/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FLAnimatedImage/FLAnimatedImage.h>
#import "FLAnimatedImageView+WebCache.h"
#import "XLLoadIndicator.h"

typedef void(^Completed)(BOOL isFromFirst);

static NSString *const ImageCellID = @"ImageCellID";

@interface ImageCell : UICollectionViewCell

@property (strong, nonatomic) ImageModel          *imageModel;
@property (strong, nonatomic) FLAnimatedImageView *imageView;
@property (strong, nonatomic) UIImageView         *labelImageView;
@property (strong, nonatomic) XLLoadIndicator     *loadIndicator;
@property (assign, nonatomic) NSInteger  indexPlace;      //位置
@property (assign, nonatomic) BOOL       isPlayingGif;    //是否正在播放gif
@property (assign, nonatomic) BOOL       isGifImageView;  //是否是动图
@property (assign, nonatomic) BOOL       isPausePlayGif;  //是否被其他操作阻挡播放了

//赋值
- (void)configImageModel:(ImageModel *)model indexPath:(NSIndexPath *)indexPath isMultiImage:(BOOL)isMultiImage isDetail:(BOOL)isDetail;

//播放gif
- (void)startGifImageViewCompleted:(Completed)completed;

//停止播放gif
- (void)stopGifImageView;

//是否在播放范围内
- (BOOL)isConfineToPlayArea;

@end
