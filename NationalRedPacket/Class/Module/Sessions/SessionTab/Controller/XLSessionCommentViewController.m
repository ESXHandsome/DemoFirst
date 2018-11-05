//
//  UserCommentViewController.m
//  NationalRedPacket
//
//  Created by Ying on 2018/5/28.
//  Copyright © 2018年 XLook. All rights reserved.
//

#import "XLSessionCommentViewController.h"
#import "XLCommentTableViewCell.h"
#import "XLSessionCommentViewModel.h"
#import "XLSessionCommentModel.h"
#import "XLPhotoShowView.h"
#import "FeedVideoDetailViewController.h"
#import "FeedImageDetailViewController.h"
#import "PublisherViewController.h"

@interface XLSessionCommentViewController () <XLCommentTableViewCellDelegate, PPSPhotoShowViewDelegate>
@property (strong ,nonatomic) UIImageView *photoStartView;
@end

@implementation XLSessionCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.photoStartView];
    self.title = @"评论";
    
    [self.sessionListViewModel markOnlyShowRedDotSessionForMessageType:XLMessageComment];
}

- (void)configureViewModel {
    self.viewModel = [[XLSessionCommentViewModel alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView fd_heightForCellWithIdentifier:NSStringFromClass(XLCommentTableViewCell.class) configuration:^(id cell) {
        [cell configHigh:self.viewModel.sessionMessageArray[indexPath.row]];
    }] + 1;
    if (height < adaptHeight1334(88*2))  height = adaptHeight1334(88*2);
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLCommentTableViewCell *cell = [tableView xl_dequeueReusableCellWithClass:XLCommentTableViewCell.class forIndexPath:indexPath];
    cell.delegate = self;
    XLSessionCommentModel *model = self.viewModel.sessionMessageArray[indexPath.row];
    [cell configModelData:model indexPath:indexPath];
    return cell;
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
        detailViewController.shouldScrollToCommentView = YES;
        detailViewController.viewModel.appointCommentScroll = YES;
        detailViewController.viewModel.appointCommentId = commentModel.commentId;
        detailViewController.viewModel.appointSecondCommentId = commentModel.secondCommentId;
        [[UIViewController currentViewController].navigationController pushViewController:detailViewController animated:YES];
        
    } else if (model.type.integerValue == XLFeedCellMultiPictureType ||
               model.type.integerValue == XLFeedCellArticleQQCircleType) {
        FeedImageDetailViewController *detailVC = [FeedImageDetailViewController new];
        detailVC.viewModel = [[FeedDetailViewModel alloc] initWithFeed:model];
        detailVC.shouldScrollToCommentView = YES;
        detailVC.viewModel.appointCommentScroll = YES;
        detailVC.viewModel.appointCommentId = commentModel.commentId;
        detailVC.viewModel.appointSecondCommentId = commentModel.secondCommentId;
        [[UIViewController currentViewController].navigationController pushViewController:detailVC animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.sessionMessageArray.count;
}

#pragma mark -
#pragma mark - Cell delegate

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

#pragma mark -
#pragma mark - Photo show view delegate

- (UIView *)dismissAction:(NSInteger)currentPage {
    
    return self.photoStartView;
}

- (void)dismissAtCurrentPage:(NSInteger)currentPage {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
