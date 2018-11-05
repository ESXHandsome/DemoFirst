//
//  BaseVideoWithAuthorCell.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/5/7.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "BaseVideoCell.h"
#import "NSString+NumberAdapt.h"
#import "UIImage+Tool.h"
#import "CommentContainerView.h"
#import "NSString+NumberAdapt.h"
#import "XLPlayerManager.h"

#define kImageHeight adaptHeight1334(196*2)

@interface BaseVideoCell ()

@property (nonatomic, strong) XLPlayerConfigModel *configModel;

@end

@implementation BaseVideoCell

#pragma mark -
#pragma mark UI Initialize

- (void)setupViews {
    [super setupViews];
    
    self.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];
    self.fullTextButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(32)];    
  
    [self setupBaseSubviews];
}

#pragma mark -
#pragma mark Public Method

/**
 * 配置数据
 *
 */
- (void)configModelData:(XLFeedModel *)model indexPath:(NSIndexPath *)indexPath {
    [super configModelData:model indexPath:indexPath];
    _model = model;

    self.commentContainerView.model = model;
    self.videoDisPlayView.feedModel = model;
    self.videoDisPlayView.playerConfigModel = [self configPlayerModel:model];
    [self.videoDisPlayView configMuteButtonDisplay];
    [self.videoDisPlayView configCoverImageViewWithURL:[NSURL URLWithString:model.picture.firstObject]];
    
    [self clearVideoSubLayers];
    [self setContentDidRead:model.isRead];
    
    [self configBaseModelData:model indexPath:indexPath];
}

/**
 子类可重写
 */
- (void)configBaseModelData:(XLFeedModel *)model indexPath:(NSIndexPath *)indexPath {
  
}

/**
 子类可以重写
 */
- (void)setupBaseSubviews {
    
}

#pragma mark -
#pragma mark Private Method

- (XLPlayerConfigModel *)configPlayerModel:(XLFeedModel *)model {
    self.configModel.videoURL = [NSURL URLWithString:model.url];
    self.configModel.shouldCache = YES;
    self.configModel.displayViewFatherView = self.videoDisPlayViewContainerView;
    self.configModel.fullScreenShouldRotate = model.type.integerValue == XLFeedCellVideoHorizonalWithAuthorType;
    self.configModel.videoWidth = model.width;
    self.configModel.videoHeight = model.height;
    self.configModel.watchNum = model.watchNum;
    self.configModel.duration = model.duration;
    
    return self.configModel;
}

/**
 移除视频layer，避免重用时，数据错乱
 */
- (void)clearVideoSubLayers {
    AVPlayerLayer *removeLayer;
    for (AVPlayerLayer *layer in self.videoDisPlayView.feedVideoShowView.layer.sublayers) {
        if ([layer isKindOfClass:[AVPlayerLayer class]]) {
            removeLayer = layer;
        }
    }
    [removeLayer removeFromSuperlayer];
}

#pragma mark - Custom Accessor

- (UIView *)videoDisPlayViewContainerView {
    if (!_videoDisPlayViewContainerView) {
        _videoDisPlayViewContainerView = [UIView new];
        _videoDisPlayViewContainerView.backgroundColor = [UIColor colorWithString:COLOREDECED];
    }
    return _videoDisPlayViewContainerView;
}

- (VideoDisplayView *)videoDisPlayView {
    if (!_videoDisPlayView) {
        _videoDisPlayView = [VideoDisplayView new];
        _videoDisPlayView.isFeedVideo = YES;
    }
    return _videoDisPlayView;
}

- (XLPlayerConfigModel *)configModel {
    if (!_configModel) {
        _configModel = [XLPlayerConfigModel new];
    }
    return _configModel;
}

@end
