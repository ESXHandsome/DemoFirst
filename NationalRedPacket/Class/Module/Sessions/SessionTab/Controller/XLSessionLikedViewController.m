//
//  NewsLikedViewController.m
//  NationalRedPacket
//
//  Created by Ying on 2018/5/28.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLSessionLikedViewController.h"
#import "XLSessionLikedViewModel.h"
#import "XLCommentTableViewCell.h"
#import "XLSessionCommentModel.h"
#import "FeedVideoDetailViewController.h"
#import "FeedImageDetailViewController.h"
#import "XLPhotoShowView.h"
#import "PublisherViewController.h"


@interface XLSessionLikedViewController () <XLCommentTableViewCellDelegate, PPSPhotoShowViewDelegate>
@property (strong ,nonatomic) UIImageView *photoStartView;
@end

@implementation XLSessionLikedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.photoStartView];
    self.title = @"收到赞";
    
    [self.sessionListViewModel markOnlyShowRedDotSessionForMessageType:XLMessagePraise];
    
}
- (void)configureViewModel {
    self.viewModel = [[XLSessionLikedViewModel alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView fd_heightForCellWithIdentifier:NSStringFromClass(XLCommentTableViewCell.class) configuration:^(XLCommentTableViewCell *cell) {
        cell.isLikedView = YES;
        [cell configHigh:self.viewModel.sessionMessageArray[indexPath.row]];
    }] + 1;
    if (height < adaptHeight1334(88*2))  height = adaptHeight1334(88*2);
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLCommentTableViewCell *cell = [tableView xl_dequeueReusableCellWithClass:XLCommentTableViewCell.class forIndexPath:indexPath];
    cell.isLikedView = YES;
    cell.delegate = self;
    XLSessionCommentModel *model = self.viewModel.sessionMessageArray[indexPath.row];
    [cell configModelData:model indexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.sessionMessageArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XLSessionCommentModel *commentModel = self.viewModel.sessionMessageArray[indexPath.row];
    XLFeedModel *model = commentModel.item;
    if (model.type.integerValue == XLFeedCellVideoHorizonalType ||
        model.type.integerValue == XLFeedCellVideoVerticalType ||
        model.type.integerValue == XLFeedCellVideoVerticalWithAuthorType ||
        model.type.integerValue == XLFeedCellVideoHorizonalWithAuthorType) {
        FeedVideoDetailViewController *detailViewController = [FeedVideoDetailViewController new];
        detailViewController.viewModel = [[FeedDetailViewModel alloc] initWithFeed:model];
        detailViewController.shouldScrollToCommentView = [commentModel.receiveType isEqualToString:@"item"] ? NO : YES;
        detailViewController.viewModel.appointCommentScroll = [commentModel.receiveType isEqualToString:@"item"] ? NO : YES;
        detailViewController.viewModel.appointCommentId = commentModel.commentId;
        [[UIViewController currentViewController].navigationController pushViewController:detailViewController animated:YES];
        
    } else if (model.type.integerValue == XLFeedCellMultiPictureType ||
               model.type.integerValue == XLFeedCellArticleQQCircleType) {
        FeedImageDetailViewController *detailVC = [FeedImageDetailViewController new];
        detailVC.viewModel = [[FeedDetailViewModel alloc] initWithFeed:model];
        detailVC.shouldScrollToCommentView = [commentModel.receiveType isEqualToString:@"item"] ? NO : YES;
        detailVC.viewModel.appointCommentScroll = [commentModel.receiveType isEqualToString:@"item"] ? NO : YES;
        detailVC.viewModel.appointCommentId = commentModel.commentId;
        [[UIViewController currentViewController].navigationController pushViewController:detailVC animated:YES];
    }
}


- (void)clickShowPictureText:(XLSessionCommentImageModel *)model imageView:(nonnull UIImageView *)imageView{
    ImageModel *imageModel = [[ImageModel alloc] init];
    imageModel.isOnLocal = NO;
    imageModel.originalImage = model.image;
    imageModel.height = model.height;
    imageModel.width = model.width;
    XLPhotoShowView *photoShowView = [[XLPhotoShowView alloc] initWithGroupItems:@[imageModel]];
    photoShowView.delegate = self;
    photoShowView.isHaveAlertView = NO;
    self.photoStartView = imageView;
    [photoShowView presentFromImageView:imageView toContainer:KeyWindow animated:YES completion:nil];
}

- (void)pushPublisherController:(XLSessionCommentModel *)model {
    PublisherViewController *personalHomepageViewController = [PublisherViewController new];
    personalHomepageViewController.publisherId = model.userId;
    [[UIViewController currentViewController].navigationController pushViewController:personalHomepageViewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark -
#pragma mark - photo show view delegate

- (UIView *)dismissAction:(NSInteger)currentPage {
    
    return self.photoStartView;
}

- (void)dismissAtCurrentPage:(NSInteger)currentPage {
    
}

@end
