//
//  VideoNewsCell.m
//  WatermelonNews
//
//  Created by sunmingyue on 17/11/14.
//  Copyright © 2017年 孙明悦. All rights reserved.
//

#import "FeedVideoHorizonalCell.h"

#define kVideoHeight adaptHeight1334(211*2)

@interface FeedVideoHorizonalCell ()

@property (assign, nonatomic) CGFloat cellHeight;

@end

@implementation FeedVideoHorizonalCell

/**
 重写父类布局文件，视频画面高度设置为横版视频高度
 */
- (void)setupBaseSubviews {
    [self.contentView addSubview:self.videoDisPlayViewContainerView];
    [self.videoDisPlayViewContainerView addSubview:self.videoDisPlayView];
    
    [self.videoDisPlayViewContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.fullTextButton.mas_bottom).mas_offset(adaptHeight1334(16));
        make.height.mas_equalTo(kVideoHeight);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.equalTo(self.commentTableView.mas_top);
    }];
    [self.videoDisPlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.videoDisPlayViewContainerView);
    }];
}

/**
 重写父类configModel方法，更新视频CELL高度
 */
- (void)configBaseModelData:(XLFeedModel *)model indexPath:(NSIndexPath *)indexPath {
    if (self.cellHeight != SCREEN_WIDTH * model.height / model.width) {
        self.cellHeight = SCREEN_WIDTH * model.height / model.width;
        [self.videoDisPlayViewContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.fullTextButton.mas_bottom).mas_offset(adaptHeight1334(16));
            make.height.mas_equalTo(self.cellHeight);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.bottom.equalTo(self.commentTableView.mas_top);
        }];
    }
}

@end

