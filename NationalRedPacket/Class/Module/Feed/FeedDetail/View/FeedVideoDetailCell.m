//
//  FeedVideoDetailCell.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/8.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "FeedVideoDetailCell.h"
#import "NSString+NumberAdapt.h"
#import "CommentContainerView.h"

@interface FeedVideoDetailCell () <CommentContainerViewDelegate>

@property (strong, nonatomic) XLFeedModel *tempModel;
@property (strong, nonatomic) UIView      *videoContainerView;

@end

@implementation FeedVideoDetailCell

- (void)setupViews {
    [super setupViews];
    
    self.topAuthorView.hidden = YES;
    self.detailLabel.hidden = YES;
    self.titleLabel.numberOfLines = 0;
    
    self.videoContainerView = [UIView new];
    [self.contentView addSubview:self.videoContainerView];
    
    self.videoDisplayView = [VideoDisplayView new];
    self.videoDisplayView.isFeedVideo = NO;

    [self.videoDisplayView setMuteButtonUnavailable];
    [self.videoContainerView addSubview:self.videoDisplayView];
    
    [self.videoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(adaptHeight1334(231*2));
    }];
    
    [self.videoDisplayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.videoContainerView);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoDisplayView.mas_bottom).mas_offset(adaptHeight1334(20));
        make.left.equalTo(self.contentView).mas_offset(kLeftMargin);
        make.width.mas_equalTo(SCREEN_WIDTH - kLeftMargin * 2);
    }];
    
    [self.commentContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
}

- (void)configModelData:(XLFeedModel *)model indexPath:(NSIndexPath *)indexPath {
    [super configModelData:model indexPath:indexPath];
    
    self.tempModel = model;
    self.fullTextButton.hidden = YES;
    self.titleLabel.numberOfLines = 0;
    
    [self setContentDidRead:NO];
    [self updateDetailInfo];
    
    self.videoDisplayView.feedModel = model;
    [self.videoDisplayView configCoverImageViewWithURL:[NSURL URLWithString:model.picture.firstObject]];
    
    [self.videoContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(SCREEN_WIDTH / (model.width/model.height));
    }];
    
}

- (void)updateDetailInfo
{
    [self updateDataWithModel:self.tempModel];
}

@end
