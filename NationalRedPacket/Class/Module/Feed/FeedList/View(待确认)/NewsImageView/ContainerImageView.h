//
//  ContainerImageView.h
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/2/22.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LayoutType) {
    LayoutTypeHome   = 0,  //首页
    LayoutTypeDetail = 1   //详情页
};

@interface ContainerImageView : UIView

@property (strong, nonatomic) XLFeedModel *newsModel;

@property (assign, nonatomic) BOOL isPlaying;

@property (assign, nonatomic) NSInteger playingPlace;

@property (assign, nonatomic) BOOL isOneGif;

- (void)configImageArray:(NSArray *)array layoutType:(LayoutType)layoutType isDetail:(BOOL)isDetail;

//递归播放
- (void)playGifImageViewWithNumber:(NSInteger)number;

//停止递归
- (void)stopPlayGifImageView;

//重启
- (void)rebootPlayGifImageView;

//是否此view上没有 => 可播放的cell
- (BOOL)isAllCellCanNotPlay;

//是否自动播放
- (BOOL)isAutoPlayGifImageView;


@end
