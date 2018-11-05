//
//  FeedSecondaryCommentUnfoldTipCell.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/4/23.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "FeedSecondaryCommentUnfoldTipCell.h"
#import "CommentLoadingMoreButton.h"
#import "UIButton+XLEdgeInsetsButton.h"

@interface FeedSecondaryCommentUnfoldTipCell ()

@property (strong, nonatomic) UIImageView *contentBgImageView;
@property (strong, nonatomic) CommentLoadingMoreButton *loadMoreButton;
@property (strong, nonatomic) UIImageView *seperateLine;
@property (strong, nonatomic) FeedCommentListRowModel *feedCommentListRowModel;
@property (assign, nonatomic) NSInteger lastShowReplyCount;
@property (strong, nonatomic) UIImageView *loadMoreButtonImageView;

@end

@implementation FeedSecondaryCommentUnfoldTipCell

#pragma mark - Initialize

- (void)setupViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self.contentView addSubview:self.contentBgImageView];
    [self.contentView addSubview:self.seperateLine];;
    [self.contentView addSubview:self.loadMoreButton];
    [self.contentView addSubview:self.loadMoreButtonImageView];
    
    [self.contentBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).mas_equalTo(adaptWidth750(128));
        make.width.mas_equalTo(SCREEN_WIDTH - adaptWidth750(64*2) - adaptWidth750(20*2));
    }];
    [self.seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(adaptHeight1334(14));
        make.left.equalTo(self.loadMoreButton.mas_left).mas_offset(adaptWidth750(18));
        make.right.equalTo(self.loadMoreButton.mas_right).mas_offset(adaptWidth750(-18));
        make.height.mas_equalTo(adaptHeight1334(1));
    }];
    [self.loadMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).mas_offset(adaptHeight1334(28));
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).mas_equalTo(adaptWidth750(128));
        make.width.mas_equalTo(self.contentBgImageView);
    }];
    [self.loadMoreButtonImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.loadMoreButton.mas_centerY);
        make.left.equalTo(self.loadMoreButton.titleLabel.mas_right).mas_equalTo(adaptWidth750(2));
        make.width.mas_equalTo(adaptWidth750(16));
        make.height.mas_equalTo(adaptWidth750(10));
    }];
    [self.loadMoreButton layoutButtonWithEdgeInsetsStyle:XLButtonEdgeInsetsStyleRight imageTitleSpace:2];
}

#pragma mark - Event Response

- (void)didClickLoadMoreButtonAction {
    [self setFeedSecondaryCommentCellSelectedState:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setFeedSecondaryCommentCellSelectedState:NO];
    });
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedSecondaryCommentCell:loadMoreButtonDidClickWithRowModel:)]) {
        [self.delegate feedSecondaryCommentCell:self loadMoreButtonDidClickWithRowModel:self.feedCommentListRowModel];
    }
    [self startLoading];
}

#pragma mark - Public

- (void)configModelData:(FeedCommentListRowModel *)rowModel indexPath:(NSIndexPath *)indexPath {
    self.feedCommentListRowModel = rowModel;
    if (self.isLoadMoreButtonShowDetail) {
        [self.loadMoreButton setTitle:[NSString stringWithFormat:@"查看%ld条回复",self.secondaryCommentTotalCount - 3] forState:UIControlStateNormal];
    } else {
        [self.loadMoreButton setTitle:@"查看更多回复" forState:UIControlStateNormal];
    }
}

- (void)startLoading {
    [self.loadMoreButton startLoading];
    self.loadMoreButtonImageView.hidden = YES;
}

- (void)stopLoading {
    [self.loadMoreButton setTitle:@"查看更多消息" forState:UIControlStateNormal];
    [self.loadMoreButton stopLoading];
    self.loadMoreButtonImageView.hidden = NO;
}

#pragma mark - Private

- (void)setFeedSecondaryCommentCellSelectedState:(BOOL)selected {
    if (selected) {
        self.loadMoreButton.backgroundColor = [UIColor colorWithString:COLOREBEBEB];
    } else {
        self.loadMoreButton.backgroundColor = [UIColor colorWithString:COLORF7F7F7];
    }
}

#pragma mark - Custom Accessors

- (UIImageView *)contentBgImageView {
    if (!_contentBgImageView) {
        _contentBgImageView = [UIImageView new];
        _contentBgImageView.backgroundColor = [UIColor colorWithString:COLORF7F7F7];
    }
    return _contentBgImageView;
}

- (UIImageView *)seperateLine {
    if (!_seperateLine) {
        _seperateLine = [UIImageView new];
        _seperateLine.backgroundColor = [UIColor colorWithRed:221/255.0 green:222/255.0 blue:223/255.0 alpha:0.5];
    }
    return _seperateLine;
}

- (UIButton *)loadMoreButton {
    if (!_loadMoreButton) {
        _loadMoreButton = [CommentLoadingMoreButton new];
        _loadMoreButton.backgroundColor = [UIColor colorWithString:COLORF7F7F7];
        _loadMoreButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_loadMoreButton setTitle:@"查看更多回复" forState:UIControlStateNormal];
        [_loadMoreButton setTitleColor:[UIColor colorWithString:COLOR999999]
                              forState:UIControlStateNormal];
        _loadMoreButton.titleLabel.font = [UIFont systemFontOfSize:adaptFontSize(25)];
        [_loadMoreButton addTarget:self action:@selector(didClickLoadMoreButtonAction)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return _loadMoreButton;
}

- (UIImageView *)loadMoreButtonImageView {
    if (!_loadMoreButtonImageView) {
        _loadMoreButtonImageView = [UIImageView new];
        _loadMoreButtonImageView.image = [UIImage imageNamed:@"secondary_comment_loadmore_icon"];
    }
    return _loadMoreButtonImageView;
}

@end
