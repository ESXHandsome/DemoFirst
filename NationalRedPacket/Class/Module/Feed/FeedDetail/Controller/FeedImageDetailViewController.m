//
//  FeedImageDetailViewController.m
//  NationalRedPacket
//
//  Created by 刘永杰 on 2018/5/7.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "FeedImageDetailViewController.h"
#import "FeedImagesCell.h"
#import "FeedCommentSectionHeaderView.h"
#import "GifPlayManager.h"

@interface FeedImageDetailViewController ()<FeedCellDelegate>

@property (strong, nonatomic) FeedImagesCell *imageHeaderView;

@end

@implementation FeedImageDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showFollowHeight = - MAXFLOAT;
    [self updateNavigationBarFollowButton];
    
    [GifPlayManager sharedManager].currentTableView = self.tableView;
    
}

- (void)configHeaderView {
    
    self.tableView.tableHeaderView = self.imageHeaderView;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.imageHeaderView.topAuthorView configFeedModel:self.viewModel.feed];
    [self.imageHeaderView.topAuthorView hiddenFollowButton:self.viewModel.feed.isFollowed];

    [GifPlayManager sharedManager].currentTableView = self.tableView;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.isEnterPersonal) { //从个人主页返回时
        [self.imageHeaderView.containerView rebootPlayGifImageView];
    } else { //首页进入页面
        if (![self.imageHeaderView.containerView isAllCellCanNotPlay] && self.imageHeaderView.containerView.isPlaying == NO) {
            self.imageHeaderView.containerView.isPlaying = YES;
            [self.imageHeaderView.containerView playGifImageViewWithNumber:self.palyPlace];
        } else {
            [self.imageHeaderView.containerView rebootPlayGifImageView];
        }
    }
    self.isEnterPersonal = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.imageHeaderView.containerView stopPlayGifImageView];
    if (!animated) {
        return;
    }
    if (!self.isEnterPersonal) {   //如果不是从个人主页返回的时候触发该方法 才回调
        if (self.ContinueGifPlayPlace) {
            self.ContinueGifPlayPlace(self.imageHeaderView.containerView.playingPlace);
        }
    }
}

#pragma mark - FeedDetailViewModelDelegate
- (void)feedModelDidUpdate:(XLFeedModel *)feed {
    
    [super feedModelDidUpdate:feed];
    
    [self.imageHeaderView.topAuthorView configFeedModel:feed];
    [self.imageHeaderView updateDetailInfo];
    
}

#pragma mark - FeedCellDelegate

- (void)didClickFollowButtonEvent:(XLFeedModel *)model withFollowButton:(FollowButton *)followButton {
    
    [self followButtonClick:followButton];
    
}

- (void)didClickAvatarButtonEvent:(XLFeedModel *)model {
    self.isEnterPersonal = YES;
    [self pushPublisherHomepage];
}

/**
 tableView 正在滚动
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:self.tableView];
    [[GifPlayManager sharedManager] currentTableViewDidScroll];
    [self imageHeaderViewPlayGif];
}

- (void)imageHeaderViewPlayGif {
    
    if ([self.imageHeaderView.containerView isAllCellCanNotPlay]) {
        self.imageHeaderView.containerView.isPlaying = NO;
    } else {
        if (self.imageHeaderView.containerView.isPlaying == NO) {
            self.imageHeaderView.containerView.isPlaying = YES;
            [self.imageHeaderView.containerView playGifImageViewWithNumber:0];
        }
    }
}

#pragma mark - Lazy Loading
- (FeedImagesCell *)imageHeaderView {
    if (!_imageHeaderView) {
        _imageHeaderView = [FeedImagesCell new];
        _imageHeaderView.cellDelegate = self;
        _imageHeaderView.playPlace = self.palyPlace;
        [_imageHeaderView setIsDetail: YES];
        [_imageHeaderView configModelData:self.viewModel.feed indexPath:nil];
        _imageHeaderView.height = [self.tableView fd_systemFittingHeightForConfiguratedCell:_imageHeaderView]+1;
    }
    return _imageHeaderView;
}

- (CGFloat)commentAreaHeight {
    return self.tableView.tableHeaderView.height + adaptHeight1334(12);
}

- (CGFloat)statSeparateHeight {
    return (self.tableView.tableHeaderView.height + kSectionHeight)/2.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
