//
//  VideoVerticalWithAuthorCell.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/5/7.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "FeedVideoVerticalCell.h"

#define kVideoHeight adaptHeight1334(375*2)

@interface FeedVideoVerticalCell ()

@property (strong, nonatomic) UIVisualEffectView *visualEffectView;
@property (strong, nonatomic) UIImageView *visualBgImageView;
@property (assign, nonatomic) CGFloat videoWidth;

@end

@implementation FeedVideoVerticalCell

/**
 重写父类布局文件，视频画面高度设置为竖版视频高度，添加模糊样式
 */
- (void)setupBaseSubviews {
    [self.contentView addSubview:self.videoDisPlayViewContainerView];
    [self.videoDisPlayViewContainerView addSubview:self.visualBgImageView];
    [self.videoDisPlayViewContainerView addSubview:self.visualEffectView];
    [self.videoDisPlayViewContainerView addSubview:self.videoDisPlayView];
    
    [self.videoDisPlayViewContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.fullTextButton.mas_bottom).mas_offset(adaptHeight1334(16));
        make.height.mas_equalTo(SCREEN_WIDTH);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.equalTo(self.commentTableView.mas_top);
    }];
    [self.videoDisPlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.videoDisPlayViewContainerView);
    }];
 
    [self.visualBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.videoDisPlayViewContainerView);
    }];
    [self.visualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.videoDisPlayViewContainerView);
    }];
}

/**
 重写父类数据配置方法，为竖版视频模糊设置模糊背景图
 */
- (void)configBaseModelData:(XLFeedModel *)model indexPath:(NSIndexPath *)indexPath {
    [self.visualBgImageView sd_setImageWithURL:[NSURL URLWithString:model.picture.firstObject]];
    if (self.videoWidth != SCREEN_WIDTH * model.width / model.height) {
        self.videoWidth = SCREEN_WIDTH * model.width / model.height;
        [self.videoDisPlayView updateCoverImageWidth:self.videoWidth height:SCREEN_WIDTH];
    }
}

#pragma mark - Custom Accessor

- (UIVisualEffectView *)visualEffectView {
    if (!_visualEffectView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    }
    return _visualEffectView;
}

- (UIImageView *)visualBgImageView {
    if (!_visualBgImageView) {
        _visualBgImageView = [UIImageView new];
    }
    return _visualBgImageView;
}

@end
