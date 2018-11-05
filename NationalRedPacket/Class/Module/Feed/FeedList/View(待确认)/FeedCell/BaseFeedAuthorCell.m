//
//  BaseWithAuthorCell.m
//  NationalRedPacket
//
//  Created by sunmingyue on 2018/2/19.
//  Copyright © 2018年 孙明悦. All rights reserved.
//

#import "BaseFeedAuthorCell.h"

@interface BaseFeedAuthorCell ()

@property (strong, nonatomic) XLFeedModel *model;

@end

@implementation BaseFeedAuthorCell

- (void)setupViews {
    [super setupViews];
    [self setupAuthorCellSubViews];
}

- (void)setupAuthorCellSubViews {
    self.isContainFollowButton = YES;
    
    UIView *contentView = self.contentView;
    [contentView addSubview:self.topAuthorView];
    [contentView addSubview:self.commentContainerView];
    [contentView addSubview:self.commentListVC.view];
    self.commentTableView = self.commentListVC.tableView;
    
    [self.topAuthorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top).mas_offset(adaptHeight1334(16));
        make.left.equalTo(contentView.mas_left);
        make.right.equalTo(contentView.mas_right);
        make.height.mas_equalTo(adaptHeight1334(64));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topAuthorView.mas_bottom).mas_offset(adaptHeight1334(16));
        make.left.equalTo(self.contentView).mas_offset(kLeftMargin);
        make.width.mas_equalTo(SCREEN_WIDTH - kLeftMargin * 2);
    }];
    [self.fullTextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.titleLabel);
        make.height.mas_equalTo(0);
    }];
    [self.commentListVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.height.mas_equalTo(adaptHeight1334(280));
        make.bottom.equalTo(self.commentContainerView.mas_top);
    }];
    [self.commentListVC.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.commentListVC.view);
    }];
    [self.commentContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left);
        make.right.equalTo(contentView.mas_right);
        make.bottom.equalTo(contentView.mas_bottom).mas_offset(-adaptHeight1334(20));
        make.height.mas_equalTo(adaptHeight1334(46*2));
    }];
}

#pragma mark -
#pragma mark Public Method

- (void)configModelData:(XLFeedModel *)model indexPath:(NSIndexPath *)indexPath {
    [super configModelData:model indexPath:indexPath];
    _model = model;
    
    self.fullTextButton.hidden = !model.isNeedFullButton;
    [self.fullTextButton setTitle:model.isAllContent ? @"收起" : @"全文" forState:UIControlStateNormal];
    [self.fullTextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.titleLabel);
        make.height.mas_equalTo(model.isNeedFullButton ? adaptHeight1334(44) : 0);
    }];
    [self.topAuthorView configFeedModel:model];
    self.commentContainerView.model = model;
    self.commentListVC.feed = model;
    self.commentListVC.superCommentArray = model.bestComment.mutableCopy;
    self.commentListVC.tableView.scrollEnabled = NO;
    
    [self.commentListVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([self.commentListVC feedListSuperCommentTotalHeight]);
    }];
}

- (void)hiddenFollowButton:(BOOL)hidden {
    [self.topAuthorView hiddenFollowButton:hidden];
}

- (void)updateDataWithModel:(XLFeedModel *)model {
    [self.topAuthorView configFeedModel:model];
    [self.topAuthorView setPublishTime:model.createdTime.integerValue];
    self.commentContainerView.model = model;
}

- (void)hiddenPublishTimeLabel {
    [self.topAuthorView hiddenPublishLabel];
}

- (void)commentTableViewTapAction {
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(didClickCellSuperCommentButtonEvent:)]) {
        [self.cellDelegate didClickCellSuperCommentButtonEvent:self.model];
    }
}

#pragma mark -
#pragma mark TopAuthorViewDelegate Delegate

- (void)didClickAvatarInTopAuthorViewEvent:(XLFeedModel *)model {
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(didClickAvatarButtonEvent:)]) {
        [self.cellDelegate didClickAvatarButtonEvent:self.model];
    }
}

- (void)didClickFollowButtonInTopAuthorView:(FollowButton *)followButton {
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(didClickFollowButtonEvent:withFollowButton:)]) {
        [self.cellDelegate didClickFollowButtonEvent:self.model withFollowButton:followButton];
    }
}

#pragma mark -
#pragma mark CommentContainerView Delegate

- (void)didClickPraiseButtonEvent:(XLFeedModel *)model {
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(didClickCellPraiseButtonEvent:)]) {
        [self.cellDelegate didClickCellPraiseButtonEvent:self.model];
    }
}

- (void)didClickTreadButtonEvent:(XLFeedModel *)model {
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(didClickCellTreadButtonEvent:)]) {
        [self.cellDelegate didClickCellTreadButtonEvent:model];
    }
}

- (void)didClickCommentButtonEvent:(XLFeedModel *)model {
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(didClickCellCommentButtonEvent:)]) {
        [self.cellDelegate didClickCellCommentButtonEvent:self.model];
    }
}

- (void)didClickForwardButtonEvent:(XLFeedModel *)model {
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(didClickCellForwardButtonEvent:)]) {
        [self.cellDelegate didClickCellForwardButtonEvent:self.model];
    }
}

#pragma mark -
#pragma mark Setters and Getters

- (TopAuthorView *)topAuthorView {
    if (!_topAuthorView) {
        _topAuthorView = [TopAuthorView new];
        _topAuthorView.topAuthorViewDelegate = self;
    }
    return _topAuthorView;
}

- (CommentContainerView *)commentContainerView {
    if (!_commentContainerView) {
        _commentContainerView = [CommentContainerView new];
        _commentContainerView.delegate = self;
    }
    return _commentContainerView;
}

- (FeedCommentListViewController *)commentListVC {
    if (!_commentListVC) {
        _commentListVC = [[FeedCommentListViewController alloc] initWithFeed:nil];
        _commentListVC.feedListSuperComment = YES;
        _commentListVC.superCommentTarget = self;
        _commentListVC.superCommentAction = @selector(commentTableViewTapAction);
    }
    return _commentListVC;
}

@end
